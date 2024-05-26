// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_http_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHttpModel _$OrderHttpModelFromJson(Map<String, dynamic> json) =>
    OrderHttpModel(
      type_order:
          $enumDecodeNullable(_$OrderServiceTypeEnumMap, json['type_order']),
      phone: json['phone'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PositionHttpModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      adress: json['adress'] == null
          ? null
          : AddressHttpModel.fromJson(json['adress'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      summa: (json['summa'] as num?)?.toDouble(),
      type_payment:
          $enumDecodeNullable(_$PaymentTypeEnumMap, json['type_payment']),
      completeBefore: json['completeBefore'] == null
          ? null
          : DateTime.parse(json['completeBefore'] as String),
    );

Map<String, dynamic> _$OrderHttpModelToJson(OrderHttpModel instance) =>
    <String, dynamic>{
      'type_order': _$OrderServiceTypeEnumMap[instance.type_order],
      'phone': instance.phone,
      'items': instance.items,
      'adress': instance.adress,
      'type_payment': _$PaymentTypeEnumMap[instance.type_payment],
      'summa': instance.summa,
      'completeBefore': instance.completeBefore?.toIso8601String(),
      'comment': instance.comment,
    };

const _$OrderServiceTypeEnumMap = {
  OrderServiceType.DeliveryPickUp: 'DeliveryPickUp',
  OrderServiceType.Common: 'Common',
  OrderServiceType.DeliveryByCourier: 'DeliveryByCourier',
};

const _$PaymentTypeEnumMap = {
  PaymentType.Cash: 'Cash',
  PaymentType.CardOnline: 'CardOnline',
  PaymentType.CardUponReceipt: 'CardUponReceipt',
};
