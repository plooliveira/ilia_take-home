import 'package:ctrl/ctrl.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/api/http_client.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/view/user/list/user_controller.dart';
import 'package:frontend/view/user/create/user_form_controller.dart';

void main() {
  Locator().registerLazySingleton<ApiClient>((_) => HttpApiClient(debug: true));
  Locator().registerFactory<UserRepository>(
    (i) => UserRepository(apiClient: i()),
  );
  Locator().registerFactory<UserCtrl>((i) => UserCtrl(userRepository: i()));
  Locator().registerFactory<UserFormCtrl>(
    (i) => UserFormCtrl(userRepository: i()),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
