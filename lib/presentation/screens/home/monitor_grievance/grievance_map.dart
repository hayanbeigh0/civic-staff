import 'dart:async';

import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GrievanceMap extends StatefulWidget {
  static const routeName = 'grievanceMap';
  const GrievanceMap({super.key});

  @override
  State<GrievanceMap> createState() => _GrievanceMapState();
}

class _GrievanceMapState extends State<GrievanceMap> {
  final Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor busLocationMarker = BitmapDescriptor.defaultMarker;

  Set<Marker> grievanceMarkers = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GrievancesBloc>(context).add(LoadGrievancesEvent());
    return Scaffold(
      body: BlocConsumer<GrievancesBloc, GrievancesState>(
        listener: (context, state) {
          if (state is GrievancesLoadedState) {
            grievanceMarkers = state.grievanceList
                .map(
                  (e) => Marker(
                    markerId: MarkerId(e.grievanceId.toString()),
                    infoWindow: InfoWindow(
                      snippet: 'Status: ${e.status}',
                      title: e.grievanceType,
                      onTap: () => Navigator.of(context).pushNamed(
                        GrievanceDetail.routeName,
                        arguments: {
                          "state": state,
                          "index": state.grievanceList.indexOf(e),
                        },
                      ),
                    ),
                    icon: e.grievanceType
                                .toString()
                                .toLowerCase()
                                .replaceAll(' ', '') ==
                            'garbagecollection'
                        ? BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRose,
                          )
                        : e.grievanceType
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll(' ', '') ==
                                'streetlighting'
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue,
                              )
                            : e.grievanceType
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '') ==
                                    'construction'
                                ? BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen,
                                  )
                                : e.grievanceType
                                            .toString()
                                            .toLowerCase()
                                            .replaceAll(' ', '') ==
                                        'watersupply/drainage'
                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueYellow,
                                      )
                                    : e.grievanceType
                                                .toString()
                                                .toLowerCase()
                                                .replaceAll(' ', '') ==
                                            'certificaterequest'
                                        ? BitmapDescriptor.defaultMarkerWithHue(
                                            BitmapDescriptor.hueCyan,
                                          )
                                        : e.grievanceType
                                                    .toString()
                                                    .toLowerCase()
                                                    .replaceAll(' ', '') ==
                                                'houseplanapproval'
                                            ? BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                BitmapDescriptor.hueOrange,
                                              )
                                            : e.grievanceType
                                                        .toString()
                                                        .toLowerCase()
                                                        .replaceAll(' ', '') ==
                                                    'roadmaintainance'
                                                ? BitmapDescriptor.defaultMarkerWithHue(
                                                    BitmapDescriptor.hueViolet,
                                                  )
                                                : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                    position: LatLng(
                      double.parse(e.latitude.toString()),
                      double.parse(e.longitude.toString()),
                    ),
                  ),
                )
                .toList()
                .toSet();
          }
        },
        builder: (context, state) {
          if (state is GrievancesLoadedState) {
            return GoogleMap(
              markers: grievanceMarkers,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(
                    state.grievanceList.first.latitude.toString(),
                  ),
                  double.parse(
                    state.grievanceList.first.longitude.toString(),
                  ),
                ),
                zoom: 12,
              ),
              zoomControlsEnabled: true,
              scrollGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) async {
                if (mounted) {
                  _mapController.complete(controller);
                }
                // BlocProvider.of<ReverseGeocodingCubit>(context)
                //     .loadReverseGeocodedAddress(
                //   latitude,
                //   longitude,
                // );
              },
              mapType: MapType.terrain,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
