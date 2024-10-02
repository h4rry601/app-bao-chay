import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'gsafe_g6_demo_screen.dart';
import 'alarm_screen.dart';
import 'add_device.dart';
import 'settings_screen.dart';
import 'setting_profile.dart';
import 'device_location.dart';
export './home_screen.dart';
import 'notification_screen.dart';
import 'registered_device.dart';
import 'incident_test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String userName = "Người dùng";
  String userPhone = "0123456789";

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      const HomeContent(),
      const IncidentListScreen(),
      const ManagementScreen(),
      AccountScreen(
        userName: userName,
        userPhone: userPhone,
        onProfileUpdated: updateUserData,
      ),
    ];
  }

  void updateUserData(String newName, String newPhone) {
    setState(() {
      userName = newName;
      userPhone = newPhone;
      _initializeScreens(); // Reinitialize screens to update AccountScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Tooltip(
          message: 'Test Alarm',
          child: IconButton(
            icon: const Icon(Icons.warning, color: Colors.white),
            onPressed: () => _navigateToAlarmScreen(context),
          ),
        ),
        title: Image.asset(
          'assets/image/GSafe.png',
          height: 80,
          width: 80,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDeviceScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red.shade700, Colors.orange.shade300],
              ),
            ),
          ),
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.red[700],
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                label: 'Điểm cháy',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Cơ sở',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Tài khoản',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  void _navigateToAlarmScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlarmScreen()),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isLoading = false;
  bool _showFloorDevices = false;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadFloorDevices() async {
    setState(() {
      _isLoading = true;
      _showFloorDevices = false;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _showFloorDevices = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegisteredArea(context),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          if (_showFloorDevices) _buildFloorDevices(),
          const SizedBox(height: 24),
          _buildGuideCards(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRegisteredArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khu vực đã đăng ký',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildManagementCard(
                  title: 'Phòng KTDT',
                  address: '123 Đường ABC, Quận XYZ',
                  onTap: _loadFloorDevices,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAddManagementCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeviceLocationScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorDevices() {
    final List<Map<String, String>> devices = [
      {
        'image': 'assets/image/GSAFE G6.png',
        'name': 'GSafe G6',
      },
      {
        'image': 'assets/image/daubaokhoi.png',
        'name': 'Đầu báo khói 1',
      },
      {
        'image': 'assets/image/daubaokhoi.png',
        'name': 'Đầu báo khói 2',
      },
      {
        'image': 'assets/image/daubaokhoi.png',
        'name': 'Đầu báo khói 3',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Tầng 3',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                child: _buildDeviceCard(
                  imagePath: devices[index]['image']!,
                  deviceName: devices[index]['name']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceCard(
      {required String imagePath, required String deviceName}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deviceName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const GSafeG6DemoScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 32),
              ),
              child: const Text('Xem chi tiết'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildFeatureCard(
              icon: Icons.book,
              title: 'Hướng dẫn sử dụng thiết bị',
              onTap: () {
                _launchURL('https://gsafe.vn/thiet-bi.htm');
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFeatureCard(
              icon: Icons.video_library,
              title: 'Hướng dẫn phòng chống cháy nổ',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required String address,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                address,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward, color: Colors.red[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddManagementCard({required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 48, color: Colors.red[700]),
              const SizedBox(height: 8),
              Text(
                'Thêm khu vực quản lý',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Colors.red[700]),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  IncidentListScreenState createState() => IncidentListScreenState();
}

class IncidentListScreenState extends State<IncidentListScreen> {
  List<Map<String, dynamic>> incidents = [
    {
      'title': 'Test A',
      'location': '123 Đường ABC, Quận XYZ',
      'time': '08:30 AM',
      'status': 'pending',
      'isSafe': false,
    },
    {
      'title': 'Test B',
      'location': '456 Đường DEF, Quận GHI',
      'time': '02:15 PM',
      'status': 'resolved',
      'isSafe': true,
    },
    {
      'title': 'Test C',
      'location': '789 Đường JKL, Quận MNO',
      'time': '11:45 AM',
      'status': 'pending',
      'isSafe': false,
    },
  ];

  Future<void> _markAsSafe(int index) async {
    setState(() {
      incidents[index]['status'] = 'loading';
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      incidents[index]['status'] = 'resolved';
      incidents[index]['isSafe'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: incidents.length,
      itemBuilder: (context, index) {
        final incident = incidents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident['title'] as String? ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(incident['location'] as String? ?? ''),
                      const SizedBox(height: 4),
                      Text(incident['time'] as String? ?? ''),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getStatusText(incident),
                            style: TextStyle(
                              color: _getStatusColor(incident),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (incident['status'] == 'pending')
                            ElevatedButton(
                              onPressed: () => _markAsSafe(index),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Đã xử lý cháy',
                                  style: TextStyle(color: Colors.white)),
                            )
                          else if (incident['status'] == 'loading')
                            const CircularProgressIndicator()
                          else if (incident['isSafe'] == true)
                            const Text(
                              'Đám cháy đã xử lý ✓',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const IncidentTestScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(Map<String, dynamic> incident) {
    if (incident['status'] == 'pending') return 'Chờ xử lý';
    if (incident['status'] == 'loading') return 'Đang xử lý';
    return 'Đã xử lý';
  }

  Color _getStatusColor(Map<String, dynamic> incident) {
    if (incident['status'] == 'pending') return Colors.red;
    if (incident['status'] == 'loading') return Colors.orange;
    return Colors.green;
  }
}

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  ManagementScreenState createState() => ManagementScreenState();
}

class ManagementScreenState extends State<ManagementScreen> {
  List<Map<String, dynamic>> properties = [
    {'name': 'Phòng KTDT', 'address': '123 Đường ABC, Quận XYZ'},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(property['name']!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red[700])),
                subtitle: Text(property['address']!,
                    style: TextStyle(color: Colors.grey[600])),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.red[700]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisteredDeviceScreen()),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.red[700],
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeviceLocationScreen()),
              );
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  properties.add(result);
                });
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class AccountScreen extends StatelessWidget {
  final String userName;
  final String userPhone;
  final Function(String, String) onProfileUpdated;

  const AccountScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/image/avatar.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          Text(userPhone,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                        if (result is Map<String, dynamic>) {
                          final newName = result['userName'] as String?;
                          final newPhone = result['userPhone'] as String?;
                          if (newName != null && newPhone != null) {
                            onProfileUpdated(newName, newPhone);
                          }
                        }
                      },
                      child: Text('Xem tài khoản',
                          style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Dịch vụ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 12),
            _buildSettingsCard(context, [
              _buildSettingsTile(context, Icons.card_membership, 'Gói dịch vụ',
                  () {
                _launchURL('https://geic.vn/dich-vu-giai-phap/');
              }),
              _buildSettingsTile(context, Icons.devices, 'Sản phẩm', () {
                _launchURL('https://gsafe.vn/thiet-bi.htm');
              }),
            ]),
            const SizedBox(height: 24),
            Text('Các chức năng',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9))),
            const SizedBox(height: 12),
            _buildSettingsCard(context, [
              _buildSettingsTile(context, Icons.settings, 'Cài đặt', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
              }),
              _buildSettingsTile(
                  context, Icons.description, 'Điều khoản sử dụng', () {
                _launchURL('https://gsafe.vn/dieu-khoan-su-dung.htm');
              }),
              _buildSettingsTile(context, Icons.security, 'Chính sách bảo mật',
                  () {
                _launchURL('https://gsafe.vn/chinh-sach-bao-mat.htm');
              }),
              _buildSettingsTile(context, Icons.support, 'Thông tin liên hệ',
                  () {
                _showContactDialog(context);
              }),
            ]),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Phiên bản hiện tại 1.0.0',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.red[700]),
      onTap: onTap,
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin liên hệ',
              style: TextStyle(
                  color: Colors.red[700], fontWeight: FontWeight.bold)),
          content: const Text(
            'Cuộc gọi khẩn cấp: 1900.2114:\nDịch vụ khách hàng: 1900232314\nĐiện thoại: 02471088114\nFax: 02471088114\nEmail: gsafe@gsafe.com.vn\nTrụ sở chính: 52 Lê Đại Hành, Q.Hai Bà Trưng, Hà Nội, Việt Nam',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng',
                  style: TextStyle(
                      color: Colors.red[700], fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }
}
