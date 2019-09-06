import 'dart:math';

class Tag {
  String epc;
  String pc;
  String tid;
  double rssi;
  double distance;

  Tag({this.epc, this.pc, this.tid, this.rssi, this.distance});

  factory Tag.fromJson(Map<dynamic, dynamic> json) {
    final castedJson = json.cast<String, String>();
    return Tag(
      epc: castedJson["epc"],
      pc: castedJson["pc"],
      tid: castedJson["tid"],
      rssi: double.tryParse(castedJson["rssi"]),
    );
  }

  void calculateDistance(double readerRssiAtOneMeter) {
    double result = pow(10, ((readerRssiAtOneMeter - this.rssi) / 20));
    
    // Update the distance when the new value is less than the current one.
    if (distance == null || distance == 0 || result < distance) {
      // Converting distance to 2 decimals value
      this.distance = double.parse(result.toStringAsFixed(2));
    }
  }
}
