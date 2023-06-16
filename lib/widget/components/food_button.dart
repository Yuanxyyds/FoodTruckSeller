import 'package:flutter/material.dart';
import 'package:food_truck_mobile/providers/food_manager.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/models/food_model.dart';
import 'package:food_truck_mobile/screen/food_detail_screen.dart';
import 'package:food_truck_mobile/screen/manage_restaurant_screen.dart';
import 'package:food_truck_mobile/widget/decorations/popular_tag.dart';
import 'package:food_truck_mobile/widget/dialogs/edit_food_dialog.dart';
import 'package:food_truck_mobile/widget/text.dart';

import 'package:food_truck_mobile/models/section_model.dart';

/// This class contains a [FoodButton] that can be pressed to view the food's
/// details. Also contains a button to edit the [FoodModel]
class FoodButton extends StatelessWidget {
  const FoodButton(
      {super.key,
      this.isPopular = true,
      required this.foodModel,
      required this.foodManager,
      required this.sections});

  final FoodModel foodModel;
  final bool isPopular;

  // TODO Edit Food
  final FoodManager foodManager;
  final List<SectionModel>? sections;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FoodDetailScreen(
                      foodModel: foodModel,
                      isPopular: isPopular),
              transitionDuration: Duration.zero,
            ),
          );
        },
        child: Container(
          height: 110,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextTitleSmall(
                        text: foodModel.name,
                        isBold: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextLabelSmall(
                        text: foodModel.description,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        maxLine: 3,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextTitleSmall(
                              text: '\$ ${foodModel.price}',
                              isBold: true,
                            )),
                            // if (isPopular) const PopularTag(),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditFoodDialog(
                                        foodManager: foodManager,
                                        foodModel: foodModel,
                                        sections: sections!,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              if (foodModel.foodUrl == null)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage(
                          'images/DefaultRestaurantImage.jpeg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              if (foodModel.foodUrl != null)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(
                          foodModel.foodUrl!,
                        ),
                        fit: BoxFit.fill,
                      ),
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
