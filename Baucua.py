# File: app.py – BOT ĐOÁN BẦU CUA THÔNG MINH NHẤT (TÍNH KỸ NHƯ NGƯỜI THẬT)
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
st.title("BOT ĐOÁN BẦU CUA – THÔNG MINH NHƯ NGƯỜI THẬT (KHÔNG NGÁO)")

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

# === BOT ĐOÁN THÔNG MINH (TÍNH KỸ NHƯ BẠN NÓI) ===
if len(history) >= 10:
    st.markdown("### BOT ĐOÁN VÁN TIẾP THEO (THÔNG MINH NHẤT)")

    # Lấy 15 ván gần nhất
    recent = history[-15:]
    all_recent = [animal for ván in recent for animal in ván]
    count_recent = Counter(all_recent)

    # Công thức thông minh:
    # - Ra nhiều gần đây → giảm điểm (khó ra lại)
    # - Ra ít gần đây → tăng điểm (dễ ra bù)
    # - Ra nhiều ở quá khứ xa → tăng nhẹ điểm (có thể ra lại)
    # - Thêm yếu tố random nhẹ để tránh đoán cố định

    scores = {}
    for animal in ANIMALS:
        recent_count = count_recent[animal]
        past_count = sum(1 for ván in history[:-15] for a in ván if a == animal) if len(history) > 15 else 0

        # Ra nhiều gần đây → trừ điểm mạnh
        recent_penalty = recent_count * 3

        # Ra ít gần đây → cộng điểm
        recent_bonus = (15 - recent_count) * 1.5

        # Ra nhiều quá khứ → cộng nhẹ (có thể ra lại)
        past_bonus = past_count * 0.5

        # Random nhẹ để linh hoạt
        random_bonus = random.uniform(0, 2)

        score = recent_bonus - recent_penalty + past_bonus + random_bonus
        scores[animal] = score

    # Con có điểm cao nhất
    best_animal = max(scores, key=scores.get)
    best_score = scores[best_animal]

    st.success(f"**BOT DỰ ĐOÁN CON DỄ RA NHẤT VÁN SAU:** {best_animal}")
    st.info(f"**LÝ DO:** Con này cân bằng tốt nhất: không ra quá nhiều gần đây, nhưng có thể ra bù hoặc ra lại!")
    st.caption("Bot tính kỹ: ra nhiều gần đây khó ra, ra ít thì dễ bù, ra nhiều quá khứ có thể ra lại – giống người thật!")

    # Bảng điểm từng con
    st.markdown("### ĐIỂM DỄ RA CỦA TỪNG CON")
    sorted_scores = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    for animal, score in sorted_scores:
        st.progress(score / max(scores.values()))
        st.write(f"{animal}: {score:.1f} điểm (ra {count_recent[animal]} lần gần đây)")

else:
    st.info("Chưa đủ dữ liệu – nhập ít nhất 10 ván để bot đoán thông minh nhất!")

# === LỊCH SỬ ===
if history:
    st.markdown("### LỊCH SỬ 20 VÁN GẦN NHẤT")
    for i, res in enumerate(reversed(history[-20:]), 1):
        st.write(f"Ván {i}: {' | '.join(res)}")

    if st.button("XÓA TOÀN BỘ LỊCH SỬ"):
        if os.path.exists(HISTORY_FILE):
            os.remove(HISTORY_FILE)
        st.rerun()

st.info("Bot đoán Bầu Cua thông minh nhất – tính kỹ như người thật: ra nhiều khó ra, ra ít dễ bù, ra nhiều quá khứ có thể ra lại!")
