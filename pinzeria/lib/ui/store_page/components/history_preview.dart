import 'package:data_layer/models/db_models/history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinzeria/ui/constants.dart';
import 'package:pinzeria/ui/store_page/components/position_string.dart';

class HistoryPreview extends StatefulWidget {
  HistoryDbModel historyDbModel;
  HistoryPreview({super.key, required this.historyDbModel});

  @override
  State<HistoryPreview> createState() {
    return _HistoryPreviewState();
  }
}

class _HistoryPreviewState extends State<HistoryPreview> {
  String status = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> lines = List.generate(
        widget.historyDbModel.positions!.length,
        (index) => PositionString(
            positionDbModel: widget.historyDbModel.positions![index]));

    return Container(
        constraints: BoxConstraints(
          minHeight: height * 0.15,
          minWidth: width * 0.95,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          elevation: 20,
          color: Color.fromARGB(205, 140, 116, 71),
          child: Column(children: [
            SizedBox(
              height: height * 0.003,
            ),
            Container(
              width: width * 0.93,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(230, 254, 249, 239),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // color: Colors.red,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color.fromARGB(255, 17, 99, 21),
                                  size: 26,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  'Заказ от ',
                                  // ${orderObject!.ids}

                                  style: TextStyle(
                                      color: Color.fromARGB(232, 50, 50, 50),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Text(
                              DateFormat('dd.MM.yyyy').format(
                                      widget.historyDbModel.date_time!) +
                                  '   ' +
                                  DateFormat.Hm()
                                      .format(widget.historyDbModel.date_time!),
                              // ${orderObject!.ids}

                              style: TextStyle(
                                  color: Color.fromARGB(232, 50, 50, 50),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/PinBon.png",
                                ),
                                // opacity: 0.60,
                                fit: BoxFit.cover,
                              ),
                            )),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 12)),
                Column(
                  children: [
                    Column(
                      children: lines,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width * 0.9,
                      height: height * 0.002,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(0, 255, 255, 255),
                          Color.fromARGB(220, 255, 255, 255),
                          Color.fromARGB(0, 255, 255, 255),
                        ])),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      width: width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Итого:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  fontSize: 16)),
                          SizedBox(width: width * 0.03),
                          Text(
                            '${widget.historyDbModel.totalcost!.toInt()} ₽',
                            // line.totalCost.toInt().toString(),
                            // '${state.positions![index].allCost!.toInt()} ₽',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 229, 229, 229),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: height * 0.015,
            ),
          ]),
        ));
  }
}
