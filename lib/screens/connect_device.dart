import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'g6_position_setting.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConnectDeviceScreen extends StatefulWidget {
  const ConnectDeviceScreen({super.key});

  @override
  ConnectDeviceScreenState createState() => ConnectDeviceScreenState();
}

class ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  final PanelController _panelController = PanelController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestBluetoothPermission();
  }

  void _showDevicePanel() {
    _panelController.open();
  }

  Future<void> _requestBluetoothPermission() async {
    PermissionStatus status = await Permission.bluetooth.request();
    if (status.isDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Quyền truy cập Bluetooth'),
            content: const Text(
                'Ứng dụng cần quyền truy cập Bluetooth để kết nối với thiết bị của bạn.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Mở cài đặt'),
                onPressed: () => openAppSettings(),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _connectDevice() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    _panelController.close();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const G6PositionSetting(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _showDevicePanel,
            tooltip: 'Test Device Connection',
          ),
        ],
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0,
        maxHeight: 300,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        panel: _buildPanel(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/bluetooth.json',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Đang tìm kiêm thiết bi·',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/image/GSAFE G6.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GSafe G6',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Đã tìm thấy thiết bị',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _connectDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Kết nối',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
