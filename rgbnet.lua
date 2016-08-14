-- Listen on a socker (port 80)
-- and set the WS2812 LED accordingly.
-- Initialize with (0,0,0)

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h is [0..359], s and v are contained in the set [0..255][0..359]
 * returns r, g, and b in the set [0..255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
function hsvToRgb(h, s, v)
    local r, g, b, base
    local h2
    
    if h > 359 then h = h % 360 end
    if s == 0 then
        r, g, b = v, v, v
    else
        base = ((255 - s) * v) / 256
        h2 = h / 60
        if h2 == 0 then
            r=v
            g=(((v-base)*h)/60)+base
            b=base
        elseif h2 == 1 then
            r=(((v-base)*(60-(h%60)))/60)+base
            g=v
            b=base
        elseif h2 == 2 then
            r=base
            g=v
            b=(((v-base)*(h%60))/60)+base
        elseif h2 == 3 then
            r=base
            g=(((v-base)*(60-(h%60)))/60)+base
            b=v
        elseif h2 == 4 then
            r = (((v-base)*(h%60))/60)+base
            g = base
            b = v
        elseif h2 == 5 then
            r = v
            g = base
            b = (((v-base)*(60-(h%60)))/60)+base
        end
    end
  return r, g, b
end

local red, green, blue
red=0
green=0
blue=0

function setLEDHSV(h, s, v)
    local r, g, b = hsvToRgb(h, s, v)
    setLEDRGB(r, g, b)
end

function setLEDRGB(r, g, b)
    print("R=", r," G=", g, " B=", b)
    ws2812.write(string.char(g, r, b))
end

function setOneColor(c, v)
    -- print("Color "..c.." done, value "..v)
    if color=='R' then
        red=v
    elseif color=='G' then
        green=v
    elseif color=='B' then
        blue=v
    end
end

--tmr.alarm(0, 100, tmr.ALARM_AUTO, setLED)

ws2812.init()

setLEDRGB(red, green, blue)
srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(conn, payload)
        -- print("Payload: " .. payload)
        local n, c, value, state=0, color
        for n=1,payload:len(),1 do
            c=payload:sub(n, n)
            if (c>='0' and c<='9') then
                if state==1 then
                    value=value*10+c:byte(1)-48
                end
            else
                if state==1 then
                    setOneColor(color, value)
                    state=0
                end
                if c=='R' or c=='G' or c=='B' then
                    color=c
                    value=0
                    state=1
                end
            end
        end
        if state==1 then
            setOneColor(color, value)
        end
        pcall(function()
            setLEDRGB(red, green, blue)
            end)
-- Does not seem to work well for TCP-to-WS bridge
--        ok, json=pcall(cjson.encode, {topic="status", data="R" .. r .. "G" .. g .. "B" .. b})
--        if ok then
--            conn:send(json)
--            print(json)
--        else
--            print("Could not cjson.encode")
--        end
        conn:send("ok R"..red.."G"..green.."B"..blue.."\r\n")
        end)
    end)
