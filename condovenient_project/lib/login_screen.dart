import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Resident'; // ตัวเลือกเริ่มต้น [cite: 34]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CondoVenient',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ), // [cite: 7]
            Text('Smart Condo Management'), // [cite: 8]
            SizedBox(height: 40),
            // ส่วนเลือก Login as [cite: 26]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roleButton('Resident'), // [cite: 34]
                _roleButton('Security'), // [cite: 35]
                _roleButton('Technician'), // [cite: 36]
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email or Phone',
                prefixIcon: Icon(Icons.email),
              ),
            ), // [cite: 37]
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ), // [cite: 42]
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
                child: Text('Sign In'), // [cite: 44]
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(String role) {
    return ChoiceChip(
      label: Text(role),
      selected: selectedRole == role,
      onSelected: (bool selected) {
        setState(() {
          selectedRole = role;
        });
      },
    );
  }
}
