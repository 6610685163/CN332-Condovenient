// index.js
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// สร้าง Route แรกเพื่อทดสอบ
app.get('/', (req, res) => {
    res.send('✅ Condovenient Backend is Running!');
});

app.listen(PORT, () => {
    console.log(`🚀 Server is running on port ${PORT}`);
});

// เพิ่ม

const authRoutes = require('./src/routes/authRoutes'); // <--- เพิ่มบรรทัดนี้

app.use(express.json()); // ต้องมีเพื่อให้รับ JSON ได้

// ใช้ Routes
app.use('/api/auth', authRoutes); // <--- เพิ่มบรรทัดนี้

// ... โค้ดเดิม (app.listen) ...