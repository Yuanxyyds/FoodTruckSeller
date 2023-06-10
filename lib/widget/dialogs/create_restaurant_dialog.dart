import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/firebase/restaurant_manager.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';

/// A dialog shows when seller clicks on 'Create Restaurant'
class CreateRestaurantDialog extends StatefulWidget {
  const CreateRestaurantDialog(
      {super.key, required this.restaurantManager, required this.uid});

  final RestaurantManager restaurantManager;
  final String uid;

  @override
  State<CreateRestaurantDialog> createState() => _CreateRestaurantDialogState();
}

class _CreateRestaurantDialogState extends State<CreateRestaurantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
      title: const Text('Add Restaurant'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              labelText: 'Restaurant Name',
              prefixIcon: const Icon(Icons.restaurant),
              controller: _nameController,
            ),
            InputField(
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description),
              controller: _descriptionController,
            ),
            InputField(
              labelText: 'Address',
              prefixIcon: const Icon(Icons.location_on),
              controller: _addressController,
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
            String uid = widget.uid;
            int timestamp = DateTime.now().millisecondsSinceEpoch;
            String name = _nameController.text;
            String description = _descriptionController.text;
            String address = _addressController.text;

            if (name.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              RestaurantModel restaurant = RestaurantModel(
                id: '$uid$timestamp',
                name: name,
                description:
                    description.isEmpty ? 'Description not set' : description,
                address: address.isEmpty ? 'UofT' : address,
              );
              await widget.restaurantManager.createRestaurant(restaurant);
            }

            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
