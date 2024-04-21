import 'package:bloc/bloc.dart';
import 'package:data_layer/database.dart';
import 'package:data_layer/models/db_models/history_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  StorageDBProvider storageDBProvider = StorageDBProvider();
  Future<void> init() async {
    await storageDBProvider.init();
  }

  HistoryBloc() : super(HistoryState(status: HistoryStatus.initial)) {
    on<AddHistoryOrder>((event, emit) async {
      await storageDBProvider.insertOrder(historyDbModel: event.historyDbModel);

      List<HistoryDbModel> historyOrders =
          await storageDBProvider.getHistoryOrders();

      historyOrders.sort((a, b) => b.date_time!.compareTo(a.date_time!));

      emit(HistoryState(
          status: HistoryStatus.success, historyOrders: historyOrders));
    });

    on<GetHistoryOrders>((event, emit) async {
      List<HistoryDbModel> historyOrders =
          await storageDBProvider.getHistoryOrders();

      historyOrders.sort((a, b) => b.date_time!.compareTo(a.date_time!));

      emit(HistoryState(
          status: HistoryStatus.success, historyOrders: historyOrders));
    });
  }
}
