import 'package:fluent_ui/fluent_ui.dart';

class WindowShell extends StatelessWidget {
  const WindowShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
