import 'dart:io';

import 'package:data_layer/models/http_models/order_http_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:valentino/ui/constants.dart';

// as datetimepic;

class SelectedPaymentType {
  PaymentType paymentType;
  String? comment = '';
  bool isError = false;
  SelectedPaymentType({required this.paymentType, this.comment}) {
    if (comment == null) comment = '';
  }
}

class PaymentWidgetBottom extends StatefulWidget {
  PaymentWidgetBottom();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaymentWidgetState();
  }
}

class PaymentWidgetState extends State<PaymentWidgetBottom> {
  int toggleIndex = 0;
  int toggleIndex1 = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.35,
      width: width * 0.99,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          color: kPrimaryColor),
      child: Column(
        children: [
          SizedBox(height: height * 0.02),
          Text(
            'Выберите способ оплаты',
            style: TextStyle(
                // fontFamily: 'Moniqa',
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: height * 0.02),
          ToggleSwitch(
            minWidth: width * 0.8,
            minHeight: height * 0.05,
            animate: true,
            animationDuration: 50,
            cornerRadius: 10,
            borderColor: [Color.fromARGB(96, 255, 255, 255)],
            borderWidth: 1,
            activeBgColor: [kContentColorLightTheme],
            activeFgColor: const Color.fromARGB(255, 255, 255, 255),
            inactiveBgColor: Color.fromARGB(255, 106, 106, 106),
            inactiveFgColor: Color.fromARGB(189, 255, 255, 255),
            initialLabelIndex: toggleIndex,
            totalSwitches: 3,
            customTextStyles: const [
              TextStyle(
                  overflow: TextOverflow.visible, fontSize: 13, inherit: false)
            ],
            labels: ['Наличными', 'Картой курьеру', 'Картой онлайн'],
            radiusStyle: true,
            onToggle: (index) {
              setState(() {
                toggleIndex = index!;
              });
            },
          ),
          Container(
            color: Colors.transparent,
            width: width - (0.01 * width),
            child: (toggleIndex == 0)
                ? Column(
                    children: [
                      SizedBox(height: height * 0.015),
                      Row(
                        children: [
                          SizedBox(width: width * 0.1),
                          Text('Нужна сдача с: ',
                              style: (TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(235, 224, 224, 224)))),
                          ToggleSwitch(
                            minWidth: width * 0.15,
                            minHeight: height * 0.03,
                            animate: true,
                            animationDuration: 50,
                            cornerRadius: 10,
                            // borderColor: [Color.fromARGB(96, 255, 255, 255)],
                            borderWidth: 1,
                            activeBgColor: [kContentColorLightTheme],
                            activeFgColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            inactiveBgColor: Color.fromARGB(255, 106, 106, 106),
                            inactiveFgColor: Color.fromARGB(189, 255, 255, 255),
                            initialLabelIndex: toggleIndex1,
                            totalSwitches: 3,
                            customTextStyles: const [
                              TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontSize: 12,
                                  inherit: false)
                            ],
                            labels: ['500', '1000', '5000'],
                            radiusStyle: true,
                            onToggle: (index) {
                              setState(() {
                                toggleIndex1 = index!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.015),
                    ],
                  )
                : SizedBox(height: height * 0.065),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              elevation: 5,
              minimumSize: Size(height * 0.35, width * 0.13),
              backgroundColor: Colors.white,
            ),
            // ignore: prefer_const_constructors
            child: Text('Подтвердить',
                style: (TextStyle(
                    fontSize: 12, color: Color.fromARGB(235, 57, 57, 57)))),
            onPressed: () {
              switch (toggleIndex) {
                case (0):
                  {
                    String comment = '';
                    if (toggleIndex1 == 0) comment = 'Сдача с 500';
                    if (toggleIndex1 == 1) comment = 'Сдача с 1000';
                    if (toggleIndex1 == 2) comment = 'Сдача с 5000';
                    Navigator.pop(
                        context,
                        SelectedPaymentType(
                            paymentType: PaymentType.Cash, comment: comment));
                    break;
                  }
                case (1):
                  {
                    Navigator.pop(
                        context,
                        SelectedPaymentType(
                            paymentType: PaymentType.CardUponReceipt));
                    break;
                  }
                case (2):
                  {
                    Navigator.pop(
                        context,
                        SelectedPaymentType(
                            paymentType: PaymentType.CardOnline));
                    break;
                  }
              }
            },
          ),
          SizedBox(height: height * 0.01),
          Container(
            width: width * 0.8,
            child: Text(
                '*Нажимая на кнопку «Подтвердить» вы даете согласие на обработку персональных данных',
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 10, color: Color.fromARGB(197, 33, 33, 33)))),
          ),
        ],
      ),
    );

    // TODO: implement build
  }
}
