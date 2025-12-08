# File: app.py – BẢN CÓ TẤT CẢ TÍNH NĂNG MỚI, RIÊNG TƯ 100%
import streamlit as st
import json
import random
import os

DB_FILE = "users.json"
CODE_FILE = "codes.json"  # Lưu code toàn server
RATE_FILE = "rates.json"  # Lưu tỷ lệ game

REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]
HORSES = ["Ngựa 1","Ngựa 2","Ngựa 3","Ngựa 4"]
FOOTBALL_RESULTS = ["Thắng nhà","Thắng khách","Hòa"]

# Load users + fix key
def load_users():
    if os.path.exists(DB_FILE):
        with open(DB_FILE,"r",encoding="utf-8") as f:
            data = json.load(f)
            for info in data.values():
                for k in ["wins","losses","used_codes"]: 
                    if k not in info: info[k] = 0 if k!="used_codes" else []
            return data
    return {}

# Load codes toàn server
def load_codes():
    if os.path.exists(CODE_FILE):
        with open(CODE_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
    return {"used_codes": []}

# Load tỷ lệ game
def load_rates():
    if os.path.exists(RATE_FILE):
        with open(RATE_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
    return {"taixiu_win_rate": 50, "caothap_win_rate": 50}  # Tỷ lệ mặc định %

users = load_users()
global_codes = load_codes()
game_rates = load_rates()

def save_users(): 
    with open(DB_FILE,"w",encoding="utf-8") as f: 
        json.dump(users,f,ensure_ascii=False,indent=2)

def save_codes(): 
    with open(CODE_FILE,"w",encoding="utf-8") as f: 
        json.dump(global_codes,f,ensure_ascii=False,indent=2)

def save_rates(): 
    with open(RATE_FILE,"w",encoding="utf-8") as f: 
        json.dump(game_rates,f,ensure_ascii=False,indent=2)

def vip(m):
    if m >= 10_000_000_000: return "ĐẠI GIA TOÀN QUỐC"
    if m >= 1_000_000_000:  return "TỶ PHÚ KIM CƯƠNG"
    if m >= 100_000_000:    return "TRIỆU PHÚ LỬA"
    if m >= 10_000_000:     return "ĐẠI GIA"
    if m >= 1_000_000:      return "GIÀU CÓ"
    return "NGƯỜI CHƠI"

st.set_page_config(page_title="BOT CÁ CƯỢC VIP", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO – CÓ PHÒNG CHAT + ĐUA NGỰA + ĐÁ BANH!")

if "user" not in st.session_state: st.session_state.user = None
if "created_acc" not in st.session_state: st.session_state.created_acc = False  # Hạn chế tạo acc

menu = st.sidebar.selectbox("MENU", [" Trang chủ","Đăng nhập","Đăng ký","Nhập code","TOP 50","Chơi Game","Chuyển tiền","Phòng Chat","Admin (nếu là admin)"])

# ==================== ĐĂNG KÝ (hạn chế nhiều acc) ====================
if menu == "Đăng ký":
    if st.session_state.created_acc:
        st.error("Bạn chỉ được tạo 1 acc mỗi phiên!")
    else:
        new = st.text_input("Tên mới")
        pw = st.text_input("Mật khẩu mới", type="password")
        if st.button("Đăng ký"):
            if new and new not in users:
                users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0}
                save_users()
                st.success("Đăng ký thành công! Nhận 50k")
                st.session_state.created_acc = True  # Hạn chế tạo thêm
                st.balloons()
            else:
                st.error("Tên đã tồn tại!")

# ==================== NHẬP CODE (chỉ 1 người/server) ====================
elif menu == "Nhập code":
    st.header("NHẬP CODE")
    user = st.text_input("Tài khoản nhận")
    code = st.text_input("Code").upper()
    if st.button("Nạp code"):
        if code in REDEEM_CODES and code not in global_codes["used_codes"]:
            if user in users:
                users[user]["money"] += REDEEM_CODES[code]
                global_codes["used_codes"].append(code)
                save_users()
                save_codes()
                st.success(f"NẠP +{REDEEM_CODES[code]:,} VND!")
                st.balloons()
            else:
                st.error("Tài khoản không tồn tại!")
        else:
            st.error("Code sai hoặc đã có người dùng rồi!")

# ==================== PHÒNG CHAT ====================
elif menu == "Phòng Chat":
    st.header("PHÒNG CHAT TOÀN SERVER")
    if not st.session_state.user:
        st.warning("Đăng nhập để chat!")
    else:
        # Lưu chat trong file (realtime đơn giản)
        chat_file = "chat.json"
        if os.path.exists(chat_file):
            with open(chat_file,"r",encoding="utf-8") as f:
                chat = json.load(f)
        else:
            chat = []

        # Hiện chat
        for msg in chat:
            st.chat_message("user").write(msg)

        # Nhập chat
        new_msg = st.chat_input("Gửi tin nhắn...")
        if new_msg:
            chat.append(f"{st.session_state.user}: {new_msg}")
            with open(chat_file,"w",encoding="utf-8") as f:
                json.dump(chat,f,ensure_ascii=False,indent=2)
            st.rerun()

# ==================== GAME ĐUA NGỰA ====================
def game_duangua(u, bet):
    choice = st.selectbox("Chọn ngựa thắng", HORSES)
    if st.button("BẮT ĐẦU CUỘC ĐUA!"):
        winner = random.choice(HORSES)
        st.write(f"Ngựa thắng: {winner}")
        if choice == winner:
            win = bet * 5
            users[u]["money"] += win - bet
            st.success(f"THẮNG +{win:,} VND!")
        else:
            users[u]["money"] -= bet
            st.error("THUA!")

# ==================== GAME ĐÁ BANH ====================
def game_dabanh(u, bet):
    choice = st.radio("Kết quả trận", FOOTBALL_RESULTS)
    if st.button("BẮT ĐẦU TRẬN ĐẤU!"):
        result = random.choice(FOOTBALL_RESULTS)
        st.write(f"Kết quả: {result}")
        if choice == result:
            win = bet * 3
            users[u]["money"] += win - bet
            st.success(f"THẮNG +{win:,} VND!")
        else:
            users[u]["money"] -= bet
            st.error("THUA!")

# ==================== ADMIN MENU ====================
elif menu == "Admin (nếu là admin)":
    if st.session_state.user != "admin":
        st.warning("Chỉ admin vào được!")
    else:
        st.header("MENU ADMIN")
        action = st.selectbox("Chọn hành động", ["Kick/Xóa acc","Vô hạn tiền","Tạo code mới","Chỉnh tỷ lệ game"])

        if action == "Kick/Xóa acc":
            target = st.text_input("Tên acc cần xóa")
            if st.button("XÓA ACC"):
                if target in users:
                    del users[target]
                    save_users()
                    st.success(f"Xóa {target} thành công!")

        elif action == "Vô hạn tiền":
            users["admin"]["money"] = 999999999999
            save_users()
            st.success("Admin giờ có vô hạn tiền!")

        elif action == "Tạo code mới":
            new_code = st.text_input("Tên code mới")
            value = st.number_input("Giá trị VND")
            if st.button("TẠO CODE"):
                REDEEM_CODES[new_code] = value
                st.success(f"Code {new_code} (+{value:,} VND) đã tạo!")

        elif action == "Chỉnh tỷ lệ game":
            game_rates["taixiu_win_rate"] = st.number_input("Tỷ lệ thắng Tài Xỉu (%)", 0, 100, game_rates["taixiu_win_rate"])
            game_rates["caothap_win_rate"] = st.number_input("Tỷ lệ thắng Cao Thấp (%)", 0, 100, game_rates["caothap_win_rate"])
            if st.button("LƯU TỶ LỆ"):
                save_rates()
                st.success("Tỷ lệ đã chỉnh sửa!")

# ==================== CHƠI GAME ====================
elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Đăng nhập để chơi!")
    else:
        u = st.session_state.user
        st.success(f"Đang chơi: {u} | {vip(users[u]['money'])} | Dư: {users[u]['money']:,} VND")

        game = st.selectbox("Chọn game", ["BẦU CUA","TÀI XỈU","CAO THẤP","ĐUA NGỰA","ĐÁ BANH"])
        bet = st.number_input("Cược", min_value=1000, step=1000, value=5000)

        # Widget luôn hiện
        if game in ["BẦU CUA","ĐUA NGỰA","ĐÁ BANH"]:
            choice = st.selectbox("Chọn", ANIMALS if game=="BẦU CUA" else HORSES if game=="ĐUA NGỰA" else FOOTBALL_RESULTS)

        if game == "TÀI XỈU":
            door = st.radio("Cửa", ["TÀI","XỈU","BỘ BA"], horizontal=True)

        if game == "CAO THẤP":
            guess = st.radio("Đoán", ["CAO hơn","THẤP hơn"], horizontal=True)
            st.write("Lá bài sẽ hiện sau khi chơi!")

        if st.button("CHƠI NGAY!") and bet <= users[u]["money"]:
            with st.container():
                st.header("KẾT QUẢ")
                if game == "BẦU CUA":
                    res = random.choices(ANIMALS, k=3)
                    st.write("KQ:", " | ".join(res))
                    cnt = res.count(choice)
                    if cnt: 
                        users[u]["money"] += bet*(cnt-1); 
                        users[u]["wins"] += 1; 
                        st.success(f"THẮNG +{bet*cnt:,} VND!")
                    else: 
                        users[u]["money"] -= bet; 
                        users[u]["losses"] += 1; 
                        st.error("THUA!")

                elif game == "TÀI XỈU":
                    d = [random.randint(1,6) for _ in range(3)]
                    total = sum(d)
                    st.write("KQ:", d, f"→ {total}")
                    win = (door == "TÀI" and total >= 11) or (door == "XỈU" and total <= 10) or (door == "BỘ BA" and d[0]==d[1]==d[2])
                    reward = bet*24 if door=="BỘ BA" and win else bet
                    if win: 
                        users[u]["money"] += reward; 
                        users[u]["wins"] += 1; 
                        st.success(f"THẮNG +{reward:,} VND!")
                    else: 
                        users[u]["money"] -= bet; 
                        users[u]["losses"] += 1; 
                        st.error("THUA!")

                elif game == "CAO THẤP":
                    card = random.randint(2,14)
                    st.write(f"Lá hiện tại: {card}")
                    new = random.randint(2,14)
                    st.write(f"Lá mới: {new}")
                    if (guess == "CAO hơn" and new > card) or (guess == "THẤP hơn" and new < card):
                        users[u]["money"] += bet
                        users[u]["wins"] += 1
                        st.success("THẮNG!")
                    else:
                        users[u]["money"] -= bet
                        users[u]["losses"] += 1
                        st.error("THUA!")

                elif game == "ĐUA NGỰA":
                    winner = random.choice(HORSES)
                    st.write("Ngựa thắng: {winner}")
                    if choice == winner:
                        win = bet * 5
                        users[u]["money"] += win - bet
                        st.success(f"THẮNG +{win:,} VND!")
                    else:
                        users[u]["money"] -= bet
                        st.error("THUA!")

                elif game == "ĐÁ BANH":
                    result = random.choice(FOOTBALL_RESULTS)
                    st.write("Kết quả: {result}")
                    if choice == result:
                        win = bet * 3
                        users[u]["money"] += win - bet
                        st.success(f"THẮNG +{win:,} VND!")
                    else:
                        users[u]["money"] -= bet
                        st.error("THUA!")

                save_users()

# Sidebar
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã login: {u}")
    st.sidebar.write(vip(users[u]["money"]))
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
