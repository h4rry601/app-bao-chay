import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;
  String _selectedLanguage = 'Tiếng Việt';
  double _alarmVolume = 0.8;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? false;
      _locationEnabled = prefs.getBool('location') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
      _alarmVolume = prefs.getDouble('alarmVolume') ?? 0.8;
    });

    // Check notification permission
    final notificationStatus = await Permission.notification.status;
    if (notificationStatus.isGranted) {
      setState(() {
        _notificationsEnabled = true;
      });
    }

    // Check location permission
    final locationStatus = await Geolocator.checkPermission();
    if (locationStatus == LocationPermission.always ||
        locationStatus == LocationPermission.whileInUse) {
      setState(() {
        _locationEnabled = true;
      });
    }

    await _saveSettings();
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('location', _locationEnabled);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setDouble('alarmVolume', _alarmVolume);
  }

  Future<void> _handleNotifications(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        _showPermissionDeniedDialog('thông báo');
      }
    } else {
      setState(() {
        _notificationsEnabled = false;
      });
    }
    await _saveSettings();
  }

  Future<void> _handleLocationPermission(bool value) async {
    if (value) {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vui lòng bật dịch vụ vị trí trên thiết bị của bạn'),
        ));
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Quyền truy cập vị trí bị từ chối'),
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedDialog('vị trí');
        return;
      }
      setState(() {
        _locationEnabled = true;
      });
    } else {
      setState(() {
        _locationEnabled = false;
      });
    }

    await _saveSettings();
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Quyền truy cập $permissionType bị từ chối'),
        content: Text(
            'Để sử dụng tính năng này, bạn cần cấp quyền truy cập $permissionType trong cài đặt của thiết bị.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Đóng'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Mở Cài đặt'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: [
            _buildSectionCard('Thông báo', [
              _buildSwitchTile(
                'Bật thông báo',
                _notificationsEnabled,
                (value) => _handleNotifications(value),
              ),
            ]),
            _buildSectionCard('Vị trí', [
              _buildSwitchTile(
                'Cho phép truy cập vị trí',
                _locationEnabled,
                (value) => _handleLocationPermission(value),
              ),
            ]),
            _buildSectionCard('Ngôn ngữ', [_buildLanguageDropdown()]),
            _buildSectionCard('Âm lượng cảnh báo', [_buildVolumeSlider()]),
            _buildSectionCard('Khác', [
              _buildListTile(
                'Về ứng dụng',
                Icons.info,
                () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.red,
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedLanguage,
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedLanguage = newValue;
              _saveSettings();
            });
          }
        },
        items: <String>['Tiếng Việt', 'English']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.volume_mute, color: Colors.grey),
          Expanded(
            child: Slider(
              value: _alarmVolume,
              onChanged: (newValue) {
                setState(() {
                  _alarmVolume = newValue;
                  _saveSettings();
                });
              },
              activeColor: Colors.red,
              inactiveColor: Colors.red.withOpacity(0.3),
            ),
          ),
          const Icon(Icons.volume_up, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
