import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';

String parsePaymentMethod(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.CASH:
      return 'Cash';
    case PaymentMethod.CHECK:
      return 'Check';
    case PaymentMethod.BANK_TRANSFER:
      return 'Bank Transfer';
  }
}
