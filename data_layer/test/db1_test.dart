// import 'package:data_layer/database.dart';
// import 'package:data_layer/models/db_models/history_model.dart';
// import 'package:data_layer/models/http_models/menu_http_model.dart';
// import 'package:data_layer/network/menu_repository.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:data_layer/data_layer.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// void main() {
//   test('insert order test', () async {
//     databaseFactory = databaseFactoryFfi;
//     StorageDBProvider storageDBProvider = StorageDBProvider();
//     await storageDBProvider.init();
//     List<PositionDbModel> listPositionDbModel = [];
//     for (int i = 0; i < 5; i++) {
//       listPositionDbModel
//           .add(PositionDbModel(name: 'name $i', amount: i, cost: 100.0));
//     }
//     HistoryDbModel historyDbModel = HistoryDbModel(
//         date_time: DateTime.now(),
//         totalcost: 1800.0,
//         status: OrderStatus.complete,
//         positions: listPositionDbModel);
//     await storageDBProvider.insertOrder(historyDbModel: historyDbModel);
//   });

//   test('get order test', () async {
//     databaseFactory = databaseFactoryFfi;
//     StorageDBProvider storageDBProvider = StorageDBProvider();
//     await storageDBProvider.init();
//     List<HistoryDbModel> listHistoryDbModel =
//         await storageDBProvider.getHistoryOrders();
//     for (HistoryDbModel historyDbModel in listHistoryDbModel) {
//       print('totalcost = ${historyDbModel.totalcost}');
//       for (PositionDbModel positionDbModel in historyDbModel.positions!) {
//         print('name = ${positionDbModel.name}, cost = ${positionDbModel.cost}');
//       }
//     }
//   });
// }
