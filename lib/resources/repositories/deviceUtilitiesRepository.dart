import 'package:biblio/resources/api/PlatformApi.dart';
import 'package:biblio/models/deviceCapabilities.dart';

class DeviceUtilitiesRepository {
  PlatformApi _platformApi;
  DeviceCapabilities deviceCapabilities;

  void init() {
    _platformApi = PlatformApi(methodChannelID: 'biblio/utilities');
  }

  void dispose() {
    deviceCapabilities = null;
  }

  Future<DeviceCapabilities> getDeviceCapabilities() async {
    if (deviceCapabilities == null) {
      List<dynamic> capabilities =
          await _platformApi.invokeMethodAndGetResult('getDeviceCapabilities');

      if (capabilities != null) {
        deviceCapabilities = DeviceCapabilities();
        capabilities.cast<String>().forEach((String capability) {
          switch (capability) {
            case "camera":
              deviceCapabilities.camera = true;
              break;
            case "rfidTagsReading":
              deviceCapabilities.rfidTagsReading = true;
              break;
          }
        });
      }
    }
    return deviceCapabilities;
  }
}
