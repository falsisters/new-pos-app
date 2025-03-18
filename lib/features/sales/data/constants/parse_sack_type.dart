import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';

String parseSackType(SackType type) {
  switch (type) {
    case SackType.FIFTY_KG:
      return '50KG';
    case SackType.TWENTY_FIVE_KG:
      return '25KG';
    case SackType.FIVE_KG:
      return '5KG';
  }
}
