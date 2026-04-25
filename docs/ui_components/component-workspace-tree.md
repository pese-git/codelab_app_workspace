# Workspace Tree

## 1. Назначение и контекст

Workspace Tree — древовидное представление файловой структуры проекта:
- Иерархия папок и файлов
- Expand/collapse для папок
- Badge для дополнительной информации

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/widgets/workspace_tree.dart`](../../apps/codelab_desktop/lib/app/widgets/workspace_tree.dart)

**Референс OpenCode:** [`reference/opencode/packages/app/src/components/file-tree.tsx`](../../reference/opencode/packages/app/src/components/file-tree.tsx)

---

## 2. Состав и layout

```
📁 lib                    [4]
  📁 app
    📁 screens
      📄 home_screen.dart
      📄 session_screen.dart
    📁 widgets
      📄 workspace_tree.dart
  📄 main.dart
📄 pubspec.yaml
```

### Flutter реализация (WorkspaceTree)
```dart
Column
└── For each node:
    └── _WorkspaceNodeRow(node, depth)

_WorkspaceNodeRow
└── Column
    ├── GestureDetector
    │   └── Container (row)
    │       └── Row
    │           ├── Icon (chevron or page)
    │           ├── Icon (folder or file)
    │           ├── Text (label)
    │           └── Container (badge)
    └── if expanded:
        └── Padding
            └── WorkspaceTree(node.children, depth + 1)
```

### Референс OpenCode (FileTree)
- Виртуализированный список
- Drag-drop support
- Context menu
- Git status indicators
- Search/filter
- Inline rename
- Multi-select

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Folder expanded | ✅ | ✅ | Папка раскрыта |
| Folder collapsed | ✅ | ✅ | Папка свернута |
| File | ✅ | ✅ | Файл (leaf node) |
| Selected | ❌ | ✅ | Выбранный элемент |
| Hover | ❌ | ✅ | Наведение |
| Dragging | ❌ | ✅ | Перетаскивание |
| Drop target | ❌ | ✅ | Цель для drop |
| Git modified | ❌ | ✅ | Изменен в git |
| Git added | ❌ | ✅ | Добавлен в git |
| Git deleted | ❌ | ✅ | Удален в git |
| Loading | ❌ | ✅ | Загрузка содержимого |

---

## 4. Пропсы/параметры

### Flutter (WorkspaceTree)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `nodes` | List<WorkspaceNode> | Список узлов |
| `depth` | int | Глубина вложенности (default: 0) |

### Flutter (_WorkspaceNodeRow)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `node` | WorkspaceNode | Узел дерева |
| `depth` | int | Глубина вложенности |

### WorkspaceNode model
```dart
class WorkspaceNode {
  final String id;
  final String label;
  final bool isFolder;
  final List<WorkspaceNode> children;
  final String? badge;
}
```

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `isNodeExpanded(nodeId)` | bool | Узел раскрыт |
| `toggleNode(nodeId)` | void | Переключить expand |

### Референс OpenCode (FileTree)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `items` | FileItem[] | Файлы и папки |
| `selected` | string[] | Выбранные |
| `expanded` | Set<string> | Раскрытые |
| `onSelect` | callback | Выбор элемента |
| `onExpand` | callback | Раскрытие |
| `onDrop` | callback | Drag-drop |

---

## 5. Стили/токены

### Flutter
```dart
// Row container
margin: EdgeInsets.symmetric(vertical: 2)
padding: EdgeInsets.fromLTRB(10 + depth * 14, 6, 10, 6)
borderRadius: 7

// Chevron icon
size: 10
color: Color(0xFF8F8F8B)

// Folder/File icon
size: 13
color: Color(0xFF787874)

// Label text
fontSize: 13
color: Color(0xFF4E4E49)

// Badge
padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2)
background: Color(0xFFE9E8E4)
borderRadius: 999
text: fontSize 11, color Color(0xFF676762)

// Indentation per level
14px
```

### Референс OpenCode
```css
/* Tree container */
flex-1
overflow-auto

/* Row */
h-7
px-2
rounded-md
hover:bg-surface-subtle

/* Selected row */
bg-surface-accent

/* Indent */
pl-[var(--indent)]
--indent-step: 12px

/* Icon */
w-4 h-4
text-icon-base

/* File icon by extension */
.dart → dart icon
.ts → typescript icon
.json → json icon

/* Git status */
text-icon-success-base  /* added */
text-icon-warning-base  /* modified */
text-icon-critical-base /* deleted */
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Toggle folder | ✅ tap → toggleNode() | ✅ |
| Select file | ❌ | ✅ → open in editor |
| Double-click | ❌ | ✅ → open/rename |
| Context menu | ❌ | ✅ Right-click |
| Drag file | ❌ | ✅ |
| Drop into folder | ❌ | ✅ |
| Multi-select | ❌ | ✅ Shift/Cmd click |
| Keyboard nav | ❌ | ✅ Arrow keys |
| Search/filter | ❌ | ✅ |
| Inline rename | ❌ | ✅ F2 |
| Create file | ❌ | ✅ Context menu |
| Delete file | ❌ | ✅ Context menu |
| Copy path | ❌ | ✅ Context menu |

---

## 7. Маршрутизация

Workspace Tree не влияет на маршрутизацию напрямую, но:
- Click на файл может открыть его в editor tabs

---

## 8. Интеграция с диалогами

Нет прямой интеграции, но в будущем:
- Create file dialog
- Rename dialog
- Delete confirmation

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Древовидная структура
- Expand/collapse папок
- Иконки файлов/папок
- Badge на папках
- Indentation по глубине

### ❌ Не реализовано
- File selection
- Click → open in editor
- Context menu
- Drag-drop
- Git status indicators
- Search/filter
- Inline rename
- Multi-select
- Keyboard navigation
- Hover states
- Виртуализация для больших деревьев

---

## 10. TODO/гап-анализ

### High Priority
- [ ] File selection state
- [ ] Click → open in editor (когда появятся tabs)
- [ ] Hover states

### Medium Priority
- [ ] Context menu (create, rename, delete, copy path)
- [ ] Git status indicators
- [ ] Search/filter

### Low Priority
- [ ] Drag-drop
- [ ] Multi-select
- [ ] Keyboard navigation
- [ ] Виртуализация
- [ ] Inline rename

---

## 11. Оптимизации

### Виртуализация для больших деревьев
```dart
// Использовать ListView.builder вместо Column
ListView.builder(
  itemCount: flattenedNodes.length,
  itemBuilder: (context, index) {
    final node = flattenedNodes[index];
    return _WorkspaceNodeRow(node: node, depth: node.depth);
  },
)
```

### Lazy loading
```dart
// Загружать содержимое папки при expand
void toggleNode(String nodeId) async {
  if (!isNodeExpanded(nodeId)) {
    await loadNodeChildren(nodeId);
  }
  // toggle expand
}
```
