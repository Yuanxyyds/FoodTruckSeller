import 'package:flutter/material.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/screen/manage_restaurant_screen.dart';
import 'package:food_truck_mobile/widget/components/button.dart';
import 'package:food_truck_mobile/widget/dialogs/delete_confirmation_dialog.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:food_truck_mobile/firebase/restaurant_manager.dart';

/// This is the Restaurant Button on the Home Screen, Slightly different UI than
/// [HomeRestaurantButton]

class RestaurantButton extends StatelessWidget {
  const RestaurantButton({
    super.key,
    required this.resModel,
    required this.restaurantManager,
  });

  final RestaurantModel resModel;
  final RestaurantManager restaurantManager;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            if (resModel.restaurantUrl == null)
              Expanded(
                flex: 2,
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage(
                        'images/DefaultRestaurantImage.jpeg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            if (resModel.restaurantUrl != null)
              Expanded(
                flex: 2,
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                        resModel.restaurantUrl,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextTitleMedium(
                        text: resModel.name,
                        isBold: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextLabelMedium(
                        text: resModel.isOpen ? 'Open' : 'Close',
                        isBold: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Button(
                              text: 'Delete',
                              textColor: Constants.whiteColor,
                              backgroundColor: Colors.deepOrangeAccent,
                              takeLeastSpace: true,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteConfirmationDialog(
                                      onDelete: () async {
                                        await restaurantManager
                                            .deleteRestaurant(resModel.id!);
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 3,
                            child: Button(
                              text: 'Manage',
                              textColor: Constants.whiteColor,
                              takeLeastSpace: true,
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ManageRestaurantScreen(
                                      resModel: resModel,
                                    ),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
