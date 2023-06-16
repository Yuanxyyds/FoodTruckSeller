import 'package:flutter/material.dart';
import 'package:food_truck_mobile/providers/food_manager.dart';
import 'package:food_truck_mobile/widget/dialogs/edit_topping_dialog.dart';
import 'package:food_truck_mobile/models/food_model.dart';

/// The class contains [Topping] instance and associate functions to edit/create
/// Toppings
class Topping extends StatefulWidget {
  final String name;
  final double price;
  final FoodManager foodManager;
  final FoodModel foodModel;

  const Topping({
    Key? key,
    required this.name,
    required this.price,
    required this.foodManager,
    required this.foodModel,
  }) : super(key: key);

  @override
  State<Topping> createState() => _ToppingState();
}

class _ToppingState extends State<Topping> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditToppingDialog(
                    name: widget.name,
                    price: widget.price,
                    foodModel: widget.foodModel,
                    foodManager: widget.foodManager,
                  );
                },
              );
            },
            icon: const Icon(Icons.edit)),
        Expanded(child: Text(widget.name)),
        Text('\$ ${widget.price.toStringAsFixed(2)}'),
      ],
    );
  }
}
