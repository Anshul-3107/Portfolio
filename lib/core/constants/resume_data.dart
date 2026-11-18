import 'package:flutter/material.dart';
import '../../models/portfolio_models.dart';
import '../theme/witcher_colors.dart';

class ResumeData {
  static const String name = "Anshul Arohi";
  static const String witcherTitle = "Anshul of AI";
  static const String witcherSchool = "School of the Neural Wolf";
  static const String rank = "Grandmaster AI Witcher";
  static const String origin = "Vellore Institute of Technology";
  static const String email = "anshularohi31072004@gmail.com";
  static const String phone = "+91 9508327460";
  static const String linkedInUrl = "https://www.linkedin.com/in/anshularohi/";
  static const String gitHubUrl = "https://github.com/Anshul-3107";
  static const String leetCodeUrl = "https://leetcode.com/u/anshularohi";
  static const String resumePdfUrl = "assets/Anshul_Arohi_Resume.pdf";

  static String get gmailComposeUrl => Uri.https('mail.google.com', '/mail/', {
        'view': 'cm',
        'fs': '1',
        'to': email,
        'su': 'Inquiry for Anshul of AI (AI/ML Engineer Role)',
        'body': 'Greetings Anshul,\n\nI reviewed your Witcher portfolio and would like to discuss an opportunity...',
      }).toString();

  static String get whatsAppUrl => Uri.https('wa.me', '/919508327460', {
        'text': 'Greetings Anshul, I reviewed your Witcher portfolio and would like to connect regarding an opportunity.',
      }).toString();

  static const String bio =
      "AI/ML Engineer and Python Developer pursuing a B.Tech in Computer Science and Engineering (AI & ML) "
      "at Vellore Institute of Technology (2023–2027). Hands-on experience developing end-to-end machine learning "
      "applications, building and evaluating production ML models, engineering resilient REST APIs with Django & FastAPI, "
      "and crafting cross-platform client interfaces in Flutter. AWS Certified Machine Learning Engineer – Associate.";

  static const String witcherMotto =
      '"A Witcher’s silver blade strikes down anomalous beasts in the dark, '
      'just as a neural network unmasks fraud hidden within millions of transactions."';

  // Combat Stats / Gauges
  static const Map<String, double> attributes = {
    "Model Precision & Recall": 0.96,
    "Neural Architecture & Vision": 0.92,
    "Backend & REST Scalability": 0.88,
    "Cross-Platform Client (Flutter)": 0.90,
    "Cloud & Container Warfare": 0.85,
  };

  // Flagship Contracts (Projects)
  static final List<ContractModel> contracts = [
    const ContractModel(
      id: "fraudlens",
      title: "Contract: FraudLens",
      subtitle: "AI/ML-Powered Financial Fraud Detection System",
      threatLevel: "Catastrophic Anomaly",
      domain: "Financial Security & Fraud Detection",
      tier: ArmorTier.grandmaster,
      status: ContractStatus.completed,
      description:
          "Hunted down subtle, evasive fraudulent transactions and erratic spending patterns hiding across massive financial streams through advanced hybrid ensemble models and real-time alert architectures.",
      highlights: [
        "Architected an anomaly detection platform fusing XGBoost with Isolation Forest algorithms on simulated financial transaction datasets.",
        "Engineered robust Django REST APIs handling transaction ingestion, real-time model scoring, automated threat alerts, and investigator workflows with PostgreSQL persistence.",
        "Forged an interactive Flutter mobile client application offering real-time transaction telemetry, spending trends, and immediate fraud alert views.",
        "Benchmarked model efficacy, achieving an extraordinary test PR-AUC of 0.8589 and ROC-AUC of 0.9971.",
      ],
      combatMetrics: {
        "PR-AUC": "0.8589",
        "ROC-AUC": "0.9971",
        "Algorithms": "XGBoost + IsoScore",
        "Stack": "Django REST + Flutter",
      },
      techStack: [
        "Python",
        "Django",
        "DRF",
        "PostgreSQL",
        "XGBoost",
        "Isolation Forest",
        "Flutter",
      ],
      githubUrl: "https://github.com/Anshul-3107/FraudLens",
    ),
    const ContractModel(
      id: "leaf_compass",
      title: "Contract: Leaf Compass",
      subtitle: "AI-Based Plant Disease Analysis & Agri-Recommendation Engine",
      threatLevel: "Widespread Botanical Blight",
      domain: "Computer Vision & Agricultural Intelligence",
      tier: ArmorTier.grandmaster,
      status: ContractStatus.completed,
      description:
          "Constructed an intelligent crop doctor and agricultural guidance engine to diagnose plant leaf pathogens early and prescribe optimal yield, crop choice, and fertilizer regimens to farmers.",
      highlights: [
        "Trained a high-accuracy custom Convolutional Neural Network (CNN) across the PlantVillage dataset, classifying 38 distinct plant disease categories.",
        "Formulated predictive machine learning pipelines delivering tailored crop yield forecasting, crop suitability recommendations, and fertilizer advisories.",
        "Built high-throughput FastAPI backend microservices and paired them with a responsive Flutter mobile interface for field image capture and immediate diagnostic feedback.",
        "Containerized the end-to-end architecture using Docker for reproducible deployment.",
      ],
      combatMetrics: {
        "Pathogen Classes": "38 Classes",
        "Vision Model": "Custom CNN",
        "Inference Engine": "FastAPI + PyTorch",
        "Deployment": "Dockerized",
      },
      techStack: [
        "Python",
        "PyTorch",
        "Scikit-learn",
        "FastAPI",
        "Flutter",
        "Docker",
      ],
      githubUrl: "https://github.com/Anshul-3107/Leaf-Compass",
    ),
    const ContractModel(
      id: "infraintel",
      title: "Contract: InfraIntel",
      subtitle: "AI-Powered Infrastructure Intelligence & Predictive Observability Platform",
      threatLevel: "Operational Outage & Latency",
      domain: "Cloud Infrastructure & SRE Intelligence",
      tier: ArmorTier.grandmaster,
      status: ContractStatus.ongoing,
      description:
          "Engineering an autonomous infrastructure intelligence engine that ingests distributed system telemetry, detects anomalous cloud resource usage, and predicts performance degradation before outages occur.",
      highlights: [
        "Architecting time-series telemetry pipelines to monitor infrastructure health, server loads, and network latency patterns in real time.",
        "Developing machine learning anomaly detection models to identify subtle infrastructure drifts, memory leaks, and CPU spikes.",
        "Designing modular FastAPI microservices backed by high-throughput PostgreSQL persistence and containerized Docker orchestrations.",
        "Building automated alert routing and intelligent investigation summaries to streamline incident response workflows for DevOps teams.",
      ],
      combatMetrics: {
        "Phase": "Ongoing Development",
        "Architecture": "FastAPI + ML Engine",
        "Focus": "Predictive SRE",
        "Deployment": "Containerized (Docker)",
      },
      techStack: [
        "Python",
        "FastAPI",
        "Docker",
        "PostgreSQL",
        "Machine Learning",
        "Cloud Telemetry",
        "REST APIs",
      ],
      githubUrl: "https://github.com/Anshul-3107/InfraIntel",
    ),
  ];

  // Signs & Arsenal (Skills categorized by Witcher Signs)
  static final List<SkillSignModel> skillSigns = [
    const SkillSignModel(
      signName: "Igni",
      domainName: "Machine Learning & AI",
      signDescription:
          "The fire of neural compute. Training deep networks, evaluating model weights, and deploying intelligent inference engines.",
      signColor: WitcherColors.signIgni,
      icon: Icons.local_fire_department_rounded,
      skills: [
        SkillItem(name: "PyTorch", tier: ArmorTier.grandmaster, note: "Deep Learning & Tensors"),
        SkillItem(name: "Scikit-learn", tier: ArmorTier.grandmaster, note: "Model Pipelines & Scoring"),
        SkillItem(name: "XGBoost & Random Forest", tier: ArmorTier.grandmaster, note: "Gradient Boosting & Ensembles"),
        SkillItem(name: "Isolation Forest", tier: ArmorTier.mastercrafted, note: "Unsupervised Anomaly Detection"),
        SkillItem(name: "Custom CNNs & YOLO", tier: ArmorTier.mastercrafted, note: "Computer Vision & Detection"),
        SkillItem(name: "NLP & LLMs", tier: ArmorTier.superior, note: "Language Models & Embeddings"),
        SkillItem(name: "Hugging Face", tier: ArmorTier.superior, note: "Transformers & Model Hub"),
      ],
    ),
    const SkillSignModel(
      signName: "Axii",
      domainName: "Backends & REST APIs",
      signDescription:
          "The power to coordinate and communicate. Forging scalable web services, clean APIs, and transactional persistence.",
      signColor: WitcherColors.signAxii,
      icon: Icons.hub_rounded,
      skills: [
        SkillItem(name: "FastAPI", tier: ArmorTier.grandmaster, note: "High-performance async APIs"),
        SkillItem(name: "Django & DRF", tier: ArmorTier.grandmaster, note: "Full-scale REST frameworks"),
        SkillItem(name: "REST APIs", tier: ArmorTier.mastercrafted, note: "API Architecture & Serialization"),
        SkillItem(name: "PostgreSQL", tier: ArmorTier.mastercrafted, note: "Relational persistence & indexing"),
        SkillItem(name: "SQLite", tier: ArmorTier.superior, note: "Embedded lightweight datastores"),
      ],
    ),
    const SkillSignModel(
      signName: "Aard",
      domainName: "Mobile & Client Interface",
      signDescription:
          "The kinetic impact upon the user. Crafting fluid, responsive mobile and web interfaces with real-time feedback.",
      signColor: WitcherColors.signAard,
      icon: Icons.devices_rounded,
      skills: [
        SkillItem(name: "Flutter", tier: ArmorTier.grandmaster, note: "Cross-platform mobile & web"),
        SkillItem(name: "Dart", tier: ArmorTier.grandmaster, note: "Client language & asynchronous streams"),
        SkillItem(name: "UI / UX Design", tier: ArmorTier.mastercrafted, note: "Intuitive workflows & layouts"),
        SkillItem(name: "State Management", tier: ArmorTier.mastercrafted, note: "Reactive data binding"),
      ],
    ),
    const SkillSignModel(
      signName: "Quen",
      domainName: "Cloud & DevOps Shield",
      signDescription:
          "The defensive ward against downtime and failure. Cloud orchestration, immutable containers, and version security.",
      signColor: WitcherColors.signQuen,
      icon: Icons.shield_rounded,
      skills: [
        SkillItem(name: "AWS Certified ML Engineer", tier: ArmorTier.grandmaster, note: "Associate Certification"),
        SkillItem(name: "Docker", tier: ArmorTier.mastercrafted, note: "Containerization & Multi-stage builds"),
        SkillItem(name: "Git & GitHub", tier: ArmorTier.mastercrafted, note: "Version control & workflows"),
      ],
    ),
    const SkillSignModel(
      signName: "Alchemy",
      domainName: "Data Science & Mathematics",
      signDescription:
          "The precise brewing of data. Cleansing raw noise, engineering features, and distilling actionable mathematical insights.",
      signColor: WitcherColors.signAlchemy,
      icon: Icons.science_rounded,
      skills: [
        SkillItem(name: "Pandas", tier: ArmorTier.grandmaster, note: "Dataframe wrangling & reshaping"),
        SkillItem(name: "NumPy", tier: ArmorTier.grandmaster, note: "Matrix operations & vectorization"),
        SkillItem(name: "SQL", tier: ArmorTier.mastercrafted, note: "Complex queries, joins & aggregates"),
      ],
    ),
    const SkillSignModel(
      signName: "Yrden",
      domainName: "Foundations & Logic",
      signDescription:
          "The binding circle of computer science fundamentals. Solid object-oriented structures and robust schema design.",
      signColor: WitcherColors.signYrden,
      icon: Icons.token_rounded,
      skills: [
        SkillItem(name: "DBMS", tier: ArmorTier.mastercrafted, note: "Database management systems & ACID"),
        SkillItem(name: "OOPs", tier: ArmorTier.mastercrafted, note: "Object-oriented design patterns"),
        SkillItem(name: "Python", tier: ArmorTier.grandmaster, note: "Core systems & scripting"),
      ],
    ),
  ];

  // Glossary (Education & Lore)
  static final List<EducationEntry> education = [
    const EducationEntry(
      institution: "Vellore Institute of Technology",
      degree: "B.Tech in Computer Science and Engineering (Specialization in AI & ML)",
      period: "2023 – 2027",
      score: "CGPA: 7.51 / 10",
      location: "Vellore, Tamil Nadu",
      details:
          "Undergoing rigorous academic and laboratory training in artificial intelligence, deep learning architectures, algorithms, and distributed computing systems.",
    ),
    const EducationEntry(
      institution: "Shivam School",
      degree: "Class XII (Senior Secondary Examination)",
      period: "2022",
      score: "80.0%",
      location: "Patna, Bihar",
      details: "Completed higher secondary education with a rigorous core in Physics, Chemistry, and Mathematics.",
    ),
    const EducationEntry(
      institution: "St. Karen’s Secondary School",
      degree: "Class X (Secondary School Examination)",
      period: "2020",
      score: "89.8%",
      location: "Patna, Bihar",
      details: "Secondary academic foundational training with distinction in Sciences and Mathematics.",
    ),
  ];

  // Certifications / Accreditations
  static final List<CertificationModel> certifications = [
    const CertificationModel(
      name: "AWS Certified Machine Learning Engineer – Associate",
      issuer: "Amazon Web Services (AWS)",
      date: "Valid: 2026 – 2029",
      tier: ArmorTier.grandmaster,
      credentialId: "1cb4efb1d7f64bf7a9688e7e494d7676",
      description:
          "Official AWS certification validating expertise in building, scaling, tuning, and deploying machine learning models on AWS. Validation Number: 1cb4efb1d7f64bf7a9688e7e494d7676 (validate at aws.amazon.com/verification).",
    ),
    const CertificationModel(
      name: "Applied Machine Learning in Python",
      issuer: "Coursera (University of Michigan)",
      date: "Certified",
      tier: ArmorTier.superior,
      description:
          "Applied mastery of supervised/unsupervised algorithms, evaluation metrics, feature engineering, and model cross-validation in Python.",
    ),
  ];
}
