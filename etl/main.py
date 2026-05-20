from db import get_connection
from scrapers.study_australia import (
    extract, transform, load,
    get_fallback_programs, FIELDS_TO_SEARCH
)

def run():
    print("=== UniCompare ETL Pipeline Starting ===\n")
    conn = get_connection()
    print("Database connected.\n")

    total_loaded = 0

    # Try CRICOS API first
    print("--- Attempting CRICOS API ---")
    api_worked = False

    for field in FIELDS_TO_SEARCH:
        print(f"\n  Field: {field}")
        raw  = extract(field=field, max_results=30)
        data = transform(raw, field)
        if data:
            load(data, conn)
            total_loaded += len(data)
            api_worked = True

    # If API returned nothing, use fallback data
    if not api_worked or total_loaded == 0:
        print("\n--- API unavailable. Loading verified fallback data ---")
        programs = get_fallback_programs()
        load(programs, conn)
        total_loaded = len(programs)

    conn.close()
    print(f"\n=== ETL Complete — {total_loaded} programs processed ===")

if __name__ == "__main__":
    run()