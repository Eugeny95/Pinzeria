import 'package:auth_feature/data/auth_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valentino/buisiness/auth_bloc/auth_bloc.dart';
import 'package:valentino/ui/auth_page/forget_password_dialog.dart';
import 'package:valentino/ui/auth_page/register_dialog.dart';
import 'package:valentino/ui/constants.dart';
import 'package:valentino/utils/Validator.dart';

class SigninOrSignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SigninOrSignupScreenState();
  }
}

class SigninOrSignupScreenState extends State<SigninOrSignupScreen> {
  String login = '';
  String password = '';
  String textStatus = '';
  bool obscurePassword1 = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(180, 253, 253, 253)),
          backgroundColor: kPrimaryColor,
          title: Text('Авторизация',
              style: TextStyle(
                  color: Color.fromARGB(202, 255, 255, 255), fontSize: 18))),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                            // width: width * 0.85,
                            child: Column(children: [
                          SizedBox(height: kDefaultPadding * 3),
                          Container(
                              height: height / 5,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25)),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/VB.png",
                                  ),
                                  opacity: 0.60,
                                  fit: BoxFit.fitHeight,
                                ),
                              )),
                          //Spacer(flex: 1),
                          SizedBox(height: kDefaultPadding * 0.9),
                          TextFormField(
                            cursorColor: Color.fromARGB(139, 255, 255, 255),

                            //controller: TextEditingController()..text = dateTime,

                            //initialValue: dateTime,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.,]'))
                            ],
                            validator: (value) =>
                                Validator.isPhoneValid('8' + value!),
                            onChanged: (String value) {
                              login = '8' + value;
                            },
                            decoration: InputDecoration(
                                fillColor: Color.fromARGB(139, 255, 255, 255),
                                focusColor:
                                    Color.fromRGBO(255, 255, 255, 0.545),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(199, 255, 255, 255),
                                        width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.545),
                                        width: 1.0)),
                                prefixText: '+7',
                                prefixIcon: Icon(Icons.phone_iphone,
                                    color: Color.fromARGB(139, 255, 255, 255)),
                                labelText: 'Телефон',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(139, 255, 255, 255),
                                    fontSize: 14)),
                          ),

                          SizedBox(height: kDefaultPadding * 0.7),
                          TextFormField(
                            cursorColor: Color.fromARGB(139, 255, 255, 255),
                            //controller: TextEditingController()..text = dateTime,
                            obscureText: obscurePassword1,
                            //initialValue: dateTime,
                            validator: (value) =>
                                Validator.isPasswordValid(value),
                            onChanged: (String value) {
                              password = value;
                            },

                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    obscurePassword1 = !obscurePassword1;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    obscurePassword1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color.fromARGB(209, 255, 255, 255),
                                  ),
                                ),
                                fillColor: Color.fromARGB(139, 255, 255, 255),
                                focusColor: Color.fromARGB(139, 255, 255, 255),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(199, 255, 255, 255),
                                        width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(139, 255, 255, 255),
                                        width: 1.0)),
                                prefixIcon: Icon(Icons.key,
                                    color: Color.fromARGB(139, 255, 255, 255)),
                                labelText: 'Пароль',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(139, 255, 255, 255),
                                    fontSize: 14)),
                          ),

                          // Spacer(flex: 2),
                          // Spacer(),
                          SizedBox(height: kDefaultPadding * 1.5),
                          Text(textStatus, style: TextStyle(color: Colors.red)),
                          // BlocBuilder<AuthBloc, AuthState>(
                          //   builder: (context, state) {
                          //     return Text(state.message,
                          //         style: TextStyle(color: Colors.red));
                          //   },
                          // ),
                          SizedBox(height: kDefaultPadding * 0.5),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 0.3) // <-- Radius
                                    ),
                                elevation: 5,
                                minimumSize: Size(height * 0.4, width * 0.12),
                              ),
                              child: Text(
                                "Войти",
                                style: TextStyle(
                                    color: Color.fromARGB(218, 255, 255, 255),
                                    fontSize: 13),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                AuthStatus status =
                                    await BlocProvider.of<AuthBloc>(context)
                                        .logIn(
                                            username: login,
                                            password: password);
                                switch (status) {
                                  case AuthStatus.authorized:
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Успешная авторизация')));
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(RegisterEvent());
                                      Navigator.pop(context);

                                      break;
                                    }
                                  case AuthStatus.initial:
                                    break;
                                  case AuthStatus.error_of_password:
                                    {
                                      setState(() {
                                        textStatus = 'Неверный пароль';
                                      });
                                      break;
                                    }
                                  case AuthStatus.user_not_found:
                                    {
                                      setState(() {
                                        textStatus =
                                            ' Пользователь не зарегистрирован';
                                      });
                                      break;
                                    }
                                  case AuthStatus.unauthorized:
                                    {
                                      setState(() {
                                        textStatus =
                                            'Неверные данные пользователя';
                                      });
                                      break;
                                    }

                                  default:
                                    {
                                      setState(() {
                                        textStatus =
                                            'Неизвестная ошибка сервера';
                                      });
                                      break;
                                    }
                                }
                              }),
                          SizedBox(height: kDefaultPadding * 0.5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 0.3) // <-- Radius
                                  ),
                              elevation: 5,
                              minimumSize: Size(height * 0.4, width * 0.12),
                            ),
                            // color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              "Зарегистрироваться",
                              style: TextStyle(
                                  color: Color.fromARGB(170, 255, 255, 255)),
                            ),
                            onPressed: () async {
                              dynamic result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlocProvider<AuthBloc>.value(
                                      value: authBloc, //
                                      child: RegisterDialog());
                                },
                              );

                              BlocProvider.of<AuthBloc>(context)
                                  .add(RegisterEvent());
                              if (result == true) Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: kDefaultPadding * 1.5),
                          TextButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ForgetPasswordDialog();
                                  },
                                );
                              },
                              child: Text('Забыли пароль?')),
                        ])),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
