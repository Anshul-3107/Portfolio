import 'package:flutter/material.dart';

enum ArmorTier {
  grandmaster,
  mastercrafted,
  superior,
  enhanced,
  standard,
}

extension ArmorTierExtension on ArmorTier {
  String get displayName {
    switch (this) {
      case ArmorTier.grandmaster:
        return 'Grandmaster';
      case ArmorTier.mastercrafted:
        return 'Mastercrafted';
      case ArmorTier.superior:
        return 'Superior';
      case ArmorTier.enhanced:
        return 'Enhanced';
      case ArmorTier.standard:
        return 'Standard';
    }
  }

  Color get color {
    switch (this) {
      case ArmorTier.grandmaster:
        return const Color(0xFFFFB74D); // Gold Amber
      case ArmorTier.mastercrafted:
        return const Color(0xFF81D4FA); // Witcher Silver/Cyan
      case ArmorTier.superior:
        return const Color(0xFFAED581); // Emerald Green
      case ArmorTier.enhanced:
        return const Color(0xFFCE93D8); // Runic Violet
      case ArmorTier.standard:
        return const Color(0xFFB0BEC5); // Steel Slate
    }
  }

  // High-Contrast Antique Ink Color for Parchment Readability
  Color get inkColor {
    switch (this) {
      case ArmorTier.grandmaster:
        return const Color(0xFF6E3E00); // Deep rich bronze amber ink
      case ArmorTier.mastercrafted:
        return const Color(0xFF0C3D5E); // Deep sapphire cobalt ink
      case ArmorTier.superior:
        return const Color(0xFF14471E); // Deep forest emerald ink
      case ArmorTier.enhanced:
        return const Color(0xFF4E165C); // Deep royal amethyst ink
      case ArmorTier.standard:
        return const Color(0xFF282E33); // Deep charcoal iron ink
    }
  }

  // Solid Parchment Badge Fill
  Color get badgeBgColor {
    switch (this) {
      case ArmorTier.grandmaster:
        return const Color(0xFFF7EACD);
      case ArmorTier.mastercrafted:
        return const Color(0xFFDCEAF2);
      case ArmorTier.superior:
        return const Color(0xFFDCF0DF);
      case ArmorTier.enhanced:
        return const Color(0xFFF2DCF7);
      case ArmorTier.standard:
        return const Color(0xFFE2E7EA);
    }
  }

  // Sharp Readable Border
  Color get badgeBorderColor {
    switch (this) {
      case ArmorTier.grandmaster:
        return const Color(0xFF9E6105);
      case ArmorTier.mastercrafted:
        return const Color(0xFF1B6594);
      case ArmorTier.superior:
        return const Color(0xFF257335);
      case ArmorTier.enhanced:
        return const Color(0xFF76268C);
      case ArmorTier.standard:
        return const Color(0xFF4A555C);
    }
  }
}

enum ContractStatus {
  completed,
  ongoing,
}

extension ContractStatusExtension on ContractStatus {
  String get displayName => this == ContractStatus.completed ? 'COMPLETED' : 'ONGOING';
  Color get color => this == ContractStatus.completed ? const Color(0xFF66BB6A) : const Color(0xFFFFA726);
}

class ContractModel {
  final String id;
  final String title;
  final String subtitle;
  final String threatLevel; // e.g. "Extreme Anomaly", "High Biological Threat"
  final String domain; // "Financial Security", "Agricultural Vision"
  final ArmorTier tier;
  final ContractStatus status;
  final String description;
  final List<String> highlights;
  final Map<String, String> combatMetrics;
  final List<String> techStack;
  final String? githubUrl;
  final String? demoUrl;

  const ContractModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.threatLevel,
    required this.domain,
    required this.tier,
    this.status = ContractStatus.completed,
    required this.description,
    required this.highlights,
    required this.combatMetrics,
    required this.techStack,
    this.githubUrl,
    this.demoUrl,
  });
}

class SkillSignModel {
  final String signName; // "Igni", "Axii", "Aard", "Quen", "Yrden", "Alchemy"
  final String domainName; // "Machine Learning & AI", "Backends & APIs", etc.
  final String signDescription;
  final Color signColor;
  final IconData icon;
  final List<SkillItem> skills;

  const SkillSignModel({
    required this.signName,
    required this.domainName,
    required this.signDescription,
    required this.signColor,
    required this.icon,
    required this.skills,
  });
}

class SkillItem {
  final String name;
  final ArmorTier tier;
  final String? note;

  const SkillItem({
    required this.name,
    required this.tier,
    this.note,
  });
}

class EducationEntry {
  final String institution;
  final String degree;
  final String period;
  final String score;
  final String location;
  final String details;

  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.period,
    required this.score,
    required this.location,
    required this.details,
  });
}

class CertificationModel {
  final String name;
  final String issuer;
  final String date;
  final ArmorTier tier;
  final String description;
  final String? credentialId;

  const CertificationModel({
    required this.name,
    required this.issuer,
    required this.date,
    required this.tier,
    required this.description,
    this.credentialId,
  });
}
