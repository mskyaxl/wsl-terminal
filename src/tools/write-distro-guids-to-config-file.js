var WshShell = new ActiveXObject("WScript.Shell");
var FSO = new ActiveXObject("Scripting.FileSystemObject");

var objExec = WshShell.Exec("cmd /c reg query HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Lxss\\");
var output = objExec.StdOut.ReadAll().split("\r\n");

var result = "";

for (var i = 0; i < output.length; ++i) {
    var lxssPos = output[i].indexOf("Lxss\\{");

    if (lxssPos < 0) {
        continue;
    }

    var name = WshShell.RegRead(output[i] + "\\DistributionName");
    var guid = output[i].substr(lxssPos + 5);

    result += "\r\n; " + name + "\r\n;distro_guid=" + guid + "\r\n";
}

if (result == "") {
    WScript.Echo("No distros found.");
    WScript.Quit();
}

conf = "..\\etc\\wsl-terminal.conf";
if (!FSO.FileExists(conf)) {
    WScript.Echo("Config file " + conf + " not found.\n\nResult:\n"
        + result + "\nPress ctrl + c to copy the result.");
    WScript.Quit();
}

var file = FSO.OpenTextFile(conf, 8, false);
file.Write(result);
file.Close();
WScript.Echo("result has been written to ..\\etc\\wsl-terminal.conf:\n"
    + result + "\nremove the ; before distro_guid to use the distro.");
