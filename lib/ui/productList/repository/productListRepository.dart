import 'package:ecommerce/network/apiService.dart';
import 'package:flutter/material.dart';

class ProductListRepository {
  static final ProductListRepository _productListRepository = ProductListRepository._();

  ProductListRepository._();

  factory ProductListRepository() {
    return _productListRepository;
  }

  Future<dynamic> getProducts({
    @required int page,
  }) async {
    try {
      return await APIService.api.fetchProductList(page: page);
    } catch (e) {
      return e.toString();
    }
  }
}
