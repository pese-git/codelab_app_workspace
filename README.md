# codelab_app_workspace

Монорепозиторий Flutter с использованием FVM и Melos.

## Требования

- FVM (Flutter Version Manager)
- Melos (`dart pub global activate melos` или `flutter pub global activate melos`)

## Подготовка окружения

```bash
# установить версию Flutter из .fvmrc
fvm install

# использовать версию в рабочей директории
fvm use

# установить зависимости во всех пакетах через melos
melos bootstrap
```

## Основные команды

```bash
# статический анализ
melos analyze

# форматирование
melos format

# тесты
melos test

# очистка артефактов
melos clean
```

## Структура

```
codelab_app_workspace
├── apps/       # приложения (например, codelab_desktop)
├── packages/   # общие пакеты (например, codelab_ui_components)
├── melos.yaml  # конфигурация Melos
├── .fvmrc      # целевая версия Flutter
└── pubspec.yaml
```
