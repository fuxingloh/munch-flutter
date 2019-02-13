import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FacebookAppEvents {
  factory FacebookAppEvents() => _instance;

  FacebookAppEvents.private(MethodChannel platformChannel) : _channel = platformChannel;

  final MethodChannel _channel;

  static final FacebookAppEvents _instance = FacebookAppEvents.private(const MethodChannel('facebook_app_events'));

  Future<void> logEvent({@required String name, Map<String, dynamic> parameters}) async {
    await _channel.invokeMethod('logEvent', <String, dynamic>{
      'name': name,
      'parameters': parameters,
    });
  }

  Future<void> setUserId(String id) async {
    await _channel.invokeMethod('setUserId', id);
  }

  Future<void> clearUserData() async {
    await _channel.invokeMethod('clearUserData');
  }
}
