import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_usage/utils/info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainController extends ChangeNotifier {
  MapType type = MapType.normal;
  BitmapDescriptor? myMarker;
  Set<Marker> setOfMarker = {};

  changeMapType(MapType mapType) {
    print(mapType);
    switch (mapType) {
      case MapType.normal:
        type = MapType.hybrid;
        break;
      case MapType.hybrid:
        type = MapType.satellite;
        break;
      case MapType.satellite:
        type = MapType.terrain;
        break;
      case MapType.terrain:
        type = MapType.normal;
        break;
      case MapType.none:
        type = MapType.normal;
        break;
    }
    notifyListeners();
  }

  showInfo(BuildContext context, bool isUni) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: InfoAkfa(
              uni: isUni,
            ),
          );
        });
    notifyListeners();
  }

  void setMarkerIcon(BuildContext context) async {
    myMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)), "assets/akfauni_logo.png");
    setOfMarker.addAll({
      Marker(
          markerId: const MarkerId("1"),
          draggable: true,
          consumeTapEvents: true,
          icon: myMarker ?? BitmapDescriptor.defaultMarker,
          position: const LatLng(41.285416, 69.204007),
          onTap: () {
            showInfo(context, false);
          },
          onDrag: (location) {}),
      Marker(
          markerId: const MarkerId("2"),
          draggable: true,
          consumeTapEvents: true,
          icon: myMarker ?? BitmapDescriptor.defaultMarker,
          position: const LatLng(41.32700746765219, 69.42740418456385),
          onTap: () {
            showInfo(context, true);
          },
          onDrag: (location) {}),
    });
    notifyListeners();
  }
}
