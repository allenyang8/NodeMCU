Set_Pin=2 --GPIO4 low for set the wifi connect to your router
--dont use GP0 GP2 GP16
gpio.mode(Set_Pin,gpio.INPUT)
if gpio.read(Set_Pin)==1 then -- if not set mode
require("routerpass") -- router ssid password store here
print(ssid)
print(password)
if true then --change to if true
print("set up wifi mode")

wifi.setmode(wifi.STATION)
 --please config ssid and password according to settings of your wireless router.
 wifi.sta.config(ssid,password)
 wifi.sta.autoconnect(1)   --wifi.sta.connect()当配置的wifi有效时，NodeMCU便能自动连入
 cnt = 0
 tmr.alarm(1, 5000, 1, function()
  if (wifi.sta.getip() == nil) and (cnt < 20) then
   print("IP unavaiable, Waiting...")
   cnt = cnt + 1
  else
   tmr.stop(1)
   if (cnt < 20) then print("Config done, IP is "..wifi.sta.getip())
    dofile("main.lua")  --do yourself lua
   else print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
   end
  end
 end)
 else
  print("\n")
  print("Please edit 'init.lua' first:")
  print("Step 1: Modify wifi.sta.config() function in line 5 according settings of your wireless router.")
  print("Step 2: Change the 'if false' statement in line 1 to 'if true'.")
 end
else
require("routerset")
print("please open 192.168.4.1 then input ssid and password")
end
