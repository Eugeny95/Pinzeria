part of 'menu_bloc.dart';

@immutable
sealed class MenuEvent {}

class GetMenuEvent extends MenuEvent{}