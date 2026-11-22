import time
import requests
import json
from typing import Dict, Any

class LeetCodeService:
    USERNAME = "anshularohi"
    PROFILE_URL = f"https://leetcode.com/u/{USERNAME}"
    
    # 1 hour cache TTL in seconds
    CACHE_TTL = 3600
    _cached_data = None
    _cached_timestamp = 0

    FALLBACK_DATA = {
        "username": USERNAME,
        "profileUrl": PROFILE_URL,
        "ranking": 1454051,
        "totalSolved": 122,
        "totalQuestions": 4115,
        "easySolved": 52,
        "totalEasy": 976,
        "mediumSolved": 68,
        "totalMedium": 2148,
        "hardSolved": 2,
        "totalHard": 991,
        "acceptanceRate": "55.5%",
        "totalSubmissions": 220,
        "activeDays": 62,
        "status": "cached",
        "lastSynced": "Just now",
    }

    GRAPHQL_QUERY = """
    query getUserStats($username: String!) {
      matchedUser(username: $username) {
        username
        profile {
          ranking
          reputation
        }
        submissionCalendar
        submitStatsGlobal {
          acSubmissionNum {
            difficulty
            count
          }
          totalSubmissionNum {
            difficulty
            count
            submissions
          }
        }
      }
      allQuestionsCount {
        difficulty
        count
      }
    }
    """

    @classmethod
    def get_stats(cls) -> Dict[str, Any]:
        """
        Fetch LeetCode stats with in-memory caching and fail-safe fallback.
        """
        now = time.time()
        if cls._cached_data and (now - cls._cached_timestamp < cls.CACHE_TTL):
            data = dict(cls._cached_data)
            data["cached"] = True
            return data

        try:
            headers = {
                'Content-Type': 'application/json',
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)',
                'Referer': 'https://leetcode.com',
            }
            
            payload = {
                'query': cls.GRAPHQL_QUERY,
                'variables': {'username': cls.USERNAME}
            }

            resp = requests.post(
                'https://leetcode.com/graphql',
                json=payload,
                headers=headers,
                timeout=8
            )

            if resp.status_code == 200:
                result = resp.json()
                data = result.get('data', {})
                matched_user = data.get('matchedUser')
                all_questions = data.get('allQuestionsCount', [])

                if matched_user:
                    parsed = cls._parse_response(matched_user, all_questions)
                    cls._cached_data = parsed
                    cls._cached_timestamp = now
                    return parsed
        except Exception as e:
            # Server-side log, returns fallback cleanly
            print(f"LeetCode fetch exception: {e}")

        # Return cached data if available, otherwise static fallback
        if cls._cached_data:
            return cls._cached_data

        return cls.FALLBACK_DATA

    @classmethod
    def _parse_response(cls, matched_user: dict, all_questions: list) -> Dict[str, Any]:
        profile = matched_user.get('profile', {})
        ranking = profile.get('ranking') or cls.FALLBACK_DATA['ranking']

        # Questions count map
        q_totals = {item.get('difficulty'): item.get('count', 0) for item in all_questions}
        total_questions = q_totals.get('All', 4115)
        total_easy = q_totals.get('Easy', 976)
        total_medium = q_totals.get('Medium', 2148)
        total_hard = q_totals.get('Hard', 991)

        # Submissions stats
        stats_global = matched_user.get('submitStatsGlobal', {})
        ac_list = stats_global.get('acSubmissionNum', [])
        ac_map = {item.get('difficulty'): item.get('count', 0) for item in ac_list}

        total_solved = ac_map.get('All', 122)
        easy_solved = ac_map.get('Easy', 52)
        medium_solved = ac_map.get('Medium', 68)
        hard_solved = ac_map.get('Hard', 2)

        # Total submissions & acceptance rate
        total_list = stats_global.get('totalSubmissionNum', [])
        total_map = {item.get('difficulty'): item.get('submissions', 0) for item in total_list}
        total_submissions = total_map.get('All', 220)

        acceptance_rate = "55.5%"
        if total_submissions > 0 and total_solved > 0:
            rate_val = (total_solved / total_submissions) * 100
            acceptance_rate = f"{rate_val:.1f}%"

        # Active days from calendar
        calendar_str = matched_user.get('submissionCalendar', '{}')
        try:
            calendar_dict = json.loads(calendar_str)
            active_days = len(calendar_dict)
        except Exception:
            active_days = 62

        return {
            "username": cls.USERNAME,
            "profileUrl": cls.PROFILE_URL,
            "ranking": ranking,
            "totalSolved": total_solved,
            "totalQuestions": total_questions,
            "easySolved": easy_solved,
            "totalEasy": total_easy,
            "mediumSolved": medium_solved,
            "totalMedium": total_medium,
            "hardSolved": hard_solved,
            "totalHard": total_hard,
            "acceptanceRate": acceptance_rate,
            "totalSubmissions": total_submissions,
            "activeDays": active_days,
            "status": "live",
            "cached": False,
        }
