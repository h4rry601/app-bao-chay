import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeAccountScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  const ChangeAccountScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  @override
  ChangeAccountScreenState createState() => ChangeAccountScreenState();
}

class ChangeAccountScreenState extends State<ChangeAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  final _formKey = GlobalKey<FormState>();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
    _phoneController = TextEditingController(text: widget.userPhone);
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi thông tin tài khoản'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[400]!, Colors.red[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField(
                              _nameController, 'Tên tài khoản', Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(
                              _emailController, 'Email', Icons.email),
                          const SizedBox(height: 16),
                          _buildTextField(
                              _phoneController, 'Số điện thoại', Icons.phone),
                          const SizedBox(height: 16),
                          _buildPasswordField(_newPasswordController,
                              'Mật khẩu mới', Icons.lock, _showNewPassword, () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          }),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                              _confirmPasswordController,
                              'Xác nhận mật khẩu mới',
                              Icons.lock_outline,
                              _showConfirmPassword, () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      IconData icon, bool showPassword, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.red,
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Mật khẩu mới và xác nhận mật khẩu không khớp')),
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userEmail', _emailController.text);
      await prefs.setString('userPhone', _phoneController.text);
      if (_newPasswordController.text.isNotEmpty) {
        await prefs.setString('userPassword', _newPasswordController.text);
      }

      Navigator.of(context).pop({
        'userName': _nameController.text,
        'userEmail': _emailController.text,
        'userPhone': _phoneController.text,
      });
    }
  }
}
