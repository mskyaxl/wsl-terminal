var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";

lnk = WshShell.CreateShortcut("open-wsl-login.lnk");
lnk.TargetPath = WshShell.CurrentDirectory + "\\open-wsl.exe";
lnk.Arguments = "-l"
lnk.Save()

WshShell.Run("cmd /c move open-wsl-login.lnk \"%USERPROFILE%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\\"", 0);
