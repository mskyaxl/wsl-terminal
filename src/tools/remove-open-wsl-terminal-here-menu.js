var WshShell = new ActiveXObject("WScript.Shell");

WshShell.RegDelete("HKCU\\Software\\Classes\\Directory\\shell\\open-wsl\\command\\");
WshShell.RegDelete("HKCU\\Software\\Classes\\Directory\\shell\\open-wsl\\");
WshShell.RegDelete("HKCU\\Software\\Classes\\Directory\\Background\\shell\\open-wsl\\command\\");
WshShell.RegDelete("HKCU\\Software\\Classes\\Directory\\Background\\shell\\open-wsl\\");
