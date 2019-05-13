/* Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete from Highschooler where grade = 12;

/* Q2: If two students A and B are Friends, and A Likes B but not vice-versa, remove the Likes tuple.*/

delete from Likes
    where exists (select * from Friend where Friend.id1 = Likes.id1 and Friend.id2 = Likes.id2)
    and not exists (select * from Likes as l2 where Likes.id1 = l2.id2 and Likes.id2 = l2.id1);


/* For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C.
 Do not add duplicate friendships, friendships that already exist, or friendships with oneself. */

insert into Friend
    select distinct f1.id1, f2.id2
    from Friend as f1, Friend as f2
    where f1.id2 = f2.id1
    and f1.id1 != f2.id2
    and not exists(select * from Friend as f3 where f1.id1 = f3.id1 and f2.id2= f3.id2);