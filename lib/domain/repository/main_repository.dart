import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/route_model.dart';
import '../service/dio_service.dart';

class MainRepo {
  DioService dio = DioService();

  Future<DrawRouting?> getRout(
      {required BuildContext context,
      required LatLng start,
      required LatLng end}) async {
    try {
      final qData = {
        "api_key": "5b3ce3597851110001cf624843605dfa84e94b4ba6fca9da96314b18",
        "start": "${start.longitude},${start.latitude}",
        "end": "${end.longitude},${end.latitude}"
      };
      var res = await dio
          .client()
          .get("/v2/directions/driving-car", queryParameters: qData);
      return DrawRouting.fromJson(res.data);
      // ignore: empty_catches
    } on DioError {}
    return null;
  }
}
