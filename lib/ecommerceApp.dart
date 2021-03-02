import 'package:ecommerce/helper/constant/strings.dart';
import 'package:ecommerce/ui/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/ui/productList/productsList.dart';
import 'package:ecommerce/ui/productList/repository/productListRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helper/style/appColors.dart';
import 'ui/cart/my_cart.dart';
import 'ui/productList/bloc/product_bloc.dart';
import 'ui/productList/productList.dart';

class ECommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      allowFontScaling: true,
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider<ProductListBloc>(
            create: (_) => ProductListBloc(productListRepository: ProductListRepository())
              ..add(ProductListStarted()),
          ),
          BlocProvider<CartBloc>(
            create: (_) => CartBloc()..add(CartStarted()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            accentColor: AppColor.lightBlue,
            primaryColor: AppColor.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(elevation: 0),
          ),
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          initialRoute: '/',
          routes: {
            '/': (context) => ProductList(),
            '/cart': (context) => MyCart(),
          },
        ),
      ),
    );
  }
}
