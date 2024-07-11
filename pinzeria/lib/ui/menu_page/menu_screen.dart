import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinzeria/buisiness/menu_page_bloc/menu_bloc/menu_bloc.dart';
import 'package:pinzeria/buisiness/menu_page_bloc/select_category_bloc/bloc/select_category_bloc.dart';
import 'package:pinzeria/ui/constants.dart';
import 'package:pinzeria/ui/menu_page/components/carousel.dart';
import 'package:pinzeria/ui/menu_page/components/horizontal_menu_scroll.dart';
import 'package:pinzeria/ui/menu_page/components/menu_card.dart';
import 'package:pinzeria/ui/menu_page/components/table_dialog.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenuPageState();
  }
}

class _MenuPageState extends State<MenuPage> {
  List<GlobalKey> globalKeys = [];
  bool lock = false;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Widget generateItems(MenuState state) {
    globalKeys.clear();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: state.menuHttpModel!.menu!.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          GlobalKey globalKey = GlobalKey();

          globalKeys.add(globalKey);
          if (state.menuHttpModel!.menu![i].items!.isEmpty) {
            return const Column();
          }
          return VisibilityDetector(
            key: Key(i.toString()),
            onVisibilityChanged: (info) async {
              if (!lock) {
                BlocProvider.of<SelectCategoryBloc>(context).add(
                    SelectCategoryIndexEvent(
                        selectedIndex:
                            int.parse(info.key.toString().split("'")[1])));
              }
              await Future.delayed(const Duration(seconds: 3)).then((value) {
                lock = false;
              });
            },
            child: HorizontalMenuCategoryItem(
              key: globalKey,
              title: state.menuHttpModel!.menu![i].category_name!,
              items: List.generate(
                  state.menuHttpModel!.menu![i].items!.length,
                  (index) => MenuCard(
                        dishHttpModel:
                            state.menuHttpModel!.menu![i].items![index],
                      )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Column(
          children: [
            Text(
              'Забронивать',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'столик',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        icon: Icon(Icons.table_bar),
        backgroundColor: kPrimaryColor.withOpacity(0.95),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TableDialog();
            },
          );
        },
        // child: Row(
        //   children: [
        //     Text('Table'),
        //     Icon(
        //       Icons.table_bar_outlined,
        //       size: 22,
        //       color: kFourthColor,
        //     ),
        //   ],
        // ),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color.fromARGB(142, 23, 23, 23)),
            borderRadius: BorderRadius.circular(10)),
      ),
      body: Container(
        color: const Color.fromARGB(0, 62, 62, 62),
        child: CustomScrollView(
          physics: const ScrollPhysics(),
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: height / 2.7,
                // backgroundColor: Colors.transparent,
                flexibleSpace: Stack(children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 116, 116, 116),
                        borderRadius: BorderRadius.only()),
                    child: const Cerousel(),
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         top: height * 0.055, right: width * 0.01),
                  //     child: FloatingActionButton.small(
                  //       backgroundColor: kPrimaryColor,
                  //       onPressed: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return TableDialog();
                  //           },
                  //         );
                  //       },
                  //       child: Icon(
                  //         Icons.table_bar_outlined,
                  //         size: 22,
                  //         color: Color.fromARGB(189, 255, 255, 255),
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //           side: BorderSide(
                  //               width: 1,
                  //               color: Color.fromARGB(49, 255, 255, 255)),
                  //           borderRadius: BorderRadius.circular(100)),
                  //     ),
                  //   ),
                  // ),
                ])),
            SliverAppBar(
              // backgroundColor: Colors.transparent,
              toolbarHeight: 12,
              pinned: true,
              snap: false,
              floating: false,
              flexibleSpace: Container(
                color: kContentColorLightTheme,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    BlocBuilder<MenuBloc, MenuState>(
                      builder: (context, state) {
                        if (state.menuStatus == MenuStatus.done) {
                          return BlocBuilder<SelectCategoryBloc,
                                  SelectCategoryState>(
                              builder: (context, stateCategory) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.menuHttpModel!.menu!.length,
                                itemBuilder: (context, index) {
                                  if (state.menuHttpModel!.menu![index]!.items!
                                      .isEmpty) return Column();
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 7, bottom: 7),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (index ==
                                                stateCategory.selectedIndex)
                                            ? Color.fromARGB(255, 243, 236, 230)
                                            : kPrimaryColor.withOpacity(0.6),
                                        minimumSize:
                                            Size(height * 0.12, width * 0.25),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () {
                                        lock = true;
                                        BlocProvider.of<SelectCategoryBloc>(
                                                context)
                                            .add(SelectCategoryIndexEvent(
                                                selectedIndex: index));
                                        Scrollable.ensureVisible(
                                            globalKeys[index].currentContext!,
                                            duration: const Duration(
                                                milliseconds: 0));
                                      },
                                      child: Text(
                                          state.menuHttpModel!.menu![index]
                                              .category_name
                                              .toString(),
                                          style: TextStyle(
                                              // fontFamily: 'Moniqa',
                                              fontWeight: FontWeight.w600,
                                              fontFamily:
                                                  GoogleFonts.merriweather()
                                                      .fontFamily,
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  243, 218, 58, 47))),
                                    ),
                                  );
                                });
                          });
                        } else {
                          return const Column();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BlocBuilder<MenuBloc, MenuState>(
                    builder: (context, state) {
                      return (state.menuStatus == MenuStatus.done)
                          ? generateItems(state)
                          : const Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
