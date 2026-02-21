import 'dart:io';

import 'api_config.dart';

class PlatformApiClientConfig implements ApiConfig {
  @override
  String get baseUrl =>
      Platform.isAndroid ? 'http://10.0.2.2:3000/' : 'http://localhost:3000/';
}
