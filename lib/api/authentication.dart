import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:munch_app/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/pages/profile/onboarding_page.dart';
import 'package:munch_app/pages/profile/tastebud_saved_place_database.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

part 'authentication.g.dart';

@JsonSerializable()
class UserData {
  UserData(this.profile, this.setting, this.searchPreference);

  UserProfile profile;
  UserSetting setting;
  UserSearchPreference searchPreference;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

enum AuthenticationState { loggedIn, cancel }

class Authentication {
  static Authentication instance = Authentication();

  final MunchApi _api = MunchApi.instance;

  Future<String> getCustomToken() {
    return _api.get('/users/authenticate/custom/token').then((res) => res.data['token'] as String);
  }

  Future<String> getToken() {
    return FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) return null;
      return user.getIdToken(refresh: false);
    });
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("UserProfile") == null) {
      MunchAnalytic.clearUserData();
      FirebaseAuth.instance.signOut();
      return false;
    }

    return FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) return true;
      MunchAnalytic.clearUserData();
      return false;
    });
  }

  Future<AuthenticationState> requireAuthentication(BuildContext context) {
    return isAuthenticated().then((authenticated) {
      if (authenticated) return AuthenticationState.loggedIn;

      // If user is not logged in, preset boarding controller and try to login
      return OnBoardingPage.push(context);
    });
  }

  Future<AuthenticationState> loginFacebook(String accessToken) {
    final credential = FacebookAuthProvider.getCredential(accessToken: accessToken);

    return FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      return _authenticate().then((_) => AuthenticationState.loggedIn);
    });
  }

  Future<void> _authenticate() async {
    return _api.post("/users/authenticate").then((res) => UserData.fromJson(res.data)).then((UserData data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("UserProfile", jsonEncode(data.profile.toJson()));
      prefs.setString("UserSetting", jsonEncode(data.setting.toJson()));
      prefs.setString("UserSearchPreference", jsonEncode(data.searchPreference.toJson()));

      PlaceSavedDatabase.instance.reset(reload: true);
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("UserProfile");
    prefs.remove("UserSetting");
    prefs.remove("UserSearchPreference");
    UserSearchPreference.instance = null;

    PlaceSavedDatabase.instance.reset(reload: false);

    return FirebaseAuth.instance.signOut();
  }
}
