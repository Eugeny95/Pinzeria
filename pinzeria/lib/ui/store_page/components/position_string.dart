import 'package:data_layer/models/db_models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PositionString extends StatefulWidget {
  PositionDbModel positionDbModel;
  PositionString({required this.positionDbModel});
  @override
  State<PositionString> createState() => _PositionStringState();
}

class _PositionStringState extends State<PositionString> {
  String status = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // if (orderObject!.isAccepted) status = 'Заказ принят';
    // if (!orderObject!.isAccepted) status = 'Ожидает подтверждения';
    // if (orderObject!.isReady) status = 'Заказ готов';

    return Row(
      children: [
        SizedBox(
          width: width * 0.02,
        ),
        Expanded(
          child: Text(widget.positionDbModel.name!,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  color: Color.fromARGB(221, 17, 17, 17),
                  fontSize: 14)),
          flex: 7,
        ),
        Expanded(
            child: Row(
              children: [
                Text(
                  widget.positionDbModel.amount.toString(),
                  // state
                  //     .positions![
                  //         index]
                  //     .count
                  //     .toString(),
                  style: TextStyle(
                      color: Color.fromARGB(225, 28, 28, 28),
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
                Text(
                  ' x ',
                  // state
                  //     .positions![
                  //         index]
                  //     .count
                  //     .toString(),
                  style: TextStyle(
                      color: Color.fromARGB(216, 29, 29, 29),
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
                Text(
                  '${widget.positionDbModel.cost!.toInt()}₽',
                  // line.totalCost.toInt().toString(),
                  // '${state.positions![index].allCost!.toInt()} ₽',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.merriweather().fontFamily,
                      color: Color.fromARGB(220, 37, 37, 37),
                      fontSize: 14),
                ),
              ],
            ),
            flex: 2),
      ],
    );
  }
}
