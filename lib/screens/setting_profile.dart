import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account/login_screen.dart';
import 'change_account.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<ProfileScreen> {
  String userName = "Người dùng";
  String userEmail = "example@email.com";
  String userPhone = "0123456789";
  final String avatarUrl = "assets/image/avatar.png";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? userName;
      userEmail = prefs.getString('userEmail') ?? userEmail;
      userPhone = prefs.getString('userPhone') ?? userPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileImage(),
                const SizedBox(height: 20),
                _buildProfileOptions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _navigateToChangeAccount(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text("Hồ sơ tài khoản"),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.red, Colors.orange],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(avatarUrl),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ảnh hồ sơ",
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionItem(
            icon: Icons.person,
            title: "Tên tài khoản",
            subtitle: userName,
            onTap: () => _navigateToChangeAccount(context),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Icons.email,
            title: "Email",
            subtitle: userEmail,
            onTap: () => _navigateToChangeAccount(context),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Icons.phone,
            title: "Số điện thoại",
            subtitle: userPhone,
            onTap: () => _navigateToChangeAccount(context),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Icons.lock,
            title: "Mật khẩu",
            subtitle: "********",
            onTap: () => _navigateToChangeAccount(context),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Icons.logout,
            title: "Đăng xuất",
            onTap: () => _showLogoutConfirmationDialog(context),
            color: Colors.red,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color color = Colors.black,
    bool showArrow = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 16, color: color)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  void _navigateToChangeAccount(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeAccountScreen(
                userName: userName,
                userEmail: userEmail,
                userPhone: userPhone,
              )),
    );
    if (result != null) {
      setState(() {
        userName = result['userName'];
        userEmail = result['userEmail'];
        userPhone = result['userPhone'];
      });
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất tài khoản?"),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
