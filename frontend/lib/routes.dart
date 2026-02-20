import 'package:go_router/go_router.dart';
import 'package:frontend/view/user/list_user_view.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const UsersView())],
);
