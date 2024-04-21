import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:valentino/buisiness/auth_bloc/auth_bloc.dart';
import 'package:valentino/buisiness/basket_bloc/basket_bloc_bloc.dart';
import 'package:valentino/buisiness/history_bloc/history_bloc.dart';
import 'package:valentino/buisiness/menu_page_bloc/menu_bloc/menu_bloc.dart';
import 'package:valentino/buisiness/menu_page_bloc/select_category_bloc/bloc/select_category_bloc.dart';
import 'package:valentino/generated/l10n.dart';
import 'package:valentino/ui/constants.dart';
import 'package:valentino/ui/menu_page/menu_screen.dart';
import 'package:valentino/ui/profile_page/profile_page.dart';
import 'package:valentino/ui/store_page/store_page.dart';
import 'package:valentino/ui/theme.dart';

import 'package:badges/badges.dart' as badges;

import 'ui/basket_page/basket_page.dart';

void main() async {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ru')],
      title: 'Pinzeria',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: lightThemeData(context),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/main': (context) => MainScreen(),
        //'/call_screen': (context) => CallPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: (context) {
                HistoryBloc historyBloc = HistoryBloc();
                historyBloc.init();
                historyBloc.add(GetHistoryOrders());
                return historyBloc;
              }),
          BlocProvider(create: (context) {
            MenuBloc menuBloc = MenuBloc();
            menuBloc.add(GetMenuEvent());
            return menuBloc;
          }),
          BlocProvider(create: (context) {
            BasketBloc basketBloc = BasketBloc();

            return basketBloc;
          }),
          BlocProvider(create: (context) {
            return SelectCategoryBloc();
          }),
          BlocProvider(
              lazy: false,
              create: (context) {
                AuthBloc authBloc = AuthBloc();
                authBloc.init();
                authBloc.add(GetUserEvent());
                return authBloc;
              }),
        ],
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [
    MenuPage(),
    BasketPage(),
    StorePage(),
    ProfilePage(),
  ];
  int _selectedIndex = 0;

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: Colors.transparent,
      currentIndex: _selectedIndex,
      onTap: (value) {
        BlocProvider.of<HistoryBloc>(context).add(GetHistoryOrders());

        print('selected index');
        setState(() {
          _selectedIndex = value;

          if (_selectedIndex == 1) {
            BlocProvider.of<BasketBloc>(context).add(GetBasketPositions());
          }
          if (_selectedIndex == 2) {
            BlocProvider.of<HistoryBloc>(context).add(GetHistoryOrders());
          }
          if (_selectedIndex == 3) {
            BlocProvider.of<AuthBloc>(context).add(GetUserEvent());
          }
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined), label: "Меню"),
        BottomNavigationBarItem(
            icon: BlocBuilder<BasketBloc, BasketState>(
              builder: (context, state) {
                if (state.basketStatus == BasketStatus.done &&
                    state.positions!.isNotEmpty)
                  return badges.Badge(
                      badgeContent: Text(
                        state.positions!.length.toString(),
                        style: TextStyle(fontSize: 8),
                      ),
                      child: Icon(Icons.shopping_basket_outlined));
                else
                  return Icon(Icons.shopping_basket_outlined);
              },
            ),
            label: "Корзина"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "История"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: screens[_selectedIndex]),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(60, 0, 0, 0),
                    spreadRadius: 0,
                    blurRadius: 10),
              ],
            ),
            child: Material(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                )),
                child: buildBottomNavigationBar())));
  }
}
