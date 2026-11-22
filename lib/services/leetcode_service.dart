import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leetcode_stats.dart';
import 'dandelion_service.dart';

class LeetCodeFrontendService {
  static Future<LeetCodeStats> fetchStats() async {
    try {
      final response = await http
          .get(Uri.parse(DandelionService.leetCodeApiUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Map<String, dynamic>) {
          return LeetCodeStats.fromJson(data);
        }
      }
    } catch (_) {
      // Backend offline or timeout -> return verified fallback data
    }
    return LeetCodeStats.fallback();
  }
}
