import 'package:flutter/material.dart';
import 'package:google_map_usage/controller/main_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainController>()..setMarkerIcon(context)..getRoute(context,LatLng(41.285416, 69.204007), LatLng(41.32700746765219, 69.42740418456385));

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = context.read<MainController>();
    final state = context.watch<MainController>();

    return Scaffold(
        body: GoogleMap(
          mapType: state.type,
          //type of map
          zoomControlsEnabled: false,
          //delete the button of android
          myLocationButtonEnabled: false,
          // delete the button of ios
          //padding: EdgeInsets.all(16), place of Google Logo
          initialCameraPosition: const CameraPosition(
              target: LatLng(41.32916835570262, 69.22062834544106), zoom: 20),
          markers: state.setOfMarker,
          polylines: {
            Polyline(
                polylineId: PolylineId("1"),
                points: state.list,
                color: Colors.blue),
          },
          onMapCreated: (GoogleMapController controller) {},
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            event.changeMapType(state.type);
          },
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ));
  }
}
