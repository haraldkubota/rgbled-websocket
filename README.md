# rgbled-websocket
WS2812 LED on NodeMCU, controlled via the web browser

## Contents

* _ws-bridge.sh_ for the TCP-socker to WebSocket bridge as NodeMCU out-of-the-box cannot handle websockets. Listens on localhost:9000. Runs on my desktop.
* _rgbbutton.html_ is the browser's web page. Runs on my desktop and is loaded via file:///[...]/rgbbutton.html
* _rgbnet.lua_ is for the NodeMCU. WS2812 is connected to D4 (default for the ws2812 module). Listens on 192.168.21.123 (the IP of my NodeMCU unit) port 80

## Notes

* Firmware NodeMCU 1.5.4 built by http://nodemcu-build.com/
* ws-tcp-bridge is from https://github.com/andrewchambers/ws-tcp-bridge
* I left a bit debugging in the Lua code as this is not a production-ready code
* I use a Wemos D1 http://www.wemos.cc/ and its WS2812 RGB LED shield modified to use D4 instead of D2

