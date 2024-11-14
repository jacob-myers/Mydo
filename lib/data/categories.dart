import 'dart:ui';

import '../themes.dart';
import 'constants.dart';

enum Category { planned, soon, eventually }
Map<Category, String> nameFromCategory = <Category, String>{
  Category.planned: PLANNED_TAG,
  Category.soon: SOON_TAG,
  Category.eventually: EVENTUALLY_TAG,
};
Map<String, Category> categoryFromName = {for (var e in nameFromCategory.entries) e.value: e.key};

Map<Category, Color> categoryColors = <Category, Color>{
  Category.planned: MydoColors.segmentedButtonPlanned,
  Category.soon: MydoColors.segmentedButtonSoon,
  Category.eventually: MydoColors.segmentedButtonEventually,
};