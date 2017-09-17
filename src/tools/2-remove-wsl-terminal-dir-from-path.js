var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";

var path = WshShell.RegRead("HKEY_CURRENT_USER\\Environment\\Path");

if (path.indexOf(WshShell.CurrentDirectory) < 0) {
    WScript.Echo(WshShell.CurrentDirectory + " is not in Path.\n\nPath:\n\n" + path);
    WScript.Quit();
}

path = path.replace(WshShell.CurrentDirectory, "").replace(";;", ";");

WshShell.Run("setx Path \"" + path + "\"", 0);
WScript.Echo("OK\n\nCurrent Path:\n\n" + path);
