import 'package:flutter/material.dart';
import 'setup_device.dart'; // Import file setup_device.dart

class AddDeviceScreen extends StatelessWidget {
  const AddDeviceScreen({super.key});

  void _navigateToRegistration(BuildContext context, String deviceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupDeviceScreen(deviceName: deviceName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn thiết bị truyền tin',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade200],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.85,
          children: [
            _buildDeviceCard(context, 'GSAFE G3', 'assets/image/GSAFE G3.png'),
            _buildDeviceCard(context, 'GSAFE G6', 'assets/image/GSAFE G6.png'),
            _buildDeviceCard(context, 'GSAFE G9', 'assets/image/GSAFE G9.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
      BuildContext context, String deviceName, String imagePath) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => _navigateToRegistration(context, deviceName),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.blue.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}