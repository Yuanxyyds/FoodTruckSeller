import 'package:flutter/material.dart';
import 'package:food_truck_mobile/firebase/auth_manager.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/dialogs/create_restaurant_dialog.dart';
import 'package:food_truck_mobile/widget/components/restaurant_button.dart';
import 'package:food_truck_mobile/widget/dividers/section_divider.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:provider/provider.dart';
import 'package:food_truck_mobile/helper/constants.dart';
import 'package:food_truck_mobile/widget/components/bottom_navigation.dart';
import 'package:food_truck_mobile/widget/components/button.dart';

import 'package:food_truck_mobile/firebase/restaurant_manager.dart';


/// The [MyRestaurantScreen] of this app, it has two screens: User Information
/// Screen and the User Login Screen.

class MyRestaurantScreen extends StatefulWidget {
  const MyRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<MyRestaurantScreen> createState() => _MyRestaurantScreenState();
}

class _MyRestaurantScreenState extends State<MyRestaurantScreen> {
  /// Build the page based on if currentUser has an instance
  @override
  Widget build(BuildContext context) {
    AuthManager auth = context.watch<AuthManager>();
    RestaurantManager res = context.watch<RestaurantManager>();

    return Scaffold(
      appBar: AppBar(
        title: const TextHeadlineSmall(
          text: 'My Restaurant',
        ),
      ),
      bottomNavigationBar: const BottomNavigation(
        currentIndex: 0,
      ),
      body: auth.currentUser != null
          ? getContent(res, auth.currentUser!.uid)
          : const Center(child: TextHeadlineSmall(text: 'Login First!')),
    );
  }

  Widget getContent(RestaurantManager res, String uid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: FutureBuilder<List<Widget>>(
          future: getMyRestaurants(res, uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  ...snapshot.data!,
                  Button(
                    text: 'Create New Restaurant',
                    textColor: Constants.whiteColor,
                    takeLeastSpace: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CreateRestaurantDialog(
                            restaurantManager: res,
                            uid: uid,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<Widget>> getMyRestaurants(RestaurantManager res, String uid) async {
    List<Widget> myRestaurants = <Widget>[];
    List<RestaurantModel>? restaurants = await res.getOwnedRestaurant(uid);
    if (restaurants == null) {
      return myRestaurants;
    } else {
      for (var resModel in restaurants) {
        myRestaurants.add(RestaurantButton(
          resModel: resModel,
          restaurantManager: res,
        ));
        myRestaurants.add(const SectionDivider());
      }
    }
    return myRestaurants;
  }
}
