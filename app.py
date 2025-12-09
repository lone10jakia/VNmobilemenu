import streamlit as st
import json
import random
import os
# ===================================================================

st.title("🎣 GAME CÂU CÁ VẠN CÂN — FULL EDITION")

username = st.text_input("Nhập tài khoản:")
if username not in users:
    st.warning("Tài khoản không tồn tại!")
    st.stop()

money = users[username]["money"]

st.success(f"💰 Số tiền hiện tại: {money:,} VNĐ")

st.write("### 🎣 Khu câu cá")

# ========================== FULL HTML GAME ==========================

html = """
<style>
.game-box {
  position: relative;
  width: 100%;
  height: 600px;
  background: linear-gradient(#4fa2ff, #003a75);
  border-radius: 12px;
  overflow: hidden;
}

/* Nhân vật */
#fisherman {
  position: absolute;
  bottom: 0;
  left: 40px;
  width: 220px;
  transition: 0.3s;
}

/* Cá */
#fish {
  position: absolute;
  right: -200px;
  bottom: 150px;
  width: 180px;
  transition: 0.2s;
}

/* Hiệu ứng skill */
#skillFx {
  position: absolute;
  left: 200px;
  bottom: 230px;
  width: 160px;
  opacity: 0;
  transition: 0.3s;
}

/* Thanh HP cá */
.hp-bar-bg {
  position: absolute;
  top: 20px;
  left: 50%;
  width: 300px;
  height: 20px;
  background: #00000066;
  border-radius: 10px;
  transform: translateX(-50%);
}
.hp-bar {
  height: 100%;
  background: #ff5b5b;
  width: 100%;
  border-radius: 10px;
}

/* Thanh căng dây */
.tension-bg {
  position: absolute;
  top: 55px;
  left: 50%;
  width: 300px;
  height: 20px;
  background: #00000066;
  border-radius: 10px;
  transform: translateX(-50%);
}
.tension {
  height: 100%;
  background: #ffd700;
  width: 10%;
  border-radius: 10px;
}

/* Nút điều khiển */
.control-btn {
  padding: 10px 20px;
  font-size: 20px;
  margin: 10px;
}
</style>

<div class="game-box">
  <img id="fisherman" src="https://i.imgur.com/KZtNFwN.png">
  <img id="fish" src="https://i.imgur.com/wd8ZKzB.png">
  <img id="skillFx" src="https://i.imgur.com/8t7Vsp3.png">

  <div class="hp-bar-bg"><div id="hpBar" class="hp-bar"></div></div>
  <div class="tension-bg"><div id="tensionBar" class="tension"></div></div>
</div>

<button class="control-btn" onclick="castRod()">🎣 Ném mồi</button>
<button class="control-btn" onclick="pullFish()">💪 Kéo cá</button>
<button class="control-btn" onclick="useSkill()">🔥 Kỹ năng</button>

<script>
let fishHP = 100;
let tension = 10;
let hooked = false;

// Âm thanh
function play(url){
  let a = new Audio(url);
  a.volume = 0.75;
  a.play();
}

// Ném mồi
function castRod(){
  play("https://www.myinstants.com/media/sounds/whoosh.mp3");
  let f = document.getElementById("fish");
  f.style.right = "120px";
  hooked = true;

  fishHP = Math.floor(Math.random()*80)+120; // 120–200 HP
  tension = 10;
  updateBars();
}

// Kéo cá
function pullFish(){
  if(!hooked) return;

  play("https://www.myinstants.com/media/sounds/metal-hit.mp3");

  fishHP -= Math.floor(Math.random()*10)+6;
  tension += Math.floor(Math.random()*10)+5;

  updateBars();

  if(fishHP <= 0){
    catchFish();
  } else if(tension >= 100){
    loseFish();
  }
}

// Kỹ năng
function useSkill(){
  if(!hooked) return;

  play("https://www.myinstants.com/media/sounds/superpower.mp3");

  document.getElementById("skillFx").style.opacity = 1;
  setTimeout(()=>{ document.getElementById("skillFx").style.opacity = 0; },400);

  fishHP -= 30;
  tension -= 15;

  if(tension < 5) tension = 5;
  updateBars();
}

function updateBars(){
  document.getElementById("hpBar").style.width = (fishHP<=0?0:fishHP)+"px";
  document.getElementById("tensionBar").style.width = tension+"%";
}

// Bắt cá thành công
function catchFish(){
  hooked = false;
  play("https://www.myinstants.com/media/sounds/yeah-boy.mp3");
  alert("🎉 Bạn đã bắt được cá!\n+ 50.000 VNĐ");
  window.parent.postMessage({type: "addMoney", value: 50000}, "*");
}

// Đứt dây
function loseFish(){
  hooked = false;
  play("https://www.myinstants.com/media/sounds/fail-trombone.mp3");
  alert("💢 Dây bị đứt! Cá chạy mất...");
}
</script>
"""

# Hiển thị HTML game
st.components.v1.html(html, height=750)

# Lắng nghe message từ JS để cộng tiền
msg = st.experimental_get_query_params()
if "addMoney" in msg:
    users[username]["money"] += int(msg["addMoney"][0])
    save_users(users)
