require("LeweiHttpClient")
t=require("DS18B20")
LeweiHttpClient.init("02","cca9be079b7b4b709cc6b20ef6180a1b")

t.setup(3)      --这里修改引脚号，3是GPIO00   DS18B20
addrs = t.addrs()
    if (addrs == nil) then
         print("No find 18B20 sensors.")    --提示找不到传感器
         tmr.delay(30000000)
         tmr.stop(0)
         node.restart();
     end
  print("Total DS18B20 sensors: "..table.getn(addrs))
  tmr.delay(3000)
  print("Temperature: "..t.read().."'C")      --先读一次，防止错误

  

tmr.alarm(0, 60000, 1, function()--这里的第二个参数是间隔时间，单位us,30000是30秒
st=t.read()
print("Temperature: "..st.."'C")
   
sk=net.createConnection(net.TCP, 0)
sk:on("connection", function(conn) topost() end)
sk:on("disconnection", function(conn, pl) print("disconnection") sk:close() end) 
sk:on("receive", function(conn, pl) sk:close() print(pl) end ) 
sk:connect(80,"www.lewei50.com")

function topost()
sc="[{'Name':'T1','Value':"..t.read().."}]"
print(sc)
sk:send("POST /api/V1/gateway/UpdateSensors/02 HTTP/1.1\r\n"                   --这里的2个id填你自己的
.."Host: www.lewei50.com\r\n"
.."Content-Length: "..string.len(sc).."\r\n"--the length of json is important
.."userkey:cca9be079b7b4b709cc6b20ef6180a1b\r\n"                                             --这里的APIKEY填你自己的
.."Cache-Control: no-cache\r\n\r\n"
..sc.."\r\n" )
end

end)
