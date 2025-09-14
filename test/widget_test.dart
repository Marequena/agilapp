import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agilapp/core/widgets/app_button.dart';
import 'package:agilapp/core/widgets/app_input.dart';
import 'package:agilapp/core/widgets/app_card.dart';

void main() {
  testWidgets('AppButton renders with label', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: AppButton(label: 'Prueba', onPressed: () {}))));
    expect(find.text('Prueba'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('AppInput renders with label', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AppInput(label: 'Nombre'))));
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('AppCard wraps child', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AppCard(child: Text('Hola')))));
    expect(find.text('Hola'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
