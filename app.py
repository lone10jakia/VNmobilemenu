# File: app.py
import streamlit as st
import json
import random
import time
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]
EMOJI = ["Bầu","Cua","Tôm","Cá","Gà","Nai"]

# Load/Save
def load(): 
    if os.path.exists(DB_FILE):
        with open(DB_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
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

st.set_page_config(page_title="BOT CÁ CƯỢC TIỀN ẢO", layout="centered")
st.title("BOT CÁ CƯỢC TIỀN ẢO - WEB PHIÊN BẢN")

menu = st.sidebar.selectbox("Menu", ["Đăng nhập","Đăng ký","Nhập code","TOP 50"])

if "user" not in st.session_state:
    st.session_state.user = None

if menu == "Đăng nhập":
    user = st.text_input("Tên")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success(f"Chào {user} - {vip(users[user]['money'])}")
        else: st.error("Sai tên hoặc mật khẩu")

elif menu == "Đăng ký":
    new = st.text_input("Tên mới")
    pw = st.text_input("Mật khẩu mới", type="password")
    if st.button("Đăng ký"):
        if new in users: st.error("Tên đã tồn tại")
        else:
            users[new] = {"password":pw,"money":50000,"used_codes":[]}
            save(users)
            st.success("Đăng ký OK! Nhận 50k")

elif menu == "Nhập code":
    user = st.text_input("Tài khoản")
    code = st.text_input("Code").upper()
    if st.button("Nạp"):
        if user in users and code in REDEEM_CODES and code not in users[user]["used_codes"]:
            users[user]["money"] += REDEEM_CODES[code]
            users[user]["used_codes"].append(code)
            save(users)
            st.success(f"NẠP THÀNH CÔNG +{REDEem_CODES[code]:,} VND!")
            st.balloons()
        else: st.error("Code sai hoặc đã dùng")

elif menu == "TOP 50":
    top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
    st.write("### TOP 50 TỶ PHÚ ẢO")
    for i,(n,d) in enumerate(top,1):
        st.write(f"**{i}. {n}** - {vip(d['money'])} - {d['money']:,} VND")

if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã đăng nhập: {u}")
    st.sidebar.write(f"{vip(users[u]['money'])}")
    st.sidebar.write(f"Số dư: {users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()
