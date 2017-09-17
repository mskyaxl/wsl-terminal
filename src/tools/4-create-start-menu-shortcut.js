var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";

lnk = WshShell.CreateShortcut("open-wsl.lnk");
lnk.TargetPath = WshShell.CurrentDirectory + "\\open-wsl.exe";
lnk.Arguments = "-C ~"
lnk.Save()

WshShell.Run("cmd /c move open-wsl.lnk \"%USERPROFILE%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\\"", 0);
