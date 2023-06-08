import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/widget/components/input_field.dart';
import 'package:food_truck_mobile/firebase/section_manager.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/widget/dialogs/delete_confirmation_dialog.dart';
import 'package:food_truck_mobile/models/section_model.dart';

class EditSectionDialog extends StatefulWidget {
  const EditSectionDialog(
      {super.key, required this.sectionManager, required this.sectionModel});

  final SectionModel sectionModel;
  final SectionManager sectionManager;

  @override
  State<EditSectionDialog> createState() => _EditSectionDialogState();
}

class _EditSectionDialogState extends State<EditSectionDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.sectionModel.name;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Section'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
                labelText: 'Section Name',
                prefixIcon: const Icon(Icons.restaurant),
                controller: _nameController,
                onTap: () {
                  _nameController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _nameController.value.text.length,
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
                    await widget.sectionManager
                        .deleteSection(widget.sectionModel.id!);
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
            if (_nameController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Input Cannot be Empty!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0);
            } else {
              widget.sectionModel.name = _nameController.text;
              await widget.sectionManager.updateSection(widget.sectionModel);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
