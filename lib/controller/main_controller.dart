import 'package:flutter/material.dart';
import 'package:google_map_usage/domain/repository/main_repository.dart';
import 'package:google_map_usage/domain/service/marker_image_cropper.dart';
import 'package:google_map_usage/utils/info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/model/route_model.dart';

class MainController extends ChangeNotifier {
  MapType type = MapType.normal;
  MainRepo mainRepo = MainRepo();

  //BitmapDescriptor? myMarker;
  Set<Marker> setOfMarker = {};
  final MarkerImageCropper markerImageCropper = MarkerImageCropper();
  List<LatLng> list = [];

  changeMapType(MapType mapType) {
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

  // void setMarkerIcon(BuildContext context) async {
  //   myMarker = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(size: Size(50, 50)), "assets/akfauni_logo.png");
  //   setOfMarker.addAll({
  //     Marker(
  //         markerId: const MarkerId("1"),
  //         draggable: true,
  //         consumeTapEvents: true,
  //         icon: myMarker ?? BitmapDescriptor.defaultMarker,
  //         position: const LatLng(41.285416, 69.204007),
  //         onTap: () {
  //           showInfo(context, false);
  //         },
  //         onDrag: (location) {}),
  //     Marker(
  //         markerId: const MarkerId("2"),
  //         draggable: true,
  //         consumeTapEvents: true,
  //         icon: myMarker ?? BitmapDescriptor.defaultMarker,
  //         position: const LatLng(41.32700746765219, 69.42740418456385),
  //         onTap: () {
  //           showInfo(context, true);
  //         },
  //         onDrag: (location) {}),
  //   });
  //   notifyListeners();
  // }

  //custom marker
  void setMarkerIcon(BuildContext context) async {
    var myMarker1 = await markerImageCropper.resizeAndCircle(
        "https://kursi24.uz/upload/resize_cache/iblock/3fe/260_170_1/3fed21cae9c2e2a1cfd173f40697379d.jpg", 70);
    var myMarker2 = await markerImageCropper.resizeAndCircle(
        "https://play-lh.googleusercontent.com/nZ_NMBuJ-Jy5C51C4y34V-vimdfVp0xfQJoHcOyk6p2ybPyG6SbtOuzQtPtz6StRv9h8",
        70);
    setOfMarker.addAll({
      Marker(
          markerId: const MarkerId("1"),
          draggable: true,
          consumeTapEvents: true,
          icon: myMarker1,
          position: const LatLng(41.285416, 69.204007),
          onTap: () {
            showInfo(context, false);
          },
          onDrag: (location) {}),
      Marker(
          markerId: const MarkerId("2"),
          draggable: true,
          consumeTapEvents: true,
          icon: myMarker2,
          position: const LatLng(41.32700746765219, 69.42740418456385),
          onTap: () {
            showInfo(context, true);
          },
          onDrag: (location) {}),
    });
    notifyListeners();
  }

  getRoute(BuildContext context, LatLng start, LatLng end) async {
    DrawRouting? routing =
    await mainRepo.getRout(context: context, start: start, end: end);

    List ls = routing?.features[0].geometry.coordinates ?? [];
    for (int i = 0; i < ls.length; i++) {
      list.add(LatLng(ls[i][1], ls[i][0]));
    }
    notifyListeners();
  }

}
