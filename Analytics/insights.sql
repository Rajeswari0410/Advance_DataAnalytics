/*
What is the distribution of daily screen time?
What is the average daily screen time by age group and gender?
Which device is the most commonly used?
What is the average education-to-recreation ratio across age groups?
Do urban kids spend more time on screens compared to rural kids?
What are the most commonly reported health impacts of screen time among kids?
Which group of kids (Urban or Rural) uses devices the most?
*/

/* What is the distribution of daily screen time? */
SELECT COUNT(*) FROM silver.kids_screen_time;
SELECT COUNT(*) FROM gold.fact_kids;

SELECT * FROM gold.fact_kids;

--make intervals: 0 - 13.89 {0 - 4, 4 - 6, 6 - 8, 8 - 10, 10-12, 12+)
-- SELECT MAX(avg_daily_screen_time_hr) from gold.fact_kids;
SELECT interval, COUNT(*) AS daily_screen_time_distribution 
FROM(
	SELECT avg_daily_screen_time_hr, 
	CASE WHEN avg_daily_screen_time_hr >= 0 AND avg_daily_screen_time_hr < 4
		THEN '0-4'
		WHEN avg_daily_screen_time_hr >= 4 AND avg_daily_screen_time_hr < 6
		THEN '4-6'
		WHEN avg_daily_screen_time_hr >= 6 AND avg_daily_screen_time_hr < 8
		THEN '6-8'
		WHEN avg_daily_screen_time_hr >= 8 AND avg_daily_screen_time_hr < 10
		THEN '8-10'
		WHEN avg_daily_screen_time_hr >= 10 AND avg_daily_screen_time_hr < 12
		THEN '10-12'
		ELSE '12+'
	END AS interval
	FROM gold.fact_kids
	) t
GROUP BY interval
ORDER BY daily_screen_time_distribution DESC;

/* What is the average daily screen time by age group and gender? */

SELECT MIN(age) AS minimum_age, MAX(age) AS maximum_age FROM gold.dim_kids; --> 8 - 18

-- age groups: 8-10, 10-12, 12-14, 14-16, 16-18
WITH cte_age_grouping AS (
	SELECT d.gender, d.age,
	CASE WHEN d.age >= 8 AND d.age < 10 THEN '8-10'
		WHEN d.age >= 10 AND d.age < 12 THEN '10-12'
		WHEN d.age >= 12 AND d.age < 14 THEN '12-14'
		WHEN d.age >= 14 AND d.age < 16 THEN '14-16'
		ELSE '16+'
	END AS age_interval,
	f.avg_daily_screen_time_hr,
	FROM gold.fact_kids f
		INNER JOIN gold.dim_kids d
	ON f.kid_key = d.kid_key
)
SELECT gender, age_interval, 
ROUND(AVG(avg_daily_screen_time_hr), 2) AS average_daily_screen_time
FROM cte_age_grouping
GROUP BY gender, age_interval
ORDER BY gender;

/* Which device is the most commonly used? */
SELECT primary_device, COUNT(*) AS num_of_devices
FROM gold.dim_kids
GROUP BY primary_device
ORDER BY num_of_devices DESC;

/* What is the average education-to-recreation ratio across age groups? */
WITH cte_age_grouping AS (
	SELECT d.gender, d.age,
	CASE WHEN d.age >= 8 AND d.age < 10 THEN '8-10'
		WHEN d.age >= 10 AND d.age < 12 THEN '10-12'
		WHEN d.age >= 12 AND d.age < 14 THEN '12-14'
		WHEN d.age >= 14 AND d.age < 16 THEN '14-16'
		ELSE '16+'
	END AS age_interval,
	f.educational_to_recreational_ratio
	FROM gold.fact_kids f
		INNER JOIN gold.dim_kids d
	ON f.kid_key = d.kid_key
)
SELECT age_interval, 
ROUND(AVG(educational_to_recreational_ratio), 2) AS educational_to_recreational_ratio
FROM cte_age_grouping
GROUP BY age_interval
ORDER BY educational_to_recreational_ratio DESC;

/* urban kids vs rural kids */
SELECT COUNT(*) AS total_kids,
SUM(d.is_urban) AS urban_kids,
COUNT(*) - SUM(d.is_urban) AS rural_kids
FROM gold.fact_kids f
INNER JOIN gold.dim_kids d
ON f.kid_key = d.kid_key;

/* Do urban kids spend more time on screens compared to rural kids? */
SELECT 
CASE WHEN d.is_urban = '1' THEN 'urban'
	ELSE 'rural'
END AS urban_or_rural,
ROUND(AVG(f.avg_daily_screen_time_hr), 4)
FROM gold.fact_kids f
INNER JOIN gold.dim_kids d
ON f.kid_key = d.kid_key
GROUP BY d.is_urban;

/* What are the most commonly reported health impacts of screen time among kids? */
-- SELECT * FROM gold.dim_kids;
-- SELECT COUNT(*) FROM gold.fact_kids; -- all kids

SELECT SUM(CASE WHEN d.health_impacts LIKE '%Anxiety%' THEN 1 ELSE 0 END) AS Anxiety,
	SUM(CASE WHEN d.health_impacts LIKE '%Poor sleep%' THEN 1 ELSE 0 END) AS Poor_sleep,
	SUM(CASE WHEN d.health_impacts LIKE '%Eye strain%' THEN 1 ELSE 0 END) AS Eye_strain,
	SUM(CASE WHEN d.health_impacts LIKE '%Obesity risk%' THEN 1 ELSE 0 END) AS Obesity
FROM gold.fact_kids f
LEFT JOIN gold.dim_kids d
ON f.kid_key = d.kid_key;

SELECT 
    v.impact,
    COUNT(*) AS total
FROM gold.fact_kids f
JOIN gold.dim_kids d
    ON f.kid_key = d.kid_key
CROSS APPLY (VALUES
    ('Anxiety'),
    ('Poor sleep'),
    ('Eye strain'),
    ('Obesity risk')
) v(impact)
WHERE d.health_impacts LIKE '%' + v.impact + '%'
GROUP BY v.impact;

/* Which group of kids (Urban or Rural) uses devices the most? */
SELECT primary_device, is_urban,
	COUNT(*) as num_kids
FROM gold.dim_kids
GROUP BY primary_device, is_urban
ORDER BY num_kids DESC;
