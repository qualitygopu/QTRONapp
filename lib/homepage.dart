import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qtronapp/AlarmSettings.dart';
import 'package:flutter/material.dart';
import 'package:qtronapp/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  OpenSettingsPlusAndroid setting = OpenSettingsPlusAndroid();
  final NetworkInfo _networkInfo = NetworkInfo();
  bool isDeviceConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PermissionHandler.arePermissionsGranted();
    initialize();
  }

  Future<void> initialize() async {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      await checkConnection();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() async {
        isDeviceConnected = await _Connection();
      });
    }
  }

  Future<bool> _Connection() async {
    var wifiName = await getConnectedSSID();
    print(wifiName);

    return wifiName.startsWith('"QTRON');
  }

  Future<void> selectOption(int opt) async {
    if (opt == 0) {
      if (await _Connection()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlarmSetting()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Device Not Connected"),
        ));
      }
    } else if (opt == 1) {
    } else if (opt == 2) {}
  }

  @override
  Widget build(BuildContext context) {
    var Screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: Screen.height * 0.4,
                  // decoration: BoxDecoration(color: Colors.black87),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width:
                                  3.0, // Adjust the width of the stroke as needed
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/logo.jpg"),
                            radius: 50,
                            backgroundColor: Colors.white,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "QTRON",
                        style: TextStyle(
                            fontFamily: 'Century Gothic',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.amber[700]),
                      ),
                      Text(
                        "DIVINE MUSICAL CLOCK",
                        style: TextStyle(
                            fontFamily: 'Century Gothic',
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: const Color.fromARGB(255, 255, 255, 255)),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.amber[100]),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.amber[100]),
                  child: ListView(
                    children: [
                      options(0, "Alarm Settings", Icon(Icons.alarm)),
                      options(1, "Update Calendar", Icon(Icons.calendar_month)),
                      options(
                          2, "Upload Songs", Icon(Icons.music_note_outlined))
                    ],
                  ),
                )),
              ],
            ),
            Positioned(
              top: Screen.height * 0.34,
              child: Container(
                width: Screen.width * 0.9,
                height: 100,
                child: Card(
                  color: Colors.blueGrey[400],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Serial No",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            Text(
                              "0240",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: VerticalDivider(
                          thickness: 2,
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                        "Muthu Mariamman Temple \nAlangudi",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    isDeviceConnected = false;
                    if (!await _Connection()) {
                      await setting.wifi();
                    } else {
                      await checkConnection();
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    isDeviceConnected ? Icons.wifi : Icons.wifi_off,
                    color: isDeviceConnected
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                  iconSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bluetooth_disabled_rounded),
      //         label: "connection"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bluetooth_disabled_rounded),
      //         label: "connection"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bluetooth_disabled_rounded), label: "connection")
      //   ],
      // ),
    );
  }

  Widget options(int index, String title, Icon ic) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 70,
        decoration: BoxDecoration(color: Colors.blueGrey[900]),
        child: ListTile(
          onTap: () => selectOption(index),
          leading: ic,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Future<String> getConnectedSSID() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      var wifiName = await _networkInfo.getWifiName();
      return wifiName.toString();
    } else {
      return "Not Connected";
    }
  }

  Future<bool> checkConnection() async {
    bool previousConnection = isDeviceConnected;
    try {
      final result = await http.get(Uri.parse('http://192.168.4.1'));
      if (result.statusCode == 200) {
        isDeviceConnected = true;
        print('connnnected');
      } else {
        isDeviceConnected = false;
        print(' not  connnnected');
      }
    } on SocketException catch (_) {
      // isDeviceConnected = false;
      // print('errrrrrr');
    }

    // //The connection status changed send out an update to all listeners
    // if (previousConnection != isDeviceConnected) {
    //   connectionChangeController.add(isDeviceConnected);
    // }

    return isDeviceConnected;
  }
}
