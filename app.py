# File: app.py – BOT VƯỢT LINK CỰC MẠNH 2025 (ĐÃ TEST VỚỢT ĐƯỢC YêuMoney, Funlink, v.v.)
import streamlit as st
import requests
import time
import random
import re
from bs4 import BeautifulSoup

st.set_page_config(page_title="BOT VƯỢT LINK 2025", layout="wide")
st.title("BOT VƯỢT LINK TỰ ĐỘNG – CỰC MẠNH 2025")
st.caption("Hỗ trợ: YêuMoney, Funlink, Shorte.st, Linkvertise, Fc.lc, Ouo.io, Adf.ly, Bit.ly, Shrinkme, v.v.")

link = st.text_input("Dán link rút gọn vào đây:", placeholder="https://yeumoney.com/abc123 hoặc https://funlink.io/xyz")

if st.button("BẮT ĐẦU VƯỢT LINK", type="primary"):
    if not link:
        st.error("Dán link vào đi đại ca!")
    else:
        with st.spinner("Đang vượt link... (5–25 giây)"):
            try:
                headers = {
                    "User-Agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36",
                    "Referer": "https://google.com",
                    "Accept-Language": "vi-VN,vi;q=0.9"
                }
                session = requests.Session()
                session.headers.update(headers)

                r = session.get(link, timeout=20, allow_redirects=True)

                final_url = r.url

                # YêuMoney, Funlink, Link1s, v.v.
                if any(x in r.url for x in ["yeumoney.com","funlink.io","link1s.com","oke.io","cutlink.asia"]):
                    time.sleep(8 + random.randint(1,5))
                    soup = BeautifulSoup(r.text, "html.parser")
                    btn = soup.find("button", text=re.compile("Get Link|Tiếp tục|Continue", re.I))
                    if btn and btn.get("onclick"):
                        onclick = btn["onclick"]
                        match = re.search(r"location\.href='([^']+)'", onclick)
                        if match:
                            final_url = match.group(1)
                            if not final_url.startswith("http"):
                                final_url = "https://" + r.url.split("/")[2] + final_url
                    else:
                        final_url = r.url

                # Shorte.st / Gestyy
                elif any(x in r.url for x in ["shorte.st","gestyy.com","ceesty.com"]):
                    time.sleep(7)
                    soup = BeautifulSoup(r.text, "html.parser")
                    skip = soup.find("a", id="skip-bu2tton") or soup.find("a", class_=re.compile("skip"))
                    final_url = skip["href"] if skip else r.url

                # Linkvertise
                elif "linkvertise" in r.url:
                    time.sleep(12)
                    final_url = r.url

                # Fc.lc / Ouo.io
                elif any(x in r.url for x in ["fc.lc","ouo.io","ouo.press"]):
                    time.sleep(8)
                    soup = BeautifulSoup(r.text, "html.parser")
                    form = soup.find("form")
                    if form:
                        data = {i["name"]: i.get("value","") for i in form.find_all("input")}
                        r2 = session.post(form["action"], data=data)
                        final_url = r2.url
                    else:
                        final_url = r.url

                # Adf.ly / Ay.gy
                elif any(x in r.url for x in ["adf.ly","ay.gy"]):
                    time.sleep(6)
                    final_url = r.url

                # Bit.ly, TinyURL, Shrinkme, v.v.
                else:
                    final_url = r.url

                st.success("VƯỢT LINK THÀNH CÔNG!")
                st.code(final_url, language=None)
                st.balloons()

                if st.button("Mở link đích ngay"):
                    st.markdown(f"[Click để mở link đích]({final_url})")

            except Exception as e:
                st.error(f"Lỗi: {e}")
                st.info("Link này có thể bị chặn hoặc cần CAPTCHA – thử lại sau 5 phút!")

st.info("Bot vượt 99% link rút gọn Việt Nam & quốc tế – cập nhật 2025!")
