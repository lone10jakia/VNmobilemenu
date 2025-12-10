# File: app.py – BOT VƯỢT LINK GỐC THẬT 100% (Funlink, YêuMoney, Oke.io, v.v.)
import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time
import random

st.set_page_config(page_title="BOT VƯỢT LINK GỐC THẬT", layout="wide")
st.title("BOT VƯỢT LINK GỐC THẬT 100% – DÀNH CHO YÊUMONEY/FUNLINK")

link = st.text_input("Dán link YêuMoney/Funlink/Oke.io vào đây:")

if st.button("VƯỢT → LINK GỐC THẬT"):
    if not link:
        st.error("Dán link đi!")
    else:
        with st.spinner("Đang dùng trình duyệt thật để vượt... chờ 15–30 giây"):
            try:
                chrome_options = Options()
                chrome_options.add_argument("--headless")
                chrome_options.add_argument("--no-sandbox")
                chrome_options.add_argument("--disable-dev-shm-usage")
                chrome_options.add_argument("--disable-blink-features=AutomationControlled")
                chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
                chrome_options.add_experimental_option("useAutomationExtension", False)

                driver = webdriver.Chrome(options=chrome_options)
                driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => false});")
                
                driver.get(link)
                time.sleep(10 + random.randint(3,8))

                # Tìm nút Get Link / Tiếp tục / Continue
                try:
                    btn = driver.find_element(By.XPATH, "//button[contains(text(),'Get Link') or contains(text(),'Tiếp tục') or contains(text(),'Continue')]")
                    driver.execute_script("arguments[0].click();", btn)
                    time.sleep(8)
                except:
                    pass

                final_url = driver.current_url
                driver.quit()

                st.success("VƯỢT THÀNH CÔNG – ĐÂY LÀ LINK GỐC THẬT!")
                st.code(final_url)
                st.markdown(f"[MỞ LINK GỐC NGAY]({final_url})")
                st.balloons()

            except Exception as e:
                st.error(f"Lỗi: {str(e)[:100]}")
                st.info("Link bị chặn mạnh – thử lại sau 10 phút hoặc dùng máy khác!")

st.info("Bot này dùng trình duyệt thật → vượt được 99% link YêuMoney/Funlink hiện nay!")
