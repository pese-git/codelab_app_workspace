import '../models/workspace_models.dart';

WorkspaceData buildMockWorkspace() {
  return WorkspaceData(
    models: const ['GPT-5.5', 'GPT-5.4', 'o4-mini'],
    providers: const ['OpenAI', 'Anthropic', 'OpenRouter'],
    mcps: const ['Filesystem', 'Figma', 'Postgres'],
    servers: const ['Local Agent', 'Remote Team Relay', 'CI Preview'],
    projects: [
      ProjectModel(
        id: 'project-codelab',
        name: 'acp-protocol',
        path: '~/Projects/OpenIdeaLab/CodeLab/acp-protocol',
        initials: 'A',
        color: 0xFF4F8CFF,
        workspaceRoots: [
          WorkspaceNode(
            id: 'workspace-app',
            label: 'apps',
            kind: 'folder',
            children: [
              WorkspaceNode(
                id: 'workspace-desktop',
                label: 'codelab_desktop',
                kind: 'folder',
                badge: 'active',
                children: [
                  WorkspaceNode(id: 'workspace-lib', label: 'lib', kind: 'folder'),
                  WorkspaceNode(id: 'workspace-test', label: 'test', kind: 'folder'),
                  WorkspaceNode(id: 'workspace-plan', label: 'IMPLEMENTATION_PLAN.md', kind: 'file'),
                ],
              ),
            ],
          ),
          WorkspaceNode(
            id: 'workspace-reference',
            label: 'reference',
            kind: 'folder',
            children: [
              WorkspaceNode(id: 'workspace-opencode', label: 'opencode', kind: 'folder'),
            ],
          ),
        ],
        sessions: [
          SessionModel(
            id: 'session-shell',
            title: 'Greeting in Russian conversation context',
            branchName: 'local/master',
            updatedLabel: '2 min ago',
            status: 'In progress',
            messages: [
              MessageModel(
                id: 'm1',
                author: 'You',
                role: 'user',
                timestamp: '19:54',
                body: 'Привет',
                tags: const ['plan', 'flutter'],
              ),
              MessageModel(
                id: 'm2',
                author: 'Codex',
                role: 'assistant',
                timestamp: '19:56',
                body: 'Привет! Чем могу помочь?',
                tags: const ['audit'],
              ),
              MessageModel(
                id: 'm3',
                author: 'Codex',
                role: 'assistant',
                timestamp: '20:03',
                body:
                    'Прочитал. Это README проекта CodeLab — унифицированная реализация Agent Client Protocol (ACP). Включает сервер с AI-агентом, TUI-клиент и Web UI на Python 3.12+.\n\nДля запуска: cd codelab && uv sync, затем uv run codelab serve --port 8080.\n\nЧем могу помочь?',
                tags: const ['state', 'ui'],
              ),
            ],
            fileItems: [
              FileItem(
                path: '.pytest_cache',
                summary: 'cache',
                status: '',
              ),
              FileItem(
                path: '.ruff_cache',
                summary: 'cache',
                status: '',
              ),
              FileItem(
                path: 'README.md',
                summary: 'docs',
                status: '',
              ),
            ],
            reviewItems: [
              ReviewItem(
                title: 'Sidebar density',
                summary: 'Project rail and workspace tree now align with desktop layout, but the collapsed state still needs a tighter hover affordance.',
                severity: 'P2',
              ),
              ReviewItem(
                title: 'Dialog coverage',
                summary: 'All major modal surfaces are represented as mock overlays with shared presentation logic.',
                severity: 'P3',
              ),
            ],
            terminalEntries: [
              TerminalEntry(
                label: 'flutter analyze',
                command: 'flutter analyze',
                state: 'queued',
              ),
              TerminalEntry(
                label: 'flutter test',
                command: 'flutter test',
                state: 'queued',
              ),
            ],
            metrics: [
              MetricItem(label: 'Context', value: '48k / 128k'),
              MetricItem(label: 'Changes', value: '12 files'),
              MetricItem(label: 'Dialogs', value: '11 ready'),
            ],
          ),
          SessionModel(
            id: 'session-home',
            title: 'Home screen empty states',
            branchName: 'main',
            updatedLabel: '28 min ago',
            status: 'Ready',
            messages: [
              MessageModel(
                id: 'm4',
                author: 'Design',
                role: 'user',
                timestamp: '18:32',
                body: 'Нужно воспроизвести home view с recent projects и open project actions.',
              ),
            ],
            fileItems: [
              FileItem(
                path: 'lib/app/screens/home_screen.dart',
                summary: 'Home view with recent projects and server quick action',
                status: 'planned',
              ),
            ],
            reviewItems: const [],
            terminalEntries: const [],
            metrics: [
              MetricItem(label: 'Recent', value: '5 projects'),
              MetricItem(label: 'Empty states', value: '2'),
            ],
          ),
        ],
      ),
      ProjectModel(
        id: 'project-ideas',
        name: 'Idea Archive',
        path: '~/Projects/OpenIdeaLab/Ideas',
        initials: 'IA',
        color: 0xFF58C27D,
        workspaceRoots: [
          WorkspaceNode(id: 'ideas-src', label: 'notes', kind: 'folder'),
          WorkspaceNode(id: 'ideas-assets', label: 'screenshots', kind: 'folder'),
        ],
        sessions: [
          SessionModel(
            id: 'session-research',
            title: 'Reference UI inventory',
            branchName: 'research/opencode-map',
            updatedLabel: '1 h ago',
            status: 'Paused',
            messages: [
              MessageModel(
                id: 'm5',
                author: 'Codex',
                role: 'assistant',
                timestamp: '17:42',
                body: 'Каталогизировал страницы, overlays и reusable UI primitives из `packages/app` и `packages/ui`.',
              ),
            ],
            fileItems: [
              FileItem(
                path: 'docs/reference-audit.md',
                summary: 'Screens, dialogs and state matrix',
                status: 'draft',
              ),
            ],
            reviewItems: const [],
            terminalEntries: const [],
            metrics: [
              MetricItem(label: 'Screens', value: '4'),
              MetricItem(label: 'Dialogs', value: '11'),
            ],
          ),
        ],
      ),
    ],
  );
}
