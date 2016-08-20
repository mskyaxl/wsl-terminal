var WshShell = new ActiveXObject("WScript.Shell");

if (WScript.Arguments.length == 0) {
    WshShell.CurrentDirectory = "..";
    WshShell.Run("tools\\runas.js wscript \"" + WScript.ScriptFullName + "\" \"" + WshShell.CurrentDirectory + "\\open-wsl.exe\"");
} else {
    WshShell.RegWrite("HKCR\\Directory\\Background\\shell\\open-wsl\\", "Open WSL Here", "REG_SZ");
    WshShell.RegWrite("HKCR\\Directory\\Background\\shell\\open-wsl\\command\\", WScript.Arguments(0), "REG_SZ");
    WshShell.RegWrite("HKCR\\Folder\\shell\\open-wsl\\", "Open WSL Here", "REG_SZ");
    WshShell.RegWrite("HKCR\\Folder\\shell\\open-wsl\\command\\", WScript.Arguments(0), "REG_SZ");
}
