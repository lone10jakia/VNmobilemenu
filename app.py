# File: app.py – BẢN HOÀN CHỈNH CUỐI CÙNG, ĐẢM BẢO HIỆN ĐÚNG 100%
import streamlit as st
import json
import random
import os
from datetime import datetime

DB_FILE = "users.json"
RATE_FILE = "rates.json"
ANNO_FILE = "announce.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]
HORSES = ["Ngựa 1","Ngựa 2","Ngựa 3","Ngựa 4"]

# === LOAD + SAVE ===
def load():
    if os.path.exists(DB_FILE):
        with open(DB_FILE,"r",encoding="utf-8") as f:
            data = json.load(f)
            for info in data.values():
                for k in ["wins","losses","used_codes","is_banned"]: 
                    if k not in info: info[k] = 0 if k not in ["used_codes","is_banned"] else [] if k=="used_codes" else False
            return data
    return {}
def save():
    with open(DB_FILE,"w",encoding="utf-8") as f: 
        json.dump(users,f,ensure_ascii=False,indent=2)

def load_rates():
    if os.path.exists(RATE_FILE):
        with open(RATE_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
    return {"baucua":50,"taixiu":50,"caothap":50,"duangua":25,"dabanh":33}
def save_rates():
    with open(RATE_FILE,"w",encoding="utf-8") as f:
        json.dump(game_rates,f,ensure_ascii=False)

users = load()
game_rates = load_rates()

def vip(m, name=""):
    if name == "admin": return "QUẢN TRỊ VIÊN"
    if m >= 10_000_000_000: return "ĐẠI GIA TOÀN QUỐC"
    if m >= 1_000_000_000:  return "TỶ PHÚ KIM CƯƠNG"
    if m >= 100_000_000:    return "TRIỆU PHÚ LỬA"
    if m >= 10_000_000:     return "ĐẠI GIA"
    if m >= 1_000_000:      return "GIÀU CÓ"
    return "NGƯỜI CHƠI"

st.set_page_config(page_title="BOT CÁ CƯỢC VIP", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO – ĐỦ 5 GAME + ADMIN SIÊU MẠNH")

if "user" not in st.session_state:
    st.session_state.user = None

# === MENU CHÍNH ===
menu = st.sidebar.radio("MENU", [
    "Trang chủ","Đăng nhập","Đăng ký","Nhập code","TOP 50",
    "Chơi Game","Chuyển tiền","Admin Panel"
])

# === HIỆN THÔNG BÁO ADMIN ===
if os.path.exists(ANNO_FILE):
    with open(ANNO_FILE,"r",encoding="utf-8") as f:
        ann = json.load(f)
    st.error(f"THÔNG BÁO: {ann['msg']} — {ann['time']}")

# === TRANG CHỦ ===
if menu == "Trang chủ":
    st.header("CHÀO MỪNG ĐẾN BOT CÁ CƯỢC VIP")
    st.write("Đủ 5 game siêu hot – Tiền ảo 100%")
    st.balloons()

# === ĐĂNG NHẬP ===
elif menu == "Đăng nhập":
    st.header("ĐĂNG NHẬP")
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success("Đăng nhập thành công!")
            st.balloons()
            st.rerun()
        else:
            st.error("Sai tên hoặc mật khẩu!")

# === ĐĂNG KÝ ===
elif menu == "Đăng ký":
    st.header("ĐĂNG KÝ")
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu mới", type="password")
    if st.button("Đăng ký"):
        if new and new not in users:
            users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0,"is_banned":False}
            save()
            st.success("Đăng ký thành công! +50k")
            st.balloons()
        else:
            st.error("Tên đã tồn tại!")

# === NHẬP CODE ===
elif menu == "Nhập code":
    st.header("NHẬP CODE")
    code = st.text_input("Code").upper()
    if st.button("Nạp") and st.session_state.user:
        if code in REDEEM_CODES:
            users[st.session_state.user]["money"] += REDEEM_CODES[code]
            save()
            st.success(f"NẠP +{REDEEM_CODES[code]:,} VND!")
            st.balloons()
        else:
            st.error("Code sai hoặc đã dùng!")

# === TOP 50 ===
elif menu == "TOP 50":
    st.header("TOP 50 TỶ PHÚ")
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    for i,(n,d) in enumerate(top,1):
        st.write(f"**{i}. {n}** – {vip(d['money'], n)} – {d['money']:,} VND")

# === CHƠI GAME – 5 GAME HOÀN CHỈNH ===
elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Đăng nhập để chơi!")
    elif users[st.session_state.user].get("is_banned", False):
        st.error("TÀI KHOẢN CỦA BẠN ĐÃ BỊ BAN!")
    else:
        u = st.session_state.user
        st.success(f"Chào {u} | {vip(users[u]['money'], u)} | Dư: {users[u]['money']:,} VND")

        game = st.selectbox("Chọn game", ["BẦU CUA","TÀI XỈU","CAO THẤP","ĐUA NGỰA","ĐÁ BANH"])
        bet = st.number_input("Cược", min_value=1000, step=1000, value=5000)

        # Luôn hiện ô chọn
        if game == "BẦU CUA":
            choice = st.selectbox("Chọn con", ANIMALS)
        elif game == "TÀI XỈU":
            door = st.radio("Chọn cửa", ["TÀI","XỈU","BỘ BA"], horizontal=True)
        elif game == "CAO THẤP":
            guess = st.radio("Đoán", ["CAO hơn","THẤP hơn"], horizontal=True)
        elif game == "ĐUA NGỰA":
            choice = st.selectbox("Chọn ngựa", HORSES)
        elif game == "ĐÁ BANH":
            choice = st.radio("Dự đoán", ["Chủ nhà thắng","Hòa","Khách thắng"], horizontal=True)

        result = st.empty()

        if st.button("CHƠI NGAY!") and bet <= users[u]["money"]:
            with result.container():
                st.header("KẾT QUẢ")

                def win_by_rate(rate): return random.randint(1,100) <= rate

                if game == "BẦU CUA":
                    res = random.choices(ANIMALS,k=3)
                    st.write("KQ:", " | ".join(res))
                    cnt = res.count(choice)
                    if cnt and win_by_rate(game_rates["baucua"]):
                        users[u]["money"] += bet*(cnt-1); users[u]["wins"]+=1
                        st.success(f"TRÚNG {cnt} CON → THẮNG +{bet*cnt:,} VND!")
                    else:
                        users[u]["money"] -= bet; users[u]["losses"]+=1; st.error("THUA!")

                elif game == "TÀI XỈU":
                    d = [random.randint(1,6) for _ in range(3)]
                    total = sum(d)
                    st.write(d, f"→ Tổng: {total}")
                    win = (door=="TÀI" and total>=11) or (door=="XỈU" and total<=10) or (door=="BỘ BA" and d[0]==d[1]==d[2])
                    if win and win_by_rate(game_rates["taixiu"]):
                        reward = bet*24 if door=="BỘ BA" else bet
                        users[u]["money"] += reward; users[u]["wins"]+=1
                        st.success(f"THẮNG +{reward:,} VND!")
                    else:
                        users[u]["money"] -= bet; users[u]["losses"]+=1; st.error("THUA!")

                elif game == "CAO THẤP":
                    card = random.randint(2,14); new = random.randint(2,14)
                    st.write(f"Lá hiện tại: {card} → Lá mới: {new}")
                    correct = (guess=="CAO hơn" and new>card) or (guess=="THẤP hơn" and new<card)
                    if correct and win_by_rate(game_rates["caothap"]):
                        users[u]["money"] += bet; users[u]["wins"]+=1; st.success("THẮNG!")
                    else:
                        users[u]["money"] -= bet; users[u]["losses"]+=1; st.error("THUA!")

                elif game == "ĐUA NGỰA":
                    winner = random.choice(HORSES)
                    st.write(f"Ngựa về nhất: {winner}")
                    if choice == winner and win_by_rate(game_rates["duangua"]):
                        users[u]["money"] += bet*4; users[u]["wins"]+=1; st.success("THẮNG X5!")
                    else:
                        users[u]["money"] -= bet; users[u]["losses"]+=1; st.error("THUA!")

                elif game == "ĐÁ BANH":
                    result_game = random.choice(["Chủ nhà thắng","Hòa","Khách thắng"])
                    st.write(f"Kết quả: {result_game}")
                    if choice == result_game and win_by_rate(game_rates["dabanh"]):
                        users[u]["money"] += bet*2; users[u]["wins"]+=1; st.success("THẮNG X3!")
                    else:
                        users[u]["money"] -= bet; users[u]["losses"]+=1; st.error("THUA!")

                save()

# === ADMIN PANEL ===
elif menu == "Admin Panel":
    if st.session_state.user != "admin":
        st.error("Chỉ admin mới vào được!")
    else:
        st.header("ADMIN PANEL – QUYỀN LỰC TUYỆT ĐỐI")
        tab1, tab2, tab3, tab4, tab5 = st.tabs(["Thông báo","Xóa/Ban","Cộng/Trừ tiền","Vô hạn tiền","Tạo/Xóa code"])
        with tab1:
            msg = st.text_area("Thông báo")
            if st.button("GỬI") and msg:
                with open(ANNO_FILE,"w") as f: json.dump({"msg":msg,"time":str(datetime.now())[:19]},f)
                st.success("ĐÃ GỬI!")
        with tab2:
            target = st.text_input("Tên cần xóa/ban")
            col1, col2 = st.columns(2)
            with col1:
                if st.button("XÓA ACC") and target in users and target != "admin":
                    del users[target]; save(); st.success(f"ĐÃ XÓA {target}")
            with col2:
                if st.button("BAN ACC") and target in users and target != "admin":
                    users[target]["is_banned"] = True; save(); st.success(f"ĐÃ BAN {target}")
        with tab3:
            target = st.text_input("Tên người chơi")
            amount = st.number_input("Số tiền (+ cộng, - trừ)", step=1000)
            if st.button("THỰC HIỆN") and target in users:
                users[target]["money"] += amount; save(); st.success(f"{target} còn {users[target]['money']:,} VND")
        with tab4:
            if st.button("VÔ HẠN TIỀN ADMIN"):
                users["admin"]["money"] = 999999999999999; save(); st.success("ĐÃ BẬT VÔ HẠN TIỀN!")
        with tab5:
            col1, col2 = st.columns(2)
            with col1:
                code = st.text_input("Tên code")
                value = st.number_input("Giá trị", min_value=1000)
                if st.button("TẠO CODE"):
                    REDEEM_CODES[code.upper()] = value; st.success(f"Code {code.upper()} đã tạo!")
            with col2:
                del_code = st.text_input("Code cần xóa")
                if st.button("XÓA CODE") and del_code.upper() in REDEEM_CODES:
                    del REDEEM_CODES[del_code.upper()]; st.success(f"ĐÃ XÓA CODE {del_code.upper()}")

# === SIDEBAR ===
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã login: {u}")
    st.sidebar.markdown(f"**{vip(users[u]['money'], u)}**")
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
