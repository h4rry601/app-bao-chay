import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Đảm bảo class này được định nghĩa ở một nơi có thể truy cập từ cả HomeContent và DeviceLocationScreen
class ManagementArea {
  final String title;
  final String address;
  final LatLng? location;

  ManagementArea({
    required this.title,
    required this.address,
    this.location,
  });
}

class DeviceLocationScreen extends StatefulWidget {
  const DeviceLocationScreen({super.key});

  @override
  DeviceLocationScreenState createState() => DeviceLocationScreenState();
}

class DeviceLocationScreenState extends State<DeviceLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _address;
  String? _detailedAddress;
  LatLng _selectedLocation = const LatLng(21.0285, 105.8542);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký vị trí thiết bị',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Tên địa điểm',
                  onSaved: (value) => _name = value,
                  icon: Icons.place,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Địa chỉ',
                  onSaved: (value) => _address = value,
                  icon: Icons.home,
                ),
                const SizedBox(height: 16),
                _buildDetailedAddressField(),
                const SizedBox(height: 16),
                _buildMap(),
                const SizedBox(height: 16),
                Text(
                  'Vị trí đã chọn: ${_selectedLocation.latitude.toStringAsFixed(4)}, ${_selectedLocation.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onSaved,
    required IconData icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildDetailedAddressField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Địa chỉ chi tiết',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập địa chỉ chi tiết';
        }
        return null;
      },
      onSaved: (value) => _detailedAddress = value,
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: _selectedLocation,
            initialZoom: 13.0,
            onTap: (tapPosition, point) {
              setState(() {
                _selectedLocation = point;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation,
                  width: 80.0,
                  height: 80.0,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red[700],
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Tạo một ManagementArea mới với thông tin đã nhập
      final newArea = ManagementArea(
        title: _name!,
        address:
            '$_address\n$_detailedAddress', // Combine address and detailed address
        location: _selectedLocation,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Trả về ManagementArea mới
      Navigator.pop(context, newArea);
    }
  }
}
