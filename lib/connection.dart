import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:qtronapp/permission_handler.dart';
import 'package:flutter/foundation.dart';

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({super.key});

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  final List<BluetoothDevice> _devicesList =
      List<BluetoothDevice>.empty(growable: true);
  bool isDiscovering = false;
  bool isConnecting = false;
  BluetoothConnection? connection;
  String receivedData = '';
  bool get isConnected => (connection?.isConnected ?? false);
  List<String> wifiNames = [];
  String selectedWifi = '';
  bool isWifiScanning = false;
  TextEditingController wifipwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PermissionHandler.arePermissionsGranted();
    
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  void _startDiscovery() async {
    if (_bluetoothState.isEnabled) {
      try {
        setState(() {
                  isDiscovering = true;

        });
        _devicesList.clear();
        _streamSubscription =
            FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            if(r.device.name != null){
            if (r.device.name!.startsWith('QTRON')) {
              final existingIndex = _devicesList
                  .indexWhere((element) => element.address == r.device.address);
              if (existingIndex >= 0) {
                _devicesList[existingIndex] = r.device;
              } else {
                _devicesList.add(r.device);
              }
            }}
          });
        });
      } catch (ex) {
        print("Error: $ex");
      }
    } else {
      await FlutterBluetoothSerial.instance.openSettings();
      FlutterBluetoothSerial.instance.state.then((state) {
        setState(() {
          _bluetoothState = state;
        });
      });
    }
    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  Future<void> _startListening() async {
    connection!.input!.listen((data) {
      setState(() {
        receivedData += utf8.decode(data);
      });
      // print(receivedData.endsWith('#'));
    });
    
  }

  @override
  void dispose() {
   isDiscovering ? _streamSubscription?.cancel() : null;
   isConnected ? connection!.close() : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 20),
              height: 70,
              child: ElevatedButton.icon(
                onPressed: isDiscovering
                    ? () {
                        _streamSubscription?.cancel().then((_) => setState(() {
                              isDiscovering = false;
                            }));
                      }
                    : _startDiscovery,
                label: Text(isDiscovering ? "Stop Scanning" : "Scan Device"),
                icon: Icon(isDiscovering
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth),
              )),
              isDiscovering ?  Container(
                      height: 20, padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: LinearProgressIndicator(color: Color.fromARGB(255, 255, 191, 0),))
                  : Container(),
          for(var dev in _devicesList)
          ListTile(
                title: Text(dev.name.toString()),
                subtitle: Text(dev.address),
                trailing: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {isConnecting = true;});
                      !isConnected
                          ? await BluetoothConnection.toAddress(
                                  dev.address)
                              .then((value) {
                                setState(() {connection = value;
                                // isConnecting = false;
                                });
                              
                              _startListening();
                            })
                          : connection!.close();
                      setState(() {isConnecting = false;});
                    },
                    icon: Icon(
                        isConnected ? Icons.link : Icons.link_off_outlined),
                    label: Text(isConnected ? "Disconnect" : "Connect")),
              ),
              isConnecting ?  Container(
                      height: 20, padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: LinearProgressIndicator(color: Color.fromARGB(255, 255, 191, 0),))
                  : Container(),
          isConnected
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 70,
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        wifiNames = [];
                        receivedData = '';
                      });
                      isWifiScanning = true;
                      await _sendMessage("Scan Wifi");
                      await _wifiNames();
                    },
                    label: Text("Scan Wifi"),
                    icon: const Icon(Icons.wifi_find),
                  ))
              : Container(),
          SizedBox(
            height: 20,
          ),
          wifiNames.isNotEmpty
              ? Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedWifi,
                      // style: const TextStyle(fontSize: 25),
                      elevation: 16,
                      menuMaxHeight: 400,

                      itemHeight: 70,
                      items: wifiNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.wifi,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(value),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          selectedWifi = value!;
                          print(selectedWifi);
                        });
                      },
                    ),
                    Container(
                        width: 330,
                        child: TextField(
                          controller: wifipwdController,
                          decoration:
                              InputDecoration(hintText: 'Enter Wifi Password'),
                        )),
                        SizedBox(height: 20,),
                      Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 70,
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      print('SSID :${selectedWifi}, PASS :${wifipwdController.text}');
                      setState(() {
                        receivedData='';
                        
                      });
                      await _sendMessage("connect|${selectedWifi}|${wifipwdController.text}");
                    },
                    label: Text("Connect"),
                    icon: const Icon(Icons.connected_tv_sharp),
                  ))
                  ],
                )
              : isWifiScanning
                  ?  Container(
                      height: 10, padding:const EdgeInsets.symmetric(horizontal: 20), child: LinearProgressIndicator(color: Color.fromARGB(255, 255, 191, 0),))
                  : Container(),
                  // Text(receivedData)
        ],
      ),
      floatingActionButton: IconButton(
          icon: Icon(Icons.send),
          onPressed: isConnected
              ? () async {
                  Random rnd = new Random();
                  String st = rnd.nextInt(100).toString();
                  print(st);
                  await _sendMessage(st).then((_) {
                    receivedData = "";
                  });
                }
              : null),
    );
  }

  Future<void> _wifiNames() async {
    await Future.delayed(Duration(seconds: 6)); // Simulating a delay
    setState(() {
      if (receivedData.isNotEmpty) {
        wifiNames = receivedData.split('|');
        isWifiScanning = false;
      } else {
        final snb = SnackBar(content: const Text("Error Scaning WiFi Retry.."));
        ScaffoldMessenger.of(context).showSnackBar(snb);
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
        setState(() {});
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

