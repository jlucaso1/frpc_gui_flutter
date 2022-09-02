import 'dart:io';

final frpcExecutable = Platform.isWindows ? 'frpc.exe' : 'frpc';

final frpcPath = "frp/$frpcExecutable";
