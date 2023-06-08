import 'package:flutter/material.dart';
import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/widget/dialogs/edit_section_dialog.dart';
import 'package:food_truck_mobile/widget/text.dart';

import 'package:food_truck_mobile/firebase/section_manager.dart';

/// This class contains Header Option, which text is in between of (top and
/// bottom) by two horizontal dividers.
class MenuSectionDivider extends StatelessWidget {
  const MenuSectionDivider(
      {super.key, required this.sectionModel, required this.sectionManager});

  final SectionManager sectionManager;
  final SectionModel sectionModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          const Divider(),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextTitleMedium(
                    text: sectionModel.name,
                    isBold: true,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditSectionDialog(
                          sectionManager: sectionManager,
                          sectionModel: sectionModel,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
