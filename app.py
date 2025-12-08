# File: app.py – BẢN SỬA MƯỢT, HIỆN LUÔN KHÔNG ẨN, CHỌN ĐƯỢC LUÔN!
import streamlit as st
import json
import random
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]

# Load + fix key
def load():
    if os.path.exists(DB_FILE):
        with open(DB_FILE,"r",encoding="utf-8") as f:
            data = json.load(f)
            for info in data.values():
                for k in ["wins","losses","used_codes"]: 
                    if k not in info: info[k] = 0 if k!="used_codes" else []
            return data
    return {}
def save(): 
    with open(DB_FILE,"w",encoding="utf-8") as f: 
        json.dump(users,f,ensure_ascii=False,indent=2)

users = load()

def vip(m):
    if m >= 10_000_000_000: return "ĐẠI GIA TOÀN QUỐC"
    if m >= 1_000_000_000:  return "TỶ PHÚ KIM CƯƠNG"
    if m >= 100_000_000:    return "TRIỆU PHÚ LỬA"
    if m >= 10_000_000:     return "ĐẠI GIA"
    if m >= 1_000_000:      return "GIÀU CÓ"
    return "NGƯỜI CHƠI"

st.set_page_config(page_title="BOT CÁ CƯỢC TIỀN ẢO", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO – CHƠI NGAY!")

if "user" not in st.session_state: st.session_state.user = None
if "play_triggered" not in st.session_state: st.session_state.play_triggered = False

menu = st.sidebar.selectbox("MENU", [
    "Trang chủ","Đăng nhập","Đăng ký","Nhập code",
    "TOP 50","Chơi Game","Chuyển tiền"
])

# ==================== CÁC TRANG ====================
if menu == "Trang chủ":
    st.header("CHÀO MỪNG!")
    st.write("Chơi Bầu Cua, Tài Xỉu, Cao Thấp. Tiền ảo hoàn toàn!")
    st.write("Code đặc biệt: GROK200K (+200k), GROK10TY (+10 tỷ)!")
    st.balloons()

elif menu == "Đăng nhập":
    st.header("ĐĂNG NHẬP")
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success(f"Chào {user} – {vip(users[user]['money'])}!")
            st.balloons()
            st.experimental_rerun()  # Reload to show sidebar
        else:
            st.error("Sai tên hoặc mật khẩu!")

elif menu == "Đăng ký":
    st.header("ĐĂNG KÝ")
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu mới", type="password")
    if st.button("Đăng ký"):
        if new and new not in users:
            users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0}
            save()
            st.success("Đăng ký thành công! Nhận 50k")
            st.balloons()
        else:
            st.error("Tên đã tồn tại hoặc trống!")

elif menu == "Nhập code":
    st.header("NHẬP CODE")
    user = st.text_input("Tài khoản nhận")
    code = st.text_input("Code").upper()
    if st.button("Nạp code"):
        if user in users and code in REDEEM_CODES and code not in users[user]["used_codes"]:
            users[user]["money"] += REDEEM_CODES[code]
            users[user]["used_codes"].append(code)
            save()
            st.success(f"NẠP +{REDEEM_CODES[code]:,} VND!")
            st.balloons()
        else:
            st.error("Code sai hoặc đã dùng!")

elif menu == "TOP 50":
    st.header("TOP 50 TỶ PHÚ")
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    for i,(n,d) in enumerate(top,1):
        st.write(f"**{i}. {n}** – {vip(d['money'])} – {d['money']:,} VND")

elif menu == "Chuyển tiền":
    if not st.session_state.user:
        st.warning("Đăng nhập để chuyển!")
    else:
        u = st.session_state.user
        st.write(f"Chuyển từ: {u} | Dư: {users[u]['money']:,} VND")
        to = st.text_input("Tên người nhận")
        amount = st.number_input("Số tiền", min_value=1000, step=1000)
        if st.button("CHUYỂN"):
            if to not in users: st.error("Không tìm thấy!")
            elif amount > users[u]["money"]: st.error("Không đủ tiền!")
            else:
                users[u]["money"] -= amount
                users[to]["money"] += amount
                save()
                st.success(f"CHUYỂN {amount:,} VND → {to}!")
                st.balloons()

elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Đăng nhập để chơi!")
    else:
        u = st.session_state.user
        st.success(f"Đang chơi: {u} | {vip(users[u]['money'])} | Dư: {users[u]['money']:,} VND")

        game = st.selectbox("Chọn game", ["BẦU CUA","TÀI XỈU","CAO THẤP"])
        bet = st.number_input("Cược", min_value=1000, step=1000, value=5000)

        # Widgets luôn hiện, không ẩn
        if game == "BẦU CUA":
            choice = st.selectbox("Chọn con", ANIMALS)
        elif game == "TÀI XỈU":
            door = st.radio("Cửa", ["TÀI","XỈU","BỘ BA"], horizontal=True)
        elif game == "CAO THẤP":
            guess = st.radio("Đoán", ["CAO hơn","THẤP hơn"], horizontal=True)
            st.write("Lá bài sẽ hiện sau khi chơi!")

        if st.button("CHƠI NGAY!") and bet <= users[u]["money"]:
            st.session_state.play_triggered = True  # Trigger kết quả

        # Hiện kết quả riêng biệt, không ẩn widget
        if st.session_state.play_triggered:
            st.header("KẾT QUẢ:")
            if game == "BẦU CUA":
                res = random.choices(ANIMALS, k=3)
                st.write("KQ:", " | ".join(res))
                cnt = res.count(choice)
                if cnt: users[u]["money"] += bet*(cnt-1); users[u]["wins"] += 1; st.success(f"THẮNG +{bet*cnt:,} VND!")
                else: users[u]["money"] -= bet; users[u]["losses"] += 1; st.error("THUA!")

            elif game == "TÀI XỈU":
                d = [random.randint(1,6) for _ in range(3)]
                total = sum(d)
                st.write("KQ:", d, f"→ {total}")
                win = (door == "TÀI" and total >= 11) or (door == "XỈU" and total <= 10) or (door == "BỘ BA" and d[0]==d[1]==d[2])
                reward = bet*24 if door=="BỘ BA" and win else bet
                if win: users[u]["money"] += reward; users[u]["wins"] += 1; st.success(f"THẮNG +{reward:,} VND!")
                else: users[u]["money"] -= bet; users[u]["losses"] += 1; st.error("THUA!")

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
            
            save()
            st.session_state.play_triggered = False  # Reset để ấn lại
            st.experimental_rerun()  # Reload số dư

# Sidebar
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã login: {u}")
    st.sidebar.write(vip(users[u]["money"]))
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.experimental_rerun()
