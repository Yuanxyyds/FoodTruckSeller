import 'package:flutter/material.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/button.dart';
import 'package:food_truck_mobile/widget/delete_confirmation_dialog.dart';
import 'package:food_truck_mobile/widget/text.dart';

/// This is the Restaurant Button on the Home Screen, Slightly different UI than
/// [HomeRestaurantButton]

class RestaurantButton extends StatelessWidget {
  const RestaurantButton({
    super.key,
    this.imageUrl,
    required this.restaurantName,
    required this.label,
  });

  final String? imageUrl;
  final String restaurantName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //Navigator.of(context).push(
          //PageRouteBuilder(
          //    pageBuilder: (context, animation, secondaryAnimation) =>
          //
          //    transitionDuration: Duration.zero,
          //  ),
          //);
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              if (imageUrl == null)
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
              if (imageUrl != null)
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          imageUrl!,
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
                          text: restaurantName,
                          isBold: true,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextLabelMedium(
                          text: label,
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
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteConfirmationDialog(
                                        onDelete: (){},
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Expanded(
                              flex: 3,
                              child: Button(
                                text: 'Manage',
                                textColor: Constants.whiteColor,
                                takeLeastSpace: true,
                                onPressed: (){

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
      ),
    );
  }
}
