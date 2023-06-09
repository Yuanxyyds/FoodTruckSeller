import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/food_model.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/firebase/food_manager.dart';
import 'package:food_truck_mobile/models/section_model.dart';

import 'delete_confirmation_dialog.dart';

class EditFoodDialog extends StatefulWidget {
  const EditFoodDialog(
      {super.key,
        required this.foodManager,
        required this.sections, required this.foodModel});

  final FoodModel foodModel;
  final FoodManager foodManager;
  final List<SectionModel> sections;

  @override
  State<EditFoodDialog> createState() => _EditFoodDialogState();
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.foodModel.name;
    _priceController.text = widget.foodModel.price.toString();
    _descriptionController.text = widget.foodModel.description;
    super.initState();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<SectionModel>> options = widget.sections
        .map((sectionModel) => DropdownMenuEntry(
      value: sectionModel,
      label: sectionModel.name,
    ))
        .toList();
    String sectionId = '';

    return AlertDialog(
      title: const Text('Edit Food'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(
            labelText: 'Food Name',
            prefixIcon: const Icon(Icons.fastfood),
            controller: _nameController,
          ),
          InputField(
            labelText: 'Description',
            prefixIcon: const Icon(Icons.description),
            controller: _descriptionController,
          ),
          InputField(
            labelText: 'Price',
            prefixIcon: const Icon(Icons.attach_money),
            controller: _priceController,
            textInputType:
            const TextInputType.numberWithOptions(decimal: true),
          ),
          Container(
            color: Constants.whiteColor,
            child: DropdownMenu<SectionModel>(
              width: 230,
              leadingIcon: const Icon(Icons.line_weight),
              hintText: 'Section',
              dropdownMenuEntries: options,
              onSelected: (sectionModel) {
                sectionId = sectionModel!.id!;
              },
            ),
          ),
        ],
      ),
      actions: [
        Button(
          text: 'Delete',
          takeLeastSpace: true,
          textColor: Constants.whiteColor,
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteConfirmationDialog(
                  onDelete: () async {
                    await widget.foodManager
                        .deleteFood(widget.foodModel.id!);
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
            String description = _descriptionController.text;
            if (name.isEmpty ||
                _priceController.text.isEmpty ||
                sectionId.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Name, Money and Section Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              double price = double.tryParse(_priceController.text)!;
              widget.foodModel.name = name;
              widget.foodModel.price = price;
              widget.foodModel.description = description;
              widget.foodModel.sectionId = sectionId;

              await widget.foodManager.updateFood(widget.foodModel);
            }

            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
