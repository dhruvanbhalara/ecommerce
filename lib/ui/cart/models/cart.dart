import 'package:ecommerce/network/model/productListResponse.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Cart extends Equatable {
  const Cart({this.items = const <Product>[]});

  final List<Product> items;

  int get totalPrice => items.fold(0, (total, current) => total + current.price);

  @override
  List<Object> get props => [items];
}
