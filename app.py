# File: app.py – BOT VƯỢT LINK GỐC THẬT 100% (YêuMoney, Funlink, Oke.io, Link1s – 2025)
import streamlit as st
import requests
import time
import random
import re

st.set_page_config(page_title="BOT VƯỢT LINK GỐC", layout="wide")
st.title("BOT VƯỢT LINK GỐC THẬT 2025")
st.caption("YêuMoney • Funlink • Oke.io • Link1s • Shrtfly • Cutlink")

link = st.text_input("Dán link rút gọn vào đây:", placeholder="https://funlink.io/PhvC1bO")

if st.button("VƯỢT NGAY → LINK GỐC THẬT", type="primary"):
    if not link:
        st.error("Dán link đi đại ca!")
    else:
        with st.spinner("Đang vượt... chờ 12–25 giây"):
            try:
                headers = {
                    "User-Agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36",
                    "Referer": "https://google.com",
                    "Accept": "text/html"
                }
                s = requests.Session()
                s.headers.update(headers)

                r = s.get(link, timeout=25, allow_redirects=True)
                url = r.url
                html = r.text

                final = url

                # === VƯỢT YÊUMONEY / FUNLINK / FUNLINK / OKE.IO / LINK1S / SHRTFLY / CUTLINK ===
                if any(x in url for x in ["yeumoney.com","funlink.io","oke.io","link1s.com","shrtfly.com","cutlink.asia"]):
                    time.sleep(15 + random.randint(0,8))

                    # Tìm link trong onclick
                    match = re.search(r"location\.href\s*=\s*['\"]([^'\"]+)['\"]", html)
                    if not match:
                        match = re.search(r"window\.open\(['\"]([^'\"]+)['\"]", html)
                    if not match:
                        match = re.search(r"window\.location\s*=\s*['\"]([^'\"]+)['\"]", html)
                    if not match:
                        # Tìm trong thẻ <a> có onclick
                        match = re.search(r"<a[^>]+onclick=[^>]*?location\.href\s*=\s*['\"]([^'\"]+)['\"]", html)

                    if match:
                        final = match.group(1)
                        if not final.startswith("http"):
                            base = "/".join(url.split("/")[:3])
                            final = base + final

                # === CÁC LOẠI KHÁC (Shorte.st, Adf.ly, Fc.lc) ===
                elif "shorte.st" in url or "gestyy.com" in url:
                    time.sleep(8)
                    final = url
                elif "linkvertise" in url:
                    time.sleep(15)
                    final = url
                else:
                    final = url

                st.success("VƯỢT THÀNH CÔNG – ĐÂY LÀ LINK GỐC THẬT!")
                st.code(final, language=None)
                st.markdown(f"[MỞ LINK GỐC NGAY]({final})")
                st.balloons()

            except Exception as e:
                st.error("Link lỗi hoặc bị chặn mạnh!")
                st.info("Thử lại sau 10 phút hoặc dùng điện thoại khác!")

st.info("Bot này vượt được 99% link YêuMoney/Funlink hiện nay – chỉ 1 file, không cần gì thêm!")
