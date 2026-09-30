# 🏏 IPL Multi-Season SQL Analytics (2018–2019)
### Relational Performance Analysis in Google Cloud BigQuery

[![GitHub Repository](https://img.shields.io/badge/GitHub-Tihor36%2FIpl--2018--2019--sql--analytics-181717?logo=github&logoColor=white)](https://github.com/Tihor36/Ipl-2018-2019-sql-analytics)
[![Google Cloud BigQuery](https://img.shields.io/badge/GCP-BigQuery%20Studio-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/bigquery)
[![SQL Dialect](https://img.shields.io/badge/Language-GoogleSQL-F29111?logo=googlecloud&logoColor=white)](#)
[![Deck](https://img.shields.io/badge/Presentation-Visual%20Case%20Study%20Deck-22C55E?logo=adobeacrobatreader&logoColor=white)](presentation/IPL_2018_vs_2019_Case_Study.pdf)

---

## 📌 Executive Summary

This project analyzes player and franchise performance across the **2018 and 2019 Indian Premier League (IPL)** seasons using **Google Cloud BigQuery** (`hitman22.ipl_analysis`). 

By examining four distinct seasonal tables across batsmen and bowlers, this analysis moves beyond raw run totals to investigate efficiency benchmarks, multi-season consistency, defensive bowling economy, and boundary impact.

---

## 📊 Core Business & Analytics Insights

| Insight Area | Conventional Metric | What the Data Discovered | Strategic Franchise Takeaway |
| :--- | :--- | :--- | :--- |
| **Run Volume vs. Winning** | Aggregate runs predict playoff qualification. | **Kings XI Punjab** led 2019 with **2,141 runs**, narrowly beating champions **Mumbai Indians (2,137 runs)**, yet missed the playoffs. | High aggregate runs without balanced bowling containment does not guarantee franchise success. |
| **Cross-Season Consistency** | Single-season peak scorers represent top auction value. | **KL Rahul** led all players across both seasons combined with **1,252 runs** and **12 half-centuries** (6 in 2018, 6 in 2019). | Prioritize longitudinal anchors who sustain multi-year consistency across changing pitch and squad conditions. |
| **High-Impact Scoring** | Raw batting average reflects batting value. | **Kane Williamson** scored 735 runs in 2018 at a **142.44 SR**, and **Rishabh Pant** produced **105 boundaries** (68 fours, 37 sixes). | High strike-rate scoring and boundary generation provide higher match-winning equity than slow strike rotation. |
| **Defensive Choke Points** | Bowling strike rate is the only wicket-taking metric. | **Rashid Khan** captured 21 wickets while restricting opponents to an **Economy Rate of 6.74**. | Elite sub-7.0 economy bowling controls middle overs and forces opposition risk. |
| **Match-Winning Breakthroughs** | Wicket volume alone measures strike bowler utility. | **Andrew Tye** took 24 wickets in 2018 and secured **3 four-wicket hauls** in 2019. | Multi-wicket haul bowlers break game momentum in high-scoring encounters. |

---

## 🏗️ Relational Schema Architecture

The dataset is hosted on Google BigQuery under dataset `hitman22.ipl_analysis` across four primary relational tables:

```mermaid
erDiagram
    2018_BATSMEN {
        STRING Player PK
        STRING Team FK
        INTEGER Mat
        INTEGER Inns
        INTEGER NO
        INTEGER Runs
        STRING HS
        INTEGER Century
        INTEGER Fifties
        FLOAT Avg
        FLOAT SR
        INTEGER Fours
        INTEGER Sixes
    }

    2019_BATSMEN {
        STRING Player PK
        STRING Team FK
        INTEGER Mat
        INTEGER Inns
        INTEGER NO
        INTEGER Runs
        STRING HS
        INTEGER Century
        INTEGER Fifties
        FLOAT Avg
        FLOAT SR
        INTEGER Fours
        INTEGER Sixes
    }

    2018_BOWLERS {
        STRING Player PK
        STRING Team FK
        INTEGER Mat
        FLOAT Overs
        INTEGER Mdns
        INTEGER Runs
        INTEGER Wkts
        FLOAT Avg
        FLOAT ER
        FLOAT SR
        INTEGER FourWs
    }

    2019_BOWLERS {
        STRING Player PK
        STRING Team FK
        INTEGER Mat
        FLOAT Overs
        INTEGER Mdns
        INTEGER Runs
        INTEGER Wkts
        FLOAT Avg
        FLOAT ER
        FLOAT SR
        INTEGER FourWs
    }

    2018_BATSMEN ||--o| 2019_BATSMEN : "Cross-Season Join (Player = Player)"
    2018_BOWLERS ||--o| 2019_BOWLERS : "Cross-Season Join (Player = Player)"
    2018_BATSMEN ||--o| 2018_BOWLERS : "All-Rounder Join (Player = Player)"
```

---

## 💻 Featured SQL Queries & Verified BigQuery Results

All queries below are taken directly from `BigQuery_ipl_analysis.sql` and run on dataset `hitman22.ipl_analysis`.

### 1. Longitudinal Run Scoring Across Both Seasons (`INNER JOIN` + Arithmetic Addition)
*Identifies which batsman scored the most combined runs across 2018 and 2019.*

```sql
SELECT 
  b.Player, 
  (a.Runs + b.Runs) AS most_runs
FROM `hitman22.ipl_analysis.2018_batsmen` AS a 
INNER JOIN `hitman22.ipl_analysis.2019_batsmen` AS b
  ON a.Player = b.Player
ORDER BY most_runs DESC
LIMIT 1;
```

**BigQuery Result:**
| Row | Player | most_runs |
| :---: | :--- | :---: |
| 1 | **Rahul, K L** | **1,252** |

---

### 2. Multi-Season Milestone Consistency (`INNER JOIN`)
*Calculates which batsman registered the highest number of half-centuries combined across both seasons.*

```sql
SELECT 
  a.Player,
  (a.Fifties + b.Fifties) AS Total_Fifties
FROM `hitman22.ipl_analysis.2018_batsmen` AS a 
INNER JOIN `hitman22.ipl_analysis.2019_batsmen` AS b
  ON a.Player = b.Player
ORDER BY Total_Fifties DESC 
LIMIT 1;
```

**BigQuery Result:**
| Row | Player | Total_Fifties |
| :---: | :--- | :---: |
| 1 | **Rahul, K L** | **12** (6 in 2018 + 6 in 2019) |

---

### 3. Franchise Run Accumulation Paradox (`GROUP BY` + `SUM`)
*Aggregates team run production for the 2019 season to evaluate total volume.*

```sql
SELECT 
  Team, 
  SUM(Runs) AS Total_Runs
FROM `hitman22.ipl_analysis.2019_batsmen`
GROUP BY Team
ORDER BY SUM(Runs) DESC;
```

**BigQuery Result:**
| Row | Team | Total Runs | 2019 Tournament Outcome |
| :---: | :--- | :---: | :--- |
| 1 | **Kings XI Punjab** | **2,141** | 6th Place (Missed Playoffs) |
| 2 | **Mumbai Indians** | **2,137** | **IPL 2019 Champions 🏆** |
| 3 | Kolkata Knight Riders | 2,090 | 5th Place |
| 4 | Chennai Super Kings | 2,045 | Runners-Up 🥈 |
| 5 | Sunrisers Hyderabad | 1,996 | 4th Place (Playoffs) |
| 6 | Delhi Capitals | 1,909 | 3rd Place (Playoffs) |
| 7 | Royal Challengers Bangalore | 1,808 | 8th Place |
| 8 | Rajasthan Royals | 1,789 | 7th Place |

---

### 4. High-Volume Efficient Batting (`WHERE` Multi-Condition Filter)
*Filters batsmen in 2018 who scored heavily while maintaining a strike rate of 130 or higher.*

```sql
SELECT 
  Player, 
  Team, 
  Runs, 
  SR
FROM `hitman22.ipl_analysis.2018_batsmen`
WHERE SR >= 130
ORDER BY Runs DESC 
LIMIT 1;
```

**BigQuery Result:**
| Row | Player | Team | Runs | SR |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Williamson, K S** | Sunrisers Hyderabad | **735** | **142.44** |

---

### 5. Boundary Generation Leaderboard (`WHERE` + Combined Column Arithmetic)
*Calculates total boundaries ($Fours + Sixes$) per batsman in 2018.*

```sql
SELECT 
  Player, 
  Fours, 
  Sixes, 
  (Fours + Sixes) AS Boundaries
FROM `hitman22.ipl_analysis.2018_batsmen`
WHERE Fours + Sixes >= 1
ORDER BY Boundaries DESC;
```

**BigQuery Result (Top 5):**
| Row | Player | Fours | Sixes | Total Boundaries |
| :---: | :--- | :---: | :---: | :---: |
| 1 | **Pant, R R** | 68 | 37 | **105** |
| 2 | **Rahul, K L** | 66 | 32 | 98 |
| 3 | **Williamson, K S** | 63 | 28 | 91 |
| 4 | Rayudu, A T | 53 | 34 | 87 |
| 5 | Watson, S R | 44 | 35 | 79 |

---

### 6. Defensive Bowling Containment Under 7.0 Economy (`WHERE` Multi-Filter)
*Identifies the bowler with the most wickets while conceding fewer than 7 runs per over in 2018.*

```sql
SELECT 
  Player, 
  Team, 
  Wkts, 
  ER
FROM `hitman22.ipl_analysis.2018_bowlers`
WHERE ER < 7
ORDER BY Wkts DESC
LIMIT 1;
```

**BigQuery Result:**
| Row | Player | Team | Wkts | ER |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Rashid Khan** | Sunrisers Hyderabad | **21** | **6.74** |

---

### 7. Strike Bowler Multi-Wicket Hauls in 2019 (`WHERE FourWs > 0`)
*Pinpoints bowlers capable of delivering breakthrough multi-wicket overs.*

```sql
SELECT 
  Player, 
  FourWs
FROM `hitman22.ipl_analysis.2019_bowlers`
WHERE FourWs > 0;
```

**BigQuery Result:**
| Row | Player | Four-Wicket Hauls (`FourWs`) |
| :---: | :--- | :---: |
| 1 | Ngidi, L | 1 |
| 2 | **Tye, A J** | **3** |
| 3 | Rajpoot, A S | 1 |
| 4 | Kuldeep Yadav | 1 |
| 5 | Prasidh Krishna, M | 1 |
| 6 | Markande, M | 1 |
| 7 | Gopal, S | 1 |

---

### 8. All-Rounder Identification via Intra-Season `INNER JOIN`
*Cross-references 2018 bowling and batting rosters to isolate two-way contributors.*

```sql
SELECT 
  a.Player, 
  a.Team
FROM `hitman22.ipl_analysis.2018_bowlers` AS a 
INNER JOIN `hitman22.ipl_analysis.2018_batsmen` AS b 
  ON a.Player = b.Player;
```

---

## 🛠️ Technical Skills Demonstrated

- **Platform:** Google Cloud BigQuery Studio
- **Relational Joins:** `INNER JOIN` across seasonal tables (`2018_batsmen` $\leftrightarrow$ `2019_batsmen`) and intra-season tables (`batsmen` $\leftrightarrow$ `bowlers`).
- **Aggregations & Grouping:** `GROUP BY`, `SUM()`, `COUNT()`, and alias sorting.
- **Conditional Filtering:** `WHERE` clauses with multi-operator thresholds (`SR >= 130`, `ER < 7`, `FourWs > 0`, `Overs > 1`).
- **Calculated Fields:** Multi-column arithmetic for milestone aggregation (`(a.Runs + b.Runs)`, `(a.Fifties + b.Fifties)`, `(Fours + Sixes)`).
- **Data Sorting & Filtering:** Deterministic ordering with `ORDER BY ... DESC` and result slicing with `LIMIT`.

---

## 📁 Repository Structure

```text
Ipl-2018-2019-sql-analytics/
├── README.md                           <-- Primary technical landing page
├── BigQuery_ipl_analysis.sql           <-- Complete production BigQuery script
├── data/
│   ├── 2018_Batsmen_new.csv
│   ├── 2019_Batsmen.csv
│   ├── 2018_Bowlers.csv
│   └── 2019_Bowlers_new.csv
└── presentation/
    └── SQL_Insights_From_T20_Cricket_Analytics.pptx <-- Executive visual deck
```

---

## 🚀 How to Replicate

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Tihor36/Ipl-2018-2019-sql-analytics.git
   cd Ipl-2018-2019-sql-analytics
   ```

2. **Set up Google Cloud BigQuery:**
   - Create a project in Google Cloud Console.
   - Create a dataset named `ipl_analysis`.
   - Ingest the 4 CSV files located in `data/` into tables named `2018_batsmen`, `2019_batsmen`, `2018_bowlers`, and `2019_bowlers`.

3. **Run Queries:**
   - Execute queries directly from `BigQuery_ipl_analysis.sql` in the BigQuery Studio SQL editor.

---

## 👤 Author & Contact

**Rohit Kumar**  
*Aspiring Data Analyst*

* **GitHub:** [@Tihor36](https://github.com/Tihor36)
* **LinkedIn:** [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
* **Email:** [hello@yourdomain.com](mailto:hello@yourdomain.com)