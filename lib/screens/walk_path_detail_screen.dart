import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/providers/walk_details_scr_provider.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_consts.dart';
import 'package:walking_app/utils/app_utils.dart';
import 'package:walking_app/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class WalkDetailScreen extends StatelessWidget {
  const WalkDetailScreen({super.key, required this.walk});

  final WalkPathModel walk;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalkDetailsScrProvider(walk: walk),
      child: const WalkDetailWidget(),
    );
  }
}

class WalkDetailWidget extends StatefulWidget {
  const WalkDetailWidget({super.key});

  @override
  State<WalkDetailWidget> createState() => _WalkDetailWidgetState();
}

class _WalkDetailWidgetState extends State<WalkDetailWidget> {
  late WalkDetailsScrProvider provider;

  @override
  void initState() {
    super.initState();
    context.read<WalkDetailsScrProvider>().prepareDataToExport();
  }

  FlLine getAxisDrawingLine(value) {
    if (value == 0) {
      return const FlLine(
        color: AppColors.brown,
        strokeWidth: 1,
      );
    } else {
      return const FlLine(
        color: AppColors.grey,
        dashArray: [8, 5],
        strokeWidth: 0.75,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalkDetailsScrProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.walkDetails),
          actions: [
            IconButton(
              onPressed: provider.shareCsv,
              icon: const Icon(CupertinoIcons.share),
            ),
            IconButton(
              onPressed: provider.changeView,
              icon: Icon(
                provider.isChartView
                    ? Icons.table_chart_rounded
                    : Icons.bar_chart_rounded,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                provider.walk.iniT.formatted,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              _buildDetailsRow(
                'Travelled distance',
                provider.walk.travelledDistance.formattedMeter,
              ),
              const SizedBox(height: 5),
              _buildDetailsRow(
                'Total Time',
                provider.walk.totalTime.formattedUnit,
              ),
              const SizedBox(height: 10),
              provider.isChartView
                  ? _buildChartView(provider)
                  : _buildDataTableView(provider)
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChartView(WalkDetailsScrProvider provider) {
    final List<double> minMaxXY = AppUtils.getMinMaxXY(
        provider.walk.steps.map((e) => e.coordinates).toList());
    return Expanded(
      child: LineChart(
        duration: const Duration(seconds: 1),
        LineChartData(
          backgroundColor: AppColors.yellow.withAlpha(50),
          lineBarsData: [
            LineChartBarData(
              color: AppColors.yellow,
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  if (p3 == 0) {
                    return FlDotCrossPainter(color: AppColors.green, size: 15);
                  }

                  if (p3 == p2.spots.length - 1) {
                    return FlDotCrossPainter(color: AppColors.red, size: 15);
                  }

                  return FlDotCirclePainter(color: AppColors.yellow, radius: 5);
                },
              ),
              spots: provider.walk.steps
                  .map((e) => FlSpot(e.coordinates[0], e.coordinates[1]))
                  .toList(),
            )
          ],
          gridData: FlGridData(
            getDrawingHorizontalLine: getAxisDrawingLine,
            getDrawingVerticalLine: getAxisDrawingLine,
          ),
          minX: minMaxXY[0] - 2,
          minY: minMaxXY[1] - 2,
          maxX: minMaxXY[2] + 2,
          maxY: minMaxXY[3] + 2,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                log('touchedSpots => $touchedSpots');
                return [
                  LineTooltipItem(
                    '${touchedSpots.first.x}, ${touchedSpots.first.y}',
                    const TextStyle(
                      fontSize: 16,
                      color: AppColors.bg,
                    ),
                  ),
                ];
              },
            ),
          ),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: Text(Strings.xAxisTitle),
              axisNameSize: 30,
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(Strings.yAxisTitle),
              axisNameSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTableView(WalkDetailsScrProvider provider) {
    return Expanded(
      child: Column(
        children: [
          // Heading table
          Table(
            border: TableBorder.all(),
            columnWidths: _columnWidthsMap(),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: AppColors.lYellow),
                children:
                    Consts.kTableHeadings.map((e) => _tableCell(e)).toList(),
              )
            ],
          ),
          // Data table
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                  border: const TableBorder(
                    verticalInside: BorderSide(),
                    horizontalInside: BorderSide(),
                    left: BorderSide(),
                    right: BorderSide(),
                    bottom: BorderSide(),
                  ),
                  columnWidths: _columnWidthsMap(),
                  children: provider.excelData
                      .map(
                        (row) => TableRow(
                          children: row.indexed
                              .map(
                                (cell) => TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    color: cell.$1 == 0
                                        ? AppColors.lYellow
                                        : cell.$1 == 1 || cell.$1 == 2
                                            ? AppColors.lRed.withAlpha(75)
                                            : AppColors.transparent,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Text(cell.$2),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String value) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.all(2),
        height: 40,
        alignment: Alignment.center,
        child: Text(value),
      ),
    );
  }

  Widget _buildDetailsRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Map<int, TableColumnWidth> _columnWidthsMap() => const {
        0: FractionColumnWidth(0.1),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      };
}
