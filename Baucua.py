# File: app.py – BOT ĐOÁN BẦU CUA RIÊNG (CHỈ ĐOÁN 1 CON MẠNH NHẤT CHO VÁN TIẾP THEO)
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
        json.dump(history[-100:],f,ensure_ascii=False)  # Giữ 100 ván để đoán chuẩn

history = load_history()

st.set_page_config(page_title="BOT ĐOÁN BẦU CUA", layout="wide")
st.title("BOT ĐOÁN BẦU CUA – CHỈ ĐOÁN 1 CON MẠNH NHẤT CHO VÁN TIẾP THEO")

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

# === BOT ĐOÁN VÁN TIẾP THEO (CHỈ 1 CON MẠNH NHẤT) ===
if len(history) >= 5:
    st.markdown("### BOT ĐOÁN VÁN TIẾP THEO")

    # Tính xác suất từ toàn bộ lịch sử
    all_animals = [animal for ván in history for animal in ván]
    total = len(all_animals)
    count = Counter(all_animals)
    probs = {animal: (count[animal] / total) * 100 for animal in ANIMALS}

    # Con có tỷ lệ ra cao nhất
    best_animal = max(probs, key=probs.get)
    best_percent = probs[best_animal]

    st.success(f"**BOT DỰ ĐOÁN CON MẠNH NHẤT CHO VÁN SAU:** {best_animal}")
    st.info(f"**TỶ LỆ RA:** {best_percent:.1f}% (cao nhất trong lịch sử)")
    st.caption(f"Dựa trên {total} kết quả đã nhập – bot chỉ đoán 1 con mạnh nhất để tránh lừa!")

    # Bảng xác suất đầy đủ
    st.markdown("### XÁC SUẤT TỪNG CON")
    sorted_probs = sorted(probs.items(), key=lambda x: x[1], reverse=True)
    for animal, percent in sorted_probs:
        color = "green" if animal == best_animal else "normal"
        st.progress(percent / 100)
        st.write(f"{animal}: {percent:.1f}% ({count[animal]} lần ra)")

else:
    st.info("Chưa đủ dữ liệu – nhập ít nhất 5 ván để bot đoán chính xác!")

# === LỊCH SỬ KẾT QUẢ ===
if history:
    st.markdown("### LỊCH SỬ 20 VÁN GẦN NHẤT")
    for i, res in enumerate(reversed(history[-20:]), 1):
        st.write(f"Ván {i}: {' | '.join(res)}")

    if st.button("XÓA TOÀN BỘ LỊCH SỬ"):
        if os.path.exists(HISTORY_FILE):
            os.remove(HISTORY_FILE)
        st.rerun()

st.info("Bot đoán Bầu Cua riêng – chỉ đoán 1 con mạnh nhất dựa trên lịch sử thật – không lừa, không đoán bừa!")
