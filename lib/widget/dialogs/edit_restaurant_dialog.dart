import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/firebase/restaurant_manager.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/widget/dialogs/delete_confirmation_dialog.dart';

class EditRestaurantDialog extends StatefulWidget {
  const EditRestaurantDialog(
      {super.key,
      required this.restaurantManager,
      required this.restaurantModel});

  final RestaurantModel restaurantModel;
  final RestaurantManager restaurantManager;

  @override
  State<EditRestaurantDialog> createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.restaurantModel.name;
    _descriptionController.text = widget.restaurantModel.description!;
    _addressController.text = widget.restaurantModel.address!;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Restaurant'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
                labelText: 'Restaurant Name',
                prefixIcon: const Icon(Icons.restaurant),
                controller: _nameController,
                onTap: () {
                  _nameController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _nameController.value.text.length,
                  );
                }),
            InputField(
                labelText: 'Description',
                prefixIcon: const Icon(Icons.description),
                controller: _descriptionController,
                onTap: () {
                  _descriptionController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _descriptionController.value.text.length,
                  );
                }),
            InputField(
                labelText: 'Address',
                prefixIcon: const Icon(Icons.location_on),
                controller: _addressController,
                onTap: () {
                  _addressController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _addressController.value.text.length,
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
                    await widget.restaurantManager
                        .deleteRestaurant(widget.restaurantModel.id!);
                    if (context.mounted) {
                      Navigator.of(context).pop();
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
            if (_nameController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              widget.restaurantModel.name = _nameController.text;
              widget.restaurantModel.description = _descriptionController.text;
              widget.restaurantModel.address = _addressController.text;
              await widget.restaurantManager
                  .updateRestaurant(widget.restaurantModel);
            }

            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
