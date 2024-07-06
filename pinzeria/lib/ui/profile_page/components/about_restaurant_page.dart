import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinzeria/ui/constants.dart';
import 'package:pinzeria/ui/menu_page/components/table_dialog.dart';

class AboutRestaurantPage extends StatefulWidget {
  @override
  _AboutRestaurantPageState createState() {
    return _AboutRestaurantPageState();
  }
}

class _AboutRestaurantPageState extends State<AboutRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(180, 52, 52, 52)),
          backgroundColor: kPrimaryColor,
          title: Text('О ресторане',
              style: TextStyle(
                  color: Color.fromARGB(201, 67, 67, 67), fontSize: 18))),
      body: Center(
        child: Container(
          width: width * 0.9,
          child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Pinzeria Bontempi',
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      height: 0.85),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  'Это приятное место, которое завораживает своей домашней приятной атмосферой, удивительными блюдами и вкусами.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Ресторан с удовольствием посещают компании друзей, здесь можно провести приятный вечер с родными и коллегами. В ресторан с удовольствием приходят и дети.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  width: width * 0.9,
                  child: Column(children: []),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Пинца, это новое слово в итальянской кухне',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      height: 0.9),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  'Несколько слов о рецептуре',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      fontWeight: FontWeight.normal),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
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
                  'Над созданием своего кулинарного шедевра шеф-повар работал тщательно, изучая кухню Римской империи и традиции итальянской кухни. Это блюдо значительно отличается от привычной пиццы не только формой, но и составом, количеством и набором ингредиентов.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'С добавлением уникальных дрожжей, которые привозят из Италии. Такой компонент придает особую текстуру тесту – при выпекании оно наполняется крупными пузырьками, становится по-настоящему воздушным, легким, хрустящим и ароматным.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Из заготовки, которую выдерживают перед выпеканием 72 часа. Это тот самый секрет, который позволяет готовить вкусное блюдо.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                    width: width * 0.9,
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Color.fromARGB(106, 46, 46, 46),
                                    width: 0.3) // <-- Radius
                                ),
                            elevation: 5,
                            minimumSize: Size(height * 0.43, width * 0.13),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TableDialog();
                              },
                            );
                          },
                          child: Text('Забронировать столик',
                              style: TextStyle(
                                  color: Color.fromARGB(210, 27, 27, 27)))),
                    ])),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Организация торжественных и деловых мероприятий',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      height: 1),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
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
                                "assets/event.png",
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
                  'Площадь ресторана PINZERIA ® BY BONTEMPI составляет 850 кв.м. Организация торжественных мероприятий проходит в основном зале (до 80 гостей), VIP- зале (до 25 гостей), а также на открытой веранде, в зимний период веранда отапливается.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Мы комплексно подходим к созданию праздника мечты! Предоставляем колоритную локацию для фото-сессии, услуги кондитера, флориста, ведущего и банкетный сервис высокого уровня.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  width: width * 0.9,
                  child: Column(children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Color.fromARGB(106, 46, 46, 46),
                                  width: 0.3) // <-- Radius
                              ),
                          elevation: 5,
                          minimumSize: Size(height * 0.43, width * 0.13),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TableDialog();
                            },
                          );
                        },
                        child: Text('Заказать звонок',
                            style: TextStyle(
                                color: Color.fromARGB(210, 33, 33, 33)))),
                  ]),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
              ]),
        ),
      ),
    );
  }
}
