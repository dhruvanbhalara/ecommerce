import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/helper/style/appColors.dart';
import 'package:ecommerce/network/model/productListResponse.dart';
import 'package:ecommerce/ui/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'bloc/product_bloc.dart';

class ProductList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    return Scaffold(
      appBar: _MyAppBar(),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartAddSuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColor.lightBlue,
                content: Text('Product Added to Cart'),
              ),
            );
          }
          if (state is CartRemoveSuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColor.lightBlue,
                content: Text('Product Removed from Cart'),
              ),
            );
          }
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProductListLoaded) {
              return StaggeredGridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset == _scrollController.position.maxScrollExtent &&
                        !context.read<ProductListBloc>().isFetching &&
                        context.read<ProductListBloc>().response.totalRecord <
                            state.productList.length) {
                      context.read<ProductListBloc>()
                        ..isFetching = true
                        ..add(ProductListStarted());
                    }
                  }),
                children: state.productList.map((item) {
                  return _MyListItem(item);
                }).toList(),
                staggeredTiles:
                    state.productList.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            }
            if (state is ProductListError) {
              return Center(child: const Text('Something went wrong!'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({Key key, @required this.item}) : super(key: key);

  final Product item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return Container();
        }
        if (state is CartLoaded) {
          return GestureDetector(
            onTap: state.cart.items.contains(item)
                ? () => context.read<CartBloc>().add(CartItemRemove(item))
                : () => context.read<CartBloc>().add(CartItemAdded(item)),
            child: state.cart.items.contains(item)
                ? Icon(
                    Icons.add_shopping_cart_outlined,
                    size: 24.h,
                    color: Colors.grey[700],
                  )
                : Icon(
                    Icons.shopping_cart,
                    size: 24.h,
                    color: Colors.grey[700],
                  ),
          );
        }
        if (state is CartError) {
          return Center(child: const Text('Something went wrong!'));
        }
        return Container();
      },
    );
  }
}

class _MyAppBar extends PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Shopping Mall'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  const _MyListItem(this.item, {Key key}) : super(key: key);

  final Product item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  height: 125.h,
                  width: 125.h,
                  imageUrl: item.featuredImage,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 125.h,
                    width: 125.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      _AddButton(item: item),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
