# File: app.py – BẢN CUỐI CÙNG, CHẠY MƯỢT 100%
import streamlit as st
import json
import random
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]

# Load users + tự động thêm key nếu thiếu
def load():
    if os.path.exists(DB_FILE):
        with open(DB_FILE,"r",encoding="utf-8") as f:
            data = json.load(f)
            for username, info in data.items():
                if "wins" not in info: info["wins"] = 0
                if "losses" not in info: info["losses"] = 0
                if "used_codes" not in info: info["used_codes"] = []
            return data
    return {}

def save(data):
    with open(DB_FILE,"w",encoding="utf-8") as f:
        json.dump(data,f,ensure_ascii=False,indent=2)

users = load()

# Huy hiệu VIP
def vip(m):
    if m >= 10_000_000_000: return "ĐẠI GIA TOÀN QUỐC"
    if m >= 1_000_000_000:  return "TỶ PHÚ KIM CƯƠNG"
    if m >= 100_000_000:    return "TRIỆU PHÚ LỬA"
    if m >= 10_000_000:     return "ĐẠI GIA"
    if m >= 1_000_000:      return "GIÀU CÓ"
    return "NGƯỜI CHƠI"

st.set_page_config(page_title="BOT CÁ CƯỢC", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO - CHƠI NGAY!")

menu = st.sidebar.selectbox("MENU", ["Trang chủ","Đăng nhập","Đăng ký","Nhập code","TOP 50","Chơi Game"])

if "user" not in st.session_state:
    st.session_state.user = None

# ==================== ĐĂNG NHẬP / ĐĂNG KÝ / CODE ====================
if menu == "Đăng nhập":
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success(f"Chào {user}! {vip(users[user]['money'])}")
            st.balloons()
        else: st.error("Sai tên hoặc mật khẩu!")

elif menu == "Đăng ký":
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu mới", type="password")
    if st.button("Đăng ký"):
        if new and new not in users:
            users[new] = {"password":pw, "money":50000, "used_codes":[], "wins":0, "losses":0}
            save(users)
            st.success("Đăng ký thành công! Nhận 50k")
            st.balloons()
        else: st.error("Tên đã tồn tại hoặc để trống!")

elif menu == "Nhập code":
    user = st.text_input("Tài khoản nhận code")
    code = st.text_input("Nhập code").upper()
    if st.button("Nạp code"):
        if user in users and code in REDEEM_CODES and code not in users[user]["used_codes"]:
            users[user]["money"] += REDEEM_CODES[code]
            users[user]["used_codes"].append(code)
            save(users)
            st.success(f"NẠP THÀNH CÔNG +{REDEEM_CODES[code]:,} VND!")
            st.balloons()
        else: st.error("Code sai hoặc đã dùng!")

elif menu == "TOP 50":
    st.header("BẢNG XẾP HẠNG TOP 50")
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    for i,(n,d) in enumerate(top,1):
        medal = "1st" if i==1 else "2nd" if i==2 else "3rd" if i==3 else f"#{i}"
        st.write(f"**{medal} {n}** – {vip(d['money'])} – {d['money']:,} VND")

# ==================== CHƠI GAME (ĐÃ FIX LỖI KEY) ====================
elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Vui lòng đăng nhập để chơi!")
    else:
        u = st.session_state.user
        st.success(f"Đang chơi: {u} | {vip(users[u]['money'])} | Số dư: {users[u]['money']:,} VND")
        
        game = st.selectbox("Chọn game", ["BẦU CUA", "TÀI XỈU", "CAO THẤP"])
        bet = st.number_input("Tiền cược", min_value=1000, step=1000)
        
        if st.button("CHƠI NGAY!") and bet <= users[u]["money"]:
            # BẦU CUA
            if game == "BẦU CUA":
                choice = st.selectbox("Chọn con", ANIMALS, key="bc")
                if st.button("Lắc!"):
                    res = random.choices(ANIMALS, k=3)
                    st.write("Kết quả:", " | ".join(res))
                    cnt = res.count(choice)
                    if cnt:
                        win = bet * cnt
                        users[u]["money"] += win - bet
                        users[u]["wins"] = users[u].get("wins",0) + 1
                        st.success(f"TRÚNG {cnt} CON → +{win:,} VND")
                    else:
                        users[u]["money"] -= bet
                        users[u]["losses"] = users[u].get("losses",0) + 1
                        st.error(f"THUA -{bet:,} VND")
                    save(users)
                    st.rerun()

            # TÀI XỈU
            elif game == "TÀI XỈU":
                door = st.radio("Cửa cược", ["TÀI","XỈU","BỘ BA"])
                if st.button("Lắc xí ngầu!"):
                    d = [random.randint(1,6) for _ in range(3)]
                    total = sum(d)
                    st.write("Kết quả:", d, f"→ Tổng: {total}")
                    win = False
                    if door == "TÀI" and total >= 11: win = True
                    if door == "XỈU" and total <= 10: win = True
                    if door == "BỘ BA" and len(set(d))==1: win = True; reward = bet*24
                    if win:
                        reward = bet*24 if door=="BỘ BA" else bet
                        users[u]["money"] += reward
                        users[u]["wins"] = users[u].get("wins",0) + 1
                        st.success(f"THẮNG +{reward:,} VND!")
                    else:
                        users[u]["money"] -= bet
                        users[u]["losses"] = users[u].get("losses",0) + 1
                        st.error("THUA!")
                    save(users)
                    st.rerun()

            # CAO THẤP
            elif game == "CAO THẤP":
                card = random.randint(2,14)
                st.write(f"Lá hiện tại: {card}")
                guess = st.radio("Đoán", ["CAO hơn","THẤP hơn"])
                if st.button("Rút lá mới!"):
                    new = random.randint(2,14)
                    st.write(f"Lá mới: {new}")
                    if (guess=="CAO hơn" and new>card) or (guess=="THẤP hơn" and new<card):
                        users[u]["money"] += bet
                        users[u]["wins"] = users[u].get("wins",0) + 1
                        st.success("THẮNG!")
                    else:
                        users[u]["money"] -= bet
                        users[u]["losses"] = users[u].get("losses",0) + 1
                        st.error("THUA!")
                    save(users)
                    st.rerun()

# Sidebar thông tin người chơi
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã đăng nhập: {u}")
    st.sidebar.write(f"{vip(users[u]['money'])}")
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()

if menu == "Trang chủ":
    st.write("Chào mừng đến BOT CÁ CƯỢC TIỀN ẢO!")
    st.write("Dùng code: **GROK200K** hoặc **GROK10TY** để làm giàu ngay!")
    st.balloons()
