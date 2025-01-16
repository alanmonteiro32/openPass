import 'package:my_app/app/app.dart';
import 'package:my_app/bootstrap.dart';
import 'package:my_app/injection_container.dart' as di;
void main() {
  di.init();
  bootstrap(() => const App());
}