import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/providers/walk_details_scr_provider.dart';
import 'package:walking_app/utils/app_colors.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<WalkDetailsScrProvider>().prepareDataToExport();
  }

  @override
  void dispose() {
    context.read<WalkDetailsScrProvider>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalkDetailsScrProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Walk details'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.walk.initT.formatted,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 7),
              Text(
                'Interval: ${provider.walk.interval} sec',
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: provider.isChartView
                    ? _buildChartView(provider)
                    : _buildDataView(provider),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChartView(WalkDetailsScrProvider provider) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: provider.walk.steps
                .map((e) => FlSpot(e.coordinates[0], e.coordinates[1]))
                .toList(),
          )
        ],
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map(
                  (e) => LineTooltipItem(
                    '${e.x}, ${e.y}',
                    const TextStyle(
                      fontSize: 16,
                      color: AppColors.headingTextColor,
                    ),
                  ),
                )
                .toList();
          },
        )),
        titlesData: const FlTitlesData(show: false),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildDataView(WalkDetailsScrProvider provider) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FractionColumnWidth(0.1),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.headingTextColor),
          children: [
            _tableCell('No.'),
            _tableCell('X'),
            _tableCell('Y'),
            _tableCell('Heading'),
            _tableCell('Time'),
          ],
        ),
        ...provider.excelData.map(
          (row) => TableRow(
            children: row.indexed
                .map(
                  (cell) => TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      color: cell.$1 == 0
                          ? AppColors.lightTextColor
                          : cell.$1 == 1 || cell.$1 == 2
                              ? AppColors.yellowAccent
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
      ],
    );
  }

  _tableCell(String value) {
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
}
