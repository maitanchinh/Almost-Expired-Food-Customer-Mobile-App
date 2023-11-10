import 'package:appetit/cubit/categories/categories_cubit.dart';
import 'package:appetit/cubit/categories/categories_state.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:appetit/main.dart';

class IndustriesListScreen extends StatelessWidget {
  const IndustriesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: appStore.isDarkModeOn
                      ? context.cardColor
                      : appetitAppContainerColor,
                  height: 50,
                  width: 50,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_outlined,
                          color: appetitBrownColor)),
                ),
              ),
              //categories

              BlocProvider<IndustriesCubit>(
                create: (context) => IndustriesCubit(),
                child: BlocBuilder<IndustriesCubit, IndustriesState>(
                    builder: (context, state) {
                  if (state is IndustriesLoadingState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonWidget(
                            borderRadius: 17, height: 35, width: 200),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: (1 / 1.5)),
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SkeletonWidget(
                                borderRadius: 35, height: 0, width: 0);
                          },
                        )
                      ],
                    );
                  }
                  if (state is IndustriesSuccessState) {
                    var industries = state.industries.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ngành hàng',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w500)),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: (1 / 1.5)),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: industries!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: FadeInImage.assetNetwork(
                                    image: industries[index]
                                        .thumbnailUrl
                                        .toString(),
                                    placeholder:
                                        'image/appetit/placeholder.png',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
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
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(35),
                                              topRight: Radius.circular(35)),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.grey,
                                                Colors.white.withOpacity(0.01)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)),
                                      child: Text(
                                          industries[index].name.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    )),
                              ],
                            );
                          },
                        )
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
