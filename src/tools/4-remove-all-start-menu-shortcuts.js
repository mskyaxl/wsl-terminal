var WshShell = new ActiveXObject("WScript.Shell");

WshShell.Run("cmd /c del \"%USERPROFILE%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\open-wsl*.lnk\"", 0);
