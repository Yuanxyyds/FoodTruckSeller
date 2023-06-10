import 'package:flutter/material.dart';
import 'package:food_truck_mobile/widget/components/bottom_navigation.dart';
import 'package:food_truck_mobile/widget/text.dart';

/// TODO: TBD
class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TextHeadlineMedium(
          text: 'TBD',
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 1,),
    );
  }
}
