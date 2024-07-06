import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_layer/models/http_models/dish_http_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinzeria/buisiness/auth_bloc/auth_bloc.dart';
import 'package:pinzeria/buisiness/basket_bloc/basket_bloc_bloc.dart';
import 'package:pinzeria/ui/constants.dart';

import 'package:pinzeria/ui/menu_page/components/select_dish_dialog.dart';

class MenuCategoryItem extends StatelessWidget {
  const MenuCategoryItem({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              // fontFamily: 'Moniqa',
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GridView.count(
              // scrollDirection: Axis.horizontal,
              // physics: const NeverScrollableScrollPhysics(),
              // padding: const EdgeInsets.all(15),
              // crossAxisCount: 10,
              // crossAxisSpacing: 6,
              // shrinkWrap: true,
              // primary: true,
              //Screensize grid count
              // childAspectRatio: 0.90, //1.0
              // mainAxisSpacing: 0.2, //1.0
              // crossAxisSpacing: 4.0,
              // crossAxisSpacing: 1,
              // mainAxisSpacing: 3,

              childAspectRatio: 0.76,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [...items],
            )

            // ListView(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     scrollDirection: Axis.horizontal,
            //     children: [...items])

            )
        // Center(
        //   child: GridView(
        //     gridDelegate:
        //         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //     children: [...items],
        //     padding: const EdgeInsets.all(5),
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //   ),
        // )
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  final DishHttpModel dishHttpModel;
  const MenuCard({Key? key, required this.dishHttpModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //  BlocProvider.of<BasketBloc>(context);
    return GestureDetector(
        onTap: () {
          BasketBloc basketBloc = BlocProvider.of<BasketBloc>(context);
          AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider<AuthBloc>.value(
                  value: authBloc, //
                  child: BlocProvider<BasketBloc>.value(
                      value: basketBloc, //
                      child: SelectDishDialog(
                        dishHttpModel: dishHttpModel,
                      )));
            },
          );
        },
        child: Stack(children: [
          Container(
            width: width / 2.3,
            height: height / 3.6,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              border:
                  Border.all(width: 2, color: Color.fromARGB(74, 88, 88, 88)),
              borderRadius: BorderRadius.circular(15.0),
              color: Color.fromARGB(255, 245, 240, 235),
            ),
            child: Column(children: [
              Container(
                width: width / 2.38,
                height: height / 6.7,
                // padding: const EdgeInsets.all(2), // Border width
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(70), // Image radius
                    child: CachedNetworkImage(
                        cacheKey: (dishHttpModel.imageLinks.isEmpty)
                            ? ''
                            : dishHttpModel.imageLinks.first,
                        useOldImageOnUrlChange: true,
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 0),
                        filterQuality: FilterQuality.low,
                        imageUrl:
                            //    'https://art-lunch.ru/content/uploads/2018/07/Greek_salad_01.jpg',
                            (dishHttpModel.imageLinks.isEmpty)
                                ? ''
                                : dishHttpModel.imageLinks.first,
                        placeholder: (context, url) => Container(
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  'Изображение загружается',
                                  textAlign: TextAlign.center,
                                )),
                                CircularProgressIndicator.adaptive(),
                              ],
                            )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              SizedBox(
                height: height / 22,
                width: width * 0.41,
                child: Text(
                  dishHttpModel.name ?? '',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(215, 33, 33, 33),
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.normal,
                    height: 0.97,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
                child: Row(children: [
                  SizedBox(
                    width: width / 40,
                  ),
                  // Вес блюда
                  (dishHttpModel.energyFullAmount != 0)
                      ? Text(
                          '${dishHttpModel.energyFullAmount!.toInt()} ккал',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: width * 0.005,
                  ),
                  (dishHttpModel.energyFullAmount != 0)
                      ? const Icon(Icons.circle,
                          size: 4, color: Color.fromARGB(188, 49, 49, 49))
                      : Container(),
                  // Энергетическая ценность
                  (dishHttpModel.weight != 0)
                      ? Text(
                          ' ${(dishHttpModel.weight! * 1000).toInt()} гр',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Container()
                ]),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              Container(
                width: width / 2.5,
                height: height / 22,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromARGB(108, 88, 88, 88)),
                  color: Color.fromARGB(255, 243, 243, 243),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '${dishHttpModel.currentPrice!.toInt()} ₽',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      color: Color.fromARGB(217, 39, 39, 39),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]));
  }
}
