
class UsageData {
  String fullName;
  String id;
  int usedMins;
  int billAmount;
  static final int totalMins = 13200;
  int exceededMins;

  UsageData({
    required this.fullName,
    required this.id,
    required this.usedMins,
    required this.billAmount,
    required this.exceededMins,
  });

  factory UsageData.fromArray(List<String> data) {
    return UsageData(
      fullName: data[0],
      id: data[1],
      usedMins: int.tryParse(data[2]) ?? 0,
      exceededMins: int.tryParse(data[3]) ?? 0,
      billAmount: int.tryParse(data[4]) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Name: $fullName\nID: $id\nUsed Minutes: $usedMins\nBill Amount: $exceededMins\nExceeded Minutes: $billAmount';
  }
}
