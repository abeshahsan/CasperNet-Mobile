import 'package:caspernet/iusers/usage_data.dart';
import 'package:flutter/material.dart';

class UsageTable extends StatelessWidget {
  final List<UsageData> dataList;

  const UsageTable(this.dataList, {super.key});

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: [
            _buildTableHeader('Username'),
            _buildTableHeader('Used\n(Min)'),
            _buildTableHeader('Extra\n(Min)'),
            _buildTableHeader('  Bill\n(BDT)'),
          ],
        ),
        ...dataList.map((data) {
          var dataMap = data.toMap();
          return TableRow(children: [
            _buildTableCell(dataMap['username'].toString()),
            _buildTableCell(dataMap['totalUse'].toString()),
            _buildTableCell(dataMap['extraUse'].toString()),
            _buildTableCell(dataMap['estimatedBill'].toString()),
          ]);
        }),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text),
        ),
      ),
    );
  }
}
