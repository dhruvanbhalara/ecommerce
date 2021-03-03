import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/db/database.dart';
import 'package:ecommerce/network/model/productListResponse.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartStarted) {
      yield* _mapCartStartedToState();
    } else if (event is CartItemAdded) {
      yield* _mapCartItemAddedToState(event, state);
    } else if (event is CartItemRemove) {
      yield* _mapCartItemRemoveToState(event, state);
    }
  }

  Stream<CartState> _mapCartStartedToState() async* {
    yield CartLoading();
    try {
      var productList = await DBProvider.db.getAllProduct();
      yield CartLoaded(cart: Cart(items: productList));
    } catch (_) {
      yield CartError();
    }
  }

  Stream<CartState> _mapCartItemAddedToState(
    CartItemAdded event,
    CartState state,
  ) async* {
    if (state is CartLoaded) {
      try {
        var count = await DBProvider.db.geProduct(event.item.id) ?? 0;
        print("count $count");
        if (count > 0) {
          count++;
          DBProvider.db.updateProductQuantity(event.item, count);
        } else {
          /// add product to db
          DBProvider.db.addProduct(event.item);
        }
        var productList = await DBProvider.db.getAllProduct();
        yield CartAddSuccess(cart: Cart(items: productList));
        yield CartLoaded(cart: Cart(items: productList));
      } on Exception {
        yield CartError();
      }
    }
  }

  Stream<CartState> _mapCartItemRemoveToState(
    CartItemRemove event,
    CartState state,
  ) async* {
    if (state is CartLoaded) {
      try {
        /// add product to db
        DBProvider.db.deleteProduct(event.item);

        var productList = await DBProvider.db.getAllProduct();

        yield CartRemoveSuccess(cart: Cart(items: productList));
        yield CartLoaded(cart: Cart(items: productList));
      } on Exception {
        yield CartError();
      }
    }
  }
}
