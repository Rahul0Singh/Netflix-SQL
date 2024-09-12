-- Business Problems

select * from netflix
--1. Count the Number of Movies vs TV Shows

SELECT type,COUNT(*)
FROM netflix
group by type


--2. Find the Most Common Rating for Movies and TV Shows
select type,rating from(
	SELECT type,rating,count(*),
        RANK() OVER (PARTITION BY type ORDER BY count(*) DESC) AS ranking
    FROM netflix
	group by 1,2)as t1
WHERE ranking = 1;


--3. List All Movies Released in a Specific Year 2020
SELECT * 
FROM netflix
WHERE release_year = 2020 and type='Movie';


--4. Find the Top 5 Countries with the Most Content on Netflix
SELECT * FROM(
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country,COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;


--5. Identify the Longest Movie
SELECT * FROM netflix
WHERE type = 'Movie'
and duration=(select max(duration)from netflix)
	

--6. Find Content Added in the Last 5 Years
SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director ilike '%Rajiv Chilaka%';


--8. List All TV Shows with More Than 5 Seasons
SELECT * FROM netflix
WHERE type = 'TV Show' 
	AND 
	SPLIT_PART(duration, ' ', 1)::INT > 5;


--9. Count the Number of Content Items in Each Genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


--10 Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!

SELECT country,release_year,COUNT(show_id) AS total_release,
    ROUND(COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
limit 5


--11. List All Movies that are Documentaries
SELECT * FROM netflix
WHERE listed_in iLIKE '%Documentaries';


--12. Find All Content Without a Director
SELECT * FROM netflix
WHERE director IS NULL;


--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


--Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with cte as(
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' 
	OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix)
SELECT category,COUNT(*) AS content_count FROM cte
	GROUP BY category;

