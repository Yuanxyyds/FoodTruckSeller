import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_truck_mobile/firebase/section_manager.dart';

import 'package:food_truck_mobile/firebase/restaurant_manager.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/components/food_button.dart';
import 'package:food_truck_mobile/widget/dialogs/create_section_dialog.dart';
import 'package:food_truck_mobile/widget/dialogs/edit_restaurant_dialog.dart';
import 'package:food_truck_mobile/widget/dividers/menu_section_divider.dart';
import 'package:food_truck_mobile/widget/dividers/section_divider.dart';
import 'package:food_truck_mobile/widget/dividers/section_header_tb.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:provider/provider.dart';

import 'package:food_truck_mobile/models/section_model.dart';

/// The [ManageRestaurantScreen], the parameter should be future changes to a
/// Restaurant Model

class ManageRestaurantScreen extends StatelessWidget {
  final RestaurantModel resModel;
  final double restaurantRating;

  const ManageRestaurantScreen({
    super.key,
    required this.resModel,
    // TODO rating
    this.restaurantRating = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    SectionManager sec = context.watch<SectionManager>();
    RestaurantManager res = context.watch<RestaurantManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: FutureBuilder<List<Widget>>(
            future: _getContent(sec, resModel.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: [
                    Container(
                      height: 185,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(
                            resModel.restaurantUrl,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextTitleLarge(
                          text: resModel.name,
                          isBold: true,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditRestaurantDialog(
                                  restaurantManager: res,
                                  restaurantModel: resModel,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    TextTitleSmall(
                      text: resModel.address!,
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    TextTitleSmall(
                      text: resModel.description!,
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            icon: Icons.line_weight,
                            textColor: Constants.whiteColor,
                            text: 'Add Section',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateSectionDialog(
                                    sectionManager: sec,
                                    restaurantId: resModel.id!,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Button(
                            icon: Icons.fastfood,
                            textColor: Constants.whiteColor,
                            text: 'Add Food',
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                    ...snapshot.data!,
                    const SizedBox(height: 90.0),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  /// TODO: This should be future rebuild based on Section + items
  Future<List<Widget>> _getContent(
      SectionManager sec, String restaurantId) async {
    List<Widget> content = [];
    List<SectionModel>? section = await sec.getOwnedSection(restaurantId);
    for (var sectionModel in section!) {
      content.add(MenuSectionDivider(
        sectionManager: sec,
        sectionModel: sectionModel,
      ));
    }

    return content;
  }
}
