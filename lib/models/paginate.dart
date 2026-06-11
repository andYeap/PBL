import 'package:json_annotation/json_annotation.dart';
part 'paginate.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Paginate<T> {
  final T items;

  Paginate(this.items);

  factory Paginate.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginateFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginateToJson(this, toJsonT);
}
