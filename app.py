# app.py
# Game Câu Cá Vạn Cân — Realistic style (1-file, Streamlit)
# Chạy: streamlit run app.py
import streamlit as st
import json
import os
import random
from datetime import datetime

# -------------------- Config / Data --------------------
DB_FILE = "users.json"

MAPS = {
    "Bờ Hồ Bình Minh": {
        "bg": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1400&q=80&auto=format&fit=crop",
        "weights": {"Thường": 700, "Hiếm": 250, "Huyền thoại": 45, "Boss": 5},
        "desc": "Hồ êm đềm, cá nhỏ và trung bình xuất hiện nhiều."
    },
    "Biển Xanh Đại Dương": {
        "bg": "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1400&q=80&auto=format&fit=crop",
        "weights": {"Thường": 500, "Hiếm": 320, "Huyền thoại": 150, "Boss": 30},
        "desc": "Mở rộng ra biển lớn — có cơ hội bắt cá to hơn."
    },
    "Hang Sâu Quái Vật": {
        "bg": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1400&q=80&auto=format&fit=crop",
        "weights": {"Thường": 300, "Hiếm": 300, "Huyền thoại": 250, "Boss": 150},
        "desc": "Khu vực nguy hiểm, cá quái vật xuất hiện nhiều hơn (hiếm và boss)."
    }
}

# Danh sách mẫu cá theo rarity (with weight ranges and base value)
FISH_POOL = {
    "Thường": [
        {"name":"Cá Trê","min":1,"max":5,"value":500},
        {"name":"Cá Chép","min":2,"max":8,"value":800},
        {"name":"Cá Hồi Nhỏ","min":3,"max":12,"value":1200},
    ],
    "Hiếm": [
        {"name":"Cá Mặt Trăng","min":50,"max":200,"value":15000},
        {"name":"Cá Kiếm","min":80,"max":300,"value":30000},
    ],
    "Huyền thoại": [
        {"name":"Cá Voi Điện","min":1000,"max":5000,"value":250000},
        {"name":"Rồng Biển","min":2000,"max":8000,"value":500000},
    ],
    "Boss": [
        {"name":"Leviathan (Boss)","min":10000,"max":50000,"value":2000000},
        {"name":"Hắc Long Hải (Boss)","min":25000,"max":100000,"value":5000000},
    ]
}

# Cần câu mặc định & shop
RODS = {
    "Cần Thường": {"price": 0, "bonus": 0},
    "Cần Pro": {"price": 200000, "bonus": 8},
    "Cần Titan": {"price": 1200000, "bonus": 20}
}

# -------------------- Helpers: DB --------------------
def ensure_db():
    if not os.path.exists(DB_FILE):
        with open(DB_FILE, "w", encoding="utf-8") as f:
            json.dump({"admin": {"password":"admin","money":1000000,"rod":"Cần Thường","history":[]}}, f, indent=2, ensure_ascii=False)

def load_users():
    ensure_db()
    with open(DB_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def save_users(data):
    with open(DB_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

# -------------------- Utility --------------------
def pick_rarity(map_name, bait_bonus=0):
    # build a weighted list based on MAPS weights and rod/bait bonus
    w = MAPS[map_name]["weights"].copy()
    # apply small bonus (rod/bait) to rarer tiers by shifting weight slightly
    w["Hiếm"] += int(bait_bonus*0.5)
    w["Huyền thoại"] += int(bait_bonus*0.3)
    w["Boss"] += int(bait_bonus*0.1)
    pool = []
    for k,v in w.items():
        pool += [k] * max(1, v)
    return random.choice(pool)

def pick_fish_by_rarity(rarity):
    pool = FISH_POOL.get(rarity, [])
    if not pool:
        # fallback to common
        return random.choice(FISH_POOL["Thường"]).copy()
    tmpl = random.choice(pool)
    ct = random.randint(tmpl["min"], tmpl["max"])
    result = {"name": tmpl["name"], "weight": ct, "value": tmpl["value"], "rarity": rarity}
    return result

# -------------------- Streamlit UI --------------------
st.set_page_config(page_title="Câu Cá Vạn Cân — Realistic", layout="wide")
st.title("🎣 Câu Cá Vạn Cân — Phiên bản Realistic")

# load DB
users = load_users()

# Sidebar: Auth
st.sidebar.header("Tài khoản")
auth_mode = st.sidebar.selectbox("Chọn", ["Đăng nhập", "Đăng ký", "Thông tin tài khoản"])

if auth_mode == "Đăng ký":
    new_user = st.sidebar.text_input("Tên tài khoản")
    new_pw = st.sidebar.text_input("Mật khẩu", type="password")
    if st.sidebar.button("Tạo tài khoản"):
        if not new_user or not new_pw:
            st.sidebar.error("Không được để trống.")
        elif new_user in users:
            st.sidebar.error("Tên đã tồn tại.")
        else:
            users[new_user] = {"password": new_pw, "money": 50000, "rod": "Cần Thường", "history": []}
            save_users(users)
            st.sidebar.success("Tạo tài khoản thành công! Bạn nhận 50.000 VNĐ.")
            st.experimental_rerun()

elif auth_mode == "Đăng nhập":
    user = st.sidebar.text_input("Tên tài khoản (login)")
    pw = st.sidebar.text_input("Mật khẩu", type="password")
    if st.sidebar.button("Đăng nhập"):
        if user in users and users[user]["password"] == pw:
            st.session_state["user"] = user
            st.sidebar.success(f"Đã đăng nhập: {user}")
            st.experimental_rerun()
        else:
            st.sidebar.error("Sai tên hoặc mật khẩu")

elif auth_mode == "Thông tin tài khoản":
    if "user" in st.session_state:
        u = st.session_state["user"]
        st.sidebar.markdown(f"**{u}**")
        st.sidebar.markdown(f"Số dư: **{users[u]['money']:,} VNĐ**")
        st.sidebar.markdown(f"Cần đang dùng: **{users[u].get('rod','Cần Thường')}**")
        if st.sidebar.button("Đăng xuất"):
            del st.session_state["user"]
            st.experimental_rerun()
    else:
        st.sidebar.info("Bạn chưa đăng nhập.")

# require login for main game
if "user" not in st.session_state:
    st.info("Bạn cần đăng nhập để chơi (hoặc tạo tài khoản ở sidebar).")
    st.stop()

me = st.session_state["user"]
st.sidebar.markdown("---")
st.sidebar.markdown("🎒 **Shop Cần Câu**")
for rod_name, info in RODS.items():
    col1, col2 = st.sidebar.columns([3,1])
    col1.markdown(f"**{rod_name}** — Bonus tỉ lệ: {info['bonus']}%")
    col1.markdown(f"Giá: {info['price']:,} VNĐ")
    if me in users and users[me]["rod"] == rod_name:
        col2.button("Đang dùng", key=f"rod_{rod_name}", disabled=True)
    else:
        if col2.button("Mua", key=f"buy_{rod_name}"):
            if users[me]["money"] >= info["price"]:
                users[me]["money"] -= info["price"]
                users[me]["rod"] = rod_name
                save_users(users)
                st.sidebar.success(f"Đã mua và trang bị {rod_name}")
                st.experimental_rerun()
            else:
                st.sidebar.error("Không đủ tiền để mua.")

# Main area
st.subheader(f"Xin chào {me} — Số dư: {users[me]['money']:,} VNĐ")
colL, colR = st.columns([2,3])

with colL:
    st.markdown("### Chọn Map")
    selected_map = st.selectbox("Map", list(MAPS.keys()))
    st.markdown(MAPS[selected_map]["desc"])
    st.image(MAPS[selected_map]["bg"], use_column_width=True)

    st.markdown("---")
    st.markdown("### Cần câu của bạn")
    st.markdown(f"**{users[me].get('rod','Cần Thường')}** — Bonus tỉ lệ {RODS[users[me].get('rod','Cần Thường')]['bonus']}%")
    if st.button("Thay đổi cần về Cần Thường"):
        users[me]["rod"] = "Cần Thường"
        save_users(users)

    st.markdown("---")
    st.markdown("### Thông tin & Lịch sử")
    st.write("Lịch sử bắt gần nhất:")
    hist = users[me].get("history", [])[:10]
    if hist:
        for h in hist[:10]:
            t = datetime.fromtimestamp(h["ts"]).strftime("%Y-%m-%d %H:%M")
            st.write(f"- [{t}] {h['name']} — {h['weight']} kg — {h['rarity']} — +{h['value']:,} VNĐ")
    else:
        st.write("Chưa có.")

with colR:
    st.markdown("### Khu câu — Thực nghiệm")
    st.markdown("Bấm **Quăng cần** để thả mồi. Khi cá cắn, dùng **Kéo** và **Skill** để bắt. Không đặt cược — chỉ nhận tiền khi bắt được.")
    # Game session state
    if "fishing" not in st.session_state:
        st.session_state["fishing"] = {"active": False}

    fishing = st.session_state["fishing"]

    def start_cast():
        # pick rarity based on map & rod bonus
        rod_bonus = RODS[users[me]["rod"]]["bonus"]
        rarity = pick_rarity(selected_map, bait_bonus=rod_bonus)
        fish = pick_fish_by_rarity(rarity)
        # set HP and tension values depending on rarity (boss stronger)
        base_hp = max(50, int(fish["weight"]/ (1 if rarity=="Thường" else 2)))
        # cap for boss
        if rarity == "Boss":
            base_hp = max(base_hp, 500)
        st.session_state["fishing"] = {
            "active": True,
            "fish": fish,
            "hp": base_hp,
            "tension": 10 + rod_bonus//2,  # tension starts slightly higher with worse rods
            "caught": False,
            "attempts": 0
        }

    def do_pull():
        if not st.session_state["fishing"]["active"]:
            st.warning("Bạn chưa quăng cần.")
            return
        f = st.session_state["fishing"]
        # pulling reduces HP but increases tension
        pull_power = 50 + RODS[users[me]["rod"]]["bonus"] + random.randint(-10, 20)
        # scale with fish weight => stronger fish harder
        effective = int(pull_power / (1 + f["fish"]["weight"]/2000))
        f["hp"] = max(0, f["hp"] - effective)
        f["tension"] += random.randint(8, 20)
        f["attempts"] += 1
        # auto tension reduce a bit if using good rod
        f["tension"] -= RODS[users[me]["rod"]]["bonus"] // 3
        if f["tension"] < 5: f["tension"] = 5
        # win/lose checks
        if f["hp"] <= 0:
            f["caught"] = True
            f["active"] = False
            on_caught()
        elif f["tension"] >= 100:
            f["caught"] = False
            f["active"] = False
            on_lost()

    def use_skill():
        # skill: strong yank, but has cooldown per catch (we simulate cooldown by attempts)
        if not st.session_state["fishing"]["active"]:
            st.warning("Bạn chưa quăng cần.")
            return
        f = st.session_state["fishing"]
        # skill only allowed if attempts >=0 (always allowed) but we penalize tension slightly
        skill_power = 200 + RODS[users[me]["rod"]]["bonus"] * 5
        f["hp"] = max(0, f["hp"] - skill_power)
        f["tension"] += random.randint(5, 12)
        # visual effect: we will play sound and show image below
        st.session_state["last_skill_time"] = datetime.now().timestamp()
        if f["hp"] <= 0:
            f["caught"] = True
            f["active"] = False
            on_caught()
        elif f["tension"] >= 100:
            f["caught"] = False
            f["active"] = False
            on_lost()

    def on_caught():
        f = st.session_state["fishing"]["fish"]
        value = f["value"]
        # bonus by rod
        rod_bonus_percent = RODS[users[me]["rod"]]["bonus"]
        value = int(value * (1 + rod_bonus_percent/100.0))
        users[me]["money"] += value
        # save history
        users[me].setdefault("history", [])
        users[me]["history"].insert(0, {"ts": datetime.now().timestamp(), "name": f["name"], "weight": f["weight"], "rarity": f["rarity"], "value": value})
        save_users(users)
        st.success(f"🎉 Bắt được {f['name']} ({f['weight']} kg) — Bạn nhận {value:,} VNĐ")
        st.balloons()

    def on_lost():
        f = st.session_state["fishing"]["fish"]
        # penalty: none, maybe small morale loss message
        st.error(f"💥 Dây bị đứt / cá tuột — {f['name']} chạy mất!")
        # small chance to break rod? (optional)
        # do not penalize money

    # Buttons: Cast / Pull / Skill / Abandon
    c1, c2, c3, c4 = st.columns(4)
    if c1.button("🎣 Quăng cần"):
        start_cast()
    if c2.button("💪 Kéo"):
        do_pull()
    if c3.button("🔥 Skill (Giật mạnh)"):
        use_skill()
    if c4.button("❌ Bỏ cuộc"):
        st.session_state["fishing"] = {"active": False}
        st.info("Bạn đã bỏ cuộc.")

    # show fishing status
    fs = st.session_state["fishing"]
    if fs["active"]:
        fish = fs["fish"]
        st.markdown(f"**Đang câu:** {fish['name']} — {fish['rarity']}")
        # show realistic fish image (choose by rarity)
        img_url = ""
        if fish["rarity"] == "Thường":
            img_url = "https://images.unsplash.com/photo-1562577309-2592ab84b1bc?w=800&q=80&auto=format&fit=crop"
        elif fish["rarity"] == "Hiếm":
            img_url = "https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=1000&q=80&auto=format&fit=crop"
        elif fish["rarity"] == "Huyền thoại":
            img_url = "https://images.unsplash.com/photo-1508614982313-4c2b3a8e2a32?w=1200&q=80&auto=format&fit=crop"
        else:
            img_url = "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1400&q=80&auto=format&fit=crop"
        st.image(img_url, width=420)
        st.markdown(f"- **HP cá:** {fs['hp']}")
        st.markdown(f"- **Tension (Căng dây):** {fs['tension']}%")
        st.markdown(f"- **Cân nặng dự đoán:** {fish['weight']} kg")
        # small skill visual: show skill image if used recently
        if "last_skill_time" in st.session_state:
            dt = datetime.now().timestamp() - st.session_state["last_skill_time"]
            if dt < 1.2:
                st.image("https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800&q=80&auto=format&fit=crop", width=160, caption="Hiệu ứng skill!")
    else:
        st.write("Chưa có cá cắn. Bấm **Quăng cần** để thả mồi.")

    st.markdown("---")
    st.markdown("**Gợi ý:** Dùng rod tốt (Cần Pro / Cần Titan) để tăng tỉ lệ bắt cá hiếm. Hang sâu chứa nhiều cá mạnh (và Boss).")

# End
