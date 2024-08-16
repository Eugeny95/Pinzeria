import 'package:auth_feature/data/auth_data.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinzeria/buisiness/auth_bloc/auth_bloc.dart';
import 'package:pinzeria/ui/auth_page/signin_or_signup_screen.dart';
import 'package:pinzeria/ui/constants.dart';

class DeliveryMapPage extends StatefulWidget {
  @override
  _DeliveryMapPageState createState() {
    return _DeliveryMapPageState();
  }
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(180, 44, 44, 44)),
            backgroundColor: kPrimaryColor,
            title: Text('Бонусная система',
                style: TextStyle(
                    color: Color.fromARGB(201, 35, 35, 35),
                    fontSize: 18,
                    fontFamily: GoogleFonts.merriweather().fontFamily))),
        body: Center(
          child: Container(
            width: width * 0.9,
            child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    'Правила использования накопительных бонусных баллов',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: GoogleFonts.merriweather().fontFamily,
                        height: 0.95),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text(
                    'Количество бонусов зависит от общей суммы заказов гостя:',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    '- Если сумма заказов гостя за все время составляет менее 3000 руб., то ему будет начисляться 3% бонусов от стоимости заказа.\n- Если общая сумма заказов составляет от 3000 до 8000 руб., то у него накапливается 5% бонусов от стоимости заказа.\n- Если общая сумма заказов составляет 8000 руб. и более, то начисляется 10% бонусов..',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text('Оплатить бонусами возможно 5% от заказа.',
                      style: TextStyle(
                          color: Color.fromARGB(201, 35, 35, 35),
                          fontSize: 15,
                          fontFamily: GoogleFonts.merriweather().fontFamily)),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Container(
                    width: width / 1.3,
                    height: height / 3.7,
                    padding: EdgeInsets.all(2), // Border width
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(70), // Image radius
                        child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/pinza.png",
                                ),
                                // opacity: 0.60,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    'При оплате заказа на чеке печатается информация о величине списания и начисления бонусов и сколько осталось потратить для перехода на следующий уровень в следующем виде:\nТекущая сумма заказов: 5,530.00 р.\nДо следующего уровня осталось совершить покупки на сумму 4,470.00\nСчёт будет пополнен на 10.00 р.\nПри достижении последнего порога на чеке печатается следующее:\nТекущая сумма заказов: 12,500.00 р.\nСчёт будет пополнен на 20 р.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    'Накопленные бонусы, которые не потратили сгорают по истечению 3-х месяцев.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 40)),
                ]),
          ),

          //           child: Container(
          //         width: width * 0.9,
          //         child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //           Padding(padding: EdgeInsets.only(top: height * 0.02)),
          //           InkWell(
          //               onTap: () {
          //                 final imageProvider = Image.asset(
          //                   "assets/map.png",
          //                   fit: BoxFit.fill,
          //                 ).image;
          //                 showImageViewer(context, imageProvider,
          //                     swipeDismissible: true, doubleTapZoomable: true);
          //               },
          //               child: Container(
          //                 width: width * 0.8,
          //                 height: height * 0.45,
          //                 padding: EdgeInsets.all(2), // Border width
          //                 decoration: BoxDecoration(
          //                     color: Colors.grey[800],
          //                     borderRadius: BorderRadius.circular(15.0)),
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(15.0),
          //                   child: SizedBox.fromSize(
          //                     size: Size.fromRadius(70), // Image radius
          //                     child: Image.asset(
          //                       "assets/map.png",
          //                       fit: BoxFit.fill,
          //                     ),
          //                   ),
          //                 ),
          //               )),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: Color.fromARGB(235, 206, 147, 216),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №1 Центральный район 250 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: Color.fromARGB(255, 224, 90, 53),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №2 Советский район 350 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 17, 17, 18),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №3 Юго-Западный район 350 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 141, 189, 102),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №4 Ленинский район 350 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 172, 200, 248),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №5 Коминтерновский район 300 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 248, 195, 53),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №6 Сомовский район 350 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 68, 122, 175),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №7 Репное 500 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(padding: EdgeInsets.only(top: height * 0.01)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 height: height * 0.02,
          //                 width: width * 0.1,
          //                 color: const Color.fromARGB(255, 152, 60, 111),
          //               ),
          //               Container(
          //                 width: width * 0.7,
          //                 child: Text(
          //                   '- Зона №8 Ямное 500 руб.',
          //                   style:
          //                       TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(12),
          //                     side: BorderSide(
          //                         color: Colors.white, width: 0.2) // <-- Radius
          //                     ),
          //                 elevation: 5,
          //                 minimumSize: Size(height * 0.43, width * 0.12),
          //               ),
          //               onPressed: () async {
          //                 final url =
          //                     "https://www.google.com/maps/d/u/0/viewer?mid=1-NMZa9BK7tf4NKIwWncwytubBUy5OuI&ll=51.77632438479204%2C39.1940022543466&z=11";
          //                 if (await canLaunch(url)) {
          //                   await launch(
          //                     url,
          //                   );
          //                 }
          //               },
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text('Google карты',
          //                       style: TextStyle(
          //                           color: Color.fromARGB(255, 255, 255, 255))),
          //                 ],
          //               )),
          //         ]),
          //       )
        ));
  }
}
