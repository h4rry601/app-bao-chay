import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'add_member.dart';

class RegisteredDeviceScreen extends StatelessWidget {
  const RegisteredDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà / công trình đã đăng ký'),
        backgroundColor: Colors.red[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Xử lý khi nút sửa được nhấn
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLocationCard(context),
            _buildMapCard(),
            _buildManagementOptions(context), // Truyền context vào đây
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8.0),
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phòng KTDT',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('123 đường ABC, quận XYZ'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(21.100471168666267, 105.9909475489402),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(21.100471168666267, 105.9909475489402),
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOptions(BuildContext context) {
    // Thêm tham số context
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Quản lý khu vực'),
            onTap: () {
              // Xử lý khi mục Quản lý khu vực được nhấn
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Thêm thành viên'),
            subtitle: const Text('Tại khu vực đăng ký thiết bị'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddMemberScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
