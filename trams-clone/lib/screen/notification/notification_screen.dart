import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/Neumorphic/navbar.dart';

import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/noti_services/push_service.dart';

/// Tab order and labels. The key is the formType the server saves ("B", "C", "G", "R").
const Map<String, String> _forms = {
  'B': 'Form B',
  'C': 'Form C',
  'G': 'Form G',
  'R': 'Form R',
};

/// Notifications page: one tab per form, each tab shows its unread count.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<AppNotification> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final username = Get.find<AuthController>().accessName();
    if (username == null) {
      setState(() {
        _loading = false;
        _error = 'Not logged in';
      });
      return;
    }
    try {
      final items = await PushService.fetchNotifications(username);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  List<AppNotification> _forForm(String formType) =>
      _items.where((n) => n.formType == formType).toList();

  int _unreadCount(String formType) =>
      _items.where((n) => n.formType == formType && !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _forms.length,
      child: Scaffold(
        appBar: const NeumorphicNavBar(
          title: 'Notifications',
          showDrawer: false, // shows a back arrow instead of the menu icon
          color: Color(0xfff3f8fe),
        ),
        backgroundColor: const Color(0xfff3f8fe),
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.blue.shade700,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blue.shade700,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                for (final entry in _forms.entries)
                  Tab(child: _tabLabel(entry.value, _unreadCount(entry.key))),
              ],
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _errorView()
                      : TabBarView(
                          children: [
                            for (final key in _forms.keys) _list(_forForm(key)),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  /// "Form B" with a small count bubble next to it (hidden when 0).
  Widget _tabLabel(String text, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load notifications\n$_error', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            NeumorphicButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _load();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Pull down to refresh. The ListView always scrolls so refresh also works when empty.
  Widget _list(List<AppNotification> items) {
    return RefreshIndicator(
      onRefresh: _load,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No notifications yet')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _tile(items[i]),
            ),
    );
  }

  /// Open the record this notification is about.
  void _open(AppNotification n) {
    final id = n.recordId;
    if (id == null || id.isEmpty) return; // older notifications have no record
    if (n.formType == 'B') {
      // Same arguments the "View" button on the inspection records page passes.
      // status is left out on purpose: the details page reads it from the record.
      Get.toNamed('/inspection_details', arguments: {
        'recID': id,
        'insRecID': id,
        'formType': 'B',
      });
    }
  }

  Widget _tile(AppNotification n) {
    final canOpen = n.recordId != null && n.recordId!.isNotEmpty;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: canOpen ? () => _open(n) : null,
      child: _tileCard(n, canOpen),
    );
  }

  /// The labelled lines under the title, in a fixed order.
  Widget _details(AppNotification n) {
    const labels = {
      'bridgeName': 'Bridge',
      'roadName': 'Road',
      'inspectionDate': 'Inspection date',
    };
    final rows = <Widget>[];
    for (final e in labels.entries) {
      final v = n.meta[e.key];
      if (v == null || v.isEmpty) continue;
      rows.add(Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(e.value,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ),
            Expanded(
              child: Text(v,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _tileCard(AppNotification n, bool canOpen) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue dot = unread
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: n.isRead ? Colors.transparent : Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: TextStyle(
                    fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (n.meta.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _details(n),
                ] else if (n.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(n.body, style: const TextStyle(fontSize: 13)),
                ],
                const SizedBox(height: 6),
                Text(
                  '${n.fromUsername} · ${_formatTime(n.createdAt)}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (canOpen)
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 4),
              child: Icon(Icons.chevron_right, color: Colors.black38),
            ),
        ],
      ),
    );
  }

  /// e.g. "04 Nov 2026, 14:53"
  String _formatTime(DateTime t) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.day)} ${months[t.month - 1]} ${t.year}, ${two(t.hour)}:${two(t.minute)}';
  }
}