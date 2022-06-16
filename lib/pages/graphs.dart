import 'dart:math' as math;

import 'package:alltracker_app/models/consumption_post.dart';
import 'package:alltracker_app/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphsPage extends StatefulWidget {
  final List<ConsumptionPost> posts;
  const GraphsPage({Key? key, required this.posts}) : super(key: key);

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  List<Widget> bottomRow = [];
  @override
  Widget build(BuildContext context) {
    bottomRow = [];
    var lineBarData = widget.posts.map((cp) => toSpots(cp)).toList();
    var spotMap = lineBarData.expand((lb) => lb.spots);
    var minX = (spotMap.reduce((curr, next) => curr.x < next.x ? curr : next).x);
    var maxX = (spotMap.reduce((curr, next) => curr.x > next.x ? curr : next).x) + 1;
    var minY = (spotMap.reduce((curr, next) => curr.y < next.y ? curr : next).y);
    var maxY = (spotMap.reduce((curr, next) => curr.y > next.y ? curr : next).y) * 1.2;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Graf oversigt"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        showOnTopOfTheChartBoxArea: false,
                        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    titlesData: titlesData1,
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xff4e4965), width: 4),
                        left: BorderSide(color: Colors.transparent),
                        right: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    lineBarsData: lineBarData,
                    // miny: lineBarData.map((e) => e),
                    // minX: lineBarData.reduce((curr, next) => curr.spots.reduce((a, b) => a. > b ? a : b) > next.spots.reduce((a, b) => a > b ? a : b)),
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: bottomRow
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        // reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          String text = (DateTime.fromMillisecondsSinceEpoch(value.toInt() * 86400000)).toReadableString();
          return SideTitleWidget(
            axisSide: meta.axisSide,
            // space: 10,
            // child: const Text("100", style: TextStyle(
            //   color: Color(0xff72719b),
            //   fontWeight: FontWeight.bold,
            //   fontSize: 16,
            // ),),
            child: Text(text),
          );
        } 
      )
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      ),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false)
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false)
    )
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      space: 10,
      axisSide: meta.axisSide,
      child: Text('$value'), 
    );
  }

  LineChartBarData toSpots(ConsumptionPost post) {
    Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    double total = post.registrations.map((cp) => cp.amount).fold(0, (a, b) => a + b);
    double avg = total / post.registrations.length;
    bottomRow.add(
      Column(
        children: [
          Text(post.name, style: TextStyle(color: color),),
          Text('${total.toStringAsFixed(3)} / ${avg.toStringAsFixed(3)}', style: TextStyle(color: color)),
        ],
      )
    );
    return LineChartBarData(
      isCurved: true,
      color: color, 
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: post.registrations.map<FlSpot>((cr) => FlSpot(
        cr.date.onlyDate().millisecondsSinceEpoch.toDouble() / 86400000, 
        cr.amount
      )).toList()
    );
  }
}