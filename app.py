import streamlit as st
import json
import random
import os
import base64

DB_FILE = "users.json"

# ========================== DATABASE ==========================

def load_users():
    if not os.path.exists(DB_FILE):
        json.dump({}, open(DB_FILE, "w"))
    return json.load(open(DB_FILE, "r"))

def save_users(data):
    json.dump(data, open(DB_FILE, "w"), indent=4)

users = load_users()

# ========================== CSS + ANIMATION ==========================

# Nhân vật cầm cần câu GIF
CHAR_FISHING = "https://i.imgur.com/2fYqA7J.gif"

# Hiệu ứng skill khi kéo cần câu
SKILL_EFFECT = "https://i.imgur.com/mJbZzRk.gif"

# Âm thanh bắt cá
FISH_SOUND = "https://www.myinstants.com/media/sounds/pop-cat-original-meme.mp3"

def play_sound(url):
    audio_html = f"""
    <audio autoplay>
        <source src="{url}">
    </audio>
    """
    st.markdown(audio_html, unsafe_allow_html=True)

# ========================== UI ==========================

st.set_page_config(page_title="Game Câu Cá Vạn Cân", layout="wide")
st.title("🎣 GAME CÂU CÁ VẠN CÂN – 1 FILE HOÀN CHỈNH")

menu = st.sidebar.selectbox("MENU", ["Đăng nhập", "Đăng ký", "Chơi game"])

# ===========================================================
#                   ĐĂNG NHẬP
# ===========================================================
if menu == "Đăng nhập":
    st.header("🔐 Đăng nhập")
    username = st.text_input("Tài khoản")
    password = st.text_input("Mật khẩu", type="password")

    if st.button("Đăng nhập"):
        if username in users and users[username]["password"] == password:
            st.session_state["user"] = username
            st.success(f"Đăng nhập thành công! Chào {username} 🎉")
            st.balloons()
        else:
            st.error("Sai tài khoản hoặc mật khẩu!")

# ===========================================================
#                   ĐĂNG KÝ
# ===========================================================
elif menu == "Đăng ký":
    st.header("📝 Đăng ký tài khoản mới")
    username = st.text_input("Tên tài khoản")
    password = st.text_input("Mật khẩu", type="password")

    if st.button("Tạo tài khoản"):
        if username in users:
            st.warning("Tên tài khoản đã tồn tại!")
        else:
            users[username] = {"password": password, "money": 50000}
            save_users(users)
            st.success("Đăng ký thành công! Bạn nhận 50.000 VNĐ 🎉")

# ===========================================================
#                   GAME CÂU CÁ
# ===========================================================
elif menu == "Chơi game":

    # Chưa đăng nhập
    if "user" not in st.session_state:
        st.warning("⚠ Bạn phải đăng nhập mới chơi được!")
        st.stop()

    user = st.session_state["user"]

    st.header(f"🎣 Chào {user} – Số dư: {users[user]['money']:,} VNĐ")

    st.image(CHAR_FISHING, width=280)  # Nhân vật cầm cần câu

    st.subheader("🐟 Chọn loại cá để câu")
    fish_types = {
        "Cá bé": [5000, 70],
        "Cá vàng": [20000, 40],
        "Cá mập": [100000, 15],
        "Cá thần bí": [500000, 5],
    }

    fish = st.selectbox("Loại cá", list(fish_types.keys()))
    bet = st.number_input("Tiền cược", min_value=1000, value=5000, step=1000)

    if st.button("🎣 QUĂNG CẦN!"):

        if bet > users[user]["money"]:
            st.error("Không đủ tiền!")
            st.stop()

        st.subheader("⚡ Dùng chiêu kéo cần...")
        st.image(SKILL_EFFECT, width=300)

        # Chơi âm thanh
        play_sound(FISH_SOUND)

        price, rate = fish_types[fish]
        success = random.randint(1, 100) <= rate

        if success:
            users[user]["money"] += price
            st.success(f"🎉 BẮT ĐƯỢC {fish}! +{price:,} VNĐ")
        else:
            users[user]["money"] -= bet
            st.error(f"💀 SỤT MẤT {bet:,} VNĐ – Cá tuột mất...")

        save_users(users)

    st.markdown("---")
    if st.button("Đăng xuất"):
        del st.session_state["user"]
        st.rerun()
