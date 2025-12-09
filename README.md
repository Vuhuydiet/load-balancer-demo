# 🚀 Load Balancer Demo - Hướng Dẫn Đơn Giản

> **Bắt đầu nhanh:** Chỉ cần 3 lệnh! 👇

```bash
docker-compose up -d --build    # 1. Khởi động
./simple-test.sh 10            # 2. Test ngay
./demo-health-check.sh         # 3. Demo chính (cho presentation)
```

---

## 📋 Tài Liệu Quan Trọng (Chỉ cần đọc 2 file!)

1. **File này (README.md)** - Setup & demo cơ bản ⭐
2. **PRESENTATION_NOTES.md** - Chi tiết cho presentation

**Bỏ qua các file khác nếu chỉ cần demo nhanh!**

---

## ⚡ Setup Siêu Nhanh

```bash
# Bước 1: Vào thư mục
cd /Users/vuhuydiet/hcmus/awad/seminar/demo-load-balancer

# Bước 2: Khởi động (đợi 30 giây)
docker-compose up -d --build

# Bước 3: Test ngay!
./simple-test.sh 9
```

**Xong! Đã thấy requests phân phối đều chưa?** 🎉

---

## 🎬 Demo Cho Presentation (Chỉ 1 lệnh!)

```bash
./demo-health-check.sh
```

**Đây là demo CHÍNH!** Script này sẽ:
- ✅ Show Round Robin distribution
- 🛑 Stop một server
- ✅ Nginx tự động failover
- 🔄 Restart server
- ✅ Tự động recovery

**Press Enter để next từng bước. Giải thích cho audience trong lúc chạy!**

---

## 🎯 5 Thuật Toán Đã Implement

| Thuật Toán | Khi Nào Dùng | Demo Command |
|------------|--------------|--------------|
| **Round Robin** | Equal servers | Default (đã chạy) |
| **Least Connections** | Long connections | `./switch-algorithm.sh least-conn` |
| **IP Hash** | Session persistence | `./switch-algorithm.sh ip-hash` |
| **Weighted** | Unequal servers | `./switch-algorithm.sh weighted` |
| **Health Check** | High availability | `./demo-health-check.sh` ⭐ |

---

## 🔄 Switch Thuật Toán (Optional)

```bash
# Least Connections
./switch-algorithm.sh least-conn
./simple-test.sh 9

# IP Hash (session persistence)
./switch-algorithm.sh ip-hash
./simple-test.sh 9  # Tất cả đi cùng 1 server!

# Weighted (Server 1: 50%, Server 2: 30%, Server 3: 20%)
./switch-algorithm.sh weighted
./simple-test.sh 20

# Quay lại Round Robin
./switch-algorithm.sh round-robin
```

---

## 📊 Load Test (Optional)

```bash
cd Source
npm install
node load_test.js
```

Kết quả sẽ show:
- Response time trung bình
- Distribution giữa các servers
- Throughput (requests/sec)

---

## ❓ Troubleshooting Nhanh

### Port 80 bị chiếm?
```bash
# Sửa docker-compose.yml, dòng ~46:
ports:
  - "8080:80"

# Restart
docker-compose down && docker-compose up -d
curl http://localhost:8080/
```

### Services không start?
```bash
docker-compose down -v
docker-compose up -d --build
docker-compose logs  # Xem lỗi
```

### Requests không phân phối đều?
```bash
docker-compose exec nginx nginx -s reload
```

---

## 🧹 Cleanup

```bash
docker-compose down
```

---

## 📚 Tài Liệu Khác

- **CHEAT_SHEET.md** - Copy/paste commands nhanh ⭐
- **DEMO_NHANH.md** - Hướng dẫn chi tiết 10 phút
- **PRESENTATION_NOTES.md** - Script cho presentation 30-40 phút

---

## 🎯 Key Takeaways

1. **Load Balancer phân phối traffic** tới nhiều servers
2. **Health Checks = Zero Downtime** khi server fail
3. **Chọn đúng thuật toán:**
   - Round Robin: Servers giống nhau
   - Least Conn: Long connections
   - IP Hash: Cần session
   - Weighted: Servers khác nhau

**Đơn giản vậy thôi! 🚀**

---

Made with ❤️ for AWAD Seminar
