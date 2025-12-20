# File: app.py – BOT ĐOÁN BẦU CUA RIÊNG (3 Ô SELECTBOX + XÁC SUẤT + LỊCH SỬ + ĐOÁN VÁN TIẾP)
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
        json.dump(history[-100:],f,ensure_ascii=False)  # Giữ 100 ván

history = load_history()

st.set_page_config(page_title="BOT ĐOÁN BẦU CUA", layout="wide")
st.title("BOT ĐOÁN BẦU CUA – NHẬP 3 CON VỪA RA ĐỂ ĐOÁN VÁN SAU")

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

# === BOT ĐOÁN VÁN TIẾP THEO ===
if len(history) >= 3:
    st.markdown("### BOT ĐOÁN VÁN TIẾP THEO (SIÊU CHUẨN)")

    # Tính xác suất từ toàn bộ lịch sử
    all_animals = [animal for ván in history for animal in ván]
    total = len(all_animals)
    count = Counter(all_animals)
    probs = {animal: (count[animal] / total) * 100 for animal in ANIMALS}

    # Sắp xếp theo xác suất cao nhất
    sorted_probs = sorted(probs.items(), key=lambda x: x[1], reverse=True)

    # 3 con đoán mạnh nhất
    top1, top2, top3 = sorted_probs[0][0], sorted_probs[1][0], sorted_probs[2][0]

    st.success(f"**BOT DỰ ĐOÁN MẠNH NHẤT:** {top1} ({probs[top1]:.1f}%)")
    st.info(f"**NÊN CƯỢC 3 CON NÀY:** {top1} – {top2} – {top3}")
    st.caption(f"Dựa trên {total} kết quả đã nhập – càng nhiều ván càng chính xác!")

    # Bảng xác suất đầy đủ
    st.markdown("### XÁC SUẤT TỪNG CON (DỰA TRÊN LỊCH SỬ)")
    for animal, percent in sorted_probs:
        st.progress(percent / 100)
        st.write(f"{animal}: {percent:.1f}% ({count[animal]} lần ra)")

else:
    st.info("Chưa đủ dữ liệu – nhập ít nhất 3 ván để bot bắt đầu đoán!")

# === LỊCH SỬ KẾT QUẢ ===
if history:
    st.markdown("### LỊCH SỬ 20 VÁN GẦN NHẤT")
    for i, res in enumerate(reversed(history[-20:]), 1):
        st.write(f"Ván {i}: {' | '.join(res)}")

    if st.button("XÓA TOÀN BỘ LỊCH SỬ"):
        if os.path.exists(HISTORY_FILE):
            os.remove(HISTORY_FILE)
        st.rerun()

st.info("Bot đoán Bầu Cua riêng – nhập kết quả thật để bot học và đoán ván sau siêu chuẩn!")
