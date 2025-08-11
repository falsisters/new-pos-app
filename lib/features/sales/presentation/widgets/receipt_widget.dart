import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptWidget extends StatelessWidget {
  final SaleModel sale;

  const ReceiptWidget({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    // Extract change information from metadata
    String changeAmount = '0.00';
    String tenderedAmount = '0.00';
    bool hasChange = false;

    if (sale.metadata != null) {
      if (sale.metadata!.containsKey('change')) {
        changeAmount = sale.metadata!['change'].toString();
        final changeValue = Decimal.tryParse(changeAmount) ?? Decimal.zero;
        hasChange = changeValue > Decimal.zero;
      }
      if (sale.metadata!.containsKey('tenderedAmount')) {
        tenderedAmount = sale.metadata!['tenderedAmount'].toString();
      }
    }

    return SizedBox(
      width: 550, // Optimized for thermal printer width
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Store Header
              Text(
                'FALSISTERS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'RICE TRADING',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),

              // Separator
              Container(
                height: 2,
                width: double.infinity,
                color: Colors.black,
              ),
              SizedBox(height: 16),

              // Receipt Info
              _buildReceiptRow(
                  'Receipt #:', sale.id.substring(0, 8).toUpperCase()),
              _buildReceiptRow(
                  'Date:',
                  DateFormat('MMM dd, yyyy HH:mm')
                      .format(DateTime.parse(sale.createdAt))),
              _buildReceiptRow('Cashier:', sale.cashierId.substring(0, 8)),
              SizedBox(height: 16),

              // Items Header
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.black,
              ),
              SizedBox(height: 8),

              // Items
              ...sale.saleItems.map((item) {
                final isDiscounted =
                    item.isDiscounted && item.discountedPrice != null;
                Decimal itemTotal;
                String quantityDisplay;

                if (item.sackPrice != null) {
                  itemTotal = isDiscounted
                      ? item.discountedPrice!
                      : Decimal.parse(item.sackPrice!.price.toString()) *
                          item.quantity;
                  quantityDisplay =
                      '${item.quantity.toBigInt()} sack${item.quantity > Decimal.one ? "s" : ""}';
                } else if (item.perKiloPrice != null) {
                  itemTotal = isDiscounted
                      ? item.discountedPrice!
                      : Decimal.parse(item.perKiloPrice!.price.toString()) *
                          item.quantity;
                  quantityDisplay = '${item.quantity.toStringAsFixed(2)} kg';
                  if (item.isGantang) {
                    quantityDisplay += ' (Gantang)';
                  }
                } else {
                  itemTotal =
                      isDiscounted ? item.discountedPrice! : Decimal.zero;
                  quantityDisplay = '${item.quantity.toBigInt()} pcs';
                }

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.product.name,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₱${NumberFormat('#,##0.00').format(itemTotal.toDouble())}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          quantityDisplay,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        if (isDiscounted) ...[
                          SizedBox(width: 8),
                          Text(
                            'DISCOUNTED',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),

              SizedBox(height: 8),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.black,
              ),
              SizedBox(height: 16),

              // Add cash tendered and change if applicable
              if (hasChange &&
                  sale.paymentMethod.toString().contains('CASH')) ...[
                _buildReceiptRow('Cash Tendered:',
                    '₱${NumberFormat('#,##0.00').format((Decimal.tryParse(tenderedAmount) ?? Decimal.zero).toDouble())}'),
                _buildReceiptRow('Change:',
                    '₱${NumberFormat('#,##0.00').format((Decimal.tryParse(changeAmount) ?? Decimal.zero).toDouble())}'),
                SizedBox(height: 8),
              ],

              // Total
              _buildReceiptRow(
                'TOTAL:',
                '₱${NumberFormat('#,##0.00').format(sale.totalAmount.toDouble())}',
                isBold: true,
                fontSize: 18,
              ),
              SizedBox(height: 8),
              _buildReceiptRow(
                'Payment:',
                sale.paymentMethod
                    .toString()
                    .split('.')
                    .last
                    .replaceAll('_', ' '),
              ),

              SizedBox(height: 24),

              // Footer
              Text(
                'Thank you for your business!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Please come again',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24),

              // Final separator
              Container(
                height: 2,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String leftText, String rightText,
      {bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
