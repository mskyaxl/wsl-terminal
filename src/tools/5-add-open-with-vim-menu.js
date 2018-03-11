var WshShell = new ActiveXObject("WScript.Shell");

WshShell.CurrentDirectory = "..";
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\vim-in-wsl-terminal\\"
    , "Open with &vim in wsl-terminal", "REG_SZ");
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\vim-in-wsl-terminal\\icon"
    , "\"" + WshShell.CurrentDirectory + "\\vim.exe\"" );
WshShell.RegWrite("HKCU\\Software\\Classes\\*\\shell\\vim-in-wsl-terminal\\command\\"
    , "\"" + WshShell.CurrentDirectory + "\\vim.exe\" \"%1\"", "REG_SZ");
