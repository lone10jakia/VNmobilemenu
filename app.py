import streamlit as st
import json
import random
import os

# ===== FILE DATA =====
DB_FILE = "users.json"

# ===== LOAD/SAVE =====
def load_users():
    if os.path.exists(DB_FILE):
        with open(DB_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

def save_users():
    with open(DB_FILE, "w", encoding="utf-8") as f:
        json.dump(users, f, ensure_ascii=False, indent=2)

users = load_users()

# ===== UI =====
st.set_page_config(page_title="GAME CÂU CÁ VẠN CÂN", layout="wide")
st.title("🎣 GAME CÂU CÁ VẠN CÂN – REALISTIC EDITION")

if "user" not in st.session_state:
    st.session_state.user = None

# ===== MENU =====
menu = st.sidebar.radio("MENU", ["Trang chủ", "Đăng ký", "Đăng nhập", "Câu cá"])

# ===== TRANG CHỦ =====
if menu == "Trang chủ":
    st.header("🎣 GAME CÂU CÁ – PHONG CÁCH THỰC")
    st.write("• Có map bãi biển – hồ – hang tối")
    st.write("• Nhân vật đứng câu + hiệu ứng")
    st.write("• Không cần đặt cược – chỉ câu cá nhận tiền")
    st.write("• Có kho cá + cửa hàng cần câu (sắp thêm)")
    st.image(
        "https://i.imgur.com/UfP3Z5U.jpeg",
        caption="Bãi biển – Map 1",
        use_container_width=True,
    )

# ===== ĐĂNG KÝ =====
elif menu == "Đăng ký":
    st.header("🆕 Đăng ký tài khoản")

    name = st.text_input("Tên tài khoản")
    pw = st.text_input("Mật khẩu", type="password")

    if st.button("Đăng ký"):
        if not name:
            st.error("Tên không được để trống")
        elif name in users:
            st.error("Tên đã tồn tại!")
        else:
            users[name] = {
                "password": pw,
                "money": 50000,
                "rod": "Cần câu Gỗ",
                "fish": []
            }
            save_users()
            st.success("Đăng ký thành công! +50.000 VND")
            st.rerun()

# ===== ĐĂNG NHẬP =====
elif menu == "Đăng nhập":
    st.header("🔐 Đăng nhập")

    name = st.text_input("Tên tài khoản")
    pw = st.text_input("Mật khẩu", type="password")

    if st.button("Đăng nhập"):
        if name in users and users[name]["password"] == pw:
            st.session_state.user = name
            st.success("Đăng nhập thành công!")
            st.rerun()
        else:
            st.error("Sai tên hoặc mật khẩu!")

# ===== GAME CÂU CÁ =====
elif menu == "Câu cá":

    if not st.session_state.user:
        st.warning("Bạn cần đăng nhập để chơi.")
        st.stop()

    u = st.session_state.user
    data = users[u]

    st.success(f"🧍 Nhân vật: **{u}** | 💰 {data.get('money', 0):,} VND | 🎣 {data.get('rod', 'Cần tre')}")
    # === CHỌN MAP ===
    st.subheader("🗺 Chọn khu vực câu cá:")

    maps = {
        "Bờ Biển": "https://i.imgur.com/UfP3Z5U.jpeg",
        "Hồ Thanh Bình": "https://i.imgur.com/9Hqz0Au.jpeg",
        "Hang Tối Quái Vật": "https://i.imgur.com/YzJzv3m.jpeg",
    }

    map_choice = st.selectbox("Khu vực:", list(maps.keys()))

    st.image(maps[map_choice], use_container_width=True)

    # === NÚT QUĂNG CẦN ===
    st.subheader("🎣 Bắt đầu câu cá")

    if st.button("🎣 QUĂNG CẦN!"):

        # Animation (giả lập)
        with st.spinner("Đang quăng cần..."):
            import time
            time.sleep(1.5)

        # ===== TỈ LỆ CÁ =====
        fish_table = {
            "Bờ Biển": [
                ("Cá Mè", 3000),
                ("Cá Trích", 5000),
                ("Cá Thu", 8000),
                ("Cá Vàng", 50_000),
            ],
            "Hồ Thanh Bình": [
                ("Cá Chép", 4000),
                ("Cá Rô", 6000),
                ("Cá Lóc", 9000),
                ("Cá Koi", 70_000),
            ],
            "Hang Tối Quái Vật": [
                ("Cá Đen Sâu", 20_000),
                ("Cá Rồng Đêm", 60_000),
                ("Cá Khổng Lồ", 150_000),
                ("Cá Quỷ Biển", 500_000),
            ]
        }

        fish, money = random.choice(fish_table[map_choice])

        st.subheader("🐟 Kết quả:")
        st.success(f"Bạn bắt được **{fish}** + {money:,} VND")

        # Lưu
        data["money"] += money
        data["fish"].append(fish)
        save_users()

        st.balloons()

    # === KHO CÁ ===
    st.subheader("📦 KHO CÁ ĐÃ BẮT")

    if data["fish"]:
        for f in data["fish"]:
            st.write("🐟", f)
    else:
        st.info("Chưa có con cá nào…")


# ===== SIDEBAR USER =====
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đang đăng nhập: **{u}**")
    st.sidebar.write(f"💰 {users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
