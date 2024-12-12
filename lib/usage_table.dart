import 'package:caspernet/usage_data.dart';
import 'package:flutter/material.dart';

class UsageTable extends StatelessWidget {
  final List<UsageData> dataList;

  const UsageTable(this.dataList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: dataList.map((data) {
        var dataMap = data.toMap();
        return TableRow(children: [
          TableCell(child: Text(dataMap['username'].toString())),
          TableCell(child: Text(dataMap['totalUse'].toString())),
          TableCell(child: Text(dataMap['extraUse'].toString())),
          TableCell(child: Text(dataMap['estimatedBill'].toString())),
        ]);
      }).toList(),
    );
  }
}
