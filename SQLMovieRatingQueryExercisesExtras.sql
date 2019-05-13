

/* Q1: Find the names of all reviewers who rated Gone with the Wind */

select name
from Reviewer
where rID in (
    select rID
    from Rating
    where mID in (
        select mID
        from Movie
        where title = 'Gone with the Wind'
        )
    );

/* Q2: For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */

select name, title, stars
from Reviewer join (
    select title, rID, mID, director, stars
    from Movie join Rating using (mID)
    where director is not null
    ) as Q using (rID)
where director = name;


/* Q3: Return all reviewer names and movie names together in a single list, alphabetized.
(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */

select title from Movie
union
select name from Reviewer
order by title;


-- Q4: Find the titles of all movies not reviewed by Chris Jackson.
select title
from Movie
where mID not in (
    select mID
    from Rating
    where rID in (
        select rID
        from Reviewer
        where name = 'Chris Jackson'
        )
    );


/* Q4: For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates,
don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */

select rID, mID
from Rating
group by mID


/* Q5: For all pairs of reviewers such that both reviewers gave a rating to the same movie,
 return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once.
  For each pair, return the names in the pair in alphabetical order. */

-- This is my solution but is didnot pass test because the pairs is not correct.
select distinct q4.name as name1, reviewer.name as name2
from
    (
        select name, rid2, mid
        from reviewer,
            (
                select distinct q1.mid as mID, Q1.rid as rid1, Q2.rid as rid2
                from
                    (
                        select distinct mid, rid
                        from rating order by mid
                    ) as Q1,
                    (
                        select distinct mid, rid
                        from rating order by mid
                    ) as Q2
                    where Q1.mid = Q2.mid and Q1.rid < Q2.rid
                    order by mid
            ) as Q3
        where reviewer.rid = q3.rid1
    ) as Q4 , reviewer
where q4.rid2 = reviewer.rid
order by name1, name2;

-- here is solution that passes the test
SELECT rev1.name AS reviewer_name1, rev2.name AS reviewer_name2
FROM rating AS rat1, rating AS rat2, reviewer AS rev1, reviewer AS rev2
WHERE rat1.rid = rev1.rid
AND rat2.rid = rev2.rid
AND rat1.mid = rat2.mid
AND rev1.name != rev2.name
AND rev1.name < rev2.name
order by reviewer_name1, reviewer_name2;

/* Q7: List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */
select title, stars
from Movie join (
    select mID, avg(stars) as stars
    from Rating
    group by mID
    ) as Q using (mID)
order by stars DESC, title;


/* Q8: Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) */
select name
from Reviewer
where rID in (
    select rID
    from Rating
    group by rID
    having count(stars) >= 3
    );

/* Q9: Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.
 (As an extra challenge, try writing the query both with and without COUNT.)*/

select title, director from Movie where director in (
    select director
    from Movie
    group by director
    having count(director) > 1)
order by director, title;


/* Q10: Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.
(Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding
 the highest average rating and then choosing the movie(s) with that average rating.) */

select title, avgStars from Movie join
    (
        select mid, avgStars
        from
            (
                select mid, avg(stars) as avgStars
                from rating
                group by mid
            ) as Q
        where avgStars =
            (
                select max(avgStars)
                from
                    (
                        select mid, avg(stars) as avgStars
                        from rating
                        group by mid
                    ) as Q
            )
    ) as Q using(mId);


/* Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
 (Hint: This query may be more difficult to write in SQLite than other systems;
 you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */

select title, avgStars from Movie join
    (
        select mid, avgStars
        from
            (
                select mid, avg(stars) as avgStars
                from rating
                group by mid
            ) as Q
        where avgStars =
            (
                select min(avgStars)
                from
                    (
                        select mid, avg(stars) as avgStars
                        from rating
                        group by mid
                    ) as Q
            )
    ) as Q using(mId);


/* Q12: or each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest
rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. */

select director, title, maxStarsByM
from
    (
        select director, max(maxStarsByM) as maxStarsByM from
        (
            select director, title, max(stars) as maxStarsByM
            from
                (
                    select * from movie where director is not null
                ) as Q join rating
                using (mID)
            group by director, title
        ) as Q
        group by director
    ) as Q1 join
    (
        select director, title, max(stars) as maxStarsByM
        from
            (
                select * from movie where director is not null
            ) as Q join rating
            using (mID)
        group by director, title
    ) as Q2
    using(director, maxStarsByM);