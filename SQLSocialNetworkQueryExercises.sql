/* Q1: Find the names of all students who are friends with someone named Gabriel. */
select name from Highschooler, (
    select ID1 as fID from Friend where
    ID2 in (
        select ID from Highschooler
        where name = 'Gabriel'
    )
    union
    select ID2 as fID from Friend where
    ID1 in (
        select ID from Highschooler
        where name = 'Gabriel'
    )
) as Q1
where Q1.fID = Highschooler.ID;


/* Q2: For every student who likes someone 2 or more grades younger than themselves,
 return that student's name and grade, and the name and grade of the student they like. */

select h1."name" as name1, h1.grade as grade1, h2."name" as name2, h2.grade as grade2
from Likes, Highschooler as h1, Highschooler as h2
where likes.id1 = h1.id
and likes.id2 = h2.id
and h1.grade - h2.grade >= 2;


/* Q3: For every pair of students who both like each other, return the name and grade of both students.
Include each pair only once, with the two names in alphabetical order. */

select h1.name as name1, h1.grade as grade1, h2.name as name2, h2.grade as grade2
from Likes l1, Likes l2, Highschooler h1, Highschooler h2
where l1.ID1 = l2.ID2 and l2.ID1 = l1.ID2
and h1.ID = l1.ID1
and h2.ID = l1.ID2
and h1.name < h2.name;


/* Q3: Find all students who do not appear in the Likes table
(as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */

select name, grade
from Highschooler
where ID not in (select ID1 from Likes union select ID2 from Likes)
order by grade, name


/* Q5: For every situation where student A likes student B, but we have no information about whom B likes
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

select h1.name as name1, h1.grade as grade1, h2.name as name2, h2.grade as grade2
from Likes F1, Highschooler h1, Highschooler h2
where F1.ID2 not in (select ID1 from Likes F2) and f1.ID1 = h1.ID and f1.ID2 = h2.ID;


/* Q6: Find names and grades of students who only have friends in the same grade.
Return the result sorted by grade, then by name within each grade. */


select distinct name, grade
from
    (
        select ID1, h1.grade, h1.name
        from Friend, highschooler h1, highschooler h2
        where ID1=h1.ID and ID2 = h2.id
    ) as Q1
where Q1.ID1 not in (
    select distinct ID1
    from Friend, highschooler h1, highschooler h2
    where ID1=h1.ID and ID2 = h2.id and h1.grade <> h2.grade
)
order by grade, name;


/* Q7: For each student A who likes a student B where the two are not friends,
find if they have a friend C in common (who can introduce them!). For all such trios,
return the name and grade of A, B, and C. */

select h1."name" as A, h1.grade as A_grade, h2."name" as B, h2.grade as B_grade, h3."name" as C, h3.grade as C_grade
from Likes, Friend F1, Friend f2, Highschooler h1, Highschooler h2, Highschooler h3
where not  exists (
    select *
    from Friend
    where likes.id1=friend.id1 and likes.id2 = friend.id2
    )
and likes.id1 = f1.id1
and likes.id2 = f2.id1
and f2.id2 = f1.id2
and likes.id1=h1.id
and likes.id2 = h2.id
and f1.id2 = h3.id;

/* Q8: Find the difference between the number of students in the school and the number of different first names. */
select count(id) - count(distinct name) from Highschooler;

/* Q9: Find the name and grade of all students who are liked by more than one other student. */
select name, grade
from Likes, Highschooler
where likes.ID2 = highschooler.ID
group by name, grade
having count(ID1) >1

