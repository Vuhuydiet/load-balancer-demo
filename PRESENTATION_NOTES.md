# Presentation Script - Load Balancer Demo

## 🎯 Timeline (30-40 phút)

- **Phần 1-3: Lý thuyết** (15-17 phút) - Slides
- **Phần 4: Demo** (10-12 phút) - **PHẦN NÀY** ⭐
- **Phần 5: Q&A** (3-5 phút)

## 📝 Setup Trước Demo (15 phút trước)

```bash
# 1. Khởi động services
docker-compose up -d --build

# 2. Test thử
curl http://localhost/

# 3. Mở 2 terminals:
# Terminal 1: Chạy demo commands
# Terminal 2: docker-compose logs -f
```

**Checklist:**
- [ ] Font size terminal đủ lớn
- [ ] Clear terminal history
- [ ] Browser tabs: Slides + Architecture diagram

## 🎬 Demo Script (10-12 phút)

### 1. Round Robin (2 phút)

**SAY:** "Bây giờ demo thực tế. Tôi có 3 backend servers và 1 Nginx load balancer."

```bash
docker-compose ps
./simple-test.sh 9
```

**EXPLAIN:**
- Request 1→Server 1, Request 2→Server 2, Request 3→Server 3, lặp lại...
- Phân phối đều 33.3% mỗi server
- Phù hợp khi servers giống nhau

---

### 2. Least Connections (2 phút)

**SAY:** "Nếu requests có độ phức tạp khác nhau? Least Connections sẽ gửi tới server ít connections nhất."

```bash
./switch-algorithm.sh least-conn
./simple-test.sh 9
```

**EXPLAIN:** Phù hợp cho WebSocket, long-polling, streaming.

---

### 3. IP Hash (2 phút)

**SAY:** "User đăng nhập ở Server 1, request tiếp theo đi Server 2 → Session mất! IP Hash giải quyết: cùng IP = cùng server."

```bash
./switch-algorithm.sh ip-hash
./simple-test.sh 9
```

**EXPLAIN:**
- Tất cả requests từ 1 IP → 1 server
- Session persistence không cần Redis
- **Interactive:** "Nếu gửi thêm 10 requests, sẽ đi server nào?" → Cùng server!

---

### 4. Health Check & Failover (3-4 phút) ⭐ **QUAN TRỌNG NHẤT**

**SAY:** "Phần quan trọng nhất: servers có thể crash bất cứ lúc nào. Xem Nginx xử lý thế nào."

```bash
./demo-health-check.sh
```

**EXPLAIN theo steps:**
1. **Normal:** Traffic phân phối bình thường
2. **Stop Server 2:** (bấm Enter)
   - "Tôi stop Server 2, giả lập crash..."
   - **DRAMATIC PAUSE** 🎭
   - "Không có request nào tới Server 2!"
   - "Nginx tự động bypass, zero downtime!"
3. **Restart:** (bấm Enter)
   - "Restart Server 2..."
   - "Nginx tự động add lại, automatic recovery!"

**KEY POINT:** "High Availability. AWS ELB, Google Load Balancer đều dùng health checks."

---

### 5. Performance (1-2 phút)

```bash
cd Source && node load_test.js
```

**EXPLAIN:**
- Response time: ~10-15ms
- Distribution: Gần như đều
- Throughput tăng ~3 lần với 3 servers

## 💡 Tips

### Nếu lỗi
- Stay calm: "Đây là lỗi thường gặp..."
- Có screenshots backup

### Interactive
- "Request tiếp theo đi server nào?"
- "Nếu tất cả servers down thì sao?"

### Time Management
- **Thiếu time:** Skip Weighted
- **Thừa time:** Explain nginx configs
- **Must show:** Round Robin + Health Check

## 🎤 Key Talking Points

**Round Robin:** "Facebook, Google dùng cho stateless services."

**Least Connections:** "Netflix dùng variant này cho video streaming."

**IP Hash:** "Session persistence. Nhưng nếu server down → users mất session."

**Health Check:** "Must-have cho production. AWS ELB, Google LB đều có."

**Performance:** "3 servers = throughput tăng ~3 lần. Linear scaling!"

## 📊 Expected Results

```
Round Robin (9 req):  33% / 33% / 33%
IP Hash (9 req):      100% / 0% / 0%  (1 server)
Health Check:         50% / 0% / 50%  (server 2 down)
Load Test (20 req):   Avg 10-20ms, ~33% each
```

## 🐛 Common Issues

| Issue | Quick Fix |
|-------|-----------|
| Port 80 in use | Use port 8080 |
| Service won't start | `docker-compose logs` |
| Wrong distribution | `docker-compose exec nginx nginx -s reload` |

---

**Good luck! 🚀**
