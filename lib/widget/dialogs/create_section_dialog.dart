import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/providers/section_manager.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';

/// A dialog shows when seller clicks on 'Add Section'
class CreateSectionDialog extends StatefulWidget {
  const CreateSectionDialog(
      {super.key, required this.sectionManager, required this.restaurantId});

  final SectionManager sectionManager;
  final String restaurantId;

  @override
  State<CreateSectionDialog> createState() => _CreateSectionDialogState();
}

class _CreateSectionDialogState extends State<CreateSectionDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Section'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              labelText: 'Section Name',
              prefixIcon: const Icon(Icons.line_weight_outlined),
              controller: _nameController,
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
            String resId = widget.restaurantId;
            int timestamp = DateTime.now().millisecondsSinceEpoch;
            String name = _nameController.text;

            if (name.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              SectionModel section = SectionModel(
                id: '$resId$timestamp',
                name: name,
              );
              widget.sectionManager.createSection(section);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
