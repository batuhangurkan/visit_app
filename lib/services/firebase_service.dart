import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final locationPlace = FirebaseFirestore.instance.collection('Location');

  Future<void> insertLocation(
      {required String locationName,
      required String locationTime,
      required String category}) async {
    final location = FirebaseAuth.instance.currentUser;
    await locationPlace.add({
      'locationName': locationName,
      'locationTime': locationTime,
      'category': category,
    });
  }

  Future<void> updateLocation(
      {required String locationName,
      required String locationTime,
      required String category}) async {
    final location = FirebaseAuth.instance.currentUser;
    await locationPlace.doc(location!.uid).update({
      'locationName': locationName,
      'locationTime': locationTime,
      'category': category,
    });
  }

  Future<void> deleteLocation({required String locationName}) async {
    final location = FirebaseAuth.instance.currentUser;
    await locationPlace.doc(location!.uid).delete();
  }
}
