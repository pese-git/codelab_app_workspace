# OpenCode Reference Audit

This note captures the first-pass UI inventory from `reference/opencode` and maps it to the Flutter desktop prototype.

## Primary screens

- `packages/app/src/pages/home.tsx`: home screen with recent projects, open project actions and server entry point.
- `packages/app/src/pages/layout.tsx` plus `pages/layout/*`: desktop shell, project rail, workspace sidebar and sidebar item interactions.
- `packages/app/src/pages/session.tsx`: session workspace with timeline, prompt composer, file/review/terminal regions and side panel.
- `packages/app/src/pages/directory-layout.tsx`: project-scoped layout state and navigation shell behavior.

## Secondary panels and reusable surfaces

- `components/titlebar.tsx`: custom top bar and navigation controls.
- `components/prompt-input.tsx` and `components/prompt-input/*`: composer, attachments, slash popover and drag overlay.
- `components/session/session-header.tsx`: session header actions and model controls.
- `pages/session/file-tabs.tsx`, `review-tab.tsx`, `terminal-panel.tsx`, `session-side-panel.tsx`: region tabs and right context panel.
- `components/file-tree.tsx`: workspace tree and expand/collapse states.

## Dialogs and overlays in scope

- Settings
- Select directory
- Select file
- Select model
- Select provider
- Select MCP
- Select server
- Edit project
- Fork session
- Help
- Release notes
- Command palette style surface

## State matrix

- Empty: home without projects, new session, no file selection.
- Active: selected project, selected session, active region tab, active context panel tab.
- Expanded: workspace tree nodes, visible sidebar, visible right context panel.
- Overlay: one modal surface visible at a time via shared dialog host.
- Mock interactive state: project/session selection, region tabs, dialog visibility, provider/model/server choices.
