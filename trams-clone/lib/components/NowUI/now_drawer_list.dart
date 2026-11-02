import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constant/theme.dart';
import 'now_drawer.dart';
import 'now_drawer_tile.dart';

Widget homeDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.house,
    onTap: () {
      if (current != Destination.home) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    },
    iconColor: NowUIColors.primary,
    title: "Home",
    isSelected: current == Destination.home,
  );
}

Widget warehouseDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.dharmachakra,
    onTap: () {
      if (current != Destination.warehouse) {
        Navigator.pushReplacementNamed(context, '/warehouse');
      }
    },
    iconColor: NowUIColors.error,
    title: "Warehouse",
    isSelected: current == Destination.warehouse,
  );
}

Widget projectDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.newspaper,
    onTap: () {
      if (current != Destination.project) {
        Navigator.pushReplacementNamed(context, '/project');
      }
    },
    iconColor: NowUIColors.primary,
    title: "Project",
    isSelected: current == Destination.project,
  );
}

Widget sitesDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.user,
    onTap: () {
      if (current != Destination.sites) {
        Navigator.pushReplacementNamed(context, '/sites');
      }
    },
    iconColor: NowUIColors.warning,
    title: "Sites",
    isSelected: current == Destination.sites,
  );
}

Widget inventoryDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.fileInvoice,
    onTap: () {
      if (current != Destination.inventory) {
        Navigator.pushReplacementNamed(context, '/inventory');
      }
    },
    iconColor: NowUIColors.info,
    title: "Inventory",
    isSelected: current == Destination.inventory,
  );
}

Widget materialDrawerTile(context, Destination current) {
  return DrawerTile(
    icon: FontAwesomeIcons.gear,
    onTap: () {
      if (current != Destination.materialrequest) {
        Navigator.pushReplacementNamed(context, '/materialrequest');
      }
    },
    iconColor: NowUIColors.success,
    title: "Material Request",
    isSelected: current == Destination.materialrequest,
  );
}
