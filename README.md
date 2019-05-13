# Course Info
https://lagunita.stanford.edu/courses/DB/SQL/

# Lesson
## Sub queries

### Select ids and name of student who apply to CS in some college
1. Use Subqueries
```
select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS');
```
Out put:
123|Amy
345|Craig
987|Helen
876|Irene
543|Craig


2. Use join
```
select Student.sId, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```
Output:

123|Amy
123|Amy
345|Craig
987|Helen
987|Helen
876|Irene
543|Craig

There are some duplicate value there for SNames: Amy and Helen. Not for Craig because sId of them is different.

To fix this we use **distinct**

```
select distinct Student.sId, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```

OUTPUT:

123|Amy
345|Craig
987|Helen
876|Irene
543|Craig


### Select name of student who apply to CS in some college
1. Use Subqueries
```
select sName
from Student
where sID in (select sID from Apply where major = 'CS');
```
Out put:
Craig
Helen
Irene
Craig

We see that there are 2 Craig but this is not a duplicate because we know that there are 2 student: 345 and 543

2. Use join
```
select sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```
Output:

Amy
Amy
Craig
Helen
Helen
Irene
Craigg

Like above example we use **distinct** to remove duplicate.

```
select distinct sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```

OUTPUT:
Amy
Craig
Helen
Irene

In this case **distinct** also remove duplicate of _Craig_ 
```
Question: Should we care that much about duplicate value? 
Answer: In this case we don't but another case may like next example.
```


### Select GPA of student who apply to CS in some college
1. Use Subqueries
```
select GPA
from Student
where sID in (select sID from Apply where major = 'CS');
```
Out put:
3.9
3.5
3.7
3.9
3.4

We see that there are 2 Craig but this is not a duplicate because we know that there are 2 student: 345 and 543

2. Use join
```
select GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```
Output:

3.9
3.9
3.5
3.7
3.7
3.9
3.4

Like above example we use **distinct** to remove duplicate.

```
select distinct GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';
```

OUTPUT:
3.9
3.5
3.7
3.4

In this case if we want to calc average GPA of student who apply to major 'CS' that if we use *join* the value return will change.


```
Note: We have different between *join* and *subqueries* because we dim return index that create more duplicate row so that when we use **distinct** the results is changes
```

### Find students who have applied to major CS but not EE

1. Subqueries

```
select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS') 
and sID not in (select sID from Apply where major = 'EE');
```

OUTPUT:
987|Helen
876|Irene
543|Craig

### All colloges such that some orther colleges is in the same state:

```
select cName, state
from College C1
where exists (select * from College C2 where C1.state = C2.state);
```
OUTPUT;
Stanford|CA
Berkeley|CA
MIT|MA
Cornell|NY

Output is the full table of college:

```
select cName, state from College;
```
OUTPUT:
OUTPUT;
Stanford|CA
Berkeley|CA
MIT|MA
Cornell|NY

**Why**? Because that college is in the same state with themself

```
select cName, state
from College C1
where exists (select * from College C2 where C1.state = C2.state and C1.cName <> C2.cName);
```

ouptut:
Stanford|CA
Berkeley|CA

### College with highest enrollment

```
select cName
from College C1
where not exists (select * from College C2 where C2.enrollment > C1.enrollment);
```

OUTPUT:
Berkeley

### Students with highest GPA
1. Use subqueries
```
select sName, GPA
from Student C1
where not exists (select * from Student C2 where C2.GPA > C1.GPA);
```

OUTPUT:
Amy|3.9
Doris|3.9
Irene|3.9
Amy|3.9

2. Use join
```
select S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;
```
output:
```markdown
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Bob|3.6
Bob|3.6
Bob|3.6
Bob|3.6
Bob|3.6
Craig|3.5
Craig|3.5
Craig|3.5
Craig|3.5
Doris|3.9
Doris|3.9
Doris|3.9
Doris|3.9
Doris|3.9
Doris|3.9
Doris|3.9
Doris|3.9
Fay|3.8
Fay|3.8
Fay|3.8
Fay|3.8
Fay|3.8
Fay|3.8
Fay|3.8
Gary|3.4
Gary|3.4
Helen|3.7
Helen|3.7
Helen|3.7
Helen|3.7
Helen|3.7
Helen|3.7
Irene|3.9
Irene|3.9
Irene|3.9
Irene|3.9
Irene|3.9
Irene|3.9
Irene|3.9
Irene|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Amy|3.9
Craig|3.4
Craig|3.4
```
Alot of duplicate

```
select distinct S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;
```
output:
```markdown
Amy|3.9
Bob|3.6
Craig|3.5
Doris|3.9
Fay|3.8
Gary|3.4
Helen|3.7
Irene|3.9
Craig|3.4
```

Return is not like with use subqueries. this one is find all student not include smallest GPA.
Another way to get students with highest gpa 
```
select sName
from Student
where GPA >= all (select GPA from Student);
```

### Get unique student that have highest GPA

```
select sName, GPA
from Student S1
where GPA > all ( select GPA from Student S2 where S1.sID <> S2.sID);
```
Output:
null
### Get unique college that have highest enrollment
```
select cName
from college C1
where enrollment > all (select enrollment from College C2 where C1.cname <> C2.cname);
```
Output:
Berkeley

### Get unique college that have lowest enrollment

```
select cName
from college C1
where enrollment <= all (select enrollment from College C2 where C1.cname <> C2.cname);
```

### Get all student that not from smallest school

```
select sID, sName, sizeHS
from student
where sizeHS > any (select sizehs from student);
```

```
select sID, sName, sizeHS
from Student S1
where exists (select * from Student S2 where S1.sizeHS > S2.sizeHS);
```

### Find Student that have applied to major 'CS' but not 'EE' with any

```
select sID, sName
from student
where sID = any (select sID from Apply where major = 'CS') and sID <> any (select sID from Apply where major = 'EE');
```

## Subqueries in From and Select
### Students whose scaled GPA changes GPA by more than 1

```
select sID, sName, GPA, GPA * (sizeHS / 1000.0) as scaledGPA
from Student
where GPA * (sizeHS / 1000.0) - GPA > 1.0 or GPA - GPA * (sizeHS / 1000.0) > 1.0;
```
Better way
```
select sID, sName, GPA, GPA * (sizeHS / 1000.0) as scaledGPA
from Student
where abs(GPA * (sizeHS / 1000.0) - GPA) > 1.0;
```
another better wat
```
select *
from (
select sID, sName, GPA, GPA * (sizeHS / 1000.0) as scaledGPA
from Student) G
where abs(G.scaledGPA - GPA) > 1.0;
```

### Subqueries in Select clause
College paired with highest GPA of their applicants
```
select distinct College.cName, state, GPA
from College, Apply, student
where College.Cname = Apply.cname
and Apply.sID = Student.sid
and GPA >= all (select GPA from Student, Apply where Student.sID = Apply.sID and Apply.cName = College.cName);
```

```
select distinct cName, state,
(select distinct GPA
from Apply, student
where College.Cname = Apply.cname
and Apply.sID = Student.sid
and GPA >= all (select GPA from Student, Apply where Student.sID = Apply.sID and Apply.cName = College.cName)
) as GPA
from College;
```

NOTE: with subqueries in select clause that have to return exactly one value 

## Join family operators
Type of join operators:
 * Inner Join on condition
 * Natural Join
 * Inner join using (attrs)
 * Left Right Full outer join

### Inner join operator
```
select distinct sName, major
from Student, apply
where Student.sID = Apply.sID;
```
with **inner** join

```
select distinct sName, major
from Student inner join apply
on Student.sID = Apply.sID;
```
### inner join with multi conditon

```
select sName, GPA
from Student, Apply
where Student.sID = Apply.sID
    and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```

with join operator

```
select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
    where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```

join with multi condition
```
select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
    and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```

### join with multi tables
```
select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply, Student, College
where Apply.sID = Student.sID and Apply.cName = College.cName;
```
with join

```
select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply join Student join College
on Apply.sID = Student.sID and Apply.cName = College.cName;
```

this one will be fail because that we do three way join operator
``` Apply join Student join College  ```
To chagne this

```
select Apply.sID, sName, GPA, Apply.cName, enrollment
from (Apply join Student on Apply.sID = Student.sID) join College
on Apply.cName = College.cName;
```

### Natural Join

```
select distinct sName, major
from Student, Apply
where Student.sID = Apply.sID;
```

with join
```
select distinct sName, major
from Student join Apply
on Student.sID = Apply.sID;
```

with natural join
```
select distinct sName, major
from Student natural join Apply;
```
Another feature of **natural join** that can be remove ambiguous
this one will raise error ambiguous value **ambiguous column name: sID**
```
select distinct sID
from Student, Apply
where Student.sID = Apply.sID;
```
With **natural join**
```
select distinct sID
from Student natural join Apply;
```


### Join and using clause
**natural join** may lead to unclear query another way to is use join with clause

```
select sName, GPA
from Student, Apply
where Student.sID = Apply.sID
    and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```
with natural join
```
select sName, GPA
from Student natural join Apply
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```
join with clause
```
select sName, GPA
from Student join Apply using(sID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';
```

Using clause does not allow to use with on clause
```
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;
```

```
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 using (GPA)
on S1.sID < S2.sID;
```
this on will raise error. The right script is
```
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 using (GPA)
where S1.sID < S2.sID;
```

### Outer join

```
select sName, sID, cName, major
from Student inner join Apply using(sID);
```

```sql
select sName, sID, cName, major
from Student left outer join Apply using(sID);
```

What the left outer join does, is it takes any tuples on the left side of the join. So any tuples from the relation that's on the left. And if they don't have a matching tuple from the right.
And that's called a dangling tuple, by the way. If there's a dangling tuple with no right matching tuple, it's still added to the result and it's padded with null values.

Below is a way to to the job of outer join
```
select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply);
```

### Full outer join
Include students who haven't applied anywhere and applications without matching students

```
select sName, sID, cName, major
from Student full outer join Apply using(sID);
```

Can simulate with LEFT and RIGHT outerjoins Note UNION eliminates duplicates
```
select sName, sID, cName, major
from Student left outer join Apply using(sID)
union
select sName, sID, cName, major
from Student right outer join Apply using(sID);
````

Can simulate without any JOIN operators
```
select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply)
union
select NULL, sID, cName, major
from Apply
where sID not in (select sID from Student);
```
##  Aggregation