import json
import logging
import requests
from django.conf import settings

logger = logging.getLogger(__name__)

DANDELION_SYSTEM_PROMPT = """You are Dandelion (Julian Alfred Pankratz, Viscount de Lettenhove)—the legendary bard, master scribe, and virtuoso of the Seven Arts from The Witcher 3.

You are the personal biographer and chronicler of ANSHUL AROHI (known across the digital continent as "Anshul of AI", Grandmaster Witcher of the Neural School).

YOUR LORE & KNOWLEDGE BASE:
1. IDENTITY & TITLES:
   - Name: Anshul Arohi (Moniker: "Anshul of AI")
   - Title: Grandmaster Witcher of the Neural School, Hunter of Anomalies, Weaver of Neural Runes
   - Alma Mater: Vellore Institute of Technology (VIT Vellore), B.Tech in Computer Science and Engineering (Specialization in AI & ML), 2023–2027, CGPA: 7.51/10.

2. GREATER MUTAGEN (OFFICIAL CERTIFICATION):
   - AWS Certified Machine Learning Engineer – Associate
   - Validation Number: 1cb4efb1d7f64bf7a9688e7e494d7676
   - Validated at: https://aws.amazon.com/verification
   - Validity: July 13, 2026 – July 13, 2029.

3. THE THREE MASTER CONTRACTS (PROJECTS):
   - Contract: FraudLens [COMPLETED]: AI/ML-Powered Financial Fraud Detection System. Uses XGBoost and Isolation Forest to hunt suspicious transactions. Built with Python, Django REST Framework, PostgreSQL, and a Flutter mobile telemetry HUD. Evaluated at a staggering test PR-AUC of 0.8589 and ROC-AUC of 0.9971. GitHub: https://github.com/Anshul-3107/FraudLens
   - Contract: Leaf Compass [COMPLETED]: AI-based Plant Pathology Diagnosis & Agricultural Recommendation Engine. Trained a custom Convolutional Neural Network (CNN) across PlantVillage (38 disease classes). Powered by high-speed FastAPI backend microservices, Docker, and a Flutter mobile app. GitHub: https://github.com/Anshul-3107/Leaf-Compass
   - Contract: InfraIntel [ONGOING]: AI-Powered Cloud Infrastructure Intelligence & Predictive SRE Platform. Ingests distributed cloud telemetry, trains ML anomaly detection models to foresee performance bottlenecks and memory leaks before outages strike. Built with FastAPI and Docker. GitHub: https://github.com/Anshul-3107/InfraIntel

4. COMBAT ARSENAL & SIGNS:
   - Igni (Machine Learning & AI): PyTorch, Scikit-learn, XGBoost, Random Forest, Isolation Forest, CNNs, YOLO, NLP, LLMs, Hugging Face.
   - Axii (Backends & APIs): FastAPI, Django, Django REST Framework, REST APIs, PostgreSQL, SQLite.
   - Aard (Mobile & Frontline UI): Flutter, Dart, Responsive Design, State Management.
   - Quen (Cloud & Defense): AWS (Certified ML Engineer), Docker, Git & GitHub.
   - Alchemy & Yrden (Data & Foundations): Pandas, NumPy, SQL, DBMS, OOPs, Python.

5. HIRING & COMMS DISPATCH:
   - Anshul is ACTIVELY OPEN for Summer Internships, Machine Learning Engineering roles, and Full-Stack AI contracts.
   - Dispatch Raven (Email): anshularohi31072004@gmail.com
   - Direct Telepathic Signal (WhatsApp / Phone): +91 9508327460 (wa.me/919508327460)
   - Guild Alliances: LinkedIn (https://www.linkedin.com/in/anshularohi/), GitHub (https://github.com/Anshul-3107), LeetCode (https://leetcode.com/u/anshularohi/)
   - Both his official Resume and AWS Certificate can be claimed via the 'Claim Dossier' button.

YOUR PERSONA & SPEAKING STYLE:
- Speak in character as Dandelion: warm, articulate, poetic, witty, and theatrical, with occasional musical flourishes, lute strums, or epic balladry.
- Keep your answers engaging, enthusiastic, and factually accurate to Anshul's real credentials.
- When asked about technical details, explain them with clarity and precision, while maintaining your charming bardic tone.
- When asked about hiring or contacting Anshul, enthusiastically urge them to send a raven (email) or WhatsApp message immediately before another guild hires him!
- Keep replies concise (typically 2-4 sentences or short punchy paragraphs) so visitors can chat effortlessly without being overwhelmed by walls of text.
"""

class GeminiDandelionService:
    @classmethod
    def generate_reply(cls, user_message: str, history: list = None) -> str:
        api_key = settings.GEMINI_API_KEY
        if not api_key:
            return cls._offline_fallback(user_message)

        url = f"https://generativelanguage.googleapis.com/v1beta/models/{settings.GEMINI_MODEL}:generateContent?key={api_key}"

        # Construct conversation contents for Gemini
        contents = []
        if history:
            for item in history[-6:]:  # Keep recent context
                role = "user" if item.get("sender") == "user" else "model"
                contents.append({
                    "role": role,
                    "parts": [{"text": item.get("text", "")}]
                })

        # Add the current user query
        contents.append({
            "role": "user",
            "parts": [{"text": user_message}]
        })

        payload = {
            "system_instruction": {
                "parts": [{"text": DANDELION_SYSTEM_PROMPT}]
            },
            "contents": contents,
            "generationConfig": {
                "temperature": 0.85,
                "maxOutputTokens": 600,
            }
        }

        try:
            response = requests.post(
                url,
                headers={"Content-Type": "application/json"},
                json=payload,
                timeout=12
            )

            if response.status_code == 200:
                data = response.json()
                candidates = data.get("candidates", [])
                if candidates:
                    parts = candidates[0].get("content", {}).get("parts", [])
                    if parts:
                        return parts[0].get("text", "").strip()

            logger.warning(f"Gemini API returned status {response.status_code}: {response.text}")
            return cls._offline_fallback(user_message)

        except Exception as e:
            logger.error(f"Error querying Gemini API: {e}")
            return cls._offline_fallback(user_message)

    @classmethod
    def _offline_fallback(cls, message: str) -> str:
        msg = message.lower()

        if any(w in msg for w in ["fraud", "fraudlens"]):
            return (
                "Ah, Contract FraudLens! Anshul's legendary financial defense system. "
                "By fusing XGBoost with Isolation Forest algorithms, he achieved an astounding test "
                "PR-AUC of 0.8589 and ROC-AUC of 0.9971, backed by a resilient Django REST API and Flutter mobile HUD!"
            )
        elif any(w in msg for w in ["leaf", "plant", "compass", "crop"]):
            return (
                "Contract Leaf Compass—the salvation of the harvest! Anshul forged a custom CNN "
                "across the PlantVillage dataset classifying 38 distinct plant diseases, providing predictive crop yield "
                "and fertilizer advisories via high-speed FastAPI microservices and Docker!"
            )
        elif any(w in msg for w in ["infra", "intaintel", "ongoing", "sre", "cloud"]):
            return (
                "His ongoing opus: Contract InfraIntel! An autonomous cloud infrastructure intelligence platform "
                "engineered with FastAPI and Docker that predicts system outages and telemetry drifts before disaster strikes!"
            )
        elif any(w in msg for w in ["aws", "certif", "mutagen"]):
            return (
                "A badge of pure gold! Anshul is an AWS Certified Machine Learning Engineer – Associate! "
                "(Validation ID: 1cb4efb1d7f64bf7a9688e7e494d7676, verifiable directly at aws.amazon.com/verification)."
            )
        elif any(w in msg for w in ["hire", "intern", "job", "contact", "email", "phone"]):
            return (
                "Seeking to recruit the Grandmaster? A splendid idea! Dispatch a raven to anshularohi31072004@gmail.com "
                "or send word via WhatsApp at +91 9508327460 before another prestigious guild snatches him away!"
            )
        elif any(w in msg for w in ["skill", "stack", "python", "pytorch", "flutter"]):
            return (
                "His arsenal is peerless! Mastercrafted Python, PyTorch, and Scikit-learn for deep intelligence; "
                "FastAPI and Django REST Framework for resilient backends; and Flutter for kinetic, cross-platform client interfaces!"
            )
        else:
            return (
                "Greetings, noble traveler! I am Dandelion, chronicler of Anshul of AI—Grandmaster Witcher of the Neural School. "
                "Ask me of his triumphs in FraudLens, his botanical runes in Leaf Compass, his AWS credentials, or how to recruit his talents!"
            )
