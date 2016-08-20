var UAC = new ActiveXObject("Shell.Application");

if (WScript.Arguments.length == 0) {
    WScript.Echo("Usage:\n    " + WScript.ScriptName + " command args");
    WScript.Quit();
}

var cmdArg = "";
for (i = 1; i < WScript.Arguments.length; i++) {
   cmdArg += WScript.Arguments(i) + " ";
}

// WScript.Echo(WScript.Arguments(0) + cmdArg);
// WshShell= new ActiveXObject("WScript.Shell");
// WScript.Echo(WshShell.CurrentDirectory);


UAC.ShellExecute(WScript.Arguments(0), cmdArg, "", "runas", 1);
