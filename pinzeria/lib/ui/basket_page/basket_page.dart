import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_layer/models/db_models/history_model.dart';
import 'package:data_layer/models/http_models/order_http_model.dart';
import 'package:data_layer/network/order_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_payments/acquiring.dart';
import 'package:online_payments/payment_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:pinzeria/buisiness/auth_bloc/auth_bloc.dart';
import 'package:pinzeria/buisiness/basket_bloc/basket_bloc_bloc.dart';
import 'package:pinzeria/buisiness/history_bloc/history_bloc.dart';
import 'package:pinzeria/ui/basket_page/address_widget.dart';
import 'package:pinzeria/ui/basket_page/data/models.dart';
import 'package:pinzeria/ui/basket_page/payment_widget_bottom.dart';
import 'package:pinzeria/ui/constants.dart';

class BasketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BasketPageState();
  }
}

Set onPlace = {true, false};
bool valueRadio = true;
String mytime = '30 минут';
String phone = '';

class BasketPageState extends State<BasketPage> {
  TextEditingController dateCtl = TextEditingController();
  int counter = 1;
  int toggleIndex = 0;
  DateTime completeBefore = DateTime.now().add(Duration(minutes: 16));
  String comment = '';
  double totalCost = 0;
  AddressData addressData = AddressData(
      deliveryCost: 0,
      street: '',
      house: '',
      flat: 0,
      entrance: 0,
      floor: 0,
      doorphone: '',
      city: '');

  @override
  void initState() {
    super.initState();
  }

  Future<SelectedPaymentType> paymentFeature() async {
    SelectedPaymentType paymentType = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PaymentWidgetBottom();
      },
    );
    if (paymentType.paymentType == PaymentType.CardOnline) {
      SberAquiring sberAquiring = SberAquiring(
          userName: 'p3662276447-api',
          password: '9174253qQ@',
          returnUrl:
              'http://147.45.109.158:8881/static/payment/payment_done.html',
          token: 'q0dudue2frtnr8v1tpd5rv0udj',
          pageView: PageViewVariants.MOBILE,
          failUrl:
              'http://147.45.109.158:8881/static/payment/payment_cancel.html');
      // Оплата
      PaymentObject paymentObject = await sberAquiring.toPay(
          amount: (BlocProvider.of<BasketBloc>(context).getTotalCost() * 100)
              .toInt(),
          orderNumber: Acquiring.getRandom(30));
      PaymentStatus? paymentStatus = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentWidget(
                  paymentObject: paymentObject,
                  sberAquiring: sberAquiring,
                )),
      );
      if (paymentStatus == null) {
        paymentType.isError = true;
        return paymentType;
      }
      if (paymentStatus == PaymentStatus.AUTH) {
        paymentType.isError = false;
        paymentType.comment = paymentObject.id;
        return paymentType;
      }
    }

    return paymentType;
  }

  Future<void> placeAnOrder() async {
    OrderServiceType orderServiceType = toggleIndex == 0
        ? OrderServiceType.DeliveryPickUp
        : OrderServiceType.DeliveryByCourier;

    SelectedPaymentType selectedPaymentType = await paymentFeature();
    if (selectedPaymentType.paymentType == PaymentType.CardOnline &&
        selectedPaymentType.isError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Онлайн оплата завершилась с ошибкой, попробуйте еще раз, либо выберите дргой тип оплаты')));
      return;
    }

    CreateOrderStatus orderStatus = await BlocProvider.of<BasketBloc>(context)
        .createOrder(
            addressData: addressData,
            user: BlocProvider.of<AuthBloc>(context).getUser(),
            orderServiceType: orderServiceType,
            paymentType: selectedPaymentType.paymentType,
            completeBefore: completeBefore,
            comment: comment +
                '  Комментарий к оплате: ' +
                (selectedPaymentType.comment ?? ''));
    if (orderStatus == CreateOrderStatus.failure) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Неизвестная ошибка')));
      return;
    }
    BlocProvider.of<BasketBloc>(context).add(ClearBasketEvent());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
      children: [
        Text('Ваш заказ успешно оформлен'),
        Text('Он появится в истории заказов'),
      ],
    )));
    List<PositionDbModel> listPositionDbModel = [];
    for (Position position
        in BlocProvider.of<BasketBloc>(context).getPositions()) {
      listPositionDbModel.add(PositionDbModel(
          name: position.dish!.name,
          amount: position.count,
          cost: position.dish!.currentPrice));
    }
    HistoryDbModel historyDbModel = HistoryDbModel(
        date_time: DateTime.now(),
        totalcost: BlocProvider.of<BasketBloc>(context).getTotalCost(),
        positions: listPositionDbModel);
    BlocProvider.of<HistoryBloc>(context)
        .add(AddHistoryOrder(historyDbModel: historyDbModel));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(180, 0, 0, 0)),
          backgroundColor: kPrimaryColor,
          title: Text('Оформление заказа',
              style: TextStyle(color: Color.fromARGB(201, 20, 20, 20)))),
      body: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          final _formKey = GlobalKey<FormState>();

          if (state.positions!.isNotEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Center(
                    child: Container(
                        width: width * 0.99,
                        child: Card(
                            elevation: 15,
                            color: Color.fromARGB(255, 255, 255, 238),
                            child: Column(
                              children: [
                                const ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  title: Text(
                                    'Детали заказа',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  tileColor: kPrimaryColor,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                BlocBuilder<BasketBloc, BasketState>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.positions!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: width * 0.95,
                                            height: height * 0.18,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.25,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: const Color
                                                                  .fromARGB(211,
                                                                  45, 45, 45)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child:
                                                            CachedNetworkImage(
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .low,
                                                                imageUrl: state
                                                                    .positions![
                                                                        index]
                                                                    .dish!
                                                                    .imageLinks
                                                                    .first,
                                                                //  (dishHttpModel.imageLinks.isEmpty)?'': dishHttpModel.imageLinks.first,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                                fit: BoxFit
                                                                    .cover),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Container(
                                                      width: width * 0.65,
                                                      child: Column(children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 6,
                                                              child: Text(
                                                                  state
                                                                      .positions![
                                                                          index]
                                                                      .dish!
                                                                      .name!,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color.fromARGB(
                                                                          233,
                                                                          69,
                                                                          69,
                                                                          69),
                                                                      fontSize:
                                                                          14)),
                                                            ),
                                                            Expanded(
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    BlocProvider.of<BasketBloc>(context).add(RemovePositionEvent(
                                                                        dishId: state
                                                                            .positions![index]
                                                                            .dish!
                                                                            .id!));
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .close)),
                                                              flex: 1,
                                                            )
                                                          ],
                                                        ),
                                                        Row(children: [
                                                          Expanded(
                                                            child: Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        BlocProvider.of<BasketBloc>(context).add(RemoveDishEvent(
                                                                            dishId:
                                                                                state.positions![index].dish!.id!));
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .remove)),
                                                                  Text(
                                                                    state
                                                                        .positions![
                                                                            index]
                                                                        .count
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            54,
                                                                            54,
                                                                            54),
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          BlocProvider.of<BasketBloc>(context)
                                                                              .add(AddDishEvent(dishHttpModel: state.positions![index].dish));
                                                                          if (counter <
                                                                              0)
                                                                            counter =
                                                                                0;
                                                                          // onChange(counter);
                                                                        });
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .add)),
                                                                ]),
                                                            flex: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              // line.totalCost.toInt().toString(),
                                                              '${state.positions![index].allCost!.toInt()} ₽',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          225,
                                                                          58,
                                                                          58,
                                                                          58),
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                    color: Color.fromARGB(
                                                        196, 45, 45, 45)),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                                ToggleSwitch(
                                  minWidth: 150,
                                  cornerRadius: 20,
                                  activeBgColor: [
                                    kFourthColor.withOpacity(0.8)
                                  ],
                                  inactiveBgColor:
                                      Color.fromARGB(113, 91, 91, 91),
                                  inactiveFgColor: Colors.white,
                                  initialLabelIndex: toggleIndex,
                                  totalSwitches: 2,
                                  labels: ['Самовывоз', 'Доставка'],
                                  radiusStyle: true,
                                  onToggle: (index) {
                                    if (index == 0)
                                      BlocProvider.of<BasketBloc>(context).add(
                                          SetDeliveryCost(deliveryCost: 0));
                                    if (index == 1 && state.totalCost! < 1500) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Для оформления доставки сумма товара должна быть не менее 1500 рублей')));
                                      setState(() {
                                        toggleIndex = 0;
                                      });
                                      return;
                                    }

                                    setState(() {
                                      toggleIndex = index!;
                                    });
                                  },
                                ),
                                Divider(color: Color.fromARGB(182, 67, 67, 67)),
                                Align(
                                    alignment: Alignment
                                        .center, //or choose another Alignment
                                    child: Container(
                                        color: Colors.transparent,
                                        width: width - (0.01 * width),
                                        child: (toggleIndex == 1)
                                            ? AddressWidget(
                                                onChange: (addressData) {
                                                  this.addressData =
                                                      addressData;
                                                  BlocProvider.of<BasketBloc>(
                                                          context)
                                                      .add(SetDeliveryCost(
                                                          deliveryCost:
                                                              addressData
                                                                  .deliveryCost));
                                                },
                                                globalKey: _formKey,
                                              )
                                            : Container())),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.02)),
                                SizedBox(
                                  width: width * 0.9,
                                  height: height * 0.06,
                                  child: TextField(
                                    cursorColor:
                                        Color.fromARGB(209, 41, 41, 41),
                                    controller: dateCtl,
                                    // inputFormatters: <TextInputFormatter>[_dateFormatter],
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(95, 46, 46, 46)),
                                      ),
                                      prefixIcon: const Icon(Icons.timelapse,
                                          size: 18,
                                          color:
                                              Color.fromARGB(210, 234, 44, 44)),
                                      labelText: 'Как можно скорее',
                                      labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(217, 49, 49, 49),
                                          fontSize: 14),
                                      helperText: '      Выберите время',
                                      helperStyle: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      hintStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.redAccent),
                                    ),
                                    onChanged: (String value) {
                                      //  completeBefore = value;
                                    },
                                    onTap: () async {
                                      DateTime date = DateTime.now();
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      completeBefore =
                                          await showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.4,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              child: Text(
                                                                  'Применить',
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          219,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontSize:
                                                                          14)),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            Container(
                                                              height:
                                                                  height * 0.3,
                                                              child:
                                                                  CupertinoDatePicker(
                                                                use24hFormat:
                                                                    true,
                                                                mode: CupertinoDatePickerMode
                                                                    .dateAndTime,
                                                                initialDateTime:
                                                                    // DateTime
                                                                    //     .now(),
                                                                    DateTime.now().add(
                                                                        Duration(
                                                                            hours:
                                                                                1)),
                                                                minimumDate: DateTime
                                                                        .now()
                                                                    .add(Duration(
                                                                        minutes:
                                                                            20)),
                                                                maximumDate: DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                            .month +
                                                                        2,
                                                                    DateTime.now()
                                                                        .day),
                                                                onDateTimeChanged:
                                                                    (val) {
                                                                  date = val;
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  height * 0.03,
                                                            )
                                                          ],
                                                        ));
                                                  }) ??
                                              date;

                                      dateCtl.text =
                                          DateFormat('dd.MM.yyyy hh:mm')
                                              .format(completeBefore);
                                    },
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.025)),
                                SizedBox(
                                  // width: ,
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,

                                    textCapitalization:
                                        TextCapitalization.sentences,

                                    // validator: (value) => Validator.isEmptyValid(value!),
                                    onChanged: (String value) {
                                      comment = value;
                                    },
                                    cursorColor:
                                        Color.fromARGB(194, 42, 42, 42),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    160, 24, 24, 24),
                                                width: 1.0)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(172, 29, 29, 29),
                                            width: 1.0,
                                          ),
                                        ),
                                        prefixIcon: const Icon(Icons.comment,
                                            size: 20,
                                            color: Color.fromARGB(
                                                210, 45, 45, 45)),
                                        labelText: 'Комментарий к заказу',
                                        labelStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                205, 32, 32, 32))),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.02)),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Итого: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 47, 47, 47),
                                                fontSize: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                ' ${state.totalCost!.toInt()}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        226, 53, 53, 53),
                                                    fontSize: 20),
                                              ),
                                              const Text(
                                                ' ₽',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        239, 73, 73, 73),
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ),
                                          elevation: 5,
                                          minimumSize:
                                              Size(height * 0.23, width * 0.13),
                                          backgroundColor: kFourthColor,
                                        ),
                                        child: Text('Оформить заказ',
                                            style: (TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    235, 227, 227, 227)))),
                                        onPressed: () async {
                                          if (_formKey.currentState != null) {
                                            if (_formKey.currentState!
                                                    .validate() ==
                                                false) return;
                                          }
                                          await placeAnOrder();

                                          //ECKJDBT!!!!!!
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )))),
              ],
            );
          } else
            return Center(
              child: Text('Корзина пуста'),
            );
        },
      ),
    );
  }
}
