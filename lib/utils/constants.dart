import 'dart:io';

import 'package:path_provider/path_provider.dart';

final frpcExecutable = Platform.isWindows ? 'frpc.exe' : 'frpc';

final frpcPath = isMobile
    ? Future(() => "frp/$frpcExecutable")
    : Future(() => "frp/$frpcExecutable");

final isMobile = Platform.isAndroid || Platform.isIOS;
