import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pinzeria/ui/basket_page/data/models.dart';
import 'package:yandex_autocomplete/models/result_object.dart';
import 'package:yandex_autocomplete/network/place_coder.dart';

class AddressWidget extends StatefulWidget {
  GlobalKey globalKey;
  void Function(AddressData addressData) onChange;
  AddressWidget({required this.onChange, required this.globalKey}) {}
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String _output = '';
  final _textController = TextEditingController();

  List<String> suggestions = [];

  AddressData addressData = AddressData(
      house: '',
      street: '',
      flat: 0,
      floor: 0,
      entrance: 0,
      doorphone: '',
      city: '',
      deliveryCost: 0.0);

  @override
  void initState() {
    _addressController.text = '';

    _latitudeController.text = '52.2165157';
    _longitudeController.text = '6.9437819';

    super.initState();
  }

  Future<void> getData(String value) async {
    geoPlace = await PlaceCoder.getPlace(text: value);
    suggestions.clear();
    //  if (geoPlace.results == null) geoPlace.results = [];
    for (int i = 0; i < geoPlace.results!.length; i++) {
      String address = '';
      String city = '';
      String street = '';
      String house = '';

      if (geoPlace.results![i].title != null) {
        // if (geoPlace.results![i].subtitle != null) {
        //   address = geoPlace.results![i].subtitle!.text.toString() +
        //       ', ' +
        //       geoPlace.results![i].title!.text.toString();
        // } else {
        //   address = geoPlace.results![i].title!.text.toString();
        // }
        try {
          city = geoPlace.results![i].address!.component!
                  .firstWhere((element) => element.kind!.first == 'LOCALITY')
                  .name! +
              ', ';
        } catch (_) {
          city = '';
        }

        try {
          street = geoPlace.results![i].address!.component!
                  .firstWhere((element) => element.kind!.first == 'STREET')
                  .name! +
              ', ';
        } catch (_) {
          street = '';
        }

        try {
          house = geoPlace.results![i].address!.component!
              .firstWhere((element) => element.kind!.first == 'HOUSE')
              .name!;
        } catch (_) {
          house = '';
        }

        address = city + street + house;
      }
      // if (geoPlace.results![i].subtitle != null) {
      //   address =
      //       address + ' ' + geoPlace.results![i].subtitle!.text.toString();
      // }
      if (address.isNotEmpty) suggestions.add(address);
    }
    setState(() {});
  }

  GeoPlace geoPlace = GeoPlace()..results = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fontSize = height / 60;

    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        semanticContainer: true,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        child: Container(
          height: height * 0.24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color.fromARGB(221, 236, 234, 214),
                Color.fromARGB(221, 236, 234, 214),
                Color.fromARGB(221, 236, 234, 214),
                Color.fromARGB(221, 236, 234, 214),
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 0,
                    height: 0,
                    child: Form(
                      key: widget.globalKey,
                      child: TextFormField(validator: (value) {
                        if (addressData.street == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Поле адрес не должно быть пустым',
                                  style: const TextStyle(color: Colors.red))));
                          return '';
                        }
                        if (addressData.house == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Пожалуйста, выберите номер дома из списка',
                                  style: const TextStyle(color: Colors.red))));
                          return '';
                        }
                        locationFromAddress(addressData.city +
                                addressData.street +
                                ',' +
                                addressData.house)
                            .then((locations) {
                          print(locations);
                          if (locations.isEmpty)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Укажите корректный адрес доставки',
                                    style:
                                        const TextStyle(color: Colors.red))));
                        });

                        if (_output == 'Точка находится вне зоны доставки') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Укажите обслуживаемую точку доставки',
                                  style: const TextStyle(color: Colors.red))));
                          return '';
                        }
                        //'Выберите номер дома из списка';
                        // TODO Реализовать метод
                        return null;
                      }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: width * 0.9,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              helperText: 'Улица, дом*',
                              helperStyle:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                            child: Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) async {
                                print('TEXT ${textEditingValue.text}');

                                try {
                                  String house =
                                      textEditingValue.text.split(',')[2];
                                  if (house != addressData.house)
                                    addressData.house = '';
                                } catch (_) {
                                  addressData.house = '';
                                }

                                await getData(textEditingValue.text);
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                for (String i in suggestions) {
                                  print(i);
                                }
                                print(suggestions.length);
                                print(suggestions.where((String option) {
                                  return option
                                      .toLowerCase()
                                      .contains(textEditingValue.text);
                                }));
                                var listSuggestions = suggestions;
                                //     suggestions.where((String option) {
                                //   return option.toLowerCase().contains(
                                //       textEditingValue.text.toLowerCase());
                                // });
                                if (listSuggestions.isEmpty)
                                  addressData.house = '';
                                return listSuggestions;
                              },
                              onSelected: (String selection) async {
                                addressData.street = selection;
                                widget.onChange(addressData);

                                try {
                                  addressData.city = selection.split(',').first;
                                  addressData.street = selection.split(',')[1];
                                  addressData.house = selection.split(',')[2];
                                  print('address:' +
                                      addressData.city +
                                      ', ' +
                                      addressData.street +
                                      ', ' +
                                      addressData.house);
                                  locationFromAddress(addressData.city +
                                          ',' +
                                          addressData.street +
                                          ',' +
                                          addressData.house)
                                      .then((locations) async {
                                    var output = 'Нет результата';

                                    if (locations.isNotEmpty) {
                                      output = locations[0].toString();
                                      var data = {
                                        "x": locations[0].latitude,
                                        "y": locations[0].longitude
                                      };
                                      print('address: ${data}');
                                      Response response = await Dio().post(
                                          'http://147.45.109.158:8881/orders_info/get_area_delivery/',
                                          data: {
                                            "x": locations[0].latitude,
                                            "y": locations[0].longitude
                                          });

                                      setState(() {
                                        if (response.data.toString() ==
                                            'Точка находится вне зоны доставки') {
                                          _output = response.data.toString();
                                          addressData.deliveryCost = 0.0;
                                          widget.onChange(addressData);
                                          return;
                                        }
                                        String area = response.data['name'];
                                        String cost = response.data['coast']
                                            .toString()
                                            .split('.')
                                            .first;
                                        setState(() {
                                          addressData.deliveryCost =
                                              double.parse(cost);
                                          _output =
                                              'Стоимость доставки составит $cost рублей';
                                          widget.onChange(addressData);
                                        });
                                      });
                                    }
                                  });
                                } catch (_) {
                                  addressData.house = '';
                                  print(_);
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: width * 0.2,
                          child: TextField(
                              cursorColor:
                                  const Color.fromARGB(255, 40, 40, 40),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                addressData.flat = int.parse(value);
                                widget.onChange(addressData);
                              },
                              autocorrect: true,
                              // controller: _addressController,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: InputDecoration(
                                helperText: 'Квартира',
                                helperStyle: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.redAccent),
                              ))),
                      SizedBox(
                        width: width * 0.15,
                        child: TextFormField(
                            // validator: (value) {
                            //   if (addressData.street == '')
                            //     return ''; //'Введите адрес!';
                            //   if (addressData.house == '')
                            //     return ''; //'Выберите номер дома из списка';
                            //   // TODO Реализовать метод
                            //   return null;
                            // },
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              addressData.entrance = int.parse(value);
                              widget.onChange(addressData);
                            },
                            autocorrect: true,
                            // controller: _addressController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              helperText: 'Подъезд',
                              helperStyle:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )),
                      ),
                      SizedBox(
                        width: width * 0.15,
                        child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              addressData.floor = int.parse(value);
                              widget.onChange(addressData);
                            },
                            autocorrect: true,
                            // controller: _addressController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              helperText: 'Этаж',
                              helperStyle:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )),
                      ),
                      SizedBox(
                        width: width * 0.15,
                        child: TextField(
                            onChanged: (value) {
                              addressData.doorphone = value;
                              widget.onChange(addressData);
                            },
                            autocorrect: true,
                            // controller: _addressController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              helperText: 'Домофон',
                              helperStyle:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: height * 0.03)),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      _output,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
