var ws = new ActiveXObject("WScript.Shell");
ws.Run("bin\\outbash.exe --outbash-session -c 'exec sleep 10000000'", 0, false);
