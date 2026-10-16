import 'dart:convert';
import 'package:http/http.dart' as http;

/// Point this to your FastAPI (Termux or server).
/// Example: http://192.168.1.5:8000
const String kApiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://10.0.2.2:8000', // Android emulator → host
);

class ApiClient {
  final String base = kApiBase;

  Future<Map<String, dynamic>> health() async {
    final r = await http.get(Uri.parse('$base/health'));
    if (r.statusCode != 200) throw Exception('health ${r.statusCode}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> stops() async {
    final r = await http.get(Uri.parse('$base/stops'));
    if (r.statusCode != 200) throw Exception('stops ${r.statusCode}');
    return jsonDecode(r.body) as List<dynamic>;
  }

  Future<List<dynamic>> openOrders() async {
    final r = await http.get(Uri.parse('$base/orders/open'));
    if (r.statusCode != 200) throw Exception('open ${r.statusCode}');
    return jsonDecode(r.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> createOrder({
    required String phone,
    required String itemsText,
    String deliveryType = 'stop',
    String? stopSlug,
    String? stopName,
    String? homeNote,
    String payMethod = 'cod',
  }) async {
    final r = await http.post(
      Uri.parse('$base/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'itemsText': itemsText,
        'deliveryType': deliveryType,
        'stopSlug': stopSlug,
        'stopName': stopName,
        'homeNote': homeNote,
        'payMethod': payMethod,
      }),
    );
    if (r.statusCode != 201 && r.statusCode != 200) {
      throw Exception('create ${r.statusCode} ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> accept(String id, {String riderName = 'Rider'}) async {
    final r = await http.post(
      Uri.parse('$base/orders/$id/accept?riderName=$riderName'),
    );
    if (r.statusCode != 200) throw Exception('accept ${r.statusCode}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
