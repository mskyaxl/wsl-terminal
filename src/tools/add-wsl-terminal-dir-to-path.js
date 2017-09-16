var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";

var path = WshShell.RegRead("HKEY_CURRENT_USER\\Environment\\Path");

if (path.indexOf(WshShell.CurrentDirectory) >= 0) {
    WScript.Echo(WshShell.CurrentDirectory + " is already in Path.\n\nPath:\n\n" + path);
    WScript.Quit();
}

if (path.charAt(path.length - 1) != ";") {
    path += ";"
}
path += WshShell.CurrentDirectory;

WshShell.Run("setx Path \"" + path + "\"", 0);
WScript.Echo("OK\n\nCurrent Path:\n\n" + path);
