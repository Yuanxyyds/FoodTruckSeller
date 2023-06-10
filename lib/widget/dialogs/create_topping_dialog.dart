import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/food_model.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';

import 'package:food_truck_mobile/firebase/food_manager.dart';

/// A dialog shows when seller clicks on 'Add Topping'
class CreateToppingDialog extends StatefulWidget {
  const CreateToppingDialog(
      {super.key, required this.foodManager, required this.foodModel});

  final FoodManager foodManager;
  final FoodModel foodModel;

  @override
  State<CreateToppingDialog> createState() => _CreateToppingDialogState();
}

class _CreateToppingDialogState extends State<CreateToppingDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Topping'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              labelText: 'Topping Name',
              prefixIcon: const Icon(Icons.fastfood),
              controller: _nameController,
            ),
            InputField(
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              labelText: 'Price',
              prefixIcon: const Icon(Icons.attach_money),
              controller: _priceController,
            ),
          ],
        ),
      ),
      actions: [
        Button(
          text: 'Cancel',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          text: 'Create',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          onPressed: () async {
            String name = _nameController.text;
            if (name.isEmpty || _priceController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              double price = double.tryParse(_priceController.text)!;
              widget.foodManager
                  .addTopping(widget.foodModel, name, price);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
