# File: app.py – BOT ĐOÁN BẦU CUA THÔNG MINH (CON RA NHIỀU GẦN ĐÂY → KHÓ RA LẦN SAU)
import streamlit as st
import json
import os
from collections import Counter

HISTORY_FILE = "baucua_history.json"
ANIMALS = ["BẦU","CUA","TÔM","CÁ","GÀ","NAI"]

# Load lịch sử
def load_history():
    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE,"r",encoding="utf-8") as f:
            return json.load(f)
    return []

# Save lịch sử
def save_history(history):
    with open(HISTORY_FILE,"w",encoding="utf-8") as f:
        json.dump(history[-100:],f,ensure_ascii=False)

history = load_history()

st.set_page_config(page_title="BOT ĐOÁN BẦU CUA THÔNG MINH", layout="wide")
st.title("BOT ĐOÁN BẦU CUA – CON RA NHIỀU THÌ KHÓ RA LẦN SAU")

st.markdown("### NHẬP KẾT QUẢ VÁN VỪA QUA (3 CON XÚC XẮC)")

col1, col2, col3 = st.columns(3)
with col1:
    con1 = st.selectbox("Con thứ 1", ANIMALS, index=0)
with col2:
    con2 = st.selectbox("Con thứ 2", ANIMALS, index=0)
with col3:
    con3 = st.selectbox("Con thứ 3", ANIMALS, index=0)

if st.button("NHẬP VÀ ĐOÁN VÁN TIẾP THEO", type="primary"):
    res = [con1, con2, con3]
    history.append(res)
    save_history(history)
    st.success("ĐÃ NHẬP KẾT QUẢ VÀO LỊCH SỬ!")
    st.balloons()

# === BOT ĐOÁN THÔNG MINH: CON RA NHIỀU GẦN ĐÂY → KHÓ RA LẦN SAU ===
if len(history) >= 5:
    st.markdown("### BOT ĐOÁN VÁN TIẾP THEO (THÔNG MINH HƠN)")

    # Chỉ lấy 10 ván gần nhất để đoán (ngắn hạn)
    recent = history[-10:]
    all_recent = [animal for ván in recent for animal in ván]
    count_recent = Counter(all_recent)

    # Con ra nhiều nhất gần đây → điểm thấp nhất (khó ra)
    # Con ra ít nhất → điểm cao nhất (dễ ra lần sau)
    scores = {}
    for animal in ANIMALS:
        times = count_recent[animal]
        # Công thức: càng ra nhiều → điểm càng thấp
        scores[animal] = 30 - times  # Max 30 điểm nếu chưa ra lần nào

    # Con có điểm cao nhất
    best_animal = max(scores, key=scores.get)
    best_score = scores[best_animal]

    st.success(f"**BOT DỰ ĐOÁN CON DỄ RA NHẤT VÁN SAU:** {best_animal}")
    st.info(f"**LÝ DO:** Con này ra ít nhất trong 10 ván gần đây → dễ ra bù!")
    st.caption("Logic: Con ra nhiều lần liên tục thì khó ra lần nữa – giống thực tế!")

    # Bảng điểm từng con
    st.markdown("### ĐIỂM DỄ RA CỦA TỪNG CON (TRONG 10 VÁN GẦN NHẤT)")
    sorted_scores = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    for animal, score in sorted_scores:
        st.progress(score / 30)
        st.write(f"{animal}: {score} điểm (ra {count_recent[animal]} lần gần đây)")

else:
    st.info("Chưa đủ dữ liệu – nhập ít nhất 5 ván để bot đoán thông minh!")

# === LỊCH SỬ ===
if history:
    st.markdown("### LỊCH SỬ 20 VÁN GẦN NHẤT")
    for i, res in enumerate(reversed(history[-20:]), 1):
        st.write(f"Ván {i}: {' | '.join(res)}")

    if st.button("XÓA TOÀN BỘ LỊCH SỬ"):
        if os.path.exists(HISTORY_FILE):
            os.remove(HISTORY_FILE)
        st.rerun()

st.info("Bot đoán thông minh: Con ra nhiều gần đây thì khó ra lần sau – giống sòng thật!")
