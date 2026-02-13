import 'package:flutter/material.dart';
import 'login_screen.dart'; // ดึงหน้า Login มาใช้

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Condovenient',
      debugShowCheckedModeBanner: false, // ปิดป้าย Debug มุมขวาบน
      theme: ThemeData(
        // กำหนดธีมสีหลัก (สีน้ำเงินเข้ม ดูเป็นนิติบุคคล/ความปลอดภัย)
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // เปิดแอปมาเจอหน้านี้ก่อนเลย
    );
  }
}