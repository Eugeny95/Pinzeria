part of 'menu_bloc.dart';


enum MenuStatus {initial, done, error}


class MenuState  {
  MenuStatus menuStatus;
  MenuHttpModel? menuHttpModel;
  MenuState({required this.menuStatus, this.menuHttpModel});
}
