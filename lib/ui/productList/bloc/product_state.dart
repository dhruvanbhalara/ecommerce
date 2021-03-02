part of 'product_bloc.dart';

@immutable
abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  const ProductListLoaded(this.productList);

  final List<Product> productList;

  @override
  List<Object> get props => [productList];
}

class ProductListError extends ProductListState {}
