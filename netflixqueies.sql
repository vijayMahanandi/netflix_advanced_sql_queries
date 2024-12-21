

--Q1) count number of tv shows vs movies in netflix 

select type ,count(*) as count_type
from netflix 
group by 1;

--Q2) find the most common rating for movies and tv shows


WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


--Q3) List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020;

--Q4)  top 5 countries with most content on netflix;

select unnest (string_to_array(country,',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1 
order by 2 desc
limit 5; 

-- UNNEST ) IS used to convert nestedarray or list into individual rows

--Q5) identify the longest movie

select * from netflix
	WHERE  
	type='Movie'
	AND
	duration=(SELECT MAX(duration) from netflix);

--Q6) Find content added in last 5 years

select * from netflix
		WHERE
		TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE - INTERVAL '5years';

--SELECT CURRENT_DATE - INTERVAL '5years';



--Q7) find all movies/tv shows by director 'Rajiv Chilaka'

SELECT * from netflix
	WHERE  director ILIKE '%Rajiv Chilaka%';

--> (ILIKE) IT HELPS to remove case sensitive senario


--Q8) list all tv shows with more than 5 seasons

select * from netflix 
	WHERE 
	 	type ilike 'tv show'
		AND
		SPLIT_PART(duration,' ',1)::numeric >5

--> split_part helps to split a text by space and 1 indicates a part before first space 
-->Since it return-->text ,then we need to convert it into number by (:: numeric)
		

--Q9)  count the number of items in each genre 

SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
		count(show_id) as total_content
from netflix
group by 1;

--Q10) find each year and the average number of content release by india on netflix

SELECT * FROM netflix;

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) as year ,
	Count(*) as yearly_content,
	ROUND(
	COUNT(*)::NUMERIC /(SELECT COUNT(*) FROM netflix WHERE country ='India')::NUMERIC*100
	,2) AS avg_content_per_year
FROM netflix
WHERE country='India' 
GROUP BY 1;


--Q11) List all movies that are documentaries

SELECT * FROM netflix
WHERE 
	type ilike 'movie'
	AND
	listed_in ilike '%documentaries%';


--Q12) Find all content without a director

SELECT * FROM netflix
WHERE 
	director ISNULL;


--Q13)FIND how many movies actor 'Salman Khan ' appeared in last 10 years

select * from netflix
where
 casts ilike '%salman khan%'
 and
  release_year> EXTRACT(YEAR FROM CURRENT_DATE)-10;



--Q14) find top 10 actor who have appered  in highest  number of movies produced in india

select unnest(STRING_TO_ARRAY(casts,',')) as actors,
count(*) as total_content from netflix
where country ilike '%india%'
Group by 1
order by 2 desc
limit 10;

--Q15) Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table
as
(
select *,
	case
	when description ilike '%kill%' or
	description ilike '%violence%' then 'Bad_content'
	else 'good_content'
	end category
from netflix 
)


select category ,count(*) as total_content 
from new_table 
group by 1;
	
	
	

	
	