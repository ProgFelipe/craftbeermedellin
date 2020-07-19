import 'package:craftbeer/providers/delivery_picker_provider.dart';
import 'package:craftbeer/ui/components/consents.dart';
import 'package:craftbeer/ui/components/delivery_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DeliveryPicker extends StatefulWidget {
  @override
  _DeliveryPickerState createState() => _DeliveryPickerState();
}

class _DeliveryPickerState extends State<DeliveryPicker> {
  void goToConsents() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Consents(),
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  LocationResult _pickedLocation;
  final focus = FocusNode();

  var colorMapPicker = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryPickerData>(
        builder: (context, deliveryPickerData, child) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final form = _formKey.currentState;
            if (form.validate() && (_pickedLocation?.latLng != null ||
                deliveryPickerData.delivery.latitude != null)) {
              form.save();
              if (_pickedLocation?.latLng != null) {
                deliveryPickerData.delivery.latitude =
                    _pickedLocation.latLng.latitude.toString();
                deliveryPickerData.delivery.longitude =
                    _pickedLocation.latLng.longitude.toString();
              }
              deliveryPickerData.saveAddress();
              goToConsents();
            } else {
              _scaffoldKey.currentState
                ..showSnackBar(SnackBar(
                  content: Text(
                    'El formulario no esta correcto',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.amberAccent,
                ));
            }
          },
          child: Text(
            'PEDIR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    DeliveryIcon.food_delivery,
                    color: Colors.amber,
                    size: 80.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Icon(
                    DeliveryIcon.box,
                    size: 80.0,
                    color: Colors.green,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: 40.0,
              ),
              FutureBuilder(
                future: deliveryPickerData.preFillDataIfExist(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child: Text('Cargando...'),);
                  }
                  return Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                            initialValue: snapshot.data
                                ? deliveryPickerData.delivery.address
                                : '',
                            style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0),
                            decoration: InputDecoration(
                              labelText: 'Dirección',
                              border: OutlineInputBorder(),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty || value.length > 95) {
                                return 'Ingrese una dirección válida';
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus);
                            },
                            onSaved: (val) =>
                                setState(() =>
                                deliveryPickerData.delivery.address = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            initialValue: snapshot.data
                                ? deliveryPickerData.delivery.description
                                : '',
                            focusNode: focus,
                            style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0),
                            decoration: InputDecoration(
                              labelText: 'Ciudad, Unidad, #Apto-Casa',
                              border: OutlineInputBorder(),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              // ignore: missing_return
                              if (value.isEmpty) {
                                return 'Ingrese información valida';
                              }
                            },
                            textInputAction: TextInputAction.done,
                            onSaved: (val) =>
                                setState(() =>
                                deliveryPickerData.delivery.description =
                                    val),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              LocationResult result = await showLocationPicker(
                                context,
                                'AIzaSyBwoPqHzBg0iywMArQ0RZywYCkjKv78X9c',
                                initialCenter: LatLng(31.1975844, 29.9598339),
                                automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
//                      resultCardAlignment: Alignment.bottomCenter,
                              );
                              print("result = $result");
                              setState(() {
                                _pickedLocation = result;
                                colorMapPicker = Colors.blue;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              alignment: Alignment.center,
                              color:
                              snapshot.data ? Colors.blue : colorMapPicker,
                              height: 50.0,
                              width: double.infinity,
                              child: Text(
                                'UBICACIÓN EN MAPA',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ),
                        ])),
                  );
                }
              ),
              SizedBox(
                height: 30.0,
              ),
              ImageProviderWidget(
                  'https://i.giphy.com/media/h8NdYZJGH1ZRe/giphy.gif'),
            ],
          ),
        ),
      );
    });
  }
}
