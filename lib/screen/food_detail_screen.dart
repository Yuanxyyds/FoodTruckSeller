import 'package:flutter/material.dart';
import 'package:food_truck_mobile/widget/components/add_topping.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/decorations/popular_tag.dart';
import 'package:food_truck_mobile/widget/dividers/section_divider.dart';


class FoodDetailScreen extends StatefulWidget {
  final String? imageUrl;
  final String foodName;
  final String description;
  final double price;
  final bool isPopular;
  final List<List> toppings;

  const FoodDetailScreen(
      {Key? key,
      required this.imageUrl,
      required this.foodName,
      required this.description,
      required this.price,
      required this.isPopular,
      this.toppings = const [
        ["Avocado", 0.99],
        ["Chili peppers", 0.99],
        ["Vegan mayo", 0.99]
      ]})
      : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int count = 1;

  // Ternary operator to get Url, simplifying build method
  String getImageUrlOrDefault() {
    return widget.imageUrl ?? 'images/DefaultRestaurantImage.jpeg';
  }

  double calculateSubtotal() {
    return count * widget.price;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = calculateSubtotal();
    String url = getImageUrlOrDefault();
    Color removeColor = count == 1 ? Colors.grey : Colors.black;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.foodName),
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
                    image: AssetImage(url),
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
                        text: widget.foodName,
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
                        widget.description,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: TextTitleMedium(
                          text: '\$ ${widget.price.toStringAsFixed(2)}',
                          isBold: true,
                          padding: EdgeInsets.zero,
                        )),
                  ),
                ],
              ),
              const SectionDivider(),
              const TextTitleMedium(
                text: "Toppings",
                isBold: true,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4.0, top: 8.0, bottom: 8.0),
                child: Text("Choose up to 4 additional items."),
              ),
              ..._getContent(),
              const SizedBox(
                height: 130.0,
              ),
            ],
          ),
        ),

        // Subtotal information fixed at bottom
        );
  }

  List<Widget> _getContent() {
    List<Widget> content = [];
    for (var element in widget.toppings) {
      content.add(AdditionFood(name: element[0], price: element[1]));
    }

    return content;
  }
}
