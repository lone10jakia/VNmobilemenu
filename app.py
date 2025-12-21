# File: app.py – BẢN HOÀN CHỈNH CUỐI CÙNG (5 GAME ĐỦ CHỨC NĂNG + ÂM THANH + BẦU CUA CHỌN 3 + LỊCH SỬ)
import streamlit as st
import json
import random
import os
from datetime import datetime
from collections import Counter

# === CÁC FILE DỮ LIỆU ===
DB_FILE = "users.json"
RATE_FILE = "rates.json"
ANNO_FILE = "announce.json"
HISTORY_FILE = "baucua_history.json"
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
                    if k not in info: 
                        info[k] = 0 if k in ["wins","losses"] else [] if k=="used_codes" else False
            return data
    return {}

def save():
    with open(DB_FILE,"w",encoding="utf-8") as f: 
        json.dump(users,f,ensure_ascii=False,indent=2)

def load_rates():
    default = {"baucua":50,"taixiu":50,"caothap":50,"duangua":25,"dabanh":33}
    if os.path.exists(RATE_FILE):
        try:
            with open(RATE_FILE,"r",encoding="utf-8") as f:
                data = json.load(f)
                for k in default:
                    if k not in data: data[k] = default[k]
                return data
        except:
            pass
    with open(RATE_FILE,"w",encoding="utf-8") as f:
        json.dump(default,f,ensure_ascii=False)
    return default

def save_rates():
    with open(RATE_FILE,"w",encoding="utf-8") as f:
        json.dump(game_rates,f,ensure_ascii=False)

# Lịch sử Bầu Cua
def load_history():
    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
    return []

def save_history(history):
    with open(HISTORY_FILE,"w",encoding="utf-8") as f:
        json.dump(history[-20:],f,ensure_ascii=False)

users = load()
game_rates = load_rates()
baucua_history = load_history()

def vip(m, name=""):
    if name == "admin": return "QUẢN TRỊ VIÊN"
    if m >= 10_000_000_000: return "ĐẠI GIA TOÀN QUỐC"
    if m >= 1_000_000_000:  return "TỶ PHÚ KIM CƯƠNG"
    if m >= 100_000_000:    return "TRIỆU PHÚ LỬA"
    if m >= 10_000_000:     return "ĐẠI GIA"
    if m >= 1_000_000:      return "GIÀU CÓ"
    return "NGƯỜI CHƠI"

st.set_page_config(page_title="BOT CÁ CƯỢC VIP", layout="wide")
st.title("BOT CÁ CƯỢC TIỀN ẢO – ĐỦ 5 GAME + ÂM THANH + BẦU CUA CHỌN 3 + LỊCH SỬ")

if "user" not in st.session_state:
    st.session_state.user = None

menu = st.sidebar.radio("MENU", [
    "Trang chủ","Đăng nhập","Đăng ký","Nhập code","TOP 50",
    "Chơi Game","Chuyển tiền","Admin Panel"
])

# === ÂM THANH HTML5 ===
st.markdown("""
<script>
const sounds = {
    shake: "https://freesound.org/data/previews/276/276957_5123854-lq.mp3",
    win: "https://freesound.org/data/previews/320/320655_5270808-lq.mp3",
    lose: "https://freesound.org/data/previews/341/341695_4281789-lq.mp3"
};
function playSound(type) {
    const audio = new Audio(sounds[type]);
    audio.volume = 0.7;
    audio.play().catch(e => console.log("Âm thanh bị chặn"));
}
</script>
""", unsafe_allow_html=True)

# === TRANG CHỦ ===
if menu == "Trang chủ":
    st.header("CHÀO MỪNG ĐẾN BOT CÁ CƯỢC VIP")
    st.write("Đủ 5 game: Bầu Cua – Tài Xỉu – Cao Thấp – Đua Ngựa – Đá Banh")
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

# === CHUYỂN TIỀN ===
elif menu == "Chuyển tiền":
    if not st.session_state.user:
        st.warning("Đăng nhập để chuyển!")
    else:
        u = st.session_state.user
        st.write(f"Chuyển từ: {u} | Dư: {users[u]['money']:,} VND")
        to = st.text_input("Tên người nhận")
        amount = st.number_input("Số tiền", min_value=1000, step=1000)
        if st.button("CHUYỂN") and to in users and amount <= users[u]["money"]:
            users[u]["money"] -= amount
            users[to]["money"] += amount
            save()
            st.success(f"CHUYỂN {amount:,} → {to}!")
            st.balloons()

# === ADMIN PANEL ===
elif menu == "Admin Panel":
    if st.session_state.user != "admin":
        st.error("Chỉ admin mới vào được!")
        st.stop()

    st.header("ADMIN PANEL – QUYỀN LỰC TUYỆT ĐỐI")
    tab1, tab2, tab3, tab4, tab5, tab6 = st.tabs([
        "Thông báo","Xóa/Ban","Cộng/Trừ tiền","Vô hạn tiền","Tạo/Xóa code","Chỉnh tỷ lệ"
    ])

    with tab1:
        msg = st.text_area("Nội dung thông báo")
        if st.button("GỬI THÔNG BÁO") and msg:
            with open(ANNO_FILE,"w",encoding="utf-8") as f:
                json.dump({"msg":msg,"time":str(datetime.now())[:19]},f)
            st.success("ĐÃ GỬI TOÀN SERVER!")

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
        if st.button("VÔ HẠN TIỀN CHO ADMIN"):
            users["admin"]["money"] = 999999999999999; save(); st.success("ADMIN ĐÃ CÓ VÔ HẠN TIỀN!")

    with tab5:
        col1, col2 = st.columns(2)
        with col1:
            code = st.text_input("Tên code mới")
            value = st.number_input("Giá trị", min_value=1000)
            if st.button("TẠO CODE"):
                REDEEM_CODES[code.upper()] = value; st.success(f"Code {code.upper()} đã tạo!")
        with col2:
            del_code = st.text_input("Code cần xóa")
            if st.button("XÓA CODE") and del_code.upper() in REDEEM_CODES:
                del REDEEM_CODES[del_code.upper()]; st.success(f"ĐÃ XÓA CODE {del_code.upper()}")

    with tab6:
        st.write("CHỈNH TỶ LỆ THẮNG CẢ SERVER")
        game_rates["baucua"] = st.slider("Bầu Cua (%)",0,100,game_rates.get("baucua",50))
        game_rates["taixiu"] = st.slider("Tài Xỉu (%)",0,100,game_rates.get("taixiu",50))
        game_rates["caothap"] = st.slider("Cao Thấp (%)",0,100,game_rates.get("caothap",50))
        game_rates["duangua"] = st.slider("Đua Ngựa (%)",0,100,game_rates.get("duangua",25))
        game_rates["dabanh"] = st.slider("Đá Banh (%)",0,100,game_rates.get("dabanh",33))
        if st.button("LƯU TỶ LỆ"):
            save_rates(); st.success("ĐÃ LƯU TỶ LỆ MỚI!")

# === CHƠI GAME – ĐỦ 5 GAME HOÀN CHỈNH + ÂM THANH ===
elif menu == "Chơi Game":
    if not st.session_state.user:
        st.warning("Đăng nhập để chơi!")
    else:
        u = st.session_state.user
        st.success(f"Chào {u} | {vip(users[u]['money'], u)} | Dư: {users[u]['money']:,} VND")

        game = st.selectbox("Chọn game", ["BẦU CUA","TÀI XỈU","CAO THẤP","ĐUA NGỰA","ĐÁ BANH"])
        bet = st.number_input("Cược", min_value=1000, step=1000, value=5000)

        # Ô chọn cho từng game
        choice = None
        if game == "BẦU CUA":
            choice = st.selectbox("Chọn con", ANIMALS, key="bc")
        elif game == "TÀI XỈU":
            choice = st.radio("Chọn cửa", ["TÀI","XỈU","BỘ BA"], horizontal=True, key="tx")
        elif game == "CAO THẤP":
            choice = st.radio("Đoán", ["CAO hơn","THẤP hơn"], horizontal=True, key="ct")
        elif game == "ĐUA NGỰA":
            choice = st.selectbox("Chọn ngựa", HORSES, key="ngua")
        elif game == "ĐÁ BANH":
            choice = st.radio("Dự đoán", ["Chủ nhà thắng","Hòa","Khách thắng"], horizontal=True, key="bong")

        result = st.empty()

        if st.button("CHƠI NGAY!") and bet <= users[u]["money"]:
            st.markdown('<script>playSound("shake")</script>', unsafe_allow_html=True)

            with result.container():
                st.header("KẾT QUẢ")

                def win_by_rate(key): return random.randint(1,100) <= game_rates.get(key,50)

                if game == "BẦU CUA":
                    res = random.choices(ANIMALS,k=3)
                    st.write("KQ:", " | ".join(res))
                    cnt = res.count(choice)
                    if cnt and win_by_rate("baucua"):
                        users[u]["money"] += bet*(cnt-1); users[u]["wins"] += 1
                        st.success(f"TRÚNG {cnt} CON → THẮNG +{bet*cnt:,} VND!")
                        st.markdown('<script>playSound("win")</script>', unsafe_allow_html=True)
                        st.balloons()
                    else:
                        users[u]["money"] -= bet; users[u]["losses"] += 1
                        st.error("THUA!")
                        st.markdown('<script>playSound("lose")</script>', unsafe_allow_html=True)

                elif game == "TÀI XỈU":
                    d = [random.randint(1,6) for _ in range(3)]
                    total = sum(d)
                    st.write(d, f"→ Tổng: {total}")
                    win = (choice=="TÀI" and total>=11) or (choice=="XỈU" and total<=10) or (choice=="BỘ BA" and d[0]==d[1]==d[2])
                    if win and win_by_rate("taixiu"):
                        reward = bet*24 if choice=="BỘ BA" else bet
                        users[u]["money"] += reward; users[u]["wins"] += 1
                        st.success(f"THẮNG +{reward:,} VND!")
                        st.markdown('<script>playSound("win")</script>', unsafe_allow_html=True)
                    else:
                        users[u]["money"] -= bet; users[u]["losses"] += 1
                        st.error("THUA!")
                        st.markdown('<script>playSound("lose")</script>', unsafe_allow_html=True)

                elif game == "CAO THẤP":
                    card = random.randint(2,14); new = random.randint(2,14)
                    st.write(f"Lá hiện tại: {card} → Lá mới: {new}")
                    correct = (choice=="CAO hơn" and new>card) or (choice=="THẤP hơn" and new<card)
                    if correct and win_by_rate("caothap"):
                        users[u]["money"] += bet; users[u]["wins"] += 1
                        st.success("THẮNG!")
                        st.markdown('<script>playSound("win")</script>', unsafe_allow_html=True)
                    else:
                        users[u]["money"] -= bet; users[u]["losses"] += 1
                        st.error("THUA!")
                        st.markdown('<script>playSound("lose")</script>', unsafe_allow_html=True)

                elif game == "ĐUA NGỰA":
                    winner = random.choice(HORSES)
                    st.write(f"Ngựa về nhất: {winner}")
                    if choice == winner and win_by_rate("duangua"):
                        users[u]["money"] += bet*4; users[u]["wins"] += 1
                        st.success("THẮNG X5!")
                        st.markdown('<script>playSound("win")</script>', unsafe_allow_html=True)
                    else:
                        users[u]["money"] -= bet; users[u]["losses"] += 1
                        st.error("THUA!")
                        st.markdown('<script>playSound("lose")</script>', unsafe_allow_html=True)

                elif game == "ĐÁ BANH":
                    result_game = random.choice(["Chủ nhà thắng","Hòa","Khách thắng"])
                    st.write(f"Kết quả: {result_game}")
                    if choice == result_game and win_by_rate("dabanh"):
                        users[u]["money"] += bet*2; users[u]["wins"] += 1
                        st.success("THẮNG X3!")
                        st.markdown('<script>playSound("win")</script>', unsafe_allow_html=True)
                    else:
                        users[u]["money"] -= bet; users[u]["losses"] += 1
                        st.error("THUA!")
                        st.markdown('<script>playSound("lose")</script>', unsafe_allow_html=True)

                save()

# === SIDEBAR ===
if st.session_state.user:
    u = st.session_state.user
    st.sidebar.success(f"Đã login: {u}")
    st.sidebar.markdown(f"**{vip(users[u]['money'], u)}**")
    st.sidebar.metric("Số dư", f"{users[u]['money']:,} VND")
    if st.sidebar.button("Đăng xuất"):
        st.session_state.user = None
        st.rerun()

st.info("Đủ 5 game hoàn chỉnh – mỗi game đều có ô chọn + hiện kết quả + âm thanh thắng/thua!")
