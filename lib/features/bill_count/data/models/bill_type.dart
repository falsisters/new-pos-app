enum BillType { THOUSAND, FIVE_HUNDRED, HUNDRED, FIFTY, TWENTY, COINS }

extension BillTypeExtension on BillType {
  String get name {
    switch (this) {
      case BillType.THOUSAND:
        return "THOUSAND";
      case BillType.FIVE_HUNDRED:
        return "FIVE_HUNDRED";
      case BillType.HUNDRED:
        return "HUNDRED";
      case BillType.FIFTY:
        return "FIFTY";
      case BillType.TWENTY:
        return "TWENTY";
      case BillType.COINS:
        return "COINS";
    }
  }

  int get value {
    switch (this) {
      case BillType.THOUSAND:
        return 1000;
      case BillType.FIVE_HUNDRED:
        return 500;
      case BillType.HUNDRED:
        return 100;
      case BillType.FIFTY:
        return 50;
      case BillType.TWENTY:
        return 20;
      case BillType.COINS:
        return 1;
    }
  }
}

String billTypeToString(String type) {
  switch (type) {
    case "THOUSAND":
      return "₱1,000";
    case "FIVE_HUNDRED":
      return "₱500";
    case "HUNDRED":
      return "₱100";
    case "FIFTY":
      return "₱50";
    case "TWENTY":
      return "₱20";
    case "COINS":
      return "COINS";
    default:
      return type;
  }
}
