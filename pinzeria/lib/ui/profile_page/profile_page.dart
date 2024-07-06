import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinzeria/buisiness/auth_bloc/auth_bloc.dart';
import 'package:pinzeria/ui/constants.dart';
import 'package:pinzeria/ui/profile_page/components/about_app_page.dart';
import 'package:pinzeria/ui/profile_page/components/about_restaurant_page.dart';
import 'package:pinzeria/ui/profile_page/components/about_widget.dart';

import 'package:pinzeria/ui/profile_page/components/client_data_page.dart';
import 'package:pinzeria/ui/profile_page/components/delivery_map_page.dart';
import 'package:pinzeria/ui/profile_page/components/privacy_policy_page.dart';
import 'package:pinzeria/ui/profile_page/components/social_network_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Container(
          width: width * 0.98,
          child: Column(children: [
            Padding(padding: EdgeInsets.only(top: height * 0.005)),
            Container(
              width: MediaQuery.of(context).size.width,
              height: height * 0.13,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/PinBon.png')),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: height * 0.02)),
            Align(
                alignment: Alignment.center, //or choose another Alignment
                child: Container(
                    color: Colors.transparent,
                    width: width - (0.01 * width),
                    child: AboutWidget())),
            Padding(padding: EdgeInsets.only(top: height * 0.015)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: Container(
                            width: height * 0.22,
                            height: width * 0.43,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(74, 88, 88, 88)),
                              borderRadius: BorderRadius.circular(15.0),

                              color: kButtonColor,
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/PinBon.png",
                                  ),
                                  opacity: 0.1,
                                  fit: BoxFit.fitWidth),
                              // button text
                            ),
                            child: Center(
                              child: Text(
                                "Данные пользователя",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Moniqa',
                                    color: Color.fromARGB(207, 34, 34, 34),
                                    fontSize: height * 0.035,
                                    height: 0.9,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onTap: () {
                          AuthBloc authBloc =
                              BlocProvider.of<AuthBloc>(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<AuthBloc>.value(
                                        value: authBloc, //
                                        child: ClientDataPage()),
                              ));
                        }),
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                child: Container(
                                    width: height * 0.1,
                                    height: width * 0.2,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 2,
                                          color:
                                              Color.fromARGB(74, 88, 88, 88)),
                                      borderRadius: BorderRadius.circular(15.0),

                                      color: kButtonColor,
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/PinBon.png"),
                                          opacity: 0.1,
                                          fit: BoxFit.fitWidth),
                                      // button text
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Про ресторан",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Moniqa',
                                            color:
                                                Color.fromARGB(207, 34, 34, 34),
                                            fontSize: height * 0.022,
                                            height: 0.9,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AboutRestaurantPage()),
                                  );
                                }),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            GestureDetector(
                                child: Container(
                                    width: height * 0.1,
                                    height: width * 0.2,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 2,
                                          color:
                                              Color.fromARGB(74, 88, 88, 88)),
                                      borderRadius: BorderRadius.circular(15.0),

                                      color: kButtonColor,
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/PinBon.png"),
                                          opacity: 0.1,
                                          fit: BoxFit.fitWidth),
                                      // button text
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Карта доставки",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Moniqa',
                                            color:
                                                Color.fromARGB(207, 34, 34, 34),
                                            fontSize: height * 0.022,
                                            height: 0.9,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryMapPage()),
                                  );
                                }),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        GestureDetector(
                            child: Container(
                                width: height * 0.21,
                                height: width * 0.2,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 2,
                                      color: Color.fromARGB(74, 88, 88, 88)),
                                  borderRadius: BorderRadius.circular(15.0),

                                  color: kButtonColor,
                                  image: DecorationImage(
                                      image: AssetImage("assets/PinBon.png"),
                                      opacity: 0.1,
                                      fit: BoxFit.fill),
                                  // button text
                                ),
                                child: Center(
                                  child: Text(
                                    "Политика конфиденциальности",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Moniqa',
                                        color: Color.fromARGB(207, 34, 34, 34),
                                        fontSize: height * 0.022,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrivacyPolicyPage()),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                GestureDetector(
                    child: Container(
                        width: width * 0.93,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                              width: 2, color: Color.fromARGB(74, 88, 88, 88)),
                          borderRadius: BorderRadius.circular(10.0),

                          color: kButtonColor,
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/PinBon.png",
                              ),
                              opacity: 0.1,
                              fit: BoxFit.fitHeight),
                          // button text
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "3D тур по ресторану   ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Moniqa',
                                    color: Color.fromARGB(207, 34, 34, 34),
                                    fontSize: height * 0.025,
                                    height: 0.9,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.view_in_ar_outlined,
                                size: 25,
                                color: kIconsColor,
                              ),
                            ],
                          ),
                        )),
                    onTap: () async {
                      final url =
                          "https://www.google.com/maps/@51.6829717,39.1984492,3a,60.5y,257.91h,82.81t/data=!3m8!1e1!3m6!1sAF1QipOfmL-ealCbGqdh1vv9qCse91GzLfHPi__ZpHqg!2e10!3e12!6shttps:%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOfmL-ealCbGqdh1vv9qCse91GzLfHPi__ZpHqg%3Dw900-h600-k-no-pi7.189999999999998-ya268.91-ro0-fo90!7i10000!8i5000?coh=205410&entry=ttu";
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                        );
                      }
                    }),
                SizedBox(
                  height: height * 0.007,
                ),
                GestureDetector(
                  child: Container(
                      width: width * 0.93,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                            width: 2, color: Color.fromARGB(74, 88, 88, 88)),
                        borderRadius: BorderRadius.circular(10.0),

                        color: kButtonColor,
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/PinBon.png",
                            ),
                            opacity: 0.1,
                            fit: BoxFit.fitHeight),
                        // button text
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Поделиться приложением    ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Moniqa',
                                  color: Color.fromARGB(207, 34, 34, 34),
                                  fontSize: height * 0.024,
                                  height: 0.9,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.send,
                              size: 25,
                              color: kIconsColor,
                            ),
                          ],
                        ),
                      )),
                  onTap: () async {
                    Share.share(
                        'Посмотрите новое  мобильное приложение https://apps.apple.com/ru/app/youtube/id544007664',
                        subject: 'Pinzeria Bontempi');
                  },
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: height * 0.02)),
            Align(
                alignment: Alignment.center, //or choose another Alignment
                child: Container(
                    color: Colors.transparent,
                    width: width - (0.01 * width),
                    child: SocialNetworkWidget())),
          ]),
        ),
      ],
    );
  }
}
