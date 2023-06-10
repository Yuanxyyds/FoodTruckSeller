import 'package:flutter/material.dart';
import 'package:food_truck_mobile/firebase/food_manager.dart';
import 'package:food_truck_mobile/models/food_model.dart';
import 'package:food_truck_mobile/widget/components/topping.dart';
import 'package:food_truck_mobile/widget/dialogs/create_topping_dialog.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:food_truck_mobile/widget/decorations/popular_tag.dart';
import 'package:food_truck_mobile/widget/dividers/section_divider.dart';
import 'package:provider/provider.dart';

/// The [FoodDetailScreen] that shows the detailed information of the food, and
/// topping options. Also Seller can edit food/topping information at this
/// screen
class FoodDetailScreen extends StatefulWidget {
  final FoodModel foodModel;
  final bool isPopular;

  const FoodDetailScreen(
      {Key? key, required this.isPopular, required this.foodModel})
      : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    FoodManager foodManager = context.watch<FoodManager>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodModel.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: ListView(
          children: [
            Container(
              height: 185,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(widget.foodModel.foodUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextTitleLarge(
                      text: widget.foodModel.name,
                      isBold: true,
                    ),
                  ),
                  if (widget.isPopular) const PopularTag()
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      widget.foodModel.description,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: TextTitleMedium(
                        text: '\$ ${widget.foodModel.price.toStringAsFixed(2)}',
                        isBold: true,
                        padding: EdgeInsets.zero,
                      )),
                ),
              ],
            ),
            const SectionDivider(),
            Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: TextTitleMedium(
                    text: "Toppings",
                    isBold: true,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CreateToppingDialog(
                                foodManager: foodManager,
                                foodModel: widget.foodModel,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add)))
              ],
            ),
            ..._getContent(foodManager),
            const SizedBox(
              height: 130.0,
            ),
          ],
        ),
      ),

      // Subtotal information fixed at bottom
    );
  }

  /// Method to get all topping of the current foodModel
  List<Widget> _getContent(FoodManager foodManager) {
    List<Widget> content = [];
    for (var element in widget.foodModel.topping.keys) {
      content.add(Topping(
        name: element,
        price: widget.foodModel.topping[element]!,
        foodManager: foodManager,
        foodModel: widget.foodModel,
      ));
    }

    return content;
  }
}
