import 'package:flutter_test/flutter_test.dart';
import 'package:chowkride/main.dart';

void main() {
  testWidgets('app loads role gate', (tester) async {
    await tester.pumpWidget(const ChowkRiderApp());
    expect(find.text('ChowkRider'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Rider'), findsOneWidget);
  });
}
