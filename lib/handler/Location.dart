import 'package:location/location.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

import '../Others/Environment.dart';

Future<Tuple3> getUserLocation() async {
  Location location = new Location();

  bool serviceStatus;
  PermissionStatus permissionStatus;
  LocationData? locationData;

  serviceStatus = await location.serviceEnabled();
  print("Service Status ${serviceStatus}");
  if (!serviceStatus) {
    serviceStatus = await location.requestService();
  }

  permissionStatus = await location.hasPermission();
  print("Perm Status ${permissionStatus}");
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();

  }

  if (serviceStatus == true && (permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.grantedLimited)) {
    locationData = await location.getLocation();
    print(locationData);
  }
  print("LOCC${locationData}");
  return Tuple3(locationData, serviceStatus, permissionStatus);
}

Future hereReverseGeocode(position) async {
  String url =
      'https://reverse.geocoder.ls.hereapi.com/6.2/reversegeocode.json?apiKey=${EnvironmentConfig.HERE_MAPS_KEY}&mode=retrieveAddresses&prox=${position.latitude.toString()},${position.longitude.toString()}';
  print(url);
  return await http.get(Uri.parse(url));
}