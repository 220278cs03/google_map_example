import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainController extends ChangeNotifier{

  MapType type = MapType.normal;

  changeMapType(MapType mapType){
    print(mapType);
    switch(mapType){
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
}