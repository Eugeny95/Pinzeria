// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'history_bloc.dart';

enum HistoryStatus { initial, success }

class HistoryState {
  HistoryStatus status;
  List<HistoryDbModel>? historyOrders;

  HistoryState({required this.status, this.historyOrders});
}
