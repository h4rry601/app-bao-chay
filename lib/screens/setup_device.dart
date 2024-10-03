import 'package:flutter/material.dart';
import 'connect_device.dart';

class SetupDeviceScreen extends StatefulWidget {
  final String deviceName;

  const SetupDeviceScreen({super.key, required this.deviceName});

  @override
  SetupDeviceScreenState createState() => SetupDeviceScreenState();
}

class SetupDeviceScreenState extends State<SetupDeviceScreen> {
  bool _obscureText = true;
  final _wifiNameController = TextEditingController();
  final _wifiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt ${widget.deviceName}',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade800,
              child: _buildInstructionCard(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildWifiForm(),
                  const SizedBox(height: 20),
                  _buildButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lưu ý:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            _buildInstructionItem(Icons.power_settings_new,
                'Bật nguồn thiết bị và xác nhận đèn báo được hiển thị nhấp nháy xanh'),
            _buildInstructionItem(Icons.wifi,
                'Xác nhận tín hiệu Wifi để kết nối thiết bị thuộc loại 2.4 GHz'),
            _buildInstructionItem(
                Icons.lock, 'Đảm bảo nhập đúng mật khẩu Wifi'),
            _buildInstructionItem(Icons.skip_next,
                'Nhấn nút "Bỏ qua" nếu thiết bị sử dụng Ethernet/3G/4G/5G'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade800),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildWifiForm() {
    return Column(
      children: [
        TextField(
          controller: _wifiNameController,
          decoration: InputDecoration(
            labelText: 'Tên Wifi',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.wifi),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _wifiPasswordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Mật khẩu Wifi',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConnectDeviceScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Xác nhận',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConnectDeviceScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue.shade800),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Bỏ qua', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
