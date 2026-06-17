-- =============================================================================
--  NETFLIX CONTENT ANALYSIS (2016–2025) — SQL Q&A FILE
--  Author  : Prajoshna Aare
--  Dataset : Netflix_2016_2025
--  Purpose : Business Intelligence & Portfolio Demonstration
--  Tool    : Standard SQL (compatible with MySQL / PostgreSQL / SQL Server)
-- =============================================================================


-- =============================================================================
-- Q1. How many titles did Netflix release each year?
-- =============================================================================

SELECT
    Year,
    COUNT(Title)         AS Total_Titles
FROM netflix_content
GROUP BY Year
ORDER BY Year ASC;


-- =============================================================================
-- Q2. What are the Top 10 most watched titles on Netflix?
-- =============================================================================

SELECT
    Title,
    Year,
    Genre,
    Country,
    IMDb,
    Viewership
FROM netflix_content
ORDER BY CAST(REPLACE(Viewership, 'M', '') AS DECIMAL(10,2)) DESC
LIMIT 10;


-- =============================================================================
-- Q3. Which country has produced the most Netflix content?
-- =============================================================================

SELECT
    Country,
    COUNT(Title)         AS Total_Titles
FROM netflix_content
GROUP BY Country
ORDER BY Total_Titles DESC;


-- =============================================================================
-- Q4. What is the average IMDb rating of Netflix content by genre?
-- =============================================================================

SELECT
    TRIM(Genre)          AS Genre,
    COUNT(Title)         AS Total_Titles,
    ROUND(AVG(IMDb), 2)  AS Avg_IMDb_Rating
FROM netflix_content
GROUP BY TRIM(Genre)
HAVING COUNT(Title) >= 2
ORDER BY Avg_IMDb_Rating DESC;


-- =============================================================================
-- Q5. Which titles have an IMDb rating higher than the platform average?
-- =============================================================================

SELECT
    Title,
    Year,
    Genre,
    IMDb,
    CASE
        WHEN IMDb >= 9.0 THEN 'Elite'
        WHEN IMDb >= 8.0 THEN 'Excellent'
        WHEN IMDb >= 7.0 THEN 'Good'
        ELSE 'Average'
    END AS Quality_Label
FROM netflix_content
WHERE IMDb > (SELECT AVG(IMDb) FROM netflix_content)
ORDER BY IMDb DESC;


-- =============================================================================
-- Q6. Which directors have made more than one title on Netflix?
-- =============================================================================

SELECT
    `Directors/Creators`     AS Director,
    COUNT(Title)             AS Total_Titles,
    ROUND(AVG(IMDb), 2)      AS Avg_IMDb_Rating
FROM netflix_content
GROUP BY `Directors/Creators`
HAVING COUNT(Title) > 1
ORDER BY Total_Titles DESC;


-- =============================================================================
-- Q7. What was the best rated Netflix title each year?
-- =============================================================================

SELECT
    n.Year,
    n.Title,
    n.Genre,
    n.Country,
    n.IMDb     AS Highest_IMDb
FROM netflix_content n
INNER JOIN (
    SELECT Year, MAX(IMDb) AS Max_IMDb
    FROM netflix_content
    GROUP BY Year
) best
ON n.Year = best.Year AND n.IMDb = best.Max_IMDb
ORDER BY n.Year ASC;


-- =============================================================================
-- Q8. How does South Korea compare to USA and UK on Netflix?
-- =============================================================================

SELECT
    Country,
    COUNT(Title)                                                      AS Total_Titles,
    ROUND(AVG(IMDb), 2)                                               AS Avg_IMDb_Rating,
    ROUND(
        AVG(CAST(REPLACE(Viewership, 'M', '') AS DECIMAL(10,2)))
    , 2)                                                              AS Avg_Viewership_Millions
FROM netflix_content
WHERE Country IN ('USA', 'South Korea', 'UK')
GROUP BY Country
ORDER BY Avg_IMDb_Rating DESC;


-- =============================================================================
-- END OF FILE
-- Connect: linkedin.com/in/prajoshna-aare-a87554216
-- =============================================================================
