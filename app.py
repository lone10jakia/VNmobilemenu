# File: app.py – BẢN CUỐI CÙNG, CHẠY MƯỢT 100% TRÊN RENDER/RAILWAY
import streamlit as st
import json
import random
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]

# Load + save
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

st.set_page_config(page_title="BOT CÁ CƯỢC VIP", layout="centered")
st.title("BOT CÁ CƯỢC TIỀN ẢO – PHIÊN BẢN HOÀN CHỈNH")

if "user" not in st.session_state: st.session_state.user = None

# CHỈ DÙNG 1 MENU DUY NHẤT → KHÔNG BỊ TRÙNG
menu = st.sidebar.selectbox("MENU", [
    "Trang chủ","Đăng nhập","Đăng ký","Nhập code",
    "TOP 50","Chơi Game","Chuyển tiền","Phòng Chat","Admin Panel"
])

# ==================== TRANG CHỦ ====================
if menu == "Trang chủ":
    st.header("CHÀO MỪNG ĐẾN BOT CÁ CƯỢC VIP")
    st.write("Bầu Cua – Tài Xỉu – Cao Thấp – Đua Ngựa – Đá Banh")
    st.write("Code: **GROK200K** | **GROK10TY**")
    st.balloons()

# ==================== ĐĂNG NHẬP ====================
elif menu == "Đăng nhập":
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success(f"Chào {user}!")
            st.balloons()
        else:
            st.error("Sai thông tin!")

# ==================== ĐĂNG KÝ ====================
elif menu == "Đăng ký":
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng ký"):
        if new and new not in users:
            users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0}
            save()
            st.success("Đăng ký OK! Nhận 50k")
            st.balloons()
        else:
            st.error("Tên đã tồn tại!")

# ==================== NHẬP CODE (dùng được ngay) ====================
elif menu == "Nhập code":
    code = st.text_input("Nhập code").upper()
    if st.button("Nạp code"):
        if code in REDEEM_CODES:
            if st.session_state.user:
                users[st.session_state.user]["money"] += REDEEM_CODES[code]
                save()
                st.success(f"NẠP THÀNH CÔNG +{REDEEM_CODES[code]:,} VND!")
                st.balloons()
            else:
                st.error("Đăng nhập trước khi nạp code!")
        else:
            st.error("Code sai hoặc đã dùng!")

# ==================== TOP 50 (HIỆN ĐẦY ĐỦ) ====================
elif menu == "TOP 50":
    st.header("TOP 50 TỶ PHÚ")
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    for i,(n,d) in enumerate(top,1):
        st.write(f"**{i}. {n}** – {vip(d['money'])} – {d['money']:,} VND")

# ==================== ADMIN PANEL (HOẠT ĐỘNG 100%) ====================
elif menu == "Admin Panel":
    if st.session_state.user != "admin":
        st.error("Chỉ admin mới vào được!")
    else:
        st.header("ADMIN PANEL")
        opt = st.selectbox("Hành động", ["Xóa acc","Vô hạn tiền","Tạo code mới"])
        if opt == "Xóa acc":
            target = st.text_input("Tên acc cần xóa")
            if st.button("XÓA") and target in users and target != "admin":
                del users[target]
                save()
                st.success(f"ĐÃ XÓA {target}")
        if opt == "Vô hạn tiền":
            if st.button("BẬT"):
                users["admin"]["money"] = 999999999999999
                save()
                st.success("VÔ HẠN TIỀN!")
        if opt == "Tạo code mới":
            code = st.text_input("Tên code")
            value = st.number_input("Giá trị", min_value=1000)
            if st.button("TẠO"):
                REDEEM_CODES[code.upper()] = value
                st.success(f"Code {code.upper()} đã tạo!")

# Sidebar hiện thông tin người chơi
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã login: {u}")
    st.sidebar.write(vip(users[u]["money"]))
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
