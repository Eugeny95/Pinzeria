import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valentino/buisiness/history_bloc/history_bloc.dart';
import 'package:valentino/ui/constants.dart';
import 'package:valentino/ui/store_page/components/history_preview.dart';

class StorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StorePageState();
  }
}

class StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    // BasketObject basket = Provider.of<BasketObject>(context);
    // OrderController _orderController =
    //     Provider.of<OrderController>(context, listen: true);

    List<Widget> positions = [];
    // List<HistoryPreview> orders = [];
    // for (int i = 0; i < _orderController.historyOrders.length; i++) {
    //   orders.add(HistoryPreview(
    //     _orderController.historyOrders[i],
    //     key: UniqueKey(),
    //   ));
    // }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('История заказов',
                style: TextStyle(
                    color: const Color.fromARGB(255, 239, 239, 239)))),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state.status == HistoryStatus.success)
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.historyOrders!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HistoryPreview(
                        historyDbModel: state.historyOrders![index]);
                  });
            else
              return Center(child: CircularProgressIndicator());
          },
        ));
  }
  // TODO: implement build
}
