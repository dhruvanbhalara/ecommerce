import 'package:ecommerce/network/apiService.dart';
import 'package:flutter/material.dart';

import 'ecommerceApp.dart';

void main() {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  //Init api service
  APIService.api.init();

  runApp(ECommerceApp());
}
