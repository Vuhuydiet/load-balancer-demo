# Load Balancer Demo với Nginx

Demo 5 thuật toán load balancing cho seminar AWAD.

## ⚡ Quick Start

```bash
# 1. Khởi động (đợi 30 giây)
docker-compose up -d --build

# 2. Test
./simple-test.sh 9

# 3. Demo chính
./demo-health-check.sh
```

## 🎬 Demo Interactive

```bash
./demo-health-check.sh
```

Script demo tự động:
- Round Robin distribution
- Stop server → Nginx failover
- Restart server → Auto recovery

## 🎯 5 Thuật Toán

```bash
# Least Connections - cho long connections
./switch-algorithm.sh least-conn && ./simple-test.sh 9

# IP Hash - session persistence
./switch-algorithm.sh ip-hash && ./simple-test.sh 9

# Weighted - servers khác cấu hình
./switch-algorithm.sh weighted && ./simple-test.sh 20

# Round Robin (default)
./switch-algorithm.sh round-robin && ./simple-test.sh 9
```

## 📊 Performance Test

```bash
cd Source && npm install && node load_test.js
```

## ❓ Troubleshooting

```bash
# Port 80 bị chiếm - dùng port 8080
# Sửa docker-compose.yml: "8080:80"

# Services lỗi
docker-compose down -v && docker-compose up -d --build
docker-compose logs

# Reload config
docker-compose exec nginx nginx -s reload
```

## 🧹 Cleanup

```bash
docker-compose down
```

## 📚 Chi Tiết

**PRESENTATION_NOTES.md** - Script đầy đủ cho presentation

---

**Made for AWAD Seminar 2025**
