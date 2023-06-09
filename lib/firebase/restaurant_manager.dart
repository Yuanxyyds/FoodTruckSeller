import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/firebase/section_manager.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/models/seller_model.dart';
import 'package:food_truck_mobile/models/user_model.dart';

/// The main Auth instance that stores the information of the current user
class RestaurantManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Return the Current User's information
  Future<void> createRestaurant(RestaurantModel restaurantModel) async {
    try {
      String restaurantId = restaurantModel.id!;
      CollectionReference res = _firestore.collection('restaurants');
      DocumentReference resRef = res.doc(restaurantId);
      await resRef.set(restaurantModel.toJson());

      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      notifyListeners();
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to create restaurant: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<void> updateRestaurant(RestaurantModel restaurantModel) async {
    try {
      CollectionReference res = _firestore.collection('restaurants');
      DocumentReference resRef = res.doc(restaurantModel.id);
      await resRef.update(restaurantModel.toJson());
      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      notifyListeners();
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to update restaurant: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<List<RestaurantModel>?> getOwnedRestaurant(String uid) async {
    try {
      List<RestaurantModel> myRestaurants = <RestaurantModel>[];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('restaurants') // Replace with your collection name
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: uid)
          .where(FieldPath.documentId, isLessThanOrEqualTo: '${uid}z')
          .get();
      for (var document in snapshot.docs) {
        myRestaurants.add(RestaurantModel.fromSnapshot(document));
      }
      return myRestaurants;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to get restaurants: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    return null;
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(id)
          .delete();
      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      SectionManager sectionManager = SectionManager();
      List<SectionModel>? sections = await sectionManager.getOwnedSection(id);
      sections!.forEach((sectionModel) {
        sectionManager.deleteSection(sectionModel.id!);
      });
      notifyListeners();
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to delete: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }
}
