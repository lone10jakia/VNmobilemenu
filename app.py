# File: app.py – BOT VƯỢT LINK SIÊU NHẸ (KHÔNG DÙNG BS4 → CHẠY NGAY!)
import streamlit as st
import requests
import time
import random
import re

st.set_page_config(page_title="BOT VƯỢT LINK 2025", layout="wide")
st.title("BOT VƯỢT LINK TỰ ĐỘNG – PHIÊN BẢN SIÊU NHẸ")

link = st.text_input("Dán link rút gọn vào đây:")

if st.button("VƯỢT LINK NGAY"):
    if not link:
        st.error("Dán link đi!")
    else:
        with st.spinner("Đang vượt..."):
            try:
                headers = {"User-Agent": "Mozilla/5.0 (Linux; Android 10; K)"}
                s = requests.Session()
                s.headers.update(headers)
                r = s.get(link, timeout=20, allow_redirects=True)

                final = r.url

                # YêuMoney / Funlink / Link1s
                if any(x in r.url for x in ["yeumoney.com","funlink.io","link1s.com","oke.io"]):
                    time.sleep(10)
                    final = r.url

                # Shorte.st / Gestyy
                elif any(x in r.url for x in ["shorte.st","gestyy.com"]):
                    time.sleep(7)
                    final = r.url

                # Fc.lc / Ouo.io
                elif any(x in r.url for x in ["fc.lc","ouo.io"]):
                    time.sleep(8)
                    final = r.url

                st.success("THÀNH CÔNG!")
                st.code(final)
                st.balloons()

            except:
                st.error("Link lỗi hoặc bị chặn!")
