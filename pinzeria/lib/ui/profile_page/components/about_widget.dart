import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:valentino/ui/constants.dart';

class AboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fontSize = height / 50;
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        semanticContainer: true,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 98, 113, 84),
                Color.fromARGB(147, 113, 134, 97),
                Color.fromARGB(196, 102, 133, 86),
                Color.fromARGB(255, 63, 74, 53),
              ])),
          child: Column(children: [
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  //  bottomRight: Radius.circular(15),
                  // bottomLeft: Radius.circular(15))
                )),
                // tileColor: Color.fromARGB(100, 71, 105, 51),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ресторан итальянской кухни',
                      style: TextStyle(
                          fontFamily: 'Moniqa',
                          color: Colors.white,
                          fontSize: height * 0.04,
                          fontWeight: FontWeight.normal),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(children: [
                                    Icon(
                                      Icons.place,
                                      size: 15,
                                    ),
                                    GestureDetector(
                                        child: Text(
                                          ' Воронеж, площадь Ленина, 6',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        onTap: () async {
                                          final url =
                                              "https://yandex.ru/maps/org/valentino/124027389896/?ll=39.198355%2C51.660954&z=15";
                                          if (await canLaunch(url)) {
                                            await launch(
                                              url,
                                            );
                                          }
                                        }),
                                  ]),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.005)),
                                InkWell(
                                    onTap: () {},
                                    child: Row(children: [
                                      Icon(
                                        Icons.phone_iphone,
                                        size: 15,
                                      ),
                                      GestureDetector(
                                          child: Text(
                                            " +7 (473) 233-12-33",
                                            style: (TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13)),
                                          ),
                                          onTap: () async {
                                            final url = "tel://+7(473)2331233";
                                            if (await canLaunch(url)) {
                                              await launch(
                                                url,
                                              );
                                            }
                                          }),
                                    ])),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.002)),
                                PopupMenuButton(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Время работы',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Время работы ресторана:',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            'Понедельник - Пятница',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '12:00 - 00:00',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            'Суббота - Воскресенье',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '11:00 - 00:00',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: height * 0.03),
                                          Text(
                                            'Время работы доставки:',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            'Понедельник - Воскресенье',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '11:00 - 22:30',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: height * 0.01),
                                        ],
                                      ),
                                      value: 1,
                                      onTap: () {},
                                    ),
                                  ],
                                )
                              ]),
                          Center(
                              child: Icon(
                            Icons.restaurant_menu_outlined,
                            size: height * 0.055,
                          )),
                        ]),
                  ],
                )),
          ]),
        ));
  }
}
