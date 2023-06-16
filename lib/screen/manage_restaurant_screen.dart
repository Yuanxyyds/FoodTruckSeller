import 'package:flutter/material.dart';
import 'package:food_truck_mobile/providers/section_manager.dart';
import 'package:food_truck_mobile/providers/restaurant_manager.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/components/food_button.dart';
import 'package:food_truck_mobile/widget/dialogs/create_food_dialog.dart';
import 'package:food_truck_mobile/widget/dialogs/create_section_dialog.dart';
import 'package:food_truck_mobile/widget/dialogs/edit_restaurant_dialog.dart';
import 'package:food_truck_mobile/widget/dividers/menu_section_divider.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:provider/provider.dart';

import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/providers/food_manager.dart';

import 'package:food_truck_mobile/models/food_model.dart';

/// The [ManageRestaurantScreen], A page seller can add section and food

class ManageRestaurantScreen extends StatelessWidget {
  final RestaurantModel resModel;
  final double restaurantRating;
  List<SectionModel>? sections;

  ManageRestaurantScreen({
    super.key,
    required this.resModel,
    // TODO rating
    this.restaurantRating = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    SectionManager sectionManager = context.watch<SectionManager>();
    RestaurantManager restaurantManager = context.watch<RestaurantManager>();
    FoodManager foodManager = context.watch<FoodManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: FutureBuilder<List<Widget>>(
            future: _getContent(sectionManager, foodManager, resModel.id!),
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
                                  restaurantManager: restaurantManager,
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
                      padding: const EdgeInsets.only(bottom: 10),
                    ),
                    TextTitleSmall(
                      text: resModel.description!,
                      padding: const EdgeInsets.only(bottom: 10),
                      maxLine: 3,
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
                                    sectionManager: sectionManager,
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateFoodDialog(
                                    foodManager: foodManager,
                                    uid: resModel.id!,
                                    sections: sections!,
                                  );
                                },
                              );
                            },
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

  /// Get Section and Food Instances
  Future<List<Widget>> _getContent(SectionManager sectionManager,
      FoodManager foodManager, String restaurantId) async {
    List<Widget> content = [];
    List<SectionModel>? section =
        await sectionManager.getOwnedSection(restaurantId);
    List<FoodModel>? foods =
        await foodManager.getFoodByRestaurant(restaurantId);
    sections = section;
    for (var sectionModel in section!) {
      content.add(MenuSectionDivider(
        sectionManager: sectionManager,
        sectionModel: sectionModel,
      ));
      for (var foodModel in foods!) {
        if (foodModel.sectionId == sectionModel.id) {
          content.add(FoodButton(
            foodModel: foodModel,
            foodManager: foodManager,
            sections: section,
          ));
        }
      }
    }

    return content;
  }
}
