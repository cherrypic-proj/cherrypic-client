import 'package:go_router/go_router.dart';
import 'package:cherrypic/core/router/route_path.dart';

class NavigationService {
  static GoRouter? _router;

  static void initialize(GoRouter router) {
    _router = router;
  }

  static void navigateToLogin() {
    if (_router != null) {
      _router!.go(RoutePath.login);
      print('로그인 화면으로 이동');
    } else {
      print('라우터가 초기화되지 않음');
    }
  }
}
