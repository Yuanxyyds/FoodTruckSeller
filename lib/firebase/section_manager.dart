import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_truck_mobile/models/restaurant_model.dart';
import 'package:food_truck_mobile/models/section_model.dart';
import 'package:food_truck_mobile/models/seller_model.dart';
import 'package:food_truck_mobile/models/user_model.dart';

/// The main Auth instance that stores the information of the current user
class SectionManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  /// Return the Current User's information
  Future<void> createSection(SectionModel sectionModel) async {
    try {
      CollectionReference section = _firestore.collection('sections');
      DocumentReference sectionRef = section.doc(sectionModel.id);
      await sectionRef.set(sectionModel.toJson());
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
        msg: "Fail to create section: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<void> updateSection(SectionModel sectionModel) async {
    try {
      CollectionReference res = _firestore.collection('sections');
      DocumentReference resRef = res.doc(sectionModel.id);
      await resRef.update(sectionModel.toJson());
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
        msg: "Fail to update section: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
  }

  /// Return the Current User's information
  Future<List<SectionModel>?> getOwnedSection(String restaurantId) async {
    try {
      List<SectionModel> mySections = <SectionModel>[];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sections') // Replace with your collection name
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: restaurantId)
          .where(FieldPath.documentId, isLessThanOrEqualTo: '${restaurantId}z')
          .get();
      for (var document in snapshot.docs) {
        mySections.add(SectionModel.fromSnapshot(document));
      }
      return mySections;
    } catch (e) {
      String input = e.toString();
      String substring = input.substring(input.indexOf("]") + 1);
      Fluttertoast.showToast(
        msg: "Fail to get sections: $substring",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 16.0,
      );
    }
    return null;
  }

  Future<void> deleteSection(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('sections')
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