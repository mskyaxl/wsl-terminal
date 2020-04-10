var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\emacs-in-wsl-terminal\\"
    , "Open with &emacs in wsl-terminal", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\emacs-in-wsl-terminal\\icon"
    , "\"" + WshShell.CurrentDirectory + "\\emacs.exe\"" );
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\emacs-in-wsl-terminal\\command\\"
    , "\"" + WshShell.CurrentDirectory + "\\emacs.exe\" \"%1\"", "REG_SZ");
