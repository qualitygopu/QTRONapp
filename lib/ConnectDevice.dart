import 'package:flutter/material.dart';
import 'package:qtronapp/permission_handler.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  OpenSettingsPlusAndroid setting = OpenSettingsPlusAndroid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PermissionHandler.arePermissionsGranted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Device'),
      ),
      body: Center(
          child: ElevatedButton(
        child: Text('Connect'),
        onPressed: () async {
          // bool connected = await WiFiForIoTPlugin.connect(
          //   "QTRON_1001",
          //   withInternet: false,
          // );
        },
      )),
    );
  }
}
