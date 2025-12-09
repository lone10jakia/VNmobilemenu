import streamlit as st
import json
import os
import random

DB_FILE = "users.json"

# ==============================
# LOAD + SAVE
# ==============================
def load_db():
    if not os.path.exists(DB_FILE):
        return {}
    with open(DB_FILE, "r") as f:
        return json.load(f)

def save_db(data):
    with open(DB_FILE, "w") as f:
        json.dump(data, f, indent=4)

users = load_db()

# Tự động sửa data lỗi hoặc thiếu
for u in users.values():
    u.setdefault("money", 50000)
    u.setdefault("rod", "Cần tre")
    u.setdefault("fish", [])
    u.setdefault("x", 5)
    u.setdefault("y", 5)

save_db(users)

# ==============================
# STATE
# ==============================
if "user" not in st.session_state:
    st.session_state.user = None

st.title("🎣 Game Câu Cá Vạn Cân — Web Version")
st.write("Mini-game có nhân vật di chuyển + map + khu câu cá.")

# ==============================
# ĐĂNG NHẬP / ĐĂNG KÝ
# ==============================
if st.session_state.user is None:
    tab1, tab2 = st.tabs(["Đăng nhập", "Đăng ký"])

    with tab1:
        user = st.text_input("Tên đăng nhập")
        pw = st.text_input("Mật khẩu", type="password")
        if st.button("Đăng nhập"):
            if user in users and users[user]["password"] == pw:
                st.session_state.user = user
                st.rerun()
            else:
                st.error("Sai tài khoản hoặc mật khẩu")

    with tab2:
        new_user = st.text_input("Tạo tài khoản mới")
        new_pw = st.text_input("Tạo mật khẩu", type="password")
        if st.button("Đăng ký"):
            if new_user in users:
                st.warning("Tên tài khoản đã tồn tại!")
            else:
                users[new_user] = {
                    "password": new_pw,
                    "money": 50000,
                    "rod": "Cần tre",
                    "fish": [],
                    "x": 5,
                    "y": 5,
                }
                save_db(users)
                st.success("Đăng ký thành công! Hãy đăng nhập.")
    st.stop()

# ==============================
# TRẠNG THÁI NGƯỜI CHƠI
# ==============================
u = st.session_state.user
data = users[u]

st.success(f"🧍 Nhân vật: **{u}** | 💰 {data['money']:,} VND | 🎣 {data['rod']}")

if st.button("Đăng xuất"):
    st.session_state.user = None
    st.rerun()

st.divider()

# ==============================
# MAP (12 x 12)
# ==============================
MAP_W = 12
MAP_H = 12

# Các vùng map
# Số chỉ là ký hiệu hiển thị
TILES = {
    "sand": "🟨",
    "shop": "🏪",
    "water": "🟦",
    "fish_spot": "🐟",
}

# Tạo map đơn giản
grid = [["🟨" for _ in range(MAP_W)] for _ in range(MAP_H)]

# Tiệm câu
grid[2][2] = "🏪"

# Vùng biển
for i in range(12):
    grid[10][i] = "🟦"
    grid[11][i] = "🟦"

# Khu câu đặc biệt
grid[9][5] = "🐟"

# -------------------------
# HIỂN THỊ MAP
# -------------------------
px = data["x"]
py = data["y"]

st.subheader("🗺️ Bản đồ")

map_str = ""
for y in range(MAP_H):
    row = ""
    for x in range(MAP_W):
        if x == px and y == py:
            row += "🧍"  # nhân vật
        else:
            row += grid[y][x]
    map_str += row + "\n"

st.markdown(f"<pre style='font-size:24px'>{map_str}</pre>", unsafe_allow_html=True)

# ==============================
# DI CHUYỂN
# ==============================
col1, col2, col3 = st.columns(3)

with col2:
    if st.button("⬆️"):
        if py > 0:
            data["y"] -= 1
            save_db(users)
            st.rerun()

with col1:
    if st.button("⬅️"):
        if px > 0:
            data["x"] -= 1
            save_db(users)
            st.rerun()

with col3:
    if st.button("➡️"):
        if px < MAP_W - 1:
            data["x"] += 1
            save_db(users)
            st.rerun()

with col2:
    if st.button("⬇️"):
        if py < MAP_H - 1:
            data["y"] += 1
            save_db(users)
            st.rerun()

# ==============================
# SHOP — khi đứng tại 🏪
# ==============================
if px == 2 and py == 2:
    st.subheader("🏪 Tiệm câu cá")
    if st.button("Mua cần sắt — 20.000 VND"):
        if data["money"] >= 20000:
            data["money"] -= 20000
            data["rod"] = "Cần sắt"
            save_db(users)
            st.success("Mua thành công!")
            st.rerun()
        else:
            st.error("Không đủ tiền")

# ==============================
# CÂU CÁ — khi đứng tại 🐟 hoặc 🟦
# ==============================
if grid[py][px] in ["🐟", "🟦"]:
    st.subheader("🎣 Khu vực câu cá")

    if st.button("Bắt đầu câu"):
        prob = {
            "Cần tre": 0.5,
            "Cần sắt": 0.75,
        }

        if random.random() < prob.get(data["rod"], 0.4):
            fish_list = ["Cá chép", "Cá trích", "Cá mú", "Cá thu", "Cá mập mini"]
            fish = random.choice(fish_list)
            price = random.randint(3000, 20000)
            data["fish"].append({"name": fish, "value": price})
            save_db(users)
            st.success(f"Bạn câu được **{fish}** trị giá **{price:,} VND**!")
        else:
            st.warning("Trượt mất con cá rồi…")

# ==============================
# TÚI CÁ
# ==============================
st.subheader("🧺 Túi cá đã bắt")

for f in data["fish"]:
    st.write(f"🐟 {f['name']} — {f['value']:,} VND")

if st.button("Bán toàn bộ cá"):
    total = sum(f["value"] for f in data["fish"])
    data["money"] += total
    data["fish"] = []
    save_db(users)
    st.success(f"Đã bán toàn bộ cá được **{total:,} VND**")
    st.rerun()
