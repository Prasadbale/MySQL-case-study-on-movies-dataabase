USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Number of rows in director_mapping table

SELECT 
    COUNT(*) AS total_rows_director_mapping
FROM
    director_mapping; 

-- Number of rows in genre table

SELECT 
    COUNT(*) AS total_rows_genre
FROM
    genre;

-- Number of rows in movie table

SELECT 
    COUNT(*) AS total_rows_movie
FROM
    movie; 

-- Number of rows in names table

SELECT 
    COUNT(*) AS total_rows_names
FROM
    names;

-- Number of rows in ratings table

SELECT 
    COUNT(*) AS total_rows_ratings
FROM
    ratings; 

-- Number of rows in role_mapping table

SELECT 
    COUNT(*) AS total_rows_role_mapping
FROM
    role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
	SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
	SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
	SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS world_wide_gross_income_null_count,
	SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
	SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 



-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies release in each year

SELECT 
    year, 
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY year;

-- Total number of movies release in each month

SELECT 
    MONTH(date_published) AS month_number,
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY month_number
ORDER BY month_number;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(title) AS num_of_movies
FROM
    movie
WHERE
    (country REGEXP '.*USA.*'
        OR country REGEXP '.*India.*')
        AND year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    (genre)
FROM
    genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH genre_ranking AS															/* CTE for genre ranking */
(
	SELECT 
		genre,
		COUNT(movie_id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank			/* Ranking movie genres bases on the number of movies in that genre */
	FROM genre
	GROUP BY genre
)
SELECT 
	genre,
	movie_count
FROM genre_ranking;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_genre AS															/* CTE for finding the number of genres for a particular movie */
(
	SELECT 
		movie_id,
		count(genre) AS num_genre
	FROM genre
	GROUP BY movie_id
)
SELECT 
	COUNT(movie_id) AS movies_with_1_genre
FROM movie_genre
WHERE num_genre = 1;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    G.genre, 
    AVG(M.duration) AS avg_duration
FROM
    genre AS G
        INNER JOIN
    movie AS M ON G.movie_id = M.id
GROUP BY G.genre
ORDER BY AVG(M.duration) DESC;	


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_ranking AS															/* CTE for genre ranking */
(
	SELECT 
		genre,
		COUNT(movie_id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank			/* Ranking movie genres bases on the number of movies in that genre */
	FROM genre
	GROUP BY genre
)
SELECT 
	*
FROM genre_ranking
WHERE genre= 'Thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_ranking AS 
(
	SELECT
		M.title,
		R.avg_rating,
		DENSE_RANK() OVER(ORDER BY R.avg_rating DESC) AS movie_rank
	FROM	movie as M
			INNER JOIN
			ratings as R ON M.id = R.movie_id
)
SELECT *
FROM movie_ranking
WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating,
    COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_comp AS 													/* CTE for top production companies with movies rated more than 8 */
(
	SELECT
		M.production_company,
		COUNT(M.id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(M.id) DESC) AS prod_company_rank
	FROM movie AS M
		 INNER JOIN
		 ratings AS R ON M.id = R.movie_id
	WHERE R.avg_rating > 8 AND production_company IS NOT NULL
	GROUP BY production_company
)
SELECT * 
FROM top_production_comp
WHERE prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	G.genre,
    COUNT(G.movie_id) as movie_count

FROM movie AS M
	 INNER JOIN 
     genre AS G ON M.id = G.movie_id
     INNER JOIN
     ratings AS R ON R.movie_id = M.id

WHERE	MONTH(M.date_published) = 3 AND
		M.year = 2017 AND
        M.country REGEXP '.*USA.*' AND
        R.total_votes > 1000

GROUP BY G.genre
ORDER BY movie_count DESC;
		

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    M.title, R.avg_rating, G.genre
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON M.id = R.movie_id
        INNER JOIN
    genre AS G ON G.movie_id = M.id
WHERE
    M.title REGEXP '^The'
        AND R.avg_rating > 8;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(M.id) AS num_of_movies
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON M.id = R.movie_id
WHERE
    R.median_rating = 8
        AND (M.date_published BETWEEN '2018-04-01' AND '2019-04-01')
GROUP BY R.median_rating;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
    country, 
    SUM(total_votes) AS total_votes
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON R.movie_id = M.id
WHERE
    country = 'germany' OR country = 'italy'
GROUP BY country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS					/* CTE for top 3 genre based on the numver of movies in that genre with avg rating more than 8 */
(
	SELECT 
		G.genre,
		COUNT(G.movie_id)
	FROM
		genre AS G
		INNER JOIN
		ratings As R ON G.movie_id = R.movie_id
	WHERE
		R.avg_rating > 8
	GROUP BY 
		G.genre
	ORDER BY 
		COUNT(G.movie_id) DESC
	LIMIT 3
),
top_directores AS 					/* CTE for top directors based on number of movies made in top 3 genre */
(
	SELECT 
		N.name,
		COUNT(D.movie_id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(D.movie_id) DESC) AS director_rank
	FROM
		director_mapping AS D
		INNER JOIN
		names AS N ON D.name_id = N.id
		INNER JOIN 
		genre AS G ON G.movie_id = D.movie_id
		INNER JOIN
		ratings AS R ON R.movie_id = D.movie_id
	WHERE
		R.avg_rating > 8 AND G.genre IN (SELECT genre FROM top_3_genre)
	GROUP BY 
		N.name
)

SELECT
	name,
    movie_count
    
FROM 
    top_directores
WHERE director_rank<= 3;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_movies AS   					 	/* CTE for top movies with median rating > */
(
SELECT 
    movie_id
FROM
    ratings
WHERE
    median_rating >= 8
)
SELECT
	N.name,
    COUNT(RM.movie_id) AS movie_count
FROM 
	names AS N
    INNER JOIN
    role_mapping AS RM ON RM.name_id = N.id
WHERE 
	RM.movie_id IN (SELECT * FROM top_movies)
GROUP BY N.name
ORDER BY COUNT(RM.movie_id) DESC
LIMIT 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_produciton_house AS 						/* CTE for top production houses based on total votes recieved */
(
	SELECT 
		M.production_company,
		SUM(R.total_votes) AS vote_count,
		DENSE_RANK() OVER(ORDER BY SUM(R.total_votes) DESC) AS prod_comp_rank
	FROM
		movie AS M
		INNER JOIN
		ratings AS R ON M.id = R.movie_id

	WHERE 
		M.production_company IS NOT NULL
	GROUP BY 
		M.production_company
)
SELECT 
    *
FROM
    top_produciton_house
WHERE
    prod_comp_rank <= 3;
    


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	N.name AS actor_name,
    SUM(R.total_votes) AS total_votes,
    COUNT(RM.movie_id) AS movie_count,
    ROUND(SUM(R.avg_rating*R.total_votes)/SUM(R.total_votes),2) AS actor_avg_rating, 
    RANK() OVER(ORDER BY ROUND(SUM(R.avg_rating*R.total_votes)/SUM(R.total_votes),2) DESC, SUM(R.total_votes) DESC) AS actor_rank
FROM 
	names AS N
    INNER JOIN
    role_mapping AS RM ON RM.name_id = N.id
    INNER JOIN
	ratings AS R ON R.movie_id = RM.movie_id
    INNER JOIN
    movie AS M ON M.id = RM.movie_id

WHERE 
	RM.category='actor' AND M.country regexp '.*India.*'
GROUP BY 
	N.name
HAVING 
	COUNT(R.movie_id) >= 5
LIMIT 1;
    

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	N.name AS actress_name,
    SUM(R.total_votes) AS total_votes,
    COUNT(RM.movie_id) AS movie_count,
    ROUND(SUM(R.avg_rating*R.total_votes)/SUM(R.total_votes),2) AS actress_avg_rating, 
    RANK() OVER(ORDER BY ROUND(SUM(R.avg_rating*R.total_votes)/SUM(R.total_votes),2) DESC, SUM(R.total_votes) DESC) AS actress_rank
FROM 
	names AS N
    INNER JOIN
    role_mapping AS RM ON RM.name_id = N.id
    INNER JOIN
	ratings AS R ON R.movie_id = RM.movie_id
    INNER JOIN
    movie AS M ON M.id = RM.movie_id

WHERE 
	RM.category='actress' AND M.country regexp '.*India.*' AND M.languages = 'Hindi'
GROUP BY 
	N.name
HAVING 
	COUNT(R.movie_id) >= 3;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    M.title,
    R.avg_rating,
    CASE
        WHEN R.avg_rating > 7 THEN 'Superhit'
        WHEN R.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN R.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON M.id = R.movie_id
        INNER JOIN
    genre AS G ON M.id = G.movie_id
WHERE
    G.genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH duration_summary AS
(
	SELECT 
		G.genre,
		ROUND(AVG(M.duration),2) AS avg_duration
	FROM 
		genre AS G
		INNER JOIN
		movie AS M ON M.id = G.movie_id
	GROUP BY 
		G.genre
)
SELECT
	*,
    SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS 7 PRECEDING) AS moving_avg_duration
FROM 
	duration_summary;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS
(
	 SELECT 
		genre,
		COUNT(movie_id) AS movie_count
	FROM genre
	GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),
top_gross AS
(
	SELECT 
		G.genre,
		M.year,
		M.title AS movie_name,
		M.worlwide_gross_income,
		DENSE_RANK() OVER(PARTITION BY M.year ORDER BY M.worlwide_gross_income DESC) AS movie_rank
	FROM
		movie as M
		INNER JOIN
		genre AS G ON M.id = G.movie_id
	WHERE genre IN ( SELECT genre FROM top_3_genres)
)
SELECT *
FROM
    top_gross
WHERE
    movie_rank <= 5;




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	M.production_company,
    COUNT(M.id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY COUNT(M.id) DESC) AS prod_comp_rank
FROM
	movie AS M
    INNER JOIN
    ratings AS R ON M.id = R.movie_id
WHERE R.median_rating >= 8 AND (LENGTH(languages) - LENGTH(REPLACE(languages,",","")) + 1) >1
GROUP BY production_company
HAVING production_company IS NOT NULL
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress  AS
(
	SELECT 
		N.name AS actress_name,
		SUM(R.total_votes) AS total_votes,
		COUNT(RM.movie_id) AS movie_count,
		ROUND(SUM(R.avg_rating*R.total_votes)/SUM(R.total_votes),2) AS actress_avg_rating, 
		DENSE_RANK() OVER(ORDER BY COUNT(RM.movie_id) DESC) AS actress_rank
	FROM 
		names AS N
		INNER JOIN
		role_mapping AS RM ON RM.name_id = N.id
		INNER JOIN
		ratings AS R ON R.movie_id = RM.movie_id
		INNER JOIN 
		genre AS G ON R.movie_id = G.movie_id

	WHERE 
		RM.category='actress' AND G.genre = 'Drama' AND R.avg_rating >8
	GROUP BY 
		N.name
)
SELECT 
    *
FROM
    top_actress
LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH published_date_summary AS
(
	SELECT
		D.name_id,
		N.name,
		D.movie_id,
		M.duration,
		R.avg_rating,
		R.total_votes,
		M.date_published,
		LEAD(date_published,1) OVER(PARTITION BY D.name_id ORDER BY date_published,movie_id ) AS next_date_published
	FROM 
		director_mapping AS D
		INNER JOIN
        names AS N ON N.id = D.name_id
		INNER JOIN 
        movie AS M ON M.id = D.movie_id
		INNER JOIN
        ratings AS R ON R.movie_id = M.id 
),
director_summary AS
(
	SELECT 
		*,
		DATEDIFF(next_date_published, date_published) AS inter_days
	FROM
		published_date_summary
)
SELECT 
	name_id AS director_id,
	name AS director_name,
	COUNT(movie_id) AS number_of_movies,
	ROUND(AVG(inter_days),2) AS avg_inter_movie_days,
	ROUND(AVG(avg_rating),2) AS avg_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration
FROM 
	director_summary
GROUP BY 
	director_id
ORDER BY 
	COUNT(movie_id) DESC
limit 9;
    
