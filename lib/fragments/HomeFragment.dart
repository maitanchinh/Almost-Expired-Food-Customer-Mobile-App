import 'package:appetit/cubit/campaigns/campaign_cubit.dart';
import 'package:appetit/cubit/campaigns/campaigns_state.dart';
import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/product/products_state.dart';
import 'package:appetit/cubit/profile/account_cubit.dart';
import 'package:appetit/cubit/profile/account_state.dart';
import 'package:appetit/cubit/store/store_cubit.dart';
import 'package:appetit/cubit/stores/stores_cubit.dart';
import 'package:appetit/cubit/stores/stores_state.dart';
import 'package:appetit/screens/CartScreen.dart';
import 'package:appetit/screens/IndustryScreen.dart';
import 'package:appetit/screens/ProductDetailScreen.dart';
import 'package:appetit/screens/StoreScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/main.dart';
import 'package:appetit/screens/IndustriesListScreen.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/CampaignsComponent.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  var bookmarkSelection = true;

  @override
  Widget build(BuildContext context) {
    final _industriesCubit = GetIt.I.get<IndustriesCubit>();
    final _productsCubit = BlocProvider.of<ProductsCubit>(context);
    final _storeCubit = BlocProvider.of<StoreCubit>(context);
    final _campaignCubit = BlocProvider.of<CampaignsCubit>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
            if (state is AccountLoadingState) {
              return SizedBox.shrink();
            }
            if (state is AccountSuccessState) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: FadeInImage.assetNetwork(image: state.account.avatarUrl.toString(), placeholder: 'image/appetit/avatar_placeholder.png', height: 30, width: 30, fit: BoxFit.cover));
            }
            return SizedBox.shrink();
          }),
        ),
        title: Align(alignment: Alignment.center, child: Text('Appetit', style: TextStyle(fontSize: 20))),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, size: 27, color: context.iconColor),
            onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _industriesCubit.refresh();
          _productsCubit.refresh();
          _campaignCubit.getCampaignsList();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('What do you want to buy today?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
              ),
              BlocBuilder<IndustriesCubit, IndustriesState>(builder: (context, state) {
                if (state is IndustriesLoadingState) {
                  return Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonWidget(
                            borderRadius: 10,
                            height: 20,
                            width: 70,
                          ),
                          SkeletonWidget(
                            borderRadius: 10,
                            height: 20,
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SkeletonWidget(borderRadius: 15, width: 100, height: 32),
                              SkeletonWidget(borderRadius: 15, width: 100, height: 32),
                              SkeletonWidget(borderRadius: 15, width: 100, height: 32),
                            ],
                          )
                        ],
                      ),
                    )
                  ]);
                }
                if (state is IndustriesSuccessState) {
                  var industry = state.industries.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ngành hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndustriesListScreen())),
                              child: Text('Xem tất cả', style: TextStyle(color: appStore.isDarkModeOn ? Colors.grey : Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Row(
                              children: industry!.map((e) {
                                return Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(e.name.toString(), style: TextStyle(fontWeight: FontWeight.w400, color: context.iconColor)),
                                  decoration: BoxDecoration(color: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor, borderRadius: BorderRadius.circular(15)),
                                ).onTap(() => Navigator.of(context).pushNamed(IndustryScreen.routeName, arguments: e));
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),
              SizedBox(height: 16),
              BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
                if (state is ProductsLoadingState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(left: 12),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonWidget(borderRadius: 10, height: 20, width: 100),
                        Gap.k8.height,
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SkeletonWidget(
                                borderRadius: 20,
                                height: 180,
                                width: 270,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SkeletonWidget(
                                borderRadius: 20,
                                height: 180,
                                width: 270,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                if (state is ProductsSuccessState) {
                  var products = state.products.products!.where((product) => product.quantity! > 0).toList();
                  products.sort(
                    (a, b) => DateTime.parse(a.expiredAt!).compareTo(DateTime.parse(b.expiredAt!)),
                  );
                  products.removeWhere((product) {
                    final expiredDate = DateTime.parse(product.expiredAt!);
                    return expiredDate.isBefore(DateTime.now());
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Xả kho giá tốt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      Gap.k8.height,
                      SingleChildScrollView(
                        padding: EdgeInsets.only(left: 16),
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: products.take(4).map((e) {
                            _storeCubit.getStoreByProductId(productId: e.id);
                            return Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: e),
                                  child: Stack(
                                    children: [
                                      FadeInImage.assetNetwork(
                                        image: e.thumbnailUrl.toString(),
                                        placeholder: 'image/appetit/placeholder.png',
                                        height: 180,
                                        width: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      // BlocBuilder<StoreCubit, StoreState>(
                                      //     builder: (context, state) {
                                      //   if (state is StoreLoadingState) {
                                      //     return SizedBox.shrink();
                                      //   }
                                      //   if (state is StoreSuccessState) {
                                      //     var store = state.store;
                                      //     print(store.name);
                                      //     return Positioned(
                                      //       top: 16,
                                      //       left: 16,
                                      //       child: Container(
                                      //           height: 40,
                                      //           width: 160,
                                      //           padding: EdgeInsets.symmetric(
                                      //               horizontal: 8, vertical: 4),
                                      //           decoration: BoxDecoration(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(20),
                                      //             color: Colors.grey
                                      //                 .withOpacity(0.5),
                                      //           ),
                                      //           child: Row(
                                      //             children: [
                                      //               CircleAvatar(
                                      //                 child: ClipOval(
                                      //                   child: FadeInImage
                                      //                       .assetNetwork(
                                      //                     image: store
                                      //                         .thumbnailUrl
                                      //                         .toString(),
                                      //                     placeholder:
                                      //                         'image/appetit/store-placeholder-avatar.png',
                                      //                     height: 70,
                                      //                     width: 70,
                                      //                     fit: BoxFit.cover,
                                      //                   ),
                                      //                 ),
                                      //                 radius: 15,
                                      //               ),
                                      //               SizedBox(width: 8),
                                      //               Expanded(
                                      //                 child: Text(
                                      //                     store.name.toString(),
                                      //                     style: TextStyle(
                                      //                         overflow:
                                      //                             TextOverflow
                                      //                                 .ellipsis,
                                      //                         color: Colors
                                      //                             .white)),
                                      //               ),
                                      //             ],
                                      //           )),
                                      //     );
                                      //   }
                                      //   return SizedBox.shrink();
                                      // }),
                                      Positioned(
                                        top: 0,
                                        right: 20,
                                        child: CustomPaint(
                                          size: Size(30, 40), // Set the size of the custom rectangle.
                                          // painter: Discount('GIẢM' + ((1 - e.promotionalPrice! / e.price!) * 100).round().toString() + '%'),
                                          painter: Discount(((e.price! - e.promotionalPrice!) / e.price!) * 100),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 1,
                                        left: 1,
                                        right: 1,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          height: 45,
                                          decoration: BoxDecoration(color: white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('₫' + FormatUtils.formatPrice(e.promotionalPrice!.toDouble()),
                                                  style: TextStyle(color: Colors.orange.shade600, fontSize: 16, fontWeight: FontWeight.bold)),
                                              Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 12,
                                                    width: 120,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(6),
                                                      child: LinearProgressIndicator(
                                                        value: e.sold! / (e.quantity! + e.sold!),
                                                        backgroundColor: Colors.orange.shade200,
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: -2,
                                                      bottom: 0,
                                                      right: 0,
                                                      left: 0,
                                                      child: Center(
                                                        child: Text(
                                                          'Đã bán ' + e.sold.toString(),
                                                          style: TextStyle(fontSize: 10, color: white, fontWeight: FontWeight.bold),
                                                        ),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 16,
                                        top: 80,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(color: grey.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                          child: Text(e.name.toString(), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),
              Gap.k16.height,
              BlocBuilder<CampaignsCubit, CampaignsState>(builder: (context, state) {
                if (state is CampaignsLoadingState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SkeletonWidget(
                          borderRadius: 10,
                          height: 20,
                          width: 100,
                        ),
                      ),
                      Gap.k8.height,
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (1 / 1.3), mainAxisSpacing: 16, crossAxisSpacing: 16),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        padding: EdgeInsets.only(left: 12, right: 16, top: 0, bottom: 16),
                        shrinkWrap: true,
                        itemBuilder: (context, indext) => SkeletonWidget(borderRadius: 20, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                      )
                    ],
                  );
                }
                if (state is CampaignsSuccessState) {
                  var campaigns = state.campaigns.campaigns!.where((campaign) => campaign.status == 'Opening').toList();
                  campaigns.sort((a, b) => DateTime.parse(a.startTime!).compareTo(DateTime.parse(b.startTime!)));
                  if (campaigns.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Chiến dịch mới', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                        ),
                        Gap.k8.height,
                        CampaignsComponent(campaigns: campaigns),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }
                return SizedBox.shrink();
              }),
              Gap.k8.height,
              BlocBuilder<StoresCubit, StoresState>(builder: (context, state) {
                if (state is StoresLoadingState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonWidget(borderRadius: 10, height: 20, width: 100),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            SkeletonWidget(borderRadius: 25, height: 50, width: 50),
                            SkeletonWidget(borderRadius: 25, height: 50, width: 50),
                            SkeletonWidget(borderRadius: 25, height: 50, width: 50),
                            SkeletonWidget(borderRadius: 25, height: 50, width: 50),
                            SkeletonWidget(borderRadius: 25, height: 50, width: 50),
                          ],
                        ),
                      )
                    ],
                  );
                }
                if (state is StoresSuccessState) {
                  var stores = state.stores.stores!.where((element) => element.rated != null && element.rated! >= 4).toList();
                  if (stores.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Cửa hàng nổi bật', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                        ),
                        Gap.k8.height,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: stores.map((e) {
                              return Container(
                                width: 90,
                                padding: EdgeInsets.only(right: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: white,
                                      radius: 25,
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'image/appetit/store-placeholder-avatar.png',
                                          image: e.thumbnailUrl.toString(),
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    e.rated != null
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star_outlined,
                                                color: Colors.orange.shade600,
                                                size: 16,
                                              ),
                                              Text(
                                                e.rated.toString(),
                                                style: TextStyle(color: Colors.orange.shade600, fontSize: 14),
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                    Text(
                                      e.name.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ).onTap((){
                                Navigator.pushNamed(context, StoreScreen.routeName, arguments: e);
                              });
                            }).toList(),
                          ),
                        ),
                        Gap.k16.height
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class Discount extends CustomPainter {
  final double discount;

  Discount(this.discount);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.shade600
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - size.width / 4)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // final textStyle = TextStyle(
    //   color: Colors.white,
    //   fontSize: 10,
    // );

    // final textSpan = TextSpan(
    //   text: text,
    //   style: textStyle,
    // );
    // final textPainter = TextPainter(
    //   text: textSpan,
    //   textDirection: TextDirection.ltr,
    //   textAlign: TextAlign.center
    // );
    final regularTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );

    final redTextStyle = TextStyle(
      color: Colors.red, // Make the text red.
      fontSize: 10,
    );

    final discountText = discount.round().toString() + '%';

    final textPainter = TextPainter(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'GIẢM ', style: regularTextStyle),
            TextSpan(text: discountText, style: redTextStyle),
          ],
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textX = (size.width - textPainter.width);
    final textY = (size.height - textPainter.height) / 3;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
