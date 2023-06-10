import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/firebase/food_manager.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/widget/dialogs/delete_confirmation_dialog.dart';
import 'package:food_truck_mobile/models/food_model.dart';

/// A dialog shows when seller clicks on 'Edit Topping'. It includes options to
/// update/delete Topping
class EditToppingDialog extends StatefulWidget {
  const EditToppingDialog(
      {super.key,
      required this.name,
      required this.price,
      required this.foodModel,
      required this.foodManager});

  final FoodManager foodManager;
  final FoodModel foodModel;
  final String name;
  final double price;

  @override
  State<EditToppingDialog> createState() => _EditToppingDialogState();
}

class _EditToppingDialogState extends State<EditToppingDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name;
    _priceController.text = widget.price.toString();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Topping'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
                labelText: 'Topping Name',
                prefixIcon: const Icon(Icons.restaurant),
                controller: _nameController,
                onTap: () {
                  _nameController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _nameController.value.text.length,
                  );
                }),
            InputField(
                labelText: 'Price',
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.attach_money),
                controller: _priceController,
                onTap: () {
                  _priceController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _priceController.value.text.length,
                  );
                }),
          ],
        ),
      ),
      actions: [
        Button(
          text: 'Delete',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteConfirmationDialog(
                  onDelete: () async {
                    await widget.foodManager
                        .deleteTopping(widget.foodModel, widget.name);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            );
          },
        ),
        Button(
          text: 'Cancel',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          text: 'Update',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          onPressed: () async {
            String name = _nameController.text;
            if (name.isEmpty || _nameController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              double price = double.tryParse(_priceController.text)!;
              await widget.foodManager
                  .updateTopping(widget.foodModel, name, price, widget.name);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
