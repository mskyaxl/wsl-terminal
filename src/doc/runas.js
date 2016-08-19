var UAC = new ActiveXObject("Shell.Application");
// WshShell= new ActiveXObject("WScript.Shell");

var cmdArg = "";
for (i = 1; i < WScript.Arguments.length; i++)
{
   cmdArg += WScript.Arguments(i) + " ";
}

// WScript.Echo(WScript.Arguments(0) + cmdArg);
// WScript.Echo(WshShell.CurrentDirectory);


UAC.ShellExecute(WScript.Arguments(0), cmdArg, "", "runas", 1);