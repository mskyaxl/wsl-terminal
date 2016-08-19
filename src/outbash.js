var ws = new ActiveXObject("WScript.Shell");
ws.Run("cbwin\\outbash.exe --outbash-session -c 'exec sleep 10000000'", 0, false);