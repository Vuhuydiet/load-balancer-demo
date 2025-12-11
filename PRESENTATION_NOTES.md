# Presentation Script - Load Balancer Demo

## 🎯 Timeline (30-40 phút)

- **Phần 1-3: Lý thuyết** (17-20 phút) - Slides
- **Phần 4: Demo** (7-10 phút) - **PHẦN NÀY** ⭐
- **Phần 5: Q&A** (3-5 phút)

## 📝 Setup Trước Demo (15 phút trước)

```bash
# 1. Khởi động services
docker compose up -d --build

# 2. Test thử
curl http://localhost/

# 3. Mở 2 terminals:
# Terminal 1: Chạy demo commands
# Terminal 2: docker compose logs -f
```

**Checklist:**
- [ ] Font size terminal đủ lớn
- [ ] Clear terminal history
- [ ] Browser tabs: Slides + Architecture diagram

## 🎬 Demo Script (7-10 phút)

### 1. Round Robin (1.5 phút)

**SAY:** "Bây giờ demo thực tế. Tôi có 3 backend servers và 1 Nginx load balancer."

```bash
docker compose ps
./simple-test.sh 9
```

**EXPLAIN:**
- Request 1→Server 1, Request 2→Server 2, Request 3→Server 3, lặp lại...
- Phân phối đều 33.3% mỗi server
- Phù hợp khi servers giống nhau

---

### 2. Least Connections (1 phút)

**SAY:** "Least Connections gửi tới server ít connections nhất. Phù hợp cho WebSocket, streaming."

```bash
./switch-algorithm.sh least-conn && ./simple-test.sh 6
```

---

### 3. IP Hash (1 phút)

**SAY:** "IP Hash: cùng IP luôn đi cùng server → Session persistence."

```bash
./switch-algorithm.sh ip-hash && ./simple-test.sh 6
```

**EXPLAIN:** Tất cả requests từ 1 IP → 1 server, không cần Redis.

---

### 4. Health Check & Failover (3 phút) ⭐ **QUAN TRỌNG NHẤT**

**SAY:** "Quan trọng nhất: server crash → Nginx xử lý thế nào?"

```bash
./demo-health-check.sh
```

**EXPLAIN ngắn gọn:**
1. **Normal:** Traffic phân phối đều
2. **Stop Server 2:** (Enter) → "Không request nào tới Server 2! Zero downtime!"
3. **Restart:** (Enter) → "Nginx tự động add lại!"

**KEY POINT:** "High Availability như AWS ELB."

---

### 5. Performance (0.5-1 phút) - **OPTIONAL**

```bash
cd Source && node load_test.js
```

**EXPLAIN:** "Throughput tăng ~3 lần, response time ~10-15ms."

## 💡 Tips

### Nếu lỗi
- Stay calm: "Đây là lỗi thường gặp..."
- Có screenshots backup

### Interactive
- "Request tiếp theo đi server nào?"
- "Nếu tất cả servers down thì sao?"

### Time Management (7-10 phút)
- **7 phút:** Round Robin (1.5) + Health Check (3) + Least Conn (1) + IP Hash (1) + wrap-up (0.5)
- **10 phút:** Thêm Performance test (1)
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
| Service won't start | `docker compose logs` |
| Wrong distribution | `docker compose exec nginx nginx -s reload` |

---

**Good luck! 🚀**
