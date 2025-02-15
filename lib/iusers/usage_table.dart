import 'package:caspernet/iusers/usage_data.dart';
import 'package:flutter/material.dart';

class UsageTable extends StatelessWidget {
  final List<UsageData> dataList;

  const UsageTable(this.dataList, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04; // Adjust the multiplier as needed

    if (dataList.isEmpty) {
      return Center(
        child: Text('No data available',
            style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _buildTableHeader(context, 'Username', fontSize),
            _buildTableHeader(context, 'Used\n(Min)', fontSize),
            _buildTableHeader(context, 'Extra\n(Min)', fontSize),
            _buildTableHeader(context, '  Bill\n(BDT)', fontSize),
          ],
        ),
        ...dataList.map((data) {
          var dataMap = data.toMap();
          return TableRow(children: [
            _buildTableCell(context, dataMap['username'].toString(), fontSize),
            _buildTableCell(context, dataMap['totalUse'].toString(), fontSize),
            _buildTableCell(context, dataMap['extraUse'].toString(), fontSize),
            _buildTableCell(
                context, dataMap['estimatedBill'].toString(), fontSize),
          ]);
        }),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context, String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize + 2),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
