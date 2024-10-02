import 'package:flutter/material.dart';
import 'gsafe_g6_demo_screen.dart';

class G6PositionSetting extends StatefulWidget {
  const G6PositionSetting({super.key});

  @override
  State<G6PositionSetting> createState() => _G6PositionSettingState();
}

class _G6PositionSettingState extends State<G6PositionSetting> {
  final _formKey = GlobalKey<FormState>();

  String _building = '';
  String _area = '';
  bool _isLoading = false;

  void _showAddDialog(String title, Function(String) onAdd) {
    String newItem = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm $title'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: InputDecoration(hintText: "Nhập $title mới"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Thêm'),
              onPressed: () {
                onAdd(newItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      // Simulate a 3-second loading process
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GSafeG6DemoScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lựa chọn vị trí lắp đặt thiết bị'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên thiết bị',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.devices),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên thiết bị';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 24),
              Text(
                'Nhà/Công trình',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (_building.isNotEmpty)
                    Chip(
                      label: Text(_building),
                      onDeleted: () {
                        setState(() {
                          _building = '';
                        });
                      },
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () =>
                        _showAddDialog('nhà/công trình', (newBuilding) {
                      setState(() {
                        _building = newBuilding;
                      });
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Khu vực',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (_area.isNotEmpty)
                    Chip(
                      label: Text(_area),
                      onDeleted: () {
                        setState(() {
                          _area = '';
                        });
                      },
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () => _showAddDialog('khu vực', (newArea) {
                      setState(() {
                        _area = newArea;
                      });
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Lưu',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
