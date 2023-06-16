import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/food_model.dart';

/// The main FoodManager instance (Provider) that manages the food functions
class FoodManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new food instance in Firestore based on the [FoodModel]
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

  /// Update the food instance based on the new [FoodModel]
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

  /// Find all foods created under this restaurant
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

  /// Return all foods under certain section (by sectionId)
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

  /// Delete the food instance in Firestore based on the food id
  Future<void> deleteFood(String id) async {
    try {
      await FirebaseFirestore.instance.collection('foods').doc(id).delete();
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

  /// Add a new topping (topping name, topping price) to the given [FoodModel]
  Future<void> addTopping(
      FoodModel foodModel, String name, double price) async {
    try {
      foodModel.addOrUpdateTopping(name, price);
      await updateFood(foodModel);
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
        msg: "Fail to add topping: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Update the topping (topping name, topping price) to the given [FoodModel]
  Future<void> updateTopping(
      FoodModel foodModel, String name, double price, String oldName) async {
    try {
      foodModel.removeTopping(oldName);
      foodModel.addOrUpdateTopping(name, price);
      await updateFood(foodModel);
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
        msg: "Fail to add topping: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Delete the topping (by topping name) from given [FoodModel]
  Future<void> deleteTopping(FoodModel foodModel, String name) async {
    try {
      foodModel.removeTopping(name);
      await updateFood(foodModel);
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
        msg: "Fail to delete topping: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }
}
