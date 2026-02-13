import 'dart:developer';

import 'package:flutter/material.dart';

import '/data/models/user_model.dart';
import '/data/repositories/user_repository.dart';
import '../../data/exceptions/exceptions.dart';

final class UserController extends ChangeNotifier {
  final UserRepository userRepository;
  UserController(this.userRepository);

  UserModel? userData;

  Future<void> getUserData() async {
    try {
      userData = await userRepository.getUserData();
      notifyListeners();
    } on AppException catch (e, s) {
      log("GET USER DATA", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }

  Future<void> updateUserData(UserModel userData) async {
    try {
      await userRepository.updateUserData(userData);
      this.userData?.name = userData.name;
      this.userData?.phoneNumber = userData.phoneNumber;
      this.userData?.email = userData.email;
      notifyListeners();
    } on AppException catch (e, s) {
      log("UPDATE USER DATA", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await userRepository.deleteUser();
    } on AppException catch (e, s) {
      log("DELETE ACCOUNT", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }
}
