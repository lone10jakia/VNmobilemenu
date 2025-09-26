local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function base64Decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(string.find(b,x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c + (string.sub(x,i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local encoded = [[LS0gTG9jYWxTY3JpcHQ6IFRyb2xsIE92ZXJsYXkgKFNhZmUgRmFkZSBCbGFjay9XaGl0ZSArIFJh
aW5ib3cgVGV4dCwgSW5maW5pdGUgVGltZSkNCi0tIFB1dCBpbnRvIFN0YXJ0ZXJQbGF5ZXIgLT4g
U3RhcnRlclBsYXllclNjcmlwdHMNCmxvY2FsIFBsYXllcnMgPSBnYW1lOkdldFNlcnZpY2UoIlBs
YXllcnMiKQ0KbG9jYWwgVHdlZW5TZXJ2aWNlID0gZ2FtZTpHZXRTZXJ2aWNlKCJUd2VlblNlcnZp
Y2UiKQ0KbG9jYWwgcGxheWVyID0gUGxheWVycy5Mb2NhbFBsYXllcg0KaWYgbm90IHBsYXllciB0
aGVuIHJldHVybiBlbmQNCi0tIEdVSQ0KbG9jYWwgZ3VpID0gSW5zdGFuY2UubmV3KCJTY3JlZW5H
dWkiKQ0KZ3VpLk5hbWUgPSAiVHJvbGxPdmVybGF5Ig0KZ3VpLlJlc2V0T25TcGF3biA9IGZhbHNl
DQpndWkuUGFyZW50ID0gcGxheWVyOldhaXRGb3JDaGlsZCgiUGxheWVyR3VpIikNCi0tIEZ1bGxz
Y3JlZW4gZnJhbWUNCmxvY2FsIGZ1bGwgPSBJbnN0YW5jZS5uZXcoIkZyYW1lIikNCmZ1bGwuU2l6
ZSA9IFVEaW0yLm5ldygxLDAsMSwwKQ0KZnVsbC5CYWNrZ3JvdW5kQ29sb3IzID0gQ29sb3IzLmZy
b21SR0IoMCwwLDApDQpmdWxsLlBhcmVudCA9IGd1aQ0KLS0gVGV4dA0KbG9jYWwgdGV4dCA9IElu
c3RhbmNlLm5ldygiVGV4dExhYmVsIikNCnRleHQuU2l6ZSA9IFVEaW0yLm5ldygxLDAsMCwxMDAp
DQp0ZXh0LlBvc2l0aW9uID0gVURpbTIubmV3KDAsMCwwLjQsMCkNCnRleHQuQmFja2dyb3VuZFRy
YW5zcGFyZW5jeSA9IDENCnRleHQuVGV4dCA9ICJjb2kgdGjhurFuZyBuZ3UgYuG7iyBs4burYSBr
w6xhIGhhaGFoYSINCnRleHQuRm9udCA9IEVudW0uRm9udC5Hb3RoYW1CbGFjaw0KdGV4dC5UZXh0
U2l6ZSA9IDQ4DQp0ZXh0LlRleHRDb2xvcjMgPSBDb2xvcjMubmV3KDEsMSwxKQ0KdGV4dC5QYXJl
bnQgPSBmdWxsDQotLSBSYWluYm93IHRleHQgbG9vcA0Kc3Bhd24oZnVuY3Rpb24oKQ0KbG9jYWwg
aHVlID0gMA0Kd2hpbGUgdHJ1ZSBkbw0KaHVlID0gKGh1ZSArIDAuMDA2KSAlIDENCnRleHQuVGV4
dENvbG9yMyA9IENvbG9yMy5mcm9tSFNWKGh1ZSwgMC45LCAxKQ0KdGFzay53YWl0KDAuMDMpDQpl
bmQNCmVuZCkNCi0tIEZhZGUgYmxhY2svd2hpdGUgbG9vcCAoc29mdCAiZmxhc2giKQ0Kc3Bhd24o
ZnVuY3Rpb24oKQ0Kd2hpbGUgdHJ1ZSBkbw0KVHdlZW5TZXJ2aWNlOkNyZWF0ZShmdWxsLCBUd2Vl
bkluZm8ubmV3KDAuNCwgRW51bS5FYXNpbmdTdHlsZS5TaW5lLCBFbnVtLkVhc2luZ0RpcmVjdGlv
bi5Jbk91dCksDQp7QmFja2dyb3VuZENvbG9yMyA9IENvbG9yMy5mcm9tUkdCKDI1NSwyNTUsMjU1
KX0pOlBsYXkoKQ0KdGFzay53YWl0KDAuNCkNClR3ZWVuU2VydmljZTpDcmVhdGUoZnVsbCwgVHdl
ZW5JbmZvLm5ldygwLjQsIEVudW0uRWFzaW5nU3R5bGUuU2luZSwgRW51bS5FYXNpbmdEaXJlY3Rp
b24uSW5PdXQpLA0Ke0JhY2tncm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigwLDAsMCl9KTpQ
bGF5KCkNCnRhc2sud2FpdCgwLjQpDQplbmQNCmVuZCk==]]

local decoded = base64.decode(encoded)
loadstring(decoded)()
