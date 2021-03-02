import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/network/model/productListResponse.dart';
import 'package:ecommerce/network/responseWrapper/apiResponse.dart';
import 'package:ecommerce/ui/productList/repository/productListRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductListRepository productListRepository;
  int page = 1;
  bool isFetching = false;
  ProductListResponse response;
  ProductListBloc({
    @required this.productListRepository,
  }) : super(ProductListLoading());

  @override
  Stream<ProductListState> mapEventToState(
    ProductListEvent event,
  ) async* {
    if (event is ProductListStarted) {
      yield ProductListLoading();
      try {
        APIResponse result = await productListRepository.getProducts(page: page);
        if (result.isOk) {
          response = ProductListResponse.fromJson(result.data);
          if (response.data == null) {
            yield ProductListError();
          } else {
            yield ProductListLoaded(response.data);
            page++;
          }
        } else {
          yield ProductListError();
        }
      } catch (e, stacktrace) {
        print('Exception: ' + e.toString());
        print('Stacktrace: ' + stacktrace.toString());
        yield ProductListError();
      }
    }
  }
}
