import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Location {
  Location({required this.latitude, required this.longitude});
  double latitude;
  double longitude;
  Future<void> getLocation() async {
    // get current permission status of location
    var permissionStatus = await Permission.locationWhenInUse.status;

    // if restricted, it can't be used
    if (permissionStatus == PermissionStatus.restricted) {
      return Future.value(false);
    }

    // it can be switched off, so it can't be used
    if (!await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      return Future.value(false);
    }

    // if user permanently denied access, it can't be used
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return Future.value(false);
    }

    // get permission and return result
    bool request = await Permission.locationWhenInUse.request().isGranted;
    if (request) {
      // get location here
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print(e);
      }
    }
  }
}
