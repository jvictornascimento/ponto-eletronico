import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_eletronico/main.dart';

void main() {
  testWidgets('shows the app shell', (tester) async {
    await tester.pumpWidget(const PontoEletronicoApp());

    expect(find.text('Ponto Eletronico'), findsOneWidget);
    expect(find.text('Mini ponto offline'), findsOneWidget);
  });
}
