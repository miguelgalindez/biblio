import 'package:biblio/components/underConstruction.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/resources/api/mockApi.dart';
import 'package:biblio/screens/bookScan/index.dart';
import 'package:biblio/screens/searchBook/index.dart';
import 'package:biblio/ui/screens/inventory/index.dart';
import 'package:flutter/material.dart';
import 'package:biblio/services/categories-mock-data.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// todo: create a repository base with destroy
// todo: Find out how to make IDE warns for closing this
// todo: manage screens priorities, order them and put the indexes
class ScreensRepository {
  List<Screen> screens;
  // Get rid of this as soon as posible. Replace it with bloc pattern
  List<Category> bookCategories;

  ScreensRepository() {
    getCategories().then((value) {
      bookCategories = value;
    });
  }

  Future<List<Screen>> loadAvailableScreens() async {
    if (screens == null || screens.isEmpty) {
      screens = await MockApi.getAvailableScreens();
      if (screens != null && screens.isNotEmpty) {
        screens.sort((a, b) => a.index.compareTo(b.index));
        screens.forEach((Screen screen) {
          screen.icon = getScreenIcon(screen.id);
          screen.invertColors = getScreenInvertColors(screen.id);
        });
      }
    }
    return screens;
  }

  bool getScreenInvertColors(ScreenId screenId) {
    return screenId == ScreenId.CODE_SCAN || screenId == ScreenId.INVENTORY;
  }

  IconData getScreenIcon(ScreenId screenId) {
    switch (screenId) {
      case ScreenId.CODE_SCAN:
        return MdiIcons.barcodeScan;

      case ScreenId.BOOK_CATALOG:
        return Icons.search;

      case ScreenId.INVENTORY:
        return MdiIcons.formatListChecks;

      default:
        return Icons.build;
    }
  }

  Widget getScreenWidget(ScreenId screenId) {
    switch (screenId) {
      case ScreenId.CODE_SCAN:
        return BookScanScreen(autoScan: false);

      case ScreenId.BOOK_CATALOG:
        // TODO: Change the source data
        return SearchBookScreen(bookCategories: bookCategories);

      case ScreenId.INVENTORY:
        return InventoryScreen();

      default:
        return UnderConstructionScreen();
    }
  }

  void dispose(){

  }
}
