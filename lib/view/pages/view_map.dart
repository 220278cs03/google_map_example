import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_usage/controller/main_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

import '../../utils/on_unfocused_tap.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainController>().setMarkerIcon(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = context.read<MainController>();
    final state = context.watch<MainController>();

    return OnUnFocusTap(
      child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: state.type,
                //type of map
                zoomControlsEnabled: false,
                //delete the button of android
                myLocationButtonEnabled: false,
                // delete the button of ios
                //padding: EdgeInsets.all(16), place of Google Logo
                initialCameraPosition: const CameraPosition(
                    target: LatLng(41.31410355607751, 69.2489082268902),
                    zoom: 20),
                markers: state.setOfMarker,
                polylines: {
                  Polyline(
                      polylineId: const PolylineId("1"),
                      points: state.list,
                      color: Colors.blue),
                },
                onMapCreated: (GoogleMapController controller) {
                  event.setMap(controller);
                },
              ),
              SafeArea(
                  child: Container(
                margin: const EdgeInsets.only(top: 16, right: 24, left: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 6),
                          color: Colors.grey.withOpacity(0.8))
                    ]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    controller: controller,
                    onChanged: (s) {
                      event.search(s);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32),borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32),borderSide: BorderSide.none),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32),borderSide: BorderSide.none),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32),borderSide: BorderSide.none),
                        hintText: "Search",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        suffixIcon: controller.text.isNotEmpty
                            ? GestureDetector(
                                child: const Icon(Icons.clear),
                                onTap: () {
                                  controller.clear();
                                },
                              )
                            : const Icon(Icons.search)),
                  ),
                  (state.searchText?.isNotEmpty ?? false)
                      ? FutureBuilder(
                          future: Nominatim.searchByName(
                            query: state.searchText,
                            limit: 5,
                            addressDetails: true,
                            extraTags: true,
                            nameDetails: true,
                          ),
                          builder: (context, value) {
                            if (value.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.data?.length ?? 0,
                                  itemBuilder: (context2, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // controller.text = value.data?[index].displayName ?? "";
                                        // setState(() {});
                                        FocusScope.of(context).unfocus();
                                        event.search("");
                                        state.position =
                                            await event.determinePosition();
                                        // ignore: use_build_context_synchronously
                                        event.getRoute(
                                            context,
                                            LatLng(state.position.latitude,
                                                state.position.longitude),
                                            LatLng(value.data?[index].lat ?? 0,
                                                value.data?[index].lon ?? 0));
                                        state.place = value.data?[index];
                                        state.mapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                    state.position.latitude,
                                                    state.position.longitude),
                                                zoom: 18),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                            value.data?[index].displayName ?? ""),
                                      ),
                                    );
                                  });
                            } else if (value.hasError) {
                              return Text(value.error.toString());
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(),
                              );
                            }
                          })
                      : const SizedBox.shrink(),
                ]),
              ))
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  event.changeMapType(state.type);
                },
                child: const Icon(
                  Icons.change_circle,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
              8.verticalSpace,
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  var position = await event.determinePosition();
                  state.mapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 18)));
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            ],
          )),
    );
  }
}
