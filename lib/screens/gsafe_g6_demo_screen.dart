import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GSafeG6DemoScreen extends StatefulWidget {
  const GSafeG6DemoScreen({super.key});

  @override
  State<GSafeG6DemoScreen> createState() => _GSafeG6DemoScreenState();
}

class _GSafeG6DemoScreenState extends State<GSafeG6DemoScreen> {
  bool _deviceFound = false;

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      Lottie.asset(
                        'assets/lottie/search.json',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Đang tìm kiếm thiết bị con',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Debug button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _deviceFound = true;
                          });
                        },
                        child: const Icon(Icons.bug_report),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper half - Blue background (giữ nguyên như cũ)
          Container(
            color: Colors.blue.shade800,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                children: [
                  const Text(
                    'GSafe G6',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/image/GSAFE G6.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vị trí thiết bị:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Phòng KTDT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tầng 3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatusItem(icon: Icons.wifi, text: 'Đã kết nối'),
                      StatusItem(
                          icon: Icons.check_circle, text: 'Hoạt động tốt'),
                      StatusItem(icon: Icons.battery_full, text: 'Pin 85%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Lower half - White background
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thiết bị con',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_deviceFound)
                    const DeviceCard(
                      deviceName: 'Đầu báo khói DS-PDSMK-4',
                      location: 'Phòng KTDT',
                      floor: 'Tầng 3',
                      batteryLevel: 100,
                    )
                  else
                    Expanded(
                      child: Center(
                        child: Text(
                          'Chưa có thiết bị con nào được thêm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: _showSearchBottomSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: const Text(
                        'Thêm thiết bị',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const StatusItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String location;
  final String floor;
  final int batteryLevel;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.location,
    required this.floor,
    required this.batteryLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    deviceName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Vị trí: $location'),
                  Text('Tầng: $floor'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.battery_full, color: Colors.green),
                      const SizedBox(width: 4),
                      Text('Pin: $batteryLevel%'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Image.asset(
              'assets/image/daubaokhoi.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
