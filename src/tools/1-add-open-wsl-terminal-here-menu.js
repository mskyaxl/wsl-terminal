var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\shell\\open-wsl\\", "Open wsl-terminal Here", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\shell\\open-wsl\\Icon", "\"" + WshShell.CurrentDirectory + "\\open-wsl.exe\"", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\shell\\open-wsl\\command\\"
    , "\"" + WshShell.CurrentDirectory + "\\open-wsl.exe\" -W \"%V\"", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\Background\\shell\\open-wsl\\", "Open wsl-terminal Here", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\Background\\shell\\open-wsl\\Icon", "\"" + WshShell.CurrentDirectory + "\\open-wsl.exe\"", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\Directory\\Background\\shell\\open-wsl\\command\\"
    , "\"" + WshShell.CurrentDirectory + "\\open-wsl.exe\"", "REG_SZ");
