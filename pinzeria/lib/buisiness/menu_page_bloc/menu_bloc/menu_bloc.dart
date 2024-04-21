import 'package:bloc/bloc.dart';
import 'package:data_layer/models/http_models/menu_http_model.dart';
import 'package:data_layer/network/menu_repository.dart';
import 'package:meta/meta.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState(menuStatus: MenuStatus.initial)) {
    on<MenuEvent>((event, emit) async {
      MenuHttpModel menuHttpModel;
      MenuState menuState;
      try {
        menuHttpModel = await MenuRepository().getCachedMenu();
        menuState = MenuState(menuStatus: MenuStatus.done);
        menuState.menuHttpModel = menuHttpModel;

        //  print (menuHttpModel);
        emit(menuState);
      } catch (_) {}
      menuHttpModel = await MenuRepository().syncMenu();
      menuState = MenuState(menuStatus: MenuStatus.done);
      menuState.menuHttpModel = menuHttpModel;
      //  print (menuHttpModel);
      emit(menuState);
      // emit();
      // TODO: implement event handler
    });
  }
}
