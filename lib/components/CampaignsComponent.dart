import 'package:appetit/cubit/product/products_cubit.dart';
import 'package:appetit/cubit/product/products_state.dart';
import 'package:appetit/domain/models/campaigns.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class CampaignsComponent extends StatefulWidget {
  final List<Campaign> campaigns;
  ScrollPhysics? physics;
  CampaignsComponent({this.physics, required this.campaigns});

  @override
  State<CampaignsComponent> createState() => _CampaignsComponentState();
}

class _CampaignsComponentState extends State<CampaignsComponent> {
  @override
  Widget build(BuildContext context) {
    // final productsCubit = BlocProvider.of<ProductsCubit>(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (1 / 1.3),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16),
      physics: widget.physics ?? NeverScrollableScrollPhysics(),
      itemCount: widget.campaigns.length,
      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        // productsCubit
        //     .getProductsByCampaignId(widget.campaigns.campaign![index].id!);

        return BlocProvider<ProductsCubit>(
          create: (context) => ProductsCubit(campaignId: widget.campaigns[index].id),
          child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
            if (state is ProductsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProductsSuccessState) {
              var products = state.products.products;
              Map<String, dynamic> arguments = {
                'products': products,
                'campaign': widget.campaigns[index],
              };
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage.assetNetwork(
                      image: widget.campaigns[index].thumbnailUrl
                          .toString(),
                      placeholder: 'image/appetit/placeholder.png',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Positioned(
                  //   top: 16,
                  //   right: 16,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: Colors.black.withOpacity(0.4),
                  //     ),
                  //     child: IconButton(
                  //       onPressed: () =>
                  //           setState(() {
                  //             widget.campaigns.campaign![index].isBookMark = !widget.campaigns.campaign![index].isBookMark;
                  //           }),
                  //       icon: !widget.campaigns.campaign![index].isBookMark
                  //           ? Icon(Icons.bookmark_border_outlined, color: Colors.white.withOpacity(0.70), size: 30)
                  //           : Icon(Icons.bookmark, color: Colors.orange.withOpacity(0.70), size: 30),
                  //       // color: Colors.black.withOpacity(0.4),
                  //       splashRadius: 25,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(products!.length.toString() + ' Sản phẩm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300)),
                          SizedBox(
                            width: 100,
                            child: Text(
                              widget.campaigns[index].name.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ).onTap(() => Navigator.pushNamed(
                    context,
                    CampaignsScreen.routeName,
                    arguments: arguments,
                  ));
            }
            return SizedBox.shrink();
          }),
        );
      },
    );
  }
}
