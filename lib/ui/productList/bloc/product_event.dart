part of 'product_bloc.dart';

@immutable
abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class ProductListStarted extends ProductListEvent {
  @override
  List<Object> get props => [];
}
