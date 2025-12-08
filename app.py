# File: app.py – BẢN CÓ CHUYỂN TIỀN + CHẠY MƯỢT 100%
import streamlit as st
import json
import random
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]

# Load + tự động thêm key
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

st.set_page_config(page_title="BOT CÁ CƯỢC + CHUYỂN TIỀN", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO – CÓ CHUYỂN TIỀN CHO NHAU")

if "user" not in st.session_state: st.session_state.user = None

menu = st.sidebar.selectbox("MENU", [
    "Trang chủ","Đăng nhập","Đăng ký","Nhập code",
    "TOP 50","Chơi Game","Chuyển tiền"
])

# ==================== ĐĂNG NHẬP / ĐĂNG KÝ / CODE ====================
if menu == "Đăng nhập":
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu",type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"]==pw:
            st.session_state.user = user
            st.success(f"Chào đại gia {user}!")
            st.balloons()
        else: st.error("Sai tên hoặc mật khẩu!")

elif menu == "Đăng ký":
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu mới",type="password")
    if st.button("Đăng ký"):
        if new and new not in users:
            users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0}
            save()
            st.success("Đăng ký thành công! Nhận 50k")
            st.balloons()
        else: st.error("Tên đã tồn tại!")

elif menu == "Nhập code":
    user = st.text_input("Tài khoản nhận")
    code = st.text_input("Code (GROK200K / GROK10TY)").upper()
    if st.button("Nạp code"):
        if user in users and code in REDEEM_CODES and code not in users[user]["used_codes"]:
            users[user]["money"] += REDEEM_CODES[code]
            users[user]["used_codes"].append(code)
            save()
            st.success(f"NẠP THÀNH CÔNG +{REDEEM_CODES[code]:,} VND!")
            st.balloons()
        else: st.error("Code sai hoặc đã dùng!")

elif menu == "TOP 50":
    st.header("BẢNG XẾP HẠNG TOP 50")
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    for i,(n,d) in enumerate(top,1):
        medal = "1st" if i==1 else "2nd" if i==2 else "3rd" if i==3 else f"#{i}"
        st.write(f"**{medal} {n}** – {vip(d['money'])} – {d['money']:,} VND")

# ==================== CHUYỂN TIỀN CHO NHAU ====================
elif menu == "Chuyển tiền":
    if not st.session_state.user:
        st.warning("Đăng nhập để chuyển tiền!")
    else:
        u = st.session_state.user
        st.success(f"Đang chuyển tiền từ: {u} | Số dư: {users[u]['money']:,} VND")
        
        to_user = st.text_input("Chuyển cho ai (tên tài khoản)")
        amount = st.number_input("Số tiền chuyển", min_value=1000, step=1000)
        
        if st.button("CHUYỂN TIỀN NGAY"):
            if to_user not in users:
                st.error("Không tìm thấy người nhận!")
            elif to_user == u:
                st.error("Không thể chuyển cho chính mình!")
            elif amount > users[u]["money"]:
                st.error("Không đủ tiền!")
            else:
                users[u]["money"] -= amount
                users[to_user]["money"] += amount
                save()
                st.success(f"CHUYỂN THÀNH CÔNG {amount:,} VND → {to_user}!")
                st.balloons()

# ==================== CHƠI GAME (1 nút duy nhất) ====================
elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Đăng nhập để chơi!")
    else:
        u = st.session_state.user
        st.success(f"Đang chơi: {u} | {vip(users[u]['money'])} | Dư: {users[u]['money']:,} VND")
        
        game = st.selectbox("Chọn game", ["BẦU CUA","TÀI XỈU","CAO THẤP"])
        bet = st.number_input("Tiền cược", min_value=1000, step=1000, value=5000)
        
        if st.button("LẮC / CHƠI NGAY!") and bet <= users[u]["money"]:
            # BẦU CUA
            if game == "BẦU CUA":
                choice = st.selectbox("Chọn con", ANIMALS, key="bc")
                res = random.choices(ANIMALS, k=3)
                st.write("Kết quả:", " | ".join(res))
                cnt = res.count(choice)
                if cnt:
                    win = bet * cnt
                    users[u]["money"] += win - bet
                    users[u]["wins"] += 1
                    st.success(f"TRÚNG {cnt} CON → +{win:,} VND")
                else:
                    users[u]["money"] -= bet
                    users[u]["losses"] += 1
                    st.error(f"THUA -{bet:,} VND")
            # TÀI XỈU
            elif game == "TÀI XỈU":
                door = st.radio("Cửa", ["TÀI","XỈU","BỘ BA"], horizontal=True)
                d = [random.randint(1,6) for _ in range(3)]
                total = sum(d)
                st.write("Kết quả:", d, f"→ {total}")
                win = (door=="TÀI" and total>=11) or (door=="XỈU" and total<=10) or (door=="BỘ BA" and d[0]==d[1]==d[2])
                reward = bet*24 if door=="BỘ BA" and win else bet
                if win:
                    users[u]["money"] += reward
                    users[u]["wins"] += 1
                    st.success(f"THẮNG +{reward:,} VND!")
                else:
                    users[u]["money"] -= bet
                    users[u]["losses"] += 1
                    st.error("THUA!")
            # CAO THẤP
            else:
                card = random.randint(2,14)
                st.write(f"Lá hiện tại: {card}")
                guess = st.radio("Đoán", ["CAO hơn","THẤP hơn"], horizontal=True)
                new = random.randint(2,14)
                st.write(f"Lá mới: {new}")
                if (guess=="CAO hơn" and new>card) or (guess=="THẤP hơn" and new<card):
                    users[u]["money"] += bet
                    users[u]["wins"] += 1
                    st.success("THẮNG!")
                else:
                    users[u]["money"] -= bet
                    users[u]["losses"] += 1
                    st.error("THUA!")
            save()
            st.rerun()

# Sidebar
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã đăng nhập: {u}")
    st.sidebar.write(f"{vip(users[u]['money'])}")
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
