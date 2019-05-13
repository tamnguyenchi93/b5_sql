/* Q1: For every situation where student A likes student B, but student B likes a different student C,
return the names and grades of A, B, and C. */

select h1."name" as A, h1.grade as A_grade, h2."name" as B, h2.grade as B_grade, h3."name" as C, h3.grade as C_grade
from Likes l1, Likes l2, Highschooler h1, Highschooler h2, Highschooler h3
where l1.id2 = l2.id1 and l2.id2 <> l1.id1
and h1.id = l1.id1
and h2.id = l1.id2
and h3.id = l2.id2;

/* Q2: Find those students for whom all of their friends are in different grades from themselves.
 Return the students' names and grades. */


select distinct h3.name, h3.grade
from Friend f1, Highschooler h3
where not exists
    (
        select *
        from Friend f2, Highschooler h1, Highschooler h2
        where f1.ID1 = f2.ID1 and h1.ID = f2.ID1 and h2.ID = f2.ID2 and h1.grade = h2.grade
    )
    and f1.ID1 = h3.ID;

/* Q3: What is the average number of friends per student? (Your result should be just one number.) */

select avg(numFriend)
from
    (
        select id1, count(id2) as numFriend from friend
        group by id1
    ) as Q;


/* Q4: Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra.
 Do not count Cassandra, even though technically she is a friend of a friend. */


select count(distinct f2.id2)
from Highschooler h1, Friend f1, Friend f2
where h1.name = 'Cassandra'
and h1.ID = f1.ID1
and (
        (
            f1.ID2 = f2.ID1
            and f2.ID2 <> h1.ID
        )
        or f1.ID1 = f2.ID1
    );