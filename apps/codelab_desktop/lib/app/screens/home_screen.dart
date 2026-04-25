import 'package:fluent_ui/fluent_ui.dart';

import '../models/workspace_models.dart';
import '../shell/desktop_shell.dart';
import '../state/app_scope.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final project = controller.selectedProject;

    return DesktopShell(
      title: 'Home',
      isHome: true,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2A2420),
                        width: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Создавайте что угодно',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252522),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '/Users/penkovsky_sa/Projects/OpenIdeaLab/CodeLab/${project.name.toLowerCase().replaceAll(' ', '_')}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF94928D),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.branch_fork2,
                        size: 14,
                        color: Color(0xFFA2A09B),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Основная ветка (master)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9A9892),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Последнее изменение ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9D9B96),
                        ),
                      ),
                      Text(
                        '45 минут назад',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D2D29),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: _PromptComposer(
              placeholder:
                  'Спросите что угодно... "Рефакторить эту функцию для лучшей читаемости"',
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptComposer extends StatelessWidget {
  const _PromptComposer({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      height: 184,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8D6D0)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                placeholder,
                style: const TextStyle(fontSize: 14, color: Color(0xFFA0A09A)),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectFile),
                child: const Icon(
                  FluentIcons.add,
                  size: 17,
                  color: Color(0xFF94918B),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.commandPalette),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB6B3AE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    FluentIcons.chevron_up,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectModel),
                child: const Text(
                  'Build',
                  style: TextStyle(fontSize: 14, color: Color(0xFF66645F)),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                FluentIcons.chevron_down,
                size: 10,
                color: Color(0xFF8D8A85),
              ),
              const SizedBox(width: 24),
              const Icon(
                FluentIcons.switch_user,
                size: 14,
                color: Color(0xFF97948F),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectProvider),
                child: const Text(
                  'Big Pickle',
                  style: TextStyle(fontSize: 14, color: Color(0xFF66645F)),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                FluentIcons.chevron_down,
                size: 10,
                color: Color(0xFF8D8A85),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
