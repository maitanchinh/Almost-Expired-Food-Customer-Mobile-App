import 'package:appetit/cubit/home/home_cubit.dart';
import 'package:appetit/cubit/home/home_state.dart';
import 'package:appetit/domain/models/industries.dart';
import 'package:appetit/utils/AColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/ProductsOfCategoryComponent.dart';

class IndustryScreen extends StatefulWidget {
  static const routeName = '/industry';
  final Industry categoryGroup;
  const IndustryScreen({Key? key, required this.categoryGroup})
      : super(key: key);

  @override
  State<IndustryScreen> createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesCubit>(
      create: (context) =>
          CategoriesCubit(categoryGroupId: widget.categoryGroup.id.toString()),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
        if (state is CategoriesLoadingState) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is CategoriesSuccessState) {
          var categories = state.categories.data;
          return DefaultTabController(
            length: categories!.length,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(widget.categoryGroup.name.toString(), style: TextStyle(color: black, fontWeight: FontWeight.bold),),
                leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);},),
                elevation: 0,
                backgroundColor: appetitAppContainerColor,
                bottom: TabBar(
                  indicatorColor: Colors.blue,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2, color: Colors.blue)),
                  isScrollable: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  tabs: categories.map(
                    (e) {
                      // Check the file extension of the image
                      // bool isSvg = e.image!.toLowerCase().endsWith('.svg');

                      return Row(
                        children: [
                          // isSvg
                          //     ? SvgPicture.asset(
                          //         e.image.toString(),
                          //         height: 30,
                          //         width: 30,
                          //         fit: BoxFit.cover,
                          //       )
                          //     : Image.asset(
                          //         e.image.toString(),
                          //         height: 30,
                          //         width: 30,
                          //         fit: BoxFit.cover,
                          //       ),
                          Text(
                            e.name.toString(),
                            style: TextStyle(
                                color: context.iconColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 6);
                    },
                  ).toList(),
                ),
              ),
              body: TabBarView(
                children: categories.map((c) {

                  return ProductsOfCategoryComponent(
                          categoryId: c.id!)
                      .paddingTop(16);
                }).toList()
                ,
              ),
            ),
          );
        }
        return Scaffold(
            appBar: AppBar(elevation: 0, leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);},),),
          body: Center(
            child: Text('Chưa có loại nào được tạo. Hãy qua lại sau.'),
          ),
        );
      }),
    );
  }
}
