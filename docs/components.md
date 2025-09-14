# Componentes base — Agilapp

Este documento muestra los componentes básicos que implementamos y cómo usarlos.

## AppButton
- Uso: `AppButton(label: 'Guardar', onPressed: () {})`
- Props: `label`, `onPressed`, `outline`.

## AppInput
- Uso: `AppInput(label: 'Nombre')` — usa `TextField` estándar y respeta el `InputDecorationTheme` del `ThemeData`.

## AppCard
- Uso: `AppCard(child: ...)` — contenedor con padding, border radius y sombra sutil.

## Barrel
- Importa todos los widgets con `import 'package:agilapp/core/widgets/widgets.dart';`
