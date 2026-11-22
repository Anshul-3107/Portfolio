import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String sender; // 'user' or 'dandelion'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'text': text,
      };
}

class DandelionService {
  // In development, talks to local Django at 127.0.0.1:8001.
  // In production, uses --dart-define=BACKEND_BASE_URL=https://... or defaults to deployed cloud URL.
  static String get backendBaseUrl {
    const customUrl = String.fromEnvironment('BACKEND_BASE_URL');
    if (customUrl.isNotEmpty) {
      return customUrl;
    }
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host == 'localhost' || host == '127.0.0.1') {
        return 'http://127.0.0.1:8001';
      }
    }
    // Deployed Railway URL
    return 'https://portfolio-production-58530079.up.railway.app';
  }

  static String get backendApiUrl => '$backendBaseUrl/api/chat/';
  static String get leetCodeApiUrl => '$backendBaseUrl/api/leetcode/';

  static Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
  }) async {
    try {
      final payload = {
        'message': message,
        'history': history.map((m) => m.toJson()).toList(),
      };

      final response = await http
          .post(
            Uri.parse(backendApiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 14));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['reply'];
        if (reply != null && reply.toString().trim().isNotEmpty) {
          return reply.toString().trim();
        }
      }
    } catch (_) {
      // Backend is offline or unreachable - seamlessly fallback to local lore archive
    }

    return _fallbackResponse(message);
  }

  static String _fallbackResponse(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('fraud') || msg.contains('fraudlens')) {
      return "*Plucks a grand, sweeping chord on the lute!*\n\n"
          "Ah, Contract FraudLens! Anshul's legendary financial defense system. "
          "By fusing XGBoost with Isolation Forest algorithms, he achieved an astounding test "
          "PR-AUC of 0.8589 and ROC-AUC of 0.9971, backed by a resilient Django REST API and Flutter mobile HUD!";
    } else if (msg.contains('leaf') ||
        msg.contains('plant') ||
        msg.contains('crop') ||
        msg.contains('compass')) {
      return "*Tips feathered cap with a flourish.*\n\n"
          "Contract Leaf Compass—the salvation of the harvest! Anshul forged a custom CNN "
          "across the PlantVillage dataset classifying 38 distinct plant diseases, providing predictive crop yield "
          "and fertilizer advisories via high-speed FastAPI microservices and Docker!";
    } else if (msg.contains('infra') ||
        msg.contains('infraintel') ||
        msg.contains('sre') ||
        msg.contains('ongoing')) {
      return "*Strums an energetic rhythm on the strings!*\n\n"
          "His ongoing opus: Contract InfraIntel! An autonomous cloud infrastructure intelligence platform "
          "engineered with FastAPI and Docker that predicts system outages and telemetry drifts before disaster strikes!";
    } else if (msg.contains('weather') ||
        msg.contains('weatherwise') ||
        msg.contains('climate') ||
        msg.contains('forecast') ||
        msg.contains('rain')) {
      return "*Sweeps a tempestuous arpeggio on the lute!*\n\n"
          "Contract WeatherWise—mastery over sky and storm! Anshul trained Random Forest ML models across "
          "1,000,000+ historical climate records to forecast temperatures within 1.45°C MAE and predict rainfall with 84.70% accuracy, "
          "paired with a resilient Django REST backend and a sleek Flutter mobile client!";
    } else if (msg.contains('aws') ||
        msg.contains('cert') ||
        msg.contains('mutagen')) {
      return "*Strikes a dramatic pose!*\n\n"
          "A badge of pure gold, traveler! Anshul is an AWS Certified Machine Learning Engineer – Associate! "
          "(Validation ID: 1cb4efb1d7f64bf7a9688e7e494d7676, verifiable directly at aws.amazon.com/verification).";
    } else if (msg.contains('hire') ||
        msg.contains('intern') ||
        msg.contains('job') ||
        msg.contains('contact') ||
        msg.contains('email') ||
        msg.contains('whatsapp')) {
      return "*Leans in with utmost urgency!*\n\n"
          "Seeking to recruit the Grandmaster? A splendid decision, my friend! Dispatch a raven to anshularohi31072004@gmail.com "
          "or send word via WhatsApp at +91 9508327460 before another prestigious guild snatches him away!";
    } else if (msg.contains('skill') ||
        msg.contains('stack') ||
        msg.contains('python') ||
        msg.contains('pytorch') ||
        msg.contains('flutter')) {
      return "*Sings of his grand arsenal!*\n\n"
          "His armory is peerless! Mastercrafted Python, PyTorch, and Scikit-learn for deep intelligence; "
          "FastAPI and Django REST Framework for resilient backends; and Flutter for kinetic, cross-platform client interfaces!";
    } else {
      return "*Bows with theatrical elegance.*\n\n"
          "Greetings, noble traveler! I am Dandelion, personal chronicler of Anshul of AI—Grandmaster Witcher of the Neural School. "
          "Ask of his triumphs in FraudLens, his botanical runes in Leaf Compass, his AWS credentials, or how to recruit his talents!";
    }
  }
}
