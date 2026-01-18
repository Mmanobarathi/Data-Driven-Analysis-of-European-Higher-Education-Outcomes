
-- European higher education dataset integrating demographics, academic fields,
-- international student origin, and programme funding for cross-country analysis.

use education_europe;
SHOW TABLES;
describe clean_gender;
describe cleaned_fields;
describe cleaned_origin;
describe cleaned_programmes;

-- Standardized column name by renaming encoded header (ï»¿country) to 'country' for reliable joins and primary key usage.

ALTER TABLE clean_gender
RENAME COLUMN `ï»¿country` TO country;
ALTER TABLE cleaned_origin
RENAME COLUMN `ï»¿country` TO country;
ALTER TABLE cleaned_fields
RENAME COLUMN`ï»¿country`TO country;
ALTER TABLE cleaned_programmes
RENAME COLUMN `ï»¿country` TO country;


-- Changed country column data type from TEXT to VARCHAR to allow primary key creation and improve indexing performance.

ALTER TABLE clean_gender
MODIFY country VARCHAR(100) NOT NULL;
alter table cleaned_fields 
modify country varchar(100) not null;
alter table cleaned_origin 
modify country varchar(100) not null;
alter table cleaned_programmes
modify country varchar(100) not null;

-- adding primary key as country for all table 
ALTER TABLE clean_gender
ADD PRIMARY KEY (country);
ALTER TABLE cleaned_fields
ADD PRIMARY KEY (country);
ALTER TABLE cleaned_origin
ADD PRIMARY KEY (country);
ALTER TABLE cleaned_programmes
ADD PRIMARY KEY (country);

-- checking primary key 
SHOW KEYS FROM clean_gender;
SHOW KEYS FROM cleaned_fields;
SHOW KEYS FROM cleaned_origin;
SHOW KEYS FROM cleaned_programmes;

-- seeing the first 5 rows from tables 
SELECT * FROM clean_gender LIMIT 5;
SELECT * FROM cleaned_origin LIMIT 5;
SELECT * FROM cleaned_fields LIMIT 5;
SELECT * FROM cleaned_programmes LIMIT 5;


-- Calculates total students by gender across all study levels to rank countries by overall enrollment.

SELECT 
    country,
    (short_cycle_men + bachelor_men + master_men + doctoral_men) AS total_men,
    (short_cycle_women + bachelor_women + master_women + doctoral_women) AS total_women,
    ((short_cycle_men + bachelor_men + master_men + doctoral_men) +
     (short_cycle_women + bachelor_women + master_women + doctoral_women)) AS total_students
FROM clean_gender
ORDER BY total_students DESC;


-- Retrieves the top 5 individual countries by total student enrollment, excluding EU as it represents an aggregate.

SELECT
    country,
    (short_cycle_men + bachelor_men + master_men + doctoral_men +
     short_cycle_women + bachelor_women + master_women + doctoral_women) AS total_students
FROM clean_gender
WHERE country <> 'EU'
ORDER BY total_students DESC
LIMIT 5;

-- Retrieves the bottom 5 individual countries by total student enrollment, excluding EU aggregate data.
SELECT
    country,
    (short_cycle_men + bachelor_men + master_men + doctoral_men +
     short_cycle_women + bachelor_women + master_women + doctoral_women) AS total_students
FROM clean_gender
WHERE country <> 'EU'
ORDER BY total_students ASC
LIMIT 5;


-- Extracts overall EU student enrollment separately as an aggregate benchmark.
SELECT
    country,
    (short_cycle_men + bachelor_men + master_men + doctoral_men +
     short_cycle_women + bachelor_women + master_women + doctoral_women) AS total_students
FROM clean_gender
WHERE country = 'EU';

-- Identifies the top 5 countries with the highest share of students from the dominant origin.
SELECT
    country,
    origin_1,
    origin_1_share
FROM cleaned_origin
WHERE origin_1_share IS NOT NULL
ORDER BY origin_1_share DESC
LIMIT 5;

-- Identifies the bottom 5 countries with the lowest share of students from the dominant origin.
SELECT
    country,
    origin_1,
    origin_1_share
FROM cleaned_origin
WHERE origin_1_share IS NOT NULL
ORDER BY origin_1_share ASC
LIMIT 5;


-- Retrieves the dominant student origin group for Germany.
SELECT
    country,
    origin_1 AS top_student_origin,
    origin_1_share AS top_origin_share
FROM cleaned_origin
WHERE country = 'Germany';

-- Displays the full distribution of student origin shares for Germany.
SELECT
    country,
    origin_1, origin_1_share,
    origin_2, origin_2_share,
    origin_3, origin_3_share
FROM cleaned_origin
WHERE country = 'Germany';

-- Which origin group dominates European higher education overall
SELECT
    origin_1,
    ROUND(AVG(origin_1_share), 2) AS avg_origin_1_share
FROM cleaned_origin
WHERE origin_1_share IS NOT NULL
GROUP BY origin_1
ORDER BY avg_origin_1_share DESC
limit 5;

-- basic inner join
SELECT
    g.country,
    g.bachelor_total,
    g.bachelor_men,
    g.bachelor_women,
    o.origin_1,
    o.origin_1_share
FROM clean_gender g
INNER JOIN cleaned_origin o
    ON g.country = o.country
    limit 5;
    
    -- basic inner join to find the doctoral level of education amoung countries 
    select g.country,g.doctoral_total,g.doctoral_men,g.doctoral_women,
    o.origin_1 from clean_gender g 
    join cleaned_origin o on g.country=o.country
    order by doctoral_total desc
    limit 5;
    
    -- selecting the countries where the rate of womens doctoral program is higher
    SELECT
    country,
    doctoral_total,
    doctoral_women,
    ROUND((doctoral_women / doctoral_total) * 100, 2) AS women_percentage
FROM clean_gender
WHERE doctoral_total > 0
ORDER BY women_percentage DESC
LIMIT 5;

-- selecting bachelor level highest women's percentage rate
    SELECT
    g.country,
    g.bachelor_total,
    g.bachelor_women,
    ROUND((g.bachelor_women / g.bachelor_total) * 100, 2) AS women_percentage,
    o.origin_1
FROM clean_gender g
INNER JOIN cleaned_origin o
    ON g.country = o.country
WHERE g.bachelor_total > 0
ORDER BY women_percentage DESC;


-- Aggregates country-level totals across all countries to compute overall students per education level.

SELECT
    'Short Cycle' AS education_level, SUM(short_cycle_total) AS total_students
FROM clean_gender WHERE country <> 'EU'
UNION ALL
SELECT 'Bachelor', SUM(bachelor_total) FROM clean_gender WHERE country <> 'EU'
UNION ALL
SELECT 'Master', SUM(master_total) FROM clean_gender WHERE country <> 'EU'
UNION ALL
SELECT 'Doctoral', SUM(doctoral_total) FROM clean_gender WHERE country <> 'EU'
ORDER BY total_students DESC;

-- Calculates total students per education field to determine which fields attract the most students.
SELECT 'Generic Programmes' AS field, SUM(`generic programmes and qualifications`) AS total_students FROM cleaned_fields
UNION ALL
SELECT 'Education', SUM(`education`) FROM cleaned_fields
UNION ALL
SELECT 'Arts & Humanities', SUM(`arts and humanities`) FROM cleaned_fields
UNION ALL
SELECT 'Social Sciences', SUM(`social sciences journalism and information`) FROM cleaned_fields
UNION ALL
SELECT 'Business & Law', SUM(`business administration and law`) FROM cleaned_fields
UNION ALL
SELECT 'Natural Sciences', SUM(`natural sciences mathematics and statistics`) FROM cleaned_fields
UNION ALL
SELECT 'ICT', SUM(`information and communication technologies`) FROM cleaned_fields
UNION ALL
SELECT 'Engineering', SUM(`engineering manufacturing and construction`) FROM cleaned_fields
UNION ALL
SELECT 'Agriculture & Veterinary', SUM(`agriculture forestry fisheries and veterinary`) FROM cleaned_fields
UNION ALL
SELECT 'Health & Welfare', SUM(`health and welfare`) FROM cleaned_fields
UNION ALL
SELECT 'Services', SUM(`services`) FROM cleaned_fields
UNION ALL
SELECT 'Unknown', SUM(`unknown`) FROM cleaned_fields
ORDER BY total_students DESC;

--
SELECT 'Generic Programmes' AS field, SUM(`generic programmes and qualifications`) AS total_students FROM cleaned_fields
UNION ALL
SELECT 'Education', SUM(`education`) FROM cleaned_fields
UNION ALL
SELECT 'Arts & Humanities', SUM(`arts and humanities`) FROM cleaned_fields
UNION ALL
SELECT 'Social Sciences', SUM(`social sciences journalism and information`) FROM cleaned_fields
UNION ALL
SELECT 'Business & Law', SUM(`business administration and law`) FROM cleaned_fields
UNION ALL
SELECT 'Natural Sciences', SUM(`natural sciences mathematics and statistics`) FROM cleaned_fields
UNION ALL
SELECT 'ICT', SUM(`information and communication technologies`) FROM cleaned_fields
UNION ALL
SELECT 'Engineering', SUM(`engineering manufacturing and construction`) FROM cleaned_fields
UNION ALL
SELECT 'Agriculture & Veterinary', SUM(`agriculture forestry fisheries and veterinary`) FROM cleaned_fields
UNION ALL
SELECT 'Health & Welfare', SUM(`health and welfare`) FROM cleaned_fields
UNION ALL
SELECT 'Services', SUM(`services`) FROM cleaned_fields
UNION ALL
SELECT 'Unknown', SUM(`unknown`) FROM cleaned_fields
ORDER BY total_students DESC
LIMIT 1;

-- Calculates total students in technical fields (Engineering + ICT) per country and ranks countries by tech student population.
SELECT
    country,
    (`engineering manufacturing and construction`
     + `information and communication technologies`) AS tech_share
FROM cleaned_fields
ORDER BY tech_share DESC;

--
SELECT
    g.country,
    g.bachelor_total,
    ROUND((g.bachelor_women / g.bachelor_total) * 100, 2) AS women_bachelor_pct,
    o.origin_1,
    o.origin_1_share,
    (`engineering manufacturing and construction`
     + `information and communication technologies`) AS tech_field_share,
    p.eu_programmes,
    p.other_international_programmes
FROM clean_gender g
INNER JOIN cleaned_origin o
    ON g.country = o.country
INNER JOIN cleaned_fields f
    ON g.country = f.country
LEFT JOIN cleaned_programmes p
    ON g.country = p.country
WHERE g.bachelor_total > 0;

SELECT
    g.country,
    g.doctoral_total,
    o.origin_1,
    o.origin_1_share,
    (f.`engineering manufacturing and construction` + f.`information and communication technologies`) AS tech_students
FROM clean_gender g
LEFT JOIN cleaned_origin o
    ON g.country = o.country
LEFT JOIN cleaned_fields f
    ON g.country = f.country
ORDER BY g.doctoral_total DESC
LIMIT 5;


























