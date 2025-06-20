import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/laporan_dashboard_controller.dart'; // Ensure this is your correct controller

class PendapatanView extends StatelessWidget {
  PendapatanView({super.key});

  final PendapatanController controller = Get.find<PendapatanController>();
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  // Date formatter for tooltips, keep it moderately detailed
  final DateFormat _tooltipDateFormatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Pendapatan',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22), // Slightly smaller for balance
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.chartSpots.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF02D39A)));
        }
        if (controller.chartSpots.isEmpty && !controller.isLoading.value) {
          return Center( // Center the entire no-data message including buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No data available for selected range.",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 25),
                _buildTimeRangeSelector(),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensure scroll even if content fits
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20), // Adjusted vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _getSumPendapatanTitle(controller.selectedTimeRange.value),
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15, // Adjusted size
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5), // Adjusted spacing
                Text(
                  controller.formatCurrency(controller.totalRevenue.value),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34, // Adjusted size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8), // Adjusted spacing
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Adjusted spacing
                Card(
                  color: const Color(0xFF1A1C24), // Slightly different dark shade for card
                  elevation: 4, // Subtle elevation
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)), // Consistent rounding
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 12, left: 8, right: 16), // Fine-tuned padding
                    child: SizedBox(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1.65, // Adjusted aspect ratio
                        child: controller.chartSpots.isNotEmpty
                            ? LineChart(_mainChartData(),
                                duration: const Duration(milliseconds: 300))
                            : const Center(
                                child: Text(
                                "Loading chart data...",
                                style: TextStyle(color: Colors.white54),
                              )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22), // Adjusted spacing
                _buildTimeRangeSelector(),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _getSumPendapatanTitle(TimeRange range) {
    // Using your existing well-defined titles
    switch (range) {
      case TimeRange.oneDay: return 'Pendapatan Hari Ini';
      case TimeRange.oneWeek: return 'Pendapatan 1 Minggu';
      case TimeRange.oneMonth: return 'Pendapatan 1 Bulan';
      case TimeRange.threeMonths: return 'Pendapatan 3 Bulan';
      case TimeRange.yearToDate: return 'Pendapatan Tahun Ini'; // YTD is "Tahun Ini"
      case TimeRange.oneYear: return 'Pendapatan 1 Tahun';
      default: return 'Pendapatan';
    }
  }

  LineChartData _mainChartData() {
    final List<FlSpot> spots = controller.chartSpots;
    if (spots.isEmpty) return LineChartData(); // Should be handled by parent Obx

    final lineBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      gradient: const LinearGradient(
        colors: [Color(0xFF20B2AA), Color(0xFF02D39A)], // Adjusted gradient
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      barWidth: 3.0, // Slightly thinner line
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          bool isHighest = controller.highestPendapatan.value != null &&
              spot.x == controller.highestPendapatan.value!.xValue &&
              spot.y == controller.highestPendapatan.value!.amount;
          bool isLowest = controller.lowestPendapatan.value != null &&
              spot.x == controller.lowestPendapatan.value!.xValue &&
              spot.y == controller.lowestPendapatan.value!.amount;

          if (isHighest) {
            return FlDotCirclePainter(
                radius: 6, // Adjusted size
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: const Color(0xFF02D39A));
          }
          if (isLowest) {
            return FlDotCirclePainter(
                radius: 6, // Adjusted size
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.redAccent);
          }
          // Optionally, hide other dots for a cleaner look if many points
          if (spots.length > 50 && !(index == 0 || index == spots.length -1)) {
             return FlDotCirclePainter(radius: 0); // Hide intermediate dots for very dense charts
          }
          return FlDotCirclePainter(radius: 1.5, color: Colors.white.withOpacity(0.5));
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF02D39A).withOpacity(0.3),
            const Color(0xFF1A1C24).withOpacity(0.0) // Fade to card background
          ],
          stops: const [0.0, 0.8], // Adjusted stops for smoother fade
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    // Calculate horizontal interval for grid and left titles (aim for 3-5 lines)
    double horizontalGridInterval = (controller.maxY.value - controller.minY.value) > 0
        ? (controller.maxY.value - controller.minY.value) / 4 // Results in 4 sections, 5 lines
        : 1.0;
    if (horizontalGridInterval <= 0) horizontalGridInterval = controller.maxY.value / 4; // Fallback if min=max
    if (horizontalGridInterval <= 0) horizontalGridInterval = 1.0; // Ultimate fallback


    return LineChartData(
      lineBarsData: [lineBarData],
      minX: controller.minX.value,
      maxX: controller.maxX.value,
      minY: controller.minY.value,
      // Add a little padding to maxY if it's not zero, so highest point isn't at the very edge
      maxY: controller.maxY.value == 0 ? 1.0 : controller.maxY.value * 1.05,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: horizontalGridInterval,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Colors.white12, strokeWidth: 0.8); // Subtler grid lines
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 55, // Adjusted reserved size
            getTitlesWidget: leftTitleWidgets,
            interval: horizontalGridInterval, // Match grid lines
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            // Show fewer labels: interval is set to cover at most 4-5 labels
            interval: _getBottomTitleInterval(controller.maxX.value, desiredLabelCount: 4),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false), // No internal border for the chart plot area
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            final FlSpot spot = barData.spots[index];
            bool isHighest = controller.highestPendapatan.value != null &&
                spot.x == controller.highestPendapatan.value!.xValue &&
                spot.y == controller.highestPendapatan.value!.amount;
            bool isLowest = controller.lowestPendapatan.value != null &&
                spot.x == controller.lowestPendapatan.value!.xValue &&
                spot.y == controller.lowestPendapatan.value!.amount;

            Color indicatorColor = Colors.blueGrey; // Default touch color
            if (isHighest) indicatorColor = const Color(0xFF02D39A);
            if (isLowest) indicatorColor = Colors.redAccent;

            return TouchedSpotIndicatorData(
              FlLine(color: indicatorColor.withOpacity(0.7), strokeWidth: 2.5),
              FlDotData(
                getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                  radius: 7, // Touch indicator dot size
                  color: indicatorColor,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white.withOpacity(0.8),
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.black.withOpacity(0.85), // Removed for compatibility
          tooltipRoundedRadius: 6,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot; // Use barSpot directly, no .spot
              String titlePrefix = "";
              PendapatanDataPoint? pointInfo;

              if (controller.highestPendapatan.value?.xValue == flSpot.x &&
                  controller.highestPendapatan.value?.amount == flSpot.y) {
                pointInfo = controller.highestPendapatan.value;
                titlePrefix = 'Tertinggi: ';
              } else if (controller.lowestPendapatan.value?.xValue == flSpot.x &&
                  controller.lowestPendapatan.value?.amount == flSpot.y) {
                pointInfo = controller.lowestPendapatan.value;
                titlePrefix = 'Terendah: ';
              } else {
                try {
                  DateTime startDate = controller.currentRangeStartDate.value ?? DateTime.now();
                  DateTime spotDate = startDate.add(Duration(days: flSpot.x.toInt()));
                  pointInfo = PendapatanDataPoint(
                      date: spotDate, amount: flSpot.y, xValue: flSpot.x);
                } catch (e) {
                  print("Error calculating date for tooltip: $e");
                }
              }

              String dateText = pointInfo != null
                  ? _tooltipDateFormatter.format(pointInfo.date)
                  : 'N/A';
              String amountText = controller.formatCurrency(flSpot.y);

              return LineTooltipItem(
                '$titlePrefix$amountText\n$dateText',
                const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                textAlign: TextAlign.left,
              );
            }).toList();
          },
        ),
      ),
      // Keep showing tooltips for highest/lowest by default
      showingTooltipIndicators: _getShowingTooltipIndicators(spots, lineBarData),
    );
  }

  List<ShowingTooltipIndicators> _getShowingTooltipIndicators(
      List<FlSpot> spots, LineChartBarData lineBarData) {
    // Your existing logic for this is good.
    List<ShowingTooltipIndicators> tooltips = [];
    if (spots.isEmpty) return tooltips;

    if (controller.highestPendapatan.value != null) {
      final highestSpotX = controller.highestPendapatan.value!.xValue;
      final highestSpotIndex = spots.indexWhere((s) => s.x == highestSpotX && s.y == controller.highestPendapatan.value!.amount);
      if (highestSpotIndex != -1) {
        tooltips.add(ShowingTooltipIndicators([
          LineBarSpot(lineBarData, 0, spots[highestSpotIndex]),
        ]));
      }
    }
    if (controller.lowestPendapatan.value != null) {
      final lowestSpotX = controller.lowestPendapatan.value!.xValue;
      if (controller.highestPendapatan.value == null ||
          lowestSpotX != controller.highestPendapatan.value!.xValue ||
          controller.lowestPendapatan.value!.amount != controller.highestPendapatan.value!.amount) { // Check amount too
        final lowestSpotIndex = spots.indexWhere((s) => s.x == lowestSpotX && s.y == controller.lowestPendapatan.value!.amount);
        if (lowestSpotIndex != -1) {
          tooltips.add(ShowingTooltipIndicators([
            LineBarSpot(lineBarData, 0, spots[lowestSpotIndex]),
          ]));
        }
      }
    }
    return tooltips;
  }

  // Renamed from _getBottomTitleDivisor for clarity
  double _getBottomTitleInterval(double maxX, {int desiredLabelCount = 4}) {
    final numDays = maxX + 1;
    if (numDays <= 1) return 1;
    // Calculate interval so that at most desiredLabelCount labels are shown
    double interval = (numDays / desiredLabelCount).ceilToDouble();
    if (interval < 1) interval = 1;
    return interval;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w500); // Adjusted style
    String text;

    // Only show titles at calculated intervals or min/max, ensure value is not out of actual data bounds
    if (value < controller.minY.value || value > controller.maxY.value * 1.05) return Container(); // Hide if outside actual data scope + padding

    if (value == meta.min || value == meta.max || (meta.appliedInterval > 0 && (value - meta.min).abs() % meta.appliedInterval < 0.01) ) { // Check with tolerance
      if (value.abs() >= 1000000) {
        text = '${(value / 1000000).toStringAsFixed(value.abs() < 10000000 ? 1 : 0)}M';
      } else if (value.abs() >= 1000) {
        text = '${(value / 1000).toStringAsFixed(0)}K';
      } else {
        text = value.toInt().toString();
      }
      // Avoid drawing label "0" if minY is slightly negative due to padding but actual data starts at 0.
      if (controller.minY.value >= 0 && value < 0 && value.abs() < meta.appliedInterval /2 ) return Container();


      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 6, // Adjusted space
        child: Text(text, style: style, textAlign: TextAlign.left),
      );
    }
    return Container();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w500);
    Widget textWidget = Container();

    DateTime? rangeStartDateOpt = controller.currentRangeStartDate.value;
    if (rangeStartDateOpt == null) return Container();
    DateTime rangeStartDate = rangeStartDateOpt;

    if (value < controller.minX.value || value > controller.maxX.value) return Container();

    // Only show label if it's min, max, or an interval tick (with tolerance)
    bool isMinTick = (value - meta.min).abs() < 0.01;
    bool isMaxTick = (value - meta.max).abs() < 0.01;
    bool isIntervalTick = meta.appliedInterval > 0 && ((value - meta.min).abs() % meta.appliedInterval) < 0.01;

    if (isMinTick || isMaxTick || isIntervalTick) {
      try {
        DateTime date = rangeStartDate.add(Duration(days: value.toInt()));
        String formattedDate;
        TimeRange currentTimeRange = controller.selectedTimeRange.value;

        if (currentTimeRange == TimeRange.oneYear) {
          formattedDate = DateFormat('yyyy').format(date);
        } else if (currentTimeRange == TimeRange.yearToDate || currentTimeRange == TimeRange.threeMonths) {
          formattedDate = DateFormat('MMM').format(date);
        } else if (currentTimeRange == TimeRange.oneMonth) {
          formattedDate = DateFormat('d MMM').format(date);
        } else if (currentTimeRange == TimeRange.oneWeek || currentTimeRange == TimeRange.oneDay) {
          formattedDate = DateFormat('E d').format(date);
        } else {
          formattedDate = DateFormat('dd/MM').format(date);
        }
        textWidget = Text(formattedDate, style: style);
      } catch (e) {
        textWidget = Text(value.toInt().toString(), style: style);
      }
    }

    return SideTitleWidget(axisSide: meta.axisSide, space: 6.0, child: textWidget);
  }

  // _getLeftTitleInterval is not strictly needed if matching grid, but can be kept for specific adjustments.
  // For now, left titles use same interval as grid.

  Widget _buildTimeRangeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Adjusted padding
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TimeRange.values.map((range) {
            bool isActive = controller.selectedTimeRange.value == range;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0), // Reduced horizontal padding between buttons
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? const Color(0xFF02D39A)
                        : const Color(0xFF2C2C2E), // Darker inactive button
                    foregroundColor: isActive ? Colors.black : Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)), // Slightly less rounded
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9), // Adjusted padding
                    textStyle: TextStyle(
                        fontSize: 12, // Slightly smaller font
                        fontWeight: FontWeight.w600)),
                onPressed: controller.isLoading.value && controller.selectedTimeRange.value != range // Allow deselection even if loading, but not new selection
                    ? null
                    : () => controller.changeTimeRange(range),
                child: Text(_getTimeRangeButtonText(range)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getTimeRangeButtonText(TimeRange range) {
    // Your existing mapping is good
    switch (range) {
      case TimeRange.oneDay: return '1D';
      case TimeRange.oneWeek: return '1W';
      case TimeRange.oneMonth: return '1M';
      case TimeRange.threeMonths: return '3M';
      case TimeRange.yearToDate: return 'YTD';
      case TimeRange.oneYear: return '1Y';
      default: return '';
    }
  }
}