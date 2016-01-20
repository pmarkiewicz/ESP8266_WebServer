-- tiny web service
file.open("httpd.lua", "w")

file.writeline([==[
icon = [[iVBORw0KGgoAAAANSUhEUgAAABAAAAAQEAYAAABPYyMiAAAABmJLR0T
///////8JWPfcAAAACXBIWXMAAABIAAAASABGyWs
+AAACbUlEQVRIx7WUsU/qUBTGv96WSlWeEBZijJggxrREdwYixMnByYEyOvg
fsBAMG0xuDsZ/QGc3NDFhgTioiYsmkhBYGLSBkLYR0va8gSjvQXiIT7/l5ibf
Od/v3pN7gSmVSMTj8ThRfzdYk8lkMpl83/+AVFVVVXU0eHiVJEmSpB8DIcpkMp
lsdhCYz+fzhQJROBwOh8PDQN+oQCAQCASIRFEURZHI45GkP0/e7Xa73e70AMJnj
el0Op1OA6oaDB4eAkAw6PcDvZ5t6zrw/Hx2trAw/cHYZ426ruu6DtzcGEYuBzQa1
9etFvD4WKtls4AoRqMPDwBjjLGPrt84ilgsFovF6EOapmmaRiP6O/jbAIguL4vFYp
HGqlKpVCoVomq1Wq1Wibxer9fn+w+Q9+cUiUQikQhNrfdgWZZlWf4yyGhj27Zt254M
UK/X6/X6F0aiKIqiKIOCYRmGYRjGZADLsizLIgqFQqHV1SkAnp5OTn79ItK0qyuPZ7S
xaZqmaU4GKJfPzxmbfAPc/f3pqaIQLS8vLtZqgOP0bYyJoiAARC5Xrwf4/Vtbb2+Th1Y
qlUqlErC01GgkEkCz2WxyHLC+LsuiCAiCJLlcgM+3vd3pcBzXaJTLR0dEs7Ptdv+D4TiO
G/A6DsBxQKvV621sAGtru7vl8ngAjuvXv7xcXIgiwNjMjCj2h+k4fQfPA4LA8xwHCO323V
2hABiG223bwPy8xwMAbvfcHGMAY32j47y+3t4OAsZpZ2dzEwAsy7IcBxAExhwHMIxOx3GAl
ZVUyjT/1WFIudzenstFlEpFo9M8o+Pj/X2eJzo4SCR4fnzdb2N4Pyv9cduVAAAAAElFTkSuQ
mCC]]

-- LED
pin = 4 
gpio.mode(pin, gpio.OUTPUT)

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local _, _, vars = string.find(request, "GET /?(.+) HTTP");
        local _GET = {}
        if (vars ~= '/')then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        
        local buf = "";
        tm = tmr.time()
        h = tm / 3600
        tm = tm % 3600
        m = tm / 60
        s = tm % 60
        buf = [[<html><head><link rel='icon' type='image/x-icon' href='data:image/x-icon;base64,]]
        buf = buf..icon
        buf = buf..[['></head><body><h1> ESP8266 Web Server</h1><br>]]
        buf = buf..h..":"..m..":"..s
        buf = buf..[[<p>LED <a href="?led=ON"><button>ON</button></a>&nbsp;<a href="?led=OFF"><button>OFF</button></a></p>
        </body></html>]]
        client:send(buf);
        client:close();
        if (_GET.led == 'ON') then
          gpio.write(pin, gpio.LOW)
        else
          gpio.write(pin, gpio.HIGH)
        end
        collectgarbage();
    end)
end)

]==])

file.close()
