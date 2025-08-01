// Define SackType enum if not already globally available
// enum SackType { FIFTY_KG, TWENTY_FIVE_KG, FIVE_KG }

class SalesCheckFilterDto {
  final String? date; // Format: YYYY-MM-DD
  final String? productId;
  final String? productSearch;
  final String? priceType; // 'SACK' | 'KILO'
  final String? sackType; // SackType enum as String
  final bool? isDiscounted; // Added field

  SalesCheckFilterDto({
    this.date,
    this.productId,
    this.productSearch,
    this.priceType,
    this.sackType,
    this.isDiscounted, // Added to constructor
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (date != null) json['date'] = date;
    if (productId != null) json['productId'] = productId;
    if (productSearch != null) json['productSearch'] = productSearch;
    if (priceType != null) json['priceType'] = priceType;
    if (sackType != null) json['sackType'] = sackType;
    if (isDiscounted != null)
      json['isDiscounted'] = isDiscounted; // Added to toJson
    return json;
  }
}
