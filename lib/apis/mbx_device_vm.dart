import 'dart:async';
import 'dart:io';

import 'package:client_information/client_information.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:uuid/uuid.dart';

class MbxDeviceVM {
  static Future<String> deviceId() async {
    var id = await MbxUserPreferencesVM.getDeviceId();
    if (id.isEmpty) {
      try {
        id = await ClientInformation.fetch().then((info) => info.deviceId);
      } catch (e) {
        // Fallback for macOS or other unsupported platforms
        if (Platform.isMacOS) {
          id = 'macos_device_${Platform.localHostname}';
        } else {
          id = 'unknown_device';
        }
      }
      id = id + Uuid().v4();
      id = id.replaceAll(' ', '');
      id = id.replaceAll('-', '');
      id = id.toLowerCase();
      await MbxUserPreferencesVM.setDeviceId(id);
    }
    return id;
  }

  static Future<String> deviceName() async {
    try {
      ClientInformation info = await ClientInformation.fetch();
      return info.deviceName;
    } catch (e) {
      // Fallback for macOS or other unsupported platforms
      if (Platform.isMacOS) {
        return '${Platform.localHostname} (macOS)';
      } else {
        return 'Unknown Device';
      }
    }
  }

  static Future<String> deviceOSName() async {
    try {
      ClientInformation info = await ClientInformation.fetch();
      return info.osName;
    } catch (e) {
      // Fallback for macOS or other unsupported platforms
      if (Platform.isMacOS) {
        return 'macOS';
      } else {
        return 'Unknown OS';
      }
    }
  }

  static Future<String> deviceOSVersion() async {
    try {
      ClientInformation info = await ClientInformation.fetch();
      return info.osVersion;
    } catch (e) {
      // Fallback for macOS or other unsupported platforms
      if (Platform.isMacOS) {
        return Platform.operatingSystemVersion;
      } else {
        return 'Unknown Version';
      }
    }
  }

  static Future<String> deviceOSVersionCode() async {
    try {
      ClientInformation info = await ClientInformation.fetch();
      return '${info.osVersionCode}';
    } catch (e) {
      // Fallback for macOS or other unsupported platforms
      return '0';
    }
  }
}
