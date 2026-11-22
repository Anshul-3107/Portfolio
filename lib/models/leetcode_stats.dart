class LeetCodeStats {
  final String username;
  final String profileUrl;
  final int ranking;
  final int totalSolved;
  final int totalQuestions;
  final int easySolved;
  final int totalEasy;
  final int mediumSolved;
  final int totalMedium;
  final int hardSolved;
  final int totalHard;
  final String acceptanceRate;
  final int totalSubmissions;
  final int activeDays;
  final bool isLive;

  const LeetCodeStats({
    required this.username,
    required this.profileUrl,
    required this.ranking,
    required this.totalSolved,
    required this.totalQuestions,
    required this.easySolved,
    required this.totalEasy,
    required this.mediumSolved,
    required this.totalMedium,
    required this.hardSolved,
    required this.totalHard,
    required this.acceptanceRate,
    required this.totalSubmissions,
    required this.activeDays,
    this.isLive = false,
  });

  factory LeetCodeStats.fallback() {
    return const LeetCodeStats(
      username: "anshularohi",
      profileUrl: "https://leetcode.com/u/anshularohi",
      ranking: 1454051,
      totalSolved: 122,
      totalQuestions: 4115,
      easySolved: 52,
      totalEasy: 976,
      mediumSolved: 68,
      totalMedium: 2148,
      hardSolved: 2,
      totalHard: 991,
      acceptanceRate: "55.5%",
      totalSubmissions: 220,
      activeDays: 62,
      isLive: false,
    );
  }

  factory LeetCodeStats.fromJson(Map<String, dynamic> json) {
    return LeetCodeStats(
      username: json['username']?.toString() ?? "anshularohi",
      profileUrl: json['profileUrl']?.toString() ?? "https://leetcode.com/u/anshularohi",
      ranking: json['ranking'] is int ? json['ranking'] : 1454051,
      totalSolved: json['totalSolved'] is int ? json['totalSolved'] : 122,
      totalQuestions: json['totalQuestions'] is int ? json['totalQuestions'] : 4115,
      easySolved: json['easySolved'] is int ? json['easySolved'] : 52,
      totalEasy: json['totalEasy'] is int ? json['totalEasy'] : 976,
      mediumSolved: json['mediumSolved'] is int ? json['mediumSolved'] : 68,
      totalMedium: json['totalMedium'] is int ? json['totalMedium'] : 2148,
      hardSolved: json['hardSolved'] is int ? json['hardSolved'] : 2,
      totalHard: json['totalHard'] is int ? json['totalHard'] : 991,
      acceptanceRate: json['acceptanceRate']?.toString() ?? "55.5%",
      totalSubmissions: json['totalSubmissions'] is int ? json['totalSubmissions'] : 220,
      activeDays: json['activeDays'] is int ? json['activeDays'] : 62,
      isLive: true,
    );
  }
}
