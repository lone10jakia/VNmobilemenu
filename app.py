# File: app.py (BẢN SỬA LỖI)
import streamlit as st
import json
import random
import time
import os

DB_FILE = "users.json"
REDEEM_CODES = {"GROK200K": 200000, "GROK10TY": 10000000000}
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]
EMOJI = ["Bầu","Cua","Tôm","Cá","Gà","Nai"]  # Đơn giản hóa emoji cho web

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
    if m >= 10_000_000_000: return "🌟 ĐẠI GIA TOÀN QUỐC 🌟"
    if m >= 1_000_000_000:  return "💎 TỶ PHÚ KIM CƯƠNG 💎"
    if m >= 100_000_000:    return "🔥 TRIỆU PHÚ LỬA 🔥"
    if m >= 10_000_000:     return "🤑 ĐẠI GIA 🤑"
    if m >= 1_000_000:      return "💰 GIÀU CÓ 💰"
    return "🥈 NGƯỜI CHƠI 🥈"

st.set_page_config(page_title="BOT CÁ CƯỢC TIỀN ẢO", layout="wide")
st.title("🎰 BOT CÁ CƯỢC TIỀN ẢO - WEB VERSION 🔥")

menu = st.sidebar.selectbox("📋 MENU CHÍNH", ["🏠 Trang chủ","👤 Đăng nhập","➕ Đăng ký","🎁 Nhập code","🏆 TOP 50","🎲 Chơi Game"])

if "user" not in st.session_state:
    st.session_state.user = None

if menu == "👤 Đăng nhập":
    st.header("🔐 ĐĂNG NHẬP")
    user = st.text_input("Tên đăng nhập")
    pw = st.text_input("Mật khẩu", type="password")
    if st.button("🚀 Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state.user = user
            st.success(f"✅ Chào mừng {user}! Huy hiệu: {vip(users[user]['money'])}")
            st.balloons()
        else: 
            st.error("❌ Sai tên hoặc mật khẩu!")

elif menu == "➕ Đăng ký":
    st.header("📝 ĐĂNG KÝ TÀI KHOẢN")
    new = st.text_input("Tên đăng nhập mới")
    pw = st.text_input("Mật khẩu mới", type="password")
    if st.button("💾 Đăng ký"):
        if new in users: 
            st.error("❌ Tên đã tồn tại!")
        else:
            users[new] = {"password":pw,"money":50000,"used_codes":[],"wins":0,"losses":0}
            save(users)
            st.success("✅ Đăng ký thành công! Nhận ngay 50.000 VND ảo 🎉")
            st.balloons()

elif menu == "🎁 Nhập code":
    st.header("💰 NHẬP MÃ GIFT CODE")
    user = st.text_input("Tên tài khoản nhận code")
    code = st.text_input("Nhập code (GROK200K / GROK10TY)").upper()
    if st.button("🎟️ Nạp code"):
        if user in users and code in REDEEM_CODES and code not in users[user]["used_codes"]:
            users[user]["money"] += REDEEM_CODES[code]
            users[user]["used_codes"].append(code)
            save(users)
            st.success(f"✅ NẠP THÀNH CÔNG +{REDEEM_CODES[code]:,} VND! 🎊")  # ← ĐÃ SỬA LỖI TYPO Ở ĐÂY
            st.balloons()
            st.info(f"Huy hiệu mới: {vip(users[user]['money'])}")
        else: 
            st.error("❌ Code sai hoặc đã sử dụng!")

elif menu == "🏆 TOP 50":
    st.header("👑 BẢNG XẾP HẠNG TOP 50 TỶ PHÚ ẢO")
    if users:
        top = sorted(users.items(), key=lambda x: x[1]["money"], reverse=True)[:50]
        for i,(n,d) in enumerate(top,1):
            medal = "🥇" if i==1 else "🥈" if i==2 else "🥉" if i==3 else f"#{i}"
            st.write(f"**{medal} {n}** - {vip(d['money'])} - 💰 {d['money']:,} VND | Thắng: {d.get('wins',0)} | Thua: {d.get('losses',0)}")
    else:
        st.info("Chưa có người chơi nào! Hãy đăng ký đi 😄")

elif menu == "🎲 Chơi Game" and st.session_state.user:
    u = st.session_state.user
    st.header(f"🎮 CHƠI GAME - Chào {u} ({vip(users[u]['money'])})")
    st.write(f"💳 Số dư hiện tại: {users[u]['money']:,} VND")
    
    game_type = st.selectbox("Chọn game", ["BẦU CUA CÁ CỌP", "TÀI XỈU", "CAO THẤP"])
    
    if game_type == "BẦU CUA CÁ CỌP":
        st.subheader("🍲 BẦU CUA CÁ CỌP")
        bet = st.number_input("Tiền cược", min_value=1000, value=5000)
        choice = st.selectbox("Chọn con cược", ANIMALS)
        if st.button("🎲 Lắc ngay!"):
            result = [random.choice(ANIMALS) for _ in range(3)]
            st.write(f"Kết quả: {' | '.join(result)}")
            count = result.count(choice)
            if count > 0:
                reward = bet * count
                users[u]["money"] += reward
                users[u]["wins"] += 1
                st.success(f"🎉 THẮNG! Trùng {count} con → +{reward:,} VND")
            else:
                users[u]["money"] -= bet
                users[u]["losses"] += 1
                st.error(f"😢 THUA! -{bet:,} VND")
            save(users)
            st.rerun()
    
    elif game_type == "TÀI XỈU":
        st.subheader("🎲 TÀI XỈU")
        bet = st.number_input("Tiền cược", min_value=1000, value=5000)
        choice = st.selectbox("Chọn cửa", ["TÀI (11-17)", "XỈU (4-10)", "BỘ BA (x24)"])
        if st.button("🎲 Lắc xí ngầu!"):
            dice = [random.randint(1,6) for _ in range(3)]
            total = sum(dice)
            st.write(f"Kết quả: {' '.join(map(str,dice))} → Tổng: {total}")
            win = False
            reward = 0
            if choice == "TÀI (11-17)" and total >= 11: win = True; reward = bet
            elif choice == "XỈU (4-10)" and total <= 10: win = True; reward = bet
            elif choice == "BỘ BA (x24)" and dice[0]==dice[1]==dice[2]: win = True; reward = bet*24
            if win:
                users[u]["money"] += reward
                users[u]["wins"] += 1
                st.success(f"🎉 THẮNG +{reward:,} VND!")
            else:
                users[u]["money"] -= bet
                users[u]["losses"] += 1
                st.error(f"😢 THUA -{bet:,} VND")
            save(users)
            st.rerun()
    
    elif game_type == "CAO THẤP":
        st.subheader("🃏 CAO THẤP")
        bet = st.number_input("Tiền cược", min_value=1000, value=5000)
        current_card = random.randint(2,14)
        st.write(f"Lá hiện tại: {current_card}")
        guess = st.selectbox("Đoán lá tiếp theo", ["Cao hơn", "Thấp hơn"])
        if st.button("🃏 Rút bài!"):
            next_card = random.randint(2,14)
            st.write(f"Lá mới: {next_card}")
            if next_card == current_card:
                st.warning("🤝 HÒA! Hoàn tiền")
            elif (guess == "Cao hơn" and next_card > current_card) or (guess == "Thấp hơn" and next_card < current_card):
                users[u]["money"] += bet
                users[u]["wins"] += 1
                st.success(f"🎉 THẮNG +{bet:,} VND!")
            else:
                users[u]["money"] -= bet
                users[u]["losses"] += 1
                st.error(f"😢 THUA -{bet:,} VND")
            save(users)
            st.rerun()

elif menu == "🎲 Chơi Game" and not st.session_state.user:
    st.warning("⚠️ Vui lòng đăng nhập để chơi game!")

if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"👋 Đã đăng nhập: {u}")
    st.sidebar.info(f"🏅 {vip(users[u]['money'])}")
    st.sidebar.metric("💰 Số dư", f"{users[u]['money']:,} VND")
    st.sidebar.metric("✅ Thắng", users[u].get("wins",0))
    st.sidebar.metric("❌ Thua", users[u].get("losses",0))
    if st.sidebar.button("🚪 Đăng xuất"):
        st.session_state.user = None
        st.rerun()

if menu == "🏠 Trang chủ":
    st.header("🎉 CHÀO MỪNG ĐẾN BOT CÁ CƯỢC TIỀN ẢO!")
    st.write("Chơi các game hot: Bầu Cua, Tài Xỉu, Cao Thấp. Tiền ảo 100%!")
    st.write("**Mã code đặc biệt:** GROK200K (+200k), GROK10TY (+10 tỷ)!")
    st.image("https://via.placeholder.com/600x300/FF6B6B/FFFFFF?text=Choi+Ngay+Di!")  # Ảnh demo
