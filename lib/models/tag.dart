class Tag {
  String epc;
  String pc;
  String tid;
  String rssi;

  Tag({this.epc, this.pc, this.tid, this.rssi});

  factory Tag.fromJson(Map<dynamic, dynamic> json){
    final castedJson=json.cast<String, String>();
    return Tag(
      epc: castedJson["epc"],
      pc: castedJson["pc"],
      tid: castedJson["tid"],
      rssi: castedJson["rssi"],
    );
  }
}
