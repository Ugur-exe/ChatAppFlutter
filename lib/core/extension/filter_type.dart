import 'package:chatappwithflutter/ui/main/view/main_view.dart';

extension FilterTypeExtension on FilterType {
  String get label {
    switch (this) {
      case FilterType.all:
        return 'All';
      case FilterType.unread:
        return 'Unread';
      case FilterType.read:
        return 'Read';
      case FilterType.pinned:
        return 'Pinned';
      default:
        return '';
    }
  }
}
