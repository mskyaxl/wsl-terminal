var WshShell = new ActiveXObject("WScript.Shell");

if (WScript.Arguments.length == 0) {
    WshShell.Run("runas.js wscript \"" + WScript.ScriptFullName + "\" delete");
} else {
    WshShell.RegDelete("HKCR\\Directory\\Background\\shell\\open-wsl\\command\\");
    WshShell.RegDelete("HKCR\\Directory\\Background\\shell\\open-wsl\\");
    WshShell.RegDelete("HKCR\\Folder\\shell\\open-wsl\\command\\");
    WshShell.RegDelete("HKCR\\Folder\\shell\\open-wsl\\");
}
