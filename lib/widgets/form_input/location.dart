import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFN = FocusNode();
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPostition = _center;
  MapType _currentMapType = MapType.normal;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPostition = position.target;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _addressInputFN.addListener(_updateLocation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _addressInputFN.removeListener(_updateLocation);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFN,
          child: TextFormField(
            focusNode: _addressInputFN,
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 500.0,
          child: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer())
            ].toSet(),
            mapType: _currentMapType,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
      ],
    );
  }
}
