import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesListComponent extends StatelessWidget {
  final String? name;
  const CategoriesListComponent({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    categoriesCubit.getCategories(name: name);
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
      if (state is CategoriesLoadingState) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (1 / 1.5)),
          itemCount: 6,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return SkeletonWidget(borderRadius: 35, height: 0, width: 0);
          },
        );
      }
      if (state is CategoriesSuccessState) {
        var categories = state.categories.categories;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: (1 / 1.5)),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16),
          scrollDirection: Axis.vertical,
          itemCount: categories!.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: FadeInImage.assetNetwork(
                    image: categories[index].thumbnailUrl.toString(),
                    placeholder: 'image/appetit/placeholder.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),

                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.white.withOpacity(0.01)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(categories[index].name.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    )),

                //zoom icon
                // Positioned(
                //     bottom: 16,
                //     right: 16,
                //     child: Icon(Icons.crop_free_outlined, color: Colors.white)),

                //User profile information
                // Positioned(
                //   top: 16,
                //   left: 16,
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         CircleAvatar(
                //             radius: 10,
                //             child: ClipOval(
                //                 child: Image.asset(
                //                     cookingmodal[index].chefpic.toString(),
                //                     fit: BoxFit.cover,
                //                     height: 60,
                //                     width: 60))),
                //         Text(cookingmodal[index].chefname.toString(),
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 10)),
                //       ],
                //     ),
                //     style: ElevatedButton.styleFrom(
                //         primary: Colors.white70.withOpacity(0.35),
                //         shape: StadiumBorder()),
                //   ),
                // ),
              ],
            );
          },
        );
      }
      return SizedBox.shrink();
    });
  }
}
