import 'package:flutter/material.dart';
import 'package:food_truck_mobile/screen/account_screen.dart';
import 'package:food_truck_mobile/screen/my_restaurant_screen.dart';
import 'package:food_truck_mobile/screen/order_screen.dart';


/// The Bottom Navigation Bar Component
class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({super.key, required this.currentIndex});


  @override
  Widget build(BuildContext context) {
    Widget screen = Container();
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFC1CEBD),
            spreadRadius: 5,
            blurRadius: 32,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // <-- This works for fixed
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              screen = const MyRestaurantScreen();
              break;
            case 1:
              screen = const OrderScreen();
              break;
            case 2:
              screen = const AccountScreen();
              break;

          }
          Navigator.of(context).pop();
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionDuration: Duration.zero,
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
