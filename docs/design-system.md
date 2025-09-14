# Guía de diseño — Agilapp (ERP)

Esta guía define un sistema de diseño minimalista, profesional y amigable para una aplicación ERP. Incluye paleta de colores, tipografía, espaciado, componentes básicos, consideraciones de accesibilidad y un ejemplo de `ThemeData` para Flutter.

## Principios
- Minimalismo funcional: Priorizar la información y reducir ruido visual.
- Legibilidad: tipografía clara y tamaños consistentes.
- Jerarquía clara: uso de color y espacio para guiar al usuario.
- Profesional y accesible: contraste y estados visibles.

## Paleta de colores (tokens)

- Primario: Teal profundo — #0EA5A4
- On Primary (texto sobre primario): #FFFFFF
- Secundario / Accent: Coral — #FF6B6B
- On Secondary: #FFFFFF
- Fondo: Neutral claro — #F7F8FB
- Superficie / Card: #FFFFFF
- Texto Primario (high-emphasis): #0F172A
- Texto Secundario: #475569
- Border / Divider: #E6E9F2
- Éxito: #16A34A
- Warning: #F59E0B
- Error: #DC2626
- Info: #2563EB

Nota: Para escalas tonales (50..900) recomendamos generar variantes claras/oscura con una herramienta de tokens (Figma Tokens, Tailwind shades) o usando `ColorScheme.fromSeed` en Flutter para iterar.

## Tipografía
- Familia recomendada: Inter (moderna, legible) o Roboto si prefieres paquete por defecto.
- Escala (px) y uso:
  - display / h1: 32 — peso 600
  - h2: 24 — peso 600
  - h3: 20 — peso 600
  - subtitle / h4: 16 — peso 500
  - body1: 14 — peso 400
  - body2 / caption: 12 — peso 400

Reglas: usar tamaños mayores para títulos y acciones; evitar más de dos familias de fuente en la app.

## Espaciado y layout
- Baseline: 8pt (múltiplos: 4, 8, 12, 16, 24, 32...)
- Grid: 12 columnas en pantallas grandes; responsivo con breakpoints (mobile <600, tablet 600–1024, desktop >1024)
- Margen interno estándar: 16px en listas y formularios.

## Componentes básicos

- Botones:
  - Primary (filled): fondo primario, texto onPrimary, borde none, elevación 0 o 1.
  - Ghost (text): fondo transparente, texto primario.
  - Outline: borde 1px con color border.

- Input / Form:
  - Prefija con label + hint; states: normal, focus (outline primario), error (outline error) y disabled.

- Cards:
  - Fondo surface, corner radius 8, sombra sutil (elevation 1).

- Tablas/Listados:
  - Encabezados claros, filas con padding 12–16, acciones en columna derecha.

## Estados y retroalimentación
- Success: verde; Warning: amarillo-naranja; Error: rojo; Info: azul.
- Toasts y snackbars: usar fondo oscuro / texto claro o fondo surface con borde según contexto.

## Accesibilidad
- Contraste mínimo 4.5:1 para texto normal, 3:1 para texto grande.
- Tamaño mínimo objetivo táctil: 44x44 pts.
- Visibilidad de foco (outline) y soporte para lectores de pantalla en componentes form.

## Tokens y nombres (ejemplo)
- colorPrimary: #0EA5A4
- colorPrimaryVariant: #0B9A94
- colorOnPrimary: #FFFFFF
- colorBackground: #F7F8FB
- textPrimary: #0F172A

## Ejemplo rápido: cómo aplicar en Flutter

Coloca el snippet de `design_system.dart` en `lib/core/theme/` y usa `ThemeData` exportado en `MaterialApp.theme`.

## Próximos pasos
- Convertir tokens a un archivo Dart (hecho: `design_system.dart`).
- Implementar componentes comunes (button, input, card) como widgets reutilizables.
- Añadir tests de contraste y un demo page con muestras de componentes.

---
Guía minimalista creada para Agilapp — Si quieres que genere los componentes base (Button, Input, Card) los creo y los testeo en la app.
