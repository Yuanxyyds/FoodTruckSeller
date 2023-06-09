import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/food_model.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/models/seller_model.dart';
import 'package:food_truck_mobile/models/user_model.dart';

/// The main Auth instance that stores the information of the current user
class FoodManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  /// Return the Current User's information
  Future<void> createFood(FoodModel foodModel) async {
    try {
      CollectionReference food = _firestore.collection('foods');
      DocumentReference foodRef = food.doc(foodModel.id);
      await foodRef.set(foodModel.toJson());
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
        msg: "Fail to create food: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<void> updateFood(FoodModel foodModel) async {
    try {
      CollectionReference food = _firestore.collection('foods');
      DocumentReference foodRef = food.doc(foodModel.id);
      await foodRef.update(foodModel.toJson());
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
        msg: "Fail to update food: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<List<FoodModel>?> getFoodByRestaurant(String restaurantId) async {
    try {
      List<FoodModel> myFoods = <FoodModel>[];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('foods') // Replace with your collection name
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: restaurantId)
          .where(FieldPath.documentId, isLessThanOrEqualTo: '${restaurantId}z')
          .get();
      for (var document in snapshot.docs) {
        myFoods.add(FoodModel.fromSnapshot(document));
      }
      return myFoods;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to get food: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    return null;
  }

  /// Return the Current User's information
  Future<List<FoodModel>?> getFoodBySection(String sectionId) async {
    try {
      List<FoodModel> myFoods = <FoodModel>[];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('foods') // Replace with your collection name
          .where('sectionId', isEqualTo: sectionId)
          .get();
      for (var document in snapshot.docs) {
        myFoods.add(FoodModel.fromSnapshot(document));
      }
      return myFoods;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to get food: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    return null;
  }

  Future<void> deleteFood(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('foods')
          .doc(id)
          .delete();
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
        msg: "Fail to delete: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }



}