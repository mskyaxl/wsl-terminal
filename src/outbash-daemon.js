var ws = new ActiveXObject("WScript.Shell");
ws.Run("bin\\outbash.exe --outbash-session -c 'exec sleep 10000000'", 0, false);

// If no need of outbash.exe, run a sleep to avold all WSL processes being killed.
// ws.Run("bash -c 'sleep 10000000'", 0, false);
