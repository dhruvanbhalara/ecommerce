part of 'cart_bloc.dart';

@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();
}

class CartStarted extends CartEvent {
  @override
  List<Object> get props => [];
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.item);

  final Product item;

  @override
  List<Object> get props => [item];
}

class CartItemRemove extends CartEvent {
  const CartItemRemove(this.item);

  final Product item;

  @override
  List<Object> get props => [item];
}
