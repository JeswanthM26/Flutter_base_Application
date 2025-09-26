import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  static const _profileImagePathKey = 'profile_image_path';
  String? _profileImagePath;

  String? get profileImagePath => _profileImagePath;

  ProfileProvider() {
    _loadProfileImagePath();
  }

  Future<void> _loadProfileImagePath() async {
    if (_profileImagePath != null && _profileImagePath != profileImagePath) {
      // Clear the cache for the old image
      FileImage(File(_profileImagePath!)).evict();
    }

    final prefs = await SharedPreferences.getInstance();
    _profileImagePath = prefs.getString(_profileImagePathKey);
    notifyListeners();
  }

  Future<void> updateProfileImagePath(String? path) async {
    _profileImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_profileImagePathKey, path);
      FileImage(File(path)).evict();
    } else {
      await prefs.remove(_profileImagePathKey);
    }
    notifyListeners();
  }
}
