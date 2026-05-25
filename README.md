# UniCompare
### Comparative Analytics Dashboard for University Program Selection

**Project:** 2026S1_13 | **Client:** DNC 

---

## What is this?

UniCompare is a web dashboard that helps international students compare Australian university programs. Instead of jumping between 10 different university websites, a student can open one page, set their filters, and compare programs side by side.

You can filter by field of study, degree level, tuition fee, IELTS score, and delivery mode. Each program shows fees, rankings, entry requirements, visa pathway, and career outcomes.

---

## Live Site

| Service | URL |
|---------|-----|
| Frontend | Deployed on Vercel |
| Backend API | Deployed on Render |
| Database | Aiven (MySQL 8.4) |

> The backend runs on Render free tier. First load after inactivity can take up to 30 seconds. Just wait and refresh.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React / Next.js + Tailwind CSS |
| Backend | Node.js + Express |
| Database | MySQL 8.0 |
| Data Pipeline | Python 3.11 + BeautifulSoup |
| Charts | Recharts |
| Version Control | Git + GitHub |

---

## Project Structure

```
unicompare/
├── frontend/          # React/Next.js dashboard
│   ├── pages/
│   │   ├── index.js   # Home page with search and filters
│   │   └── compare.js # Side by side comparison page
│   └── components/
│       ├── ProgramCard.js
│       ├── FilterBar.js
│       ├── CompareTable.js
│       └── FeeChart.js
├── backend/           # Node.js REST API
│   ├── server.js
│   ├── db.js
│   └── routes/
│       ├── programs.js
│       └── universities.js
├── etl/               # Python data pipeline
│   ├── main.py
│   ├── db.py
│   └── scrapers/
│       └── study_australia.py
├── database/
│   └── schema.sql     # Full MySQL schema with seed data
├── .gitignore
└── README.md
```

---

## Running Locally

### Requirements

- Node.js v20+
- Python 3.11+
- MySQL 8.0
- Git

### 1. Clone the repo

```bash
git clone https://github.com/your-username/unicompare.git
cd unicompare
```

### 2. Set up the database

```bash
mysql -u root -p < database/schema.sql
```

### 3. Run the ETL pipeline

```bash
cd etl
python -m venv venv

# Windows
venv\Scripts\activate

# Mac/Linux
source venv/bin/activate

pip install -r requirements.txt
python main.py
```

### 4. Run the backend

Create `backend/.env`:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=unicompare
PORT=5000
```

Then start the server:

```bash
cd backend
npm install
node server.js
```

Test it: `http://localhost:5000/api/health`

### 5. Run the frontend

Create `frontend/.env.local`:

```
NEXT_PUBLIC_API_URL=http://localhost:5000/api
```

Then start the frontend:

```bash
cd frontend
npm install
npm run dev
```

Open `http://localhost:3000`

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Check API is running |
| GET | `/api/programs` | List programs with optional filters |
| GET | `/api/programs/:id` | Get one program by ID |
| GET | `/api/programs/compare/list?ids=1,2,3` | Compare up to 4 programs |
| GET | `/api/programs/fields/list` | Get all fields of study |
| GET | `/api/universities` | List all universities |
| GET | `/api/universities/:id/programs` | Programs for one university |

### Filter example

```
GET /api/programs?field=Information Technology&level=Masters&maxFee=45000&ielts=6.5
```

Supported query params: `field`, `level`, `delivery`, `minFee`, `maxFee`, `ielts`, `university`, `sort`, `order`

---

## Features

- Search programs by university name
- Filter by field, level, delivery mode, fee range, and IELTS score
- Sort by fee, ranking, or name
- Add up to 4 programs to compare side by side
- Visual bar chart for tuition fee comparison
- Career outcomes: average salary and employment rate
- Visa pathway information per program
- Fully responsive layout

## Out of scope (Phase 2)

- Student accounts and saved comparisons
- AI recommendation engine
- Personalised GPA and budget filtering
- International universities outside Australia
- Mobile app

---

## Data Sources

All data is publicly available. No paid or proprietary sources are used.

- [Study Australia](https://www.studyaustralia.gov.au)
- [CRICOS Register](https://cricos.education.gov.au)
- [QS World University Rankings](https://www.topuniversities.com)
- Individual university websites

---

---

> This project is a prototype built for academic assessment. DNC is used as a dummy company name. No real commercial partnership exists.
