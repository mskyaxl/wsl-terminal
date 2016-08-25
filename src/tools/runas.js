var Shell = new ActiveXObject("Shell.Application");

if (WScript.Arguments.length == 0) {
    WScript.Echo("Usage:\n    " + WScript.ScriptName + " command args");
    WScript.Quit();
}

var cmdArg = "";
for (i = 1; i < WScript.Arguments.length; i++) {
   cmdArg += "\"" + WScript.Arguments(i) + "\" ";
}

Shell.ShellExecute(WScript.Arguments(0), cmdArg, "", "runas", 1);
