import 'package:flutter_test/flutter_test.dart';
import 'package:anshul_portfolio/main.dart';

void main() {
  testWidgets('Witcher Portfolio smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AnshulPortfolioApp());
    expect(find.byType(AnshulPortfolioApp), findsOneWidget);
  });
}
