import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/models/seller_model.dart';
import 'package:food_truck_mobile/models/user_model.dart';

/// The main Auth instance that stores the information of the current user
class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in to the account by Email/Password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
          msg: "Login Succeed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 16.0);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
          msg: "Sign in Failed: $substring",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 16.0);
    }
  }

  /// Sign out from current account
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Fluttertoast.showToast(
        msg: "Logout Succeed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Logout Failed; $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }

  /// Register and Initialize new account based on Email/Password
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
        msg: "Registration Succeed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      _initializeNewSeller(email);
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Registration Failed: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }

  /// Initialize the new user profile
  Future<void> _initializeNewSeller(String email) async {
    try {
      CollectionReference seller = _firestore.collection('sellers');
      DocumentReference sellers = seller.doc(currentUser?.uid);
      await sellers.set(
          SellerModel(id: currentUser?.uid, name: 'Users $email', email: email)
              .toJson());
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Initialize Failed: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Initialize the new user profile
  Future<bool> updateSeller(SellerModel seller) async {
    try {
      CollectionReference sellers = _firestore.collection('sellers');
      DocumentReference sellerRef = sellers.doc(seller.id);
      await sellerRef.update(seller.toJson());
      Fluttertoast.showToast(
        msg: "Update Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      notifyListeners();
      return true;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Update Failed: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      return false;
    }
  }

  /// Update Email
  Future<bool> updateEmail(String newEmail) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
      notifyListeners();
      return true;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Failed to update email: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "A password reset email has sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Failed to send reset email: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<SellerModel?> getSellerInfo() async {
    try {
      CollectionReference sellers = _firestore.collection('sellers');
      DocumentReference sellerRef = sellers.doc(currentUser?.uid);
      var documentSnapshot = await sellerRef.get();
      return SellerModel.fromSnapshot(documentSnapshot);
    } catch (e) {
      if (e.toString().contains("Null check operator used on a null value")) {
        _initializeNewSeller(currentUser!.email!);
        getSellerInfo();
      } else {
        String input = e.toString();
        String substring = input.substring(input.indexOf("]") + 1);
        print(e);
        Fluttertoast.showToast(
          msg: "Fail to get user info: $substring",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 16.0,
        );
      }

      return null;
    }
  }

  /// Return the Current User's information
  Future<void> createRestaurant(RestaurantModel restaurantModel) async {
    try {
      CollectionReference res = _firestore.collection('restaurants');
      DocumentReference resRef = res.doc(restaurantModel.id);
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
  Future<List<RestaurantModel>?> getOwnedRestaurant() async {
    try {
      List<RestaurantModel> myRestaurants = <RestaurantModel>[];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('restaurants') // Replace with your collection name
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: currentUser!.uid)
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
}
