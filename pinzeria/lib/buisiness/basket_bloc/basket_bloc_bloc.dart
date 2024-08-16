import 'dart:developer';
import 'dart:ffi';

import 'package:auth_feature/data/auth_data.dart';
import 'package:bloc/bloc.dart';
import 'package:data_layer/models/http_models/address_http_model.dart';
import 'package:data_layer/models/http_models/dish_http_model.dart';
import 'package:data_layer/models/http_models/order_http_model.dart';
import 'package:data_layer/models/http_models/position_http_model.dart';
import 'package:data_layer/network/bonuses_repository.dart';
import 'package:data_layer/network/order_repository.dart';
import 'package:meta/meta.dart';
import 'package:pinzeria/ui/basket_page/data/models.dart';
part 'basket_bloc_event.dart';
part 'basket_bloc_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  List<Position> positions = [];
  String accessToken = '';

  double deliveryCost = 0;
  double bonusesBalance = 0.0;
  double availibleBonuces = 0.0;
  bool useBonuses = false;

  Future<double> calculateTotalSum(bool useBonuses) async {
    double totalCost = 0;

    bonusesBalance =
        await BonusesRepository().getBonusesBalance(accessToken: accessToken);

    for (Position position in positions) {
      position.calculateCost();
      totalCost = totalCost + position.allCost;
    }
    totalCost += deliveryCost;

    if (useBonuses == true) {
      availibleBonuces = await BonusesRepository()
          .getAvailibleBonuses(totalCost: totalCost, accessToken: accessToken);
    } else {
      availibleBonuces = 0.0;
    }
    totalCost = totalCost - availibleBonuces;
    log('Bonuses balance = $bonusesBalance');

    return totalCost;
  }

  BasketBloc({required this.accessToken})
      : super(BasketState(
            basketStatus: BasketStatus.initial,
            availableBonuses: 0.0,
            useBonuses: false,
            totalCost: 0.0,
            positions: [],
            bonusesBalance: 0.0)) {
    on<AddDishEvent>((event, emit) async {
      bool noAddflag = false;

      for (Position position in positions) {
        if (position.dish == event.dishHttpModel) {
          position.count++;
          noAddflag = true;
          break;
        }
      }
      if (!noAddflag) {
        positions.add(Position(dish: event.dishHttpModel, count: 1));
      }
      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });

    on<ClearBasketEvent>((event, emit) {
      positions.clear();

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: 0 + deliveryCost));
    });

    on<RemoveDishEvent>((event, emit) async {
      for (Position position in positions) {
        if (position.dish!.id == event.dishId) {
          if (position.count == 1) break;
          position.count--;
          position.calculateCost();
          break;
        }
      }
      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });

    on<SetDeliveryCost>((event, emit) async {
      deliveryCost = event.deliveryCost;

      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });

    on<SetBonusesUse>((event, emit) async {
      useBonuses = event.useBonuses;

      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });

    on<RemovePositionEvent>((event, emit) async {
      for (Position position in positions) {
        if (position.dish!.id == event.dishId) {
          positions.remove(position);
          break;
        }
      }
      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });

    on<GetBasketPositions>((event, emit) async {
      double totalCost = await calculateTotalSum(useBonuses);

      emit(BasketState(
          basketStatus: BasketStatus.done,
          positions: positions,
          availableBonuses: availibleBonuces,
          bonusesBalance: bonusesBalance,
          useBonuses: useBonuses,
          totalCost: totalCost));
    });
  }

  List<Position> getPositions() {
    return positions;
  }

  Future<CreateOrderStatus> createOrder(
      {required AddressData addressData,
      required UserData user,
      required OrderServiceType orderServiceType,
      required PaymentType paymentType,
      required DateTime completeBefore,
      required String comment}) async {
    List<PositionHttpModel> itemsHttp = [];
    for (int i = 0; i < positions.length; i++) {
      itemsHttp.add(PositionHttpModel(
          amount: positions[i].count,
          modifiers: [],
          productId: positions[i].dish!.id));
    }
    AddressHttpModel addressHttpModel = AddressHttpModel(
        doorphone: addressData.doorphone,
        entrance: addressData.entrance,
        flat: addressData.flat,
        floor: addressData.floor,
        house: addressData.house,
        street: addressData.street);
    double totalCost = await calculateTotalSum(useBonuses);

    OrderHttpModel orderHttpModel = OrderHttpModel(
        type_order: orderServiceType,
        phone: user.username,
        items: itemsHttp,
        adress: addressHttpModel,
        completeBefore: completeBefore,
        comment: comment,
        summa: totalCost,
        type_payment: paymentType);

    CreateOrderStatus orderStatus =
        await OrderRepository().createOrder(orderHttpModel, user.accessToken);

    return orderStatus;
  }
}
