import 'package:flutter/material.dart';
import '../utils/app_preferences.dart';
import 'account/login_screen.dart';

class ToSScreen extends StatelessWidget {
  const ToSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade400, Colors.orange.shade300],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Điều khoản sử dụng',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Nội dung thoả thuận:\n\n'
                        '1.1. Bằng việc sử dụng ứng dụng báo cháy này ("Ứng dụng"), bạn đồng ý tuân thủ các điều khoản và điều kiện được quy định trong thỏa thuận này.\n\n'
                        '1.2. Ứng dụng được thiết kế để cung cấp thông tin và cảnh báo về tình huống hỏa hoạn. Chúng tôi nỗ lực đảm bảo tính chính xác của thông tin, nhưng không chịu trách nhiệm cho bất kỳ thiệt hại nào phát sinh từ việc sử dụng Ứng dụng.\n\n'
                        '1.3. Bạn đồng ý sử dụng Ứng dụng một cách có trách nhiệm và không lạm dụng hoặc can thiệp vào hoạt động bình thường của Ứng dụng.\n\n'
                        '1.4. Chúng tôi có quyền cập nhật, thay đổi hoặc chấm dứt Ứng dụng mà không cần thông báo trước.\n\n'
                        'Tài khoản:\n\n'
                        '2.1. Để sử dụng đầy đủ các tính năng của Ứng dụng, bạn có thể cần tạo một tài khoản.\n\n'
                        '2.2. Bạn chịu trách nhiệm duy trì tính bảo mật của tài khoản và mật khẩu của mình. Bạn đồng ý thông báo ngay cho chúng tôi về bất kỳ việc sử dụng trái phép nào đối với tài khoản của bạn.\n\n'
                        '2.3. Chúng tôi có quyền từ chối dịch vụ, chấm dứt tài khoản, xóa hoặc chỉnh sửa nội dung, hoặc hủy đơn đặt hàng theo quyết định riêng của chúng tôi.\n\n'
                        '2.4. Bạn đồng ý cung cấp thông tin chính xác, cập nhật và đầy đủ khi tạo tài khoản và cập nhật thông tin khi cần thiết.\n\n',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await AppPreferences.setTermsAccepted(true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Đồng ý và tiếp tục',
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận'),
                          content: const Text(
                              'Bạn có chắc chắn muốn thoát ứng dụng?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Huỷ'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Đồng ý'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Tôi không đồng ý',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
