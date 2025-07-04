// Define SackType enum if not already globally available
// enum SackType { FIFTY_KG, TWENTY_FIVE_KG, FIVE_KG }

class TotalSalesFilterDto {
  final String? date; // Format: YYYY-MM-DD
  final String? productName;
  final String? priceType; // 'SACK' | 'KILO'
  final String? sackType; // SackType enum as String
  final bool? isDiscounted; // Added field

  TotalSalesFilterDto({
    this.date,
    this.productName,
    this.priceType,
    this.sackType,
    this.isDiscounted, // Added to constructor
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (date != null) json['date'] = date;
    if (productName != null) json['productName'] = productName;
    if (priceType != null) json['priceType'] = priceType;
    if (sackType != null) json['sackType'] = sackType;
    if (isDiscounted != null)
      json['isDiscounted'] = isDiscounted; // Added to toJson
    return json;
  }
}
