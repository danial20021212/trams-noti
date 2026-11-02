import 'dart:async';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../model/form/form_depot/form_draft/form_draft_model.dart';
import '../../model/shared/draft_status_model.dart';

class FormDraftController extends GetxController {
  Database? _database;
  final String tableName = 'form_drafts';
  final Completer<void> _dbReady = Completer<void>();

  // Observable list to keep track of drafts in the UI
  var drafts = <FormDraft>[].obs;

  static int? draftIdFromArguments(dynamic arguments) {
    if (arguments is! Map) return null;
    final value = arguments['draftId'];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  void onInit() {
    super.onInit();
    _initDb();
  }

  /// Waits for the database to be initialized (up to 10 seconds).
  Future<Database?> _awaitDb() async {
    if (_database != null) return _database;
    try {
      await _dbReady.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      Get.log('[DB ERROR] Database initialization timed out');
    }
    return _database;
  }

  // --- DATABASE INITIALIZATION ---
  Future<void> _initDb() async {
    try {
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'draft_outbox.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              form_type TEXT NOT NULL,
              form_data TEXT NOT NULL,
              status TEXT DEFAULT 'Draft',
              created_at TEXT NOT NULL,
              updated_at TEXT NOT NULL,
              sync_retry_count INTEGER DEFAULT 0,
              error_log TEXT,
              media_paths TEXT
            )
          ''');
        },
      );
      await fetchAllDrafts();
    } catch (e) {
      Get.log('[DB ERROR] Init failed: $e');
    } finally {
      if (!_dbReady.isCompleted) _dbReady.complete();
    }
  }

  // --- CREATE / INSERT DRAFT ---
  Future<int> insertDraft(FormDraft draft) async {
    final db = await _awaitDb();
    if (db == null) {
      return -1; // Database not initialized
    }

    // Serialize the dynamic form data into a JSON string
    final draftData = draft.toJson();

    // Insert into SQLite with conflict resolution
    int id = await db.insert(
      tableName,
      draftData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await fetchAllDrafts(); // Automatically refresh the UI state
    return id;
  }

  // --- READ ---
  Future<void> fetchAllDrafts() async {
    Get.log('[DB READ ALL] Fetching all drafts...');
    final db = await _awaitDb();
    if (db == null) {
      Get.log('[DB READ ALL ERROR] Database is null!');
      return;
    }

    // A synced row is no longer a draft. Older sync flows marked completed
    // rows as `synced` without deleting them, which left already-submitted
    // inspections visible in Local Drafts forever. Clean those legacy rows
    // before publishing the current draft list.
    final removedSyncedRows = await db.delete(
      tableName,
      where: 'status = ?',
      whereArgs: [DraftStatus.synced.name],
    );
    if (removedSyncedRows > 0) {
      Get.log(
          '[DB CLEANUP] Removed $removedSyncedRows completed synced draft(s).');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'created_at DESC', // Oldest vs Newest sorting
    );

    Get.log('[DB READ ALL SUCCESS] Fetched ${maps.length} drafts.');
    // Uncomment the line below if you want to print the massive raw JSON of every single list item
    // Get.log('[DB READ ALL DATA] Raw records: $maps');

    drafts.value = maps.map((map) => FormDraft.fromJson(map)).toList();
  }

  Future<FormDraft?> getDraftById(int id) async {
    Get.log('[DB READ BY ID] Fetching draft with ID: $id...');
    final db = await _awaitDb();
    if (db == null) {
      Get.log('[DB READ BY ID ERROR] Database is null!');
      return null;
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      Get.log('[DB READ BY ID SUCCESS] Found record: ${maps.first}');
      return FormDraft.fromJson(maps.first);
    }

    Get.log('[DB READ BY ID WARNING] No record found for ID: $id');
    return null;
  }

  // --- UPDATE ---
  Future<int> updateDraft(FormDraft draft) async {
    Get.log('[DB UPDATE] Attempting to update draft ID: ${draft.id}...');
    final db = await _awaitDb();
    if (db == null || draft.id == null) {
      Get.log('[DB UPDATE ERROR] Database is null or Draft ID is missing!');
      return -1;
    }

    // Update the updated_at timestamp right before saving
    draft.updatedAt = DateTime.now().toUtc().toIso8601String();

    final draftData = draft.toJson();
    Get.log('[DB UPDATE] Update payload: $draftData');

    int count = await db.update(
      tableName,
      draftData,
      where: 'id = ?',
      whereArgs: [draft.id],
    );

    Get.log('[DB UPDATE SUCCESS] Rows affected: $count');
    await fetchAllDrafts(); // Refresh UI
    return count;
  }

  // --- DELETE ---
  Future<int> deleteDraft(int id) async {
    Get.log('[DB DELETE] Attempting to delete draft ID: $id...');
    final db = await _awaitDb();
    if (db == null) {
      Get.log('[DB DELETE ERROR] Database is null!');
      return -1;
    }

    int count = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    Get.log('[DB DELETE SUCCESS] Rows affected: $count');
    try {
      await fetchAllDrafts();
    } catch (e) {
      Get.log(
        '[DB DELETE WARNING] '
        'Draft was deleted, but list refresh failed: $e',
      );
    }
    return count;
  }

  // --- READ BY SINGLE STATUS ---
  Future<List<FormDraft>> getDraftsByStatus(DraftStatus status) async {
    Get.log(
        '[DB READ BY STATUS] Fetching drafts with status: ${status.name}...');
    final db = await _awaitDb();
    if (db == null) {
      Get.log('[DB READ BY STATUS ERROR] Database is null!');
      return [];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'status = ?',
      // Convert the Enum to a String because SQLite stores it as text
      whereArgs: [status.name],
      orderBy: 'created_at ASC', // Oldest first is usually best for syncing
    );

    Get.log('[DB READ BY STATUS SUCCESS] Found ${maps.length} records.');
    return maps.map((map) => FormDraft.fromJson(map)).toList();
  }
}
