import 'package:flutter/material.dart';
import 'repair_screen.dart';
import 'parcel_screen.dart'; // เพิ่มการ import ไฟล์ parcel
import 'visitor_screen.dart'; // เพิ่มการ import ไฟล์ visitor

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CondoVenient')), //
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนแสดงค่าส่วนกลาง (Outstanding Fee)
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outstanding Common Fee'), //
                      Text(
                        'THB 5,250', //
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ในอนาคตจะเชื่อมไปหน้า Pay Invoice
                    },
                    child: Text('Pay'), //
                  ),
                ],
              ),
            ),
            // เมนูหลัก (Grid Menu)
            GridView.count(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // เพิ่มเพื่อให้ Scroll ลื่นไหล
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              children: [
                _menuCard(
                  context,
                  Icons.build,
                  'Repair',
                  RepairScreen(), //
                ),
                _menuCard(
                  context,
                  Icons.inventory,
                  'Parcel',
                  ParcelScreen(), // แก้จาก null เป็น ParcelScreen()
                ),
                _menuCard(
                  context,
                  Icons.people,
                  'Visitor',
                  VisitorScreen(), // แก้จาก null เป็น VisitorScreen()
                ),
                _menuCard(
                  context,
                  Icons.announcement,
                  'News',
                  null, //
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget? page,
  ) {
    return InkWell(
      onTap: () => page != null
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            )
          : null,
      child: Card(
        elevation: 2, // เพิ่มเงาให้ดูสวยงามเหมือน GUI
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
