// final TextEditingController _serverAddressController =
//       TextEditingController();
//   final TextEditingController _serverPortController = TextEditingController();
//   final TextEditingController _localPortController = TextEditingController();
//   final TextEditingController _remotePortController = TextEditingController();
class FrpcConfig {
  String serverAddress;
  int serverPort;
  int localPort;
  int remotePort;
  String protocol;

  FrpcConfig({
    required this.serverAddress,
    required this.serverPort,
    required this.localPort,
    required this.remotePort,
    required this.protocol,
  });

  FrpcConfig.fromJson(dynamic json)
      : serverAddress = json['serverAddress'],
        serverPort = json['serverPort'],
        localPort = json['localPort'],
        remotePort = json['remotePort'],
        protocol = json['protocol'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverAddress': serverAddress,
        'serverPort': serverPort,
        'localPort': localPort,
        'remotePort': remotePort,
        'protocol': protocol,
      };
}
