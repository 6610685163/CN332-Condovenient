import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // URL สำหรับ Android Emulator ใช้ 10.0.2.2
  // ถ้าใช้เครื่องจริงต้องเปลี่ยนเป็น IP ของคอมพิวเตอร์ (เช่น 192.168.1.x:3000)
  final String backendUrl = 'http://10.0.2.2:3000';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ตัวควบคุมข้อความ
  final _roomController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _roomController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ฟังก์ชัน Login ปกติ (เชื่อมต่อ Backend)
  void _handleLogin() async {
    // 1. ตรวจสอบว่ากรอกข้อมูลครบไหม
    if (_roomController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกเลขห้องและรหัสผ่าน')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. ยิง API ไปที่ Backend
      final response = await http.post(
        Uri.parse('${widget.backendUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _roomController.text,
          'password': _passwordController.text,
        }),
      );

      // 3. แปลงข้อมูลที่ได้กลับมา
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        // Login สำเร็จ
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ยินดีต้อนรับคุณ ${data['user']['name']}')),
          );
        }
      } else {
        // Login ไม่ผ่าน (รหัสผิด หรือไม่พบผู้ใช้)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ')),
          );
        }
      }
    } catch (e) {
      // กรณีต่อ Server ไม่ได้
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ฟังก์ชัน Login ด้วย Google (เชื่อมต่อ Firebase + Backend)
  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. เริ่มกระบวนการ Google Sign In (เด้งหน้าต่าง Google)
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // กรณีผู้ใช้กดยกเลิก
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 2. ขอ Authentication Credential จาก Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Sign in เข้าสู่ Firebase ของแอพเรา
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // 4. ดึง ID Token เพื่อส่งไปยืนยันกับ Backend ของเรา
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken != null) {
        // 5. ส่ง Token ไปให้ Backend (Node.js) ตรวจสอบและจัดการ User
        final response = await http.post(
          Uri.parse(
            '${widget.backendUrl}/api/auth/google-login',
          ), // URL ต้องตรงกับ Backend
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': idToken}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['success']) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Google Login สำเร็จ: ${data['user']['name']}'),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ระบบปฏิเสธการเข้าใช้งาน: ${data['message']}'),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google Login Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. โลโก้
              const Icon(
                Icons.apartment_rounded,
                size: 100,
                color: Colors.lightBlue,
              ),
              const SizedBox(height: 20),

              // 2. ชื่อแอป
              const Text(
                'Condovenient',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'ระบบจัดการคอนโดมิเนียม',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // 3. การ์ด Login
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _roomController,
                        decoration: const InputDecoration(
                          labelText: 'เลขห้อง / เบอร์โทร',
                          prefixIcon: Icon(Icons.meeting_room),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'รหัสผ่าน',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ปุ่ม Login ปกติ
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- ส่วนที่เพิ่มเข้ามา: เส้นคั่น ---
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'หรือ',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- ส่วนที่เพิ่มเข้ามา: ปุ่ม Google ---
                      SizedBox(
                        width: double.infinity,
                        height:
                            20, // สูงเท่าเดิมตามโค้ดคุณ (แต่ปกติน่าจะ 40-50 นะครับ)
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _handleGoogleLogin,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // โหลดรูป Logo Google สีรุ้งจากเน็ต
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/240px-Google_%22G%22_logo.svg.png',
                                height: 24,
                                width: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  // กันเหนียว: ถ้ารูปไม่ขึ้นให้โชว์ไอคอนปกติแทน
                                  return const Icon(
                                    Icons.g_mobiledata,
                                    size: 30,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'เข้าสู่ระบบด้วย Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text('ลืมรหัสผ่าน? / ติดต่อนิติบุคคล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
