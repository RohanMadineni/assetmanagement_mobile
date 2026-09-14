import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final dynamic asset;
  // final VoidCallback? onTap;

  const AssetCard({
    super.key,
    required this.asset,
    // this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String name = asset['name']?.toString() ?? 'Unknown Asset';
    final String brand = asset['brand']?.toString() ?? '';
    final String status = asset['status']?.toString().toLowerCase() ?? 'Unknown';
    final String category =
        asset['category']?['name']?.toString() ?? 'Unknown Category';

    final String price = asset['price']?.toString() ?? '0';
    final String warranty = asset['Warranty']?.toString() ?? 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Brand and category
              Text(
                '$brand • $category',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              // Status + price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusChip(status: status),

                  Text(
                    '\$$price',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Warranty
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Warranty: $warranty',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status),
      visualDensity: VisualDensity.compact,
    );
  }
}