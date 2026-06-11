// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paginate<T> _$PaginateFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => Paginate<T>(fromJsonT(json['items']));

Map<String, dynamic> _$PaginateToJson<T>(
  Paginate<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'items': toJsonT(instance.items)};
