import 'package:flutter/material.dart';
import 'package:food_truck_mobile/firebase/auth.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/widget/create_restaurant_dialog.dart';
import 'package:food_truck_mobile/widget/restaurant_button.dart';
import 'package:food_truck_mobile/widget/section_divider.dart';
import 'package:food_truck_mobile/widget/text.dart';
import 'package:provider/provider.dart';
import '../helper/constants.dart';
import '../widget/bottom_navigation.dart';
import '../widget/button.dart';

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
    Auth auth = context.watch<Auth>();
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
          ? getContent(auth)
          : const Center(child: TextHeadlineSmall(text: 'Login First!')),
    );
  }

  Widget getContent(Auth auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: FutureBuilder<List<Widget>>(
          future: getMyRestaurants(auth),
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
                            auth: auth,
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

  Future<List<Widget>> getMyRestaurants(Auth auth) async {
    List<Widget> myRestaurants = <Widget>[];
    List<RestaurantModel>? restaurants = await auth.getOwnedRestaurant();
    if (restaurants == null) {
      return myRestaurants;
    } else {
      for (var resModel in restaurants) {
        myRestaurants.add(RestaurantButton(
          restaurantName: resModel.name,
          label: resModel.isOpen.toString(),
        ));
        myRestaurants.add(const SectionDivider());
      }
    }
    return myRestaurants;
  }
}
