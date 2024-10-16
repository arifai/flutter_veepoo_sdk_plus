import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_veepoo_sdk/flutter_veepoo_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterVeepooSdkPlugin = FlutterVeepooSdk();
  final List<BluetoothDevice> _bluetoothDevices = [];
  bool? _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final PermissionStatus? status =
        await _flutterVeepooSdkPlugin.requestBluetoothPermissions();
    debugPrint('Permission status: $status');
  }

  void _isBluetoothEnabled() async {
    final bool? isEnabled = await _flutterVeepooSdkPlugin.isBluetoothEnabled();
    setState(() {
      _isEnabled = isEnabled;
    });
  }

  void _openBluetooth() async {
    await _flutterVeepooSdkPlugin.openBluetooth();
  }

  void _closeBluetooth() async {
    await _flutterVeepooSdkPlugin.closeBluetooth();
  }

  void _scanDevices() async {
    _flutterVeepooSdkPlugin.scanDevices();
  }

  Future<void> _connectDevice(String address) async {
    try {
      await _flutterVeepooSdkPlugin.connectDevice(address);
    } catch (e) {
      debugPrint('Failed to connect to device: $e');
    }
  }

  void _disconnectDevice() async {
    try {
      await _flutterVeepooSdkPlugin.disconnectDevice();
    } catch (e) {
      debugPrint('Failed to disconnect from device: $e');
    }
  }

  void _starDetectHeart() async {
    try {
      await _flutterVeepooSdkPlugin.startDetectHeartAfterBinding('0000', true);
    } catch (e) {
      debugPrint('Failed to start detect heart: $e');
    }
  }

  void _stopDetectHeart() async {
    try {
      await _flutterVeepooSdkPlugin.stopDetectHeart();
    } catch (e) {
      debugPrint('Failed to stop detect heart: $e');
    }
  }

  void _settingHeartWarning() async {
    await _flutterVeepooSdkPlugin.settingHeartRate(70, 60, true);
  }

  void _readHeartWarning() async {
    await _flutterVeepooSdkPlugin.readHeartRate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder(
                stream: _flutterVeepooSdkPlugin.heartRateResult,
                builder: (context, snapshot) {
                  debugPrint('Heart rate snapshot: ${snapshot.data}');
                  if (snapshot.hasData) {
                    return Text(
                      'Heart Rate: ${snapshot.data?.data ?? 0}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const Text(
                      'Heart rate no data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
              Text(
                'Is Bluetooth enabled: $_isEnabled',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isBluetoothEnabled,
                child: const Text('Is Bluetooth Enabled'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openBluetooth,
                child: const Text('Open Bluetooth'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _closeBluetooth,
                child: const Text('Close Bluetooth'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _scanDevices,
                child: const Text('Scan Bluetooth Devices'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _disconnectDevice,
                child: const Text('Disconnect Device'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _starDetectHeart,
                child: const Text('Start Detect Heart'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _stopDetectHeart,
                child: const Text('Stop Detect Heart'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _settingHeartWarning,
                child: const Text('Setting Heart Warning'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _readHeartWarning,
                child: const Text('Read Heart Warning'),
              ),
              const Text(
                'Bluetooth Devices:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                  stream: _flutterVeepooSdkPlugin.scanBluetoothResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _bluetoothDevices.clear();
                      _bluetoothDevices.addAll(snapshot.data ?? []);

                      return Expanded(
                        child: ListView.builder(
                          itemCount: _bluetoothDevices.length,
                          itemBuilder: (context, index) {
                            final item = _bluetoothDevices[index];

                            return ListTile(
                              title: Text(item.name ?? 'Unknown'),
                              subtitle: Text(item.address ?? 'Unknown'),
                              trailing: Text('${item.rssi ?? 0} dBm'),
                              onTap: () async {
                                await _connectDevice(item.address ?? '');

                                debugPrint(
                                    'Connected device address: ${await _flutterVeepooSdkPlugin.getAddress()}');
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text('No data');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
