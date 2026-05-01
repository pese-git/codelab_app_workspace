import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/overlay/overlay_controller.dart';
import '../../../workspace/application/workspace_controller.dart';

class OpenProjectDialog extends StatefulWidget {
  const OpenProjectDialog({super.key});

  @override
  State<OpenProjectDialog> createState() => _OpenProjectDialogState();
}

class _OpenProjectDialogState extends State<OpenProjectDialog> {
  String? _selectedPath;
  bool _isLoading = false;
  String? _error;

  Future<void> _pickDirectory() async {
    setState(() {
      _error = null;
    });

    try {
      final result = await FilePicker.getDirectoryPath();
      if (result != null) {
        setState(() {
          _selectedPath = result;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Не удалось выбрать директорию: $e';
      });
    }
  }

  Future<void> _openProject() async {
    final path = _selectedPath;
    if (path == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final workspaceController = context.read<WorkspaceController>();
      final overlayController = context.read<OverlayController>();

      await workspaceController.openProject(path);

      if (mounted) {
        overlayController.close();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Не удалось открыть проект: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final overlayController = context.read<OverlayController>();

    return _OverlayFrame(
      width: 640,
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Открыть проект',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23231F),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: overlayController.close,
                  child: Icon(
                    FluentIcons.chrome_close,
                    size: 16,
                    color: colors.iconMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Выберите директорию проекта для открытия',
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Color(0xFF6B6963),
              ),
            ),
            const SizedBox(height: 24),
            _PathSelector(
              selectedPath: _selectedPath,
              onPick: _pickDirectory,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF5A0A0)),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFC0392B),
                  ),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: overlayController.close,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.borderBase),
                    ),
                    child: const Center(
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _isLoading ? null : _openProject,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: _selectedPath != null && !_isLoading
                          ? const Color(0xFF4F8CFF)
                          : colors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: ProgressRing(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Открыть',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PathSelector extends StatelessWidget {
  const _PathSelector({required this.selectedPath, required this.onPick});

  final String? selectedPath;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderBase),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                selectedPath ?? 'Выберите директорию...',
                style: TextStyle(
                  fontSize: 15,
                  color: selectedPath != null
                      ? colors.textStrong
                      : colors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: onPick,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: colors.accentSubtle,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon.sm(AppIcons.folder, color: colors.iconBase),
                  const SizedBox(width: 8),
                  Text(
                    'Обзор',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textStrong,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayFrame extends StatelessWidget {
  const _OverlayFrame({required this.child, required this.width, this.height});

  final Widget child;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(maxWidth: width, maxHeight: height ?? 860),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8D5CF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}
