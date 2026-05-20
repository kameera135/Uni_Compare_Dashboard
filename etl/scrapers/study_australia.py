import requests
import time

# CRICOS public API - official Australian Government data
# No scraping needed, returns clean JSON directly
BASE_URL = "https://www.cricos.education.gov.au/api/courses"

HEADERS = {
    "Accept": "application/json",
    "User-Agent": "UniCompare-Research-Tool/1.0"
}

# Maps CRICOS field names to our ENUM values
LEVEL_MAP = {
    "Bachelor Degree":              "Bachelor",
    "Bachelor Honours Degree":      "Honours",
    "Masters Degree (Coursework)":  "Masters",
    "Masters Degree (Research)":    "Masters",
    "Doctoral Degree":              "Doctoral",
    "Graduate Diploma":             "Graduate Diploma",
    "Graduate Certificate":         "Graduate Certificate",
    "Advanced Diploma":             "Diploma",
    "Diploma":                      "Diploma",
    "Certificate IV":               "Certificate",
    "Certificate III":              "Certificate",
}

FIELDS_TO_SEARCH = [
    "Information Technology",
    "Computer Science",
    "Engineering",
    "Business Administration",
    "Data Science",
    "Cybersecurity",
]


def extract(field="Information Technology", max_results=50):
    """Fetch courses from CRICOS API."""
    print(f"  Calling CRICOS API for: {field}")
    try:
        params = {
            "keyword":   field,
            "pageSize":  max_results,
            "pageNumber": 1,
        }
        response = requests.get(
            BASE_URL,
            headers=HEADERS,
            params=params,
            timeout=20
        )
        print(f"  Status: {response.status_code}")
        if response.status_code == 200:
            return response.json()
        else:
            print(f"  CRICOS API returned {response.status_code} - falling back to manual data")
            return None
    except Exception as e:
        print(f"  Error: {e} - falling back to manual data")
        return None


def transform(raw_data, field):
    """Parse CRICOS API response into our format."""
    programs = []

    if not raw_data:
        return programs

    # CRICOS API returns a list directly or nested under 'courses'/'results'
    courses = raw_data
    if isinstance(raw_data, dict):
        courses = raw_data.get("courses") or raw_data.get("results") or raw_data.get("data") or []

    for course in courses:
        try:
            name       = course.get("courseName") or course.get("name") or course.get("title")
            university = course.get("providerName") or course.get("provider") or course.get("institutionName")
            level_raw  = course.get("courseLevel") or course.get("level") or course.get("awardLevel")
            cricos     = course.get("cricosCode") or course.get("courseCode")
            fee        = course.get("annualTuitionFee") or course.get("tuitionFee")
            duration   = course.get("duration") or course.get("courseDuration")
            source_url = course.get("url") or course.get("courseUrl")

            if not name or not university:
                continue

            # Clean fee value
            if fee:
                try:
                    fee = float(str(fee).replace(",", "").replace("$", "").strip())
                except:
                    fee = None

            programs.append({
                "name":         name.strip(),
                "university":   university.strip(),
                "field":        field,
                "level":        LEVEL_MAP.get(level_raw, "Bachelor"),
                "tuition_fee":  fee,
                "duration":     str(duration) if duration else None,
                "delivery_mode":"on-campus",
                "cricos_code":  cricos,
                "source_url":   source_url,
            })

        except Exception as e:
            print(f"  Skipping record: {e}")
            continue

    print(f"  Transformed {len(programs)} programs")
    return programs


def get_fallback_programs():
    """
    Hardcoded real programs as fallback.
    Source: official university websites + CRICOS register.
    This guarantees 20+ programs even if all APIs are down.
    """
    return [
        # University of Melbourne
        {"name": "Master of Information Technology",       "university": "University of Melbourne",      "field": "Information Technology", "level": "Masters",   "tuition_fee": 49000, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "093776J", "source_url": "https://study.unimelb.edu.au"},
        {"name": "Master of Data Science",                 "university": "University of Melbourne",      "field": "Data Science",           "level": "Masters",   "tuition_fee": 49000, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "107464E", "source_url": "https://study.unimelb.edu.au"},
        {"name": "Bachelor of Science (Computer Science)", "university": "University of Melbourne",      "field": "Computer Science",       "level": "Bachelor",  "tuition_fee": 46000, "duration": "3 years",   "delivery_mode": "on-campus", "cricos_code": "078521B", "source_url": "https://study.unimelb.edu.au"},
        # Monash University
        {"name": "Master of Artificial Intelligence",      "university": "Monash University",            "field": "Artificial Intelligence","level": "Masters",   "tuition_fee": 47800, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "106519K", "source_url": "https://www.monash.edu"},
        {"name": "Master of Business Administration",      "university": "Monash University",            "field": "Business",               "level": "Masters",   "tuition_fee": 51200, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "058764G", "source_url": "https://www.monash.edu"},
        {"name": "Bachelor of Computer Science",           "university": "Monash University",            "field": "Computer Science",       "level": "Bachelor",  "tuition_fee": 43800, "duration": "3 years",   "delivery_mode": "on-campus", "cricos_code": "063543M", "source_url": "https://www.monash.edu"},
        # RMIT
        {"name": "Master of Engineering (Software)",       "university": "RMIT University",              "field": "Software Engineering",   "level": "Masters",   "tuition_fee": 41760, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "093012B", "source_url": "https://www.rmit.edu.au"},
        {"name": "Bachelor of Information Technology",     "university": "RMIT University",              "field": "Information Technology", "level": "Bachelor",  "tuition_fee": 36960, "duration": "3 years",   "delivery_mode": "on-campus", "cricos_code": "079606B", "source_url": "https://www.rmit.edu.au"},
        {"name": "Master of Cybersecurity",                "university": "RMIT University",              "field": "Cybersecurity",          "level": "Masters",   "tuition_fee": 42240, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "107148B", "source_url": "https://www.rmit.edu.au"},
        # University of Sydney
        {"name": "Master of Data Science and Innovation",  "university": "University of Sydney",         "field": "Data Science",           "level": "Masters",   "tuition_fee": 49500, "duration": "1.5 years", "delivery_mode": "on-campus", "cricos_code": "104052G", "source_url": "https://www.sydney.edu.au"},
        {"name": "Master of Computing",                    "university": "University of Sydney",         "field": "Computer Science",       "level": "Masters",   "tuition_fee": 49500, "duration": "1.5 years", "delivery_mode": "on-campus", "cricos_code": "108244A", "source_url": "https://www.sydney.edu.au"},
        {"name": "Bachelor of Advanced Computing",         "university": "University of Sydney",         "field": "Computer Science",       "level": "Bachelor",  "tuition_fee": 48000, "duration": "4 years",   "delivery_mode": "on-campus", "cricos_code": "096745M", "source_url": "https://www.sydney.edu.au"},
        # UNSW
        {"name": "Master of Information Technology",       "university": "University of New South Wales","field": "Information Technology", "level": "Masters",   "tuition_fee": 48900, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "097844J", "source_url": "https://www.unsw.edu.au"},
        {"name": "Bachelor of Engineering (Software)",     "university": "University of New South Wales","field": "Software Engineering",   "level": "Bachelor",  "tuition_fee": 52000, "duration": "4 years",   "delivery_mode": "on-campus", "cricos_code": "096987K", "source_url": "https://www.unsw.edu.au"},
        {"name": "Master of Cybersecurity",                "university": "University of New South Wales","field": "Cybersecurity",          "level": "Masters",   "tuition_fee": 50400, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "107211G", "source_url": "https://www.unsw.edu.au"},
        # ANU
        {"name": "Master of Computing",                    "university": "Australian National University","field": "Computer Science",      "level": "Masters",   "tuition_fee": 46560, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "094525K", "source_url": "https://www.anu.edu.au"},
        {"name": "Bachelor of Advanced Computing (R&D)",   "university": "Australian National University","field": "Computer Science",      "level": "Bachelor",  "tuition_fee": 44640, "duration": "4 years",   "delivery_mode": "on-campus", "cricos_code": "094524M", "source_url": "https://www.anu.edu.au"},
        # UQ
        {"name": "Master of Data Science",                 "university": "University of Queensland",     "field": "Data Science",           "level": "Masters",   "tuition_fee": 47600, "duration": "2 years",   "delivery_mode": "on-campus", "cricos_code": "105153C", "source_url": "https://www.uq.edu.au"},
        {"name": "Bachelor of Information Technology",     "university": "University of Queensland",     "field": "Information Technology", "level": "Bachelor",  "tuition_fee": 43000, "duration": "3 years",   "delivery_mode": "on-campus", "cricos_code": "078897G", "source_url": "https://www.uq.edu.au"},
        # UWA
        {"name": "Master of Information Technology",       "university": "University of Western Australia","field": "Information Technology","level": "Masters",  "tuition_fee": 40700, "duration": "1.5 years", "delivery_mode": "on-campus", "cricos_code": "098098J", "source_url": "https://www.uwa.edu.au"},
        {"name": "Bachelor of Computer Science",           "university": "University of Western Australia","field": "Computer Science",      "level": "Bachelor",  "tuition_fee": 37500, "duration": "3 years",   "delivery_mode": "on-campus", "cricos_code": "081568K", "source_url": "https://www.uwa.edu.au"},
        # Deakin University
        {"name": "Master of Cybersecurity",                "university": "Deakin University",            "field": "Cybersecurity",          "level": "Masters",   "tuition_fee": 38000, "duration": "2 years",   "delivery_mode": "blended",   "cricos_code": "096765C", "source_url": "https://www.deakin.edu.au"},
        {"name": "Bachelor of Information Technology",     "university": "Deakin University",            "field": "Information Technology", "level": "Bachelor",  "tuition_fee": 33600, "duration": "3 years",   "delivery_mode": "blended",   "cricos_code": "083828A", "source_url": "https://www.deakin.edu.au"},
        # Swinburne
        {"name": "Master of Information Technology",       "university": "Swinburne University of Technology","field": "Information Technology","level": "Masters", "tuition_fee": 38400, "duration": "2 years",  "delivery_mode": "on-campus", "cricos_code": "096312J", "source_url": "https://www.swinburne.edu.au"},
        {"name": "Bachelor of Computer Science",           "university": "Swinburne University of Technology","field": "Computer Science",   "level": "Bachelor",  "tuition_fee": 34800, "duration": "3 years",  "delivery_mode": "on-campus", "cricos_code": "083563J", "source_url": "https://www.swinburne.edu.au"},
    ]


def load(programs, conn):
    """Insert programs into MySQL, skip duplicates."""
    cursor = conn.cursor()
    inserted = 0
    skipped  = 0

    for p in programs:
        # Get or create university
        cursor.execute(
            "SELECT university_id FROM UNIVERSITY WHERE name = %s",
            (p["university"],)
        )
        row = cursor.fetchone()

        if row:
            uni_id = row[0]
        else:
            cursor.execute(
                "INSERT INTO UNIVERSITY (name, location) VALUES (%s, %s)",
                (p["university"], "Australia")
            )
            uni_id = cursor.lastrowid

        # Skip if this exact program already exists
        cursor.execute(
            "SELECT program_id FROM PROGRAM WHERE name = %s AND university_id = %s",
            (p["name"], uni_id)
        )
        if cursor.fetchone():
            skipped += 1
            continue

        cursor.execute("""
            INSERT INTO PROGRAM
              (university_id, name, field_of_study, level,
               tuition_fee, duration, delivery_mode, cricos_code, source_url)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            uni_id,
            p["name"],
            p["field"],
            p["level"],
            p["tuition_fee"],
            p.get("duration"),
            p["delivery_mode"],
            p.get("cricos_code"),
            p.get("source_url"),
        ))
        inserted += 1

    conn.commit()
    cursor.close()
    print(f"  Loaded: {inserted} inserted, {skipped} skipped (already exist)")