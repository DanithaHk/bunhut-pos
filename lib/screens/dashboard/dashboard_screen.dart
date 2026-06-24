import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/order_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Provider එකෙන් orders list එක ලබාගන්නවා
    final orders = context.watch<OrderProvider>().orders;

    // අද sales total එක calculate කරනවා
    final todayTotal =
    orders.fold(0.0, (sum, order) => sum + order.total);

    // Demo chart data
    final spark = [
      12, 18, 14, 22, 19, 28,
      24, 32, 28, 36, 30, 38
    ];

    // Chart එකේ highest value එක
    final maxSpark =
    spark.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // =========================
          // HEADER SECTION
          // =========================

          const Text(
            'OVERVIEW',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSec,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 18),

          // =========================
          // TOP CARDS
          // =========================

          Row(
            children: [

              // Today's Revenue Card
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSec,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // අද sales amount
                      Text(
                        formatLKR(todayTotal),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Growth badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(999),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [

                            Icon(
                              Icons.arrow_upward,
                              size: 11,
                              color: Color(0xFF047857),
                            ),

                            SizedBox(width: 4),

                            Text(
                              '12.4%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Monthly Revenue Card
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'THIS MONTH',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSec,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        formatLKR(680000),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Mini bar chart
                      SizedBox(
                        height: 22,

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,

                          children: spark
                              .asMap()
                              .entries
                              .map((entry) {

                            // Last 3 bars highlight කරනවා
                            final isRecent =
                                entry.key >= spark.length - 3;

                            return Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),

                                child: FractionallySizedBox(
                                  heightFactor:
                                  entry.value / maxSpark,

                                  alignment:
                                  Alignment.bottomCenter,

                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isRecent
                                          ? AppColors.primary
                                          : AppColors.primaryTint,

                                      borderRadius:
                                      BorderRadius.circular(1.5),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =========================
          // QUICK STATS
          // =========================

          Row(
            children: [

              // Total Orders
              Expanded(
                child: _MiniStat(
                  'ORDERS',
                  '${orders.length}',
                ),
              ),

              const SizedBox(width: 10),

              // Average Bill
              Expanded(
                child: _MiniStat(
                  'AVG BILL',

                  formatLKR(
                    orders.isEmpty
                        ? 0
                        : orders.fold(
                      0.0,
                          (sum, order) =>
                      sum + order.total,
                    ) /
                        orders.length,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Total Items Sold
              Expanded(
                child: _MiniStat(
                  'ITEMS',
                  '${orders.fold(0, (sum, order) => sum + order.itemCount)}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =========================
          // RECENT ORDERS TITLE
          // =========================

          Row(
            children: [

              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),

              const Spacer(),

              Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // RECENT ORDERS LIST
          // =========================

          AppCard(
            padding: EdgeInsets.zero,

            child: ListView.separated(

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              // Maximum orders 5ක් පෙන්වනවා
              itemCount: orders.length.clamp(0, 5),

              separatorBuilder: (_, __) =>
              const Divider(
                height: 1,
                color: AppColors.divider,
              ),

              itemBuilder: (_, index) {

                // Current order
                final order = orders[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),

                  child: Row(
                    children: [

                      // Order Icon
                      Container(
                        width: 36,
                        height: 36,

                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),

                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Order Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            // Invoice Number
                            Text(
                              order.invoiceId,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                            ),

                            const SizedBox(height: 1),

                            // Order Time + Item Count
                            Text(
                              '${order.createdAt.hour % 12 == 0 ? 12 : order.createdAt.hour % 12}:'
                                  '${order.createdAt.minute.toString().padLeft(2, '0')} '
                                  '${order.createdAt.hour >= 12 ? 'PM' : 'AM'}'
                                  ' · ${order.itemCount} items',

                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSec,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order Total
                      Text(
                        formatLKR(order.total),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================
// SMALL STAT CARD WIDGET
// =======================================

class _MiniStat extends StatelessWidget {

  final String label;
  final String value;

  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSec,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}