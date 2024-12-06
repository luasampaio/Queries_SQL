-- Q1
-- For every situation where student A likes student B, 
-- but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes l1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) AND (H2.ID = L2.ID1 AND H3.ID = L2.ID2 AND H3.ID <> H1.ID);


-- Q2
-- Find those students for whom all of their friends are in different grades from themselves. 
-- Return the students' names and grades. 

SELECT H1.name, H1.grade
FROM Highschooler H1 
WHERE H1.grade not in (
						SELECT H2.grade
						From Highschooler H2, Friend F
						WHERE H1.ID = F.ID1 AND H2.ID = F.ID2);
            
            

-- Q3
-- What is the average number of friends per student? (Your result should be just one number.) 

SELECT AVG(COUNT_PER_STUDENT)
FROM (	SELECT COUNT(*) AS COUNT_PER_STUDENT
		FROM Friend 
		GROUP BY ID1);


-- Q4
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
-- Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT COUNT(*)
FROM Friend
WHERE ID1 IN(SELECT ID2
			FROM Friend 
WHERE ID1 in (SELECT ID 
			  FROM Highschooler
			  WHERE name = 'Cassandra'));
	      
	      
	      
-- Q5
-- Find the name and grade of the student(s) with the greatest number of friends. 


SELECT name, grade
FROM Highschooler INNER JOIN Friend F
ON Highschooler.ID = F.ID1
GROUP BY F.ID1
HAVING COUNT(*) = (
	SELECT MAX(COUNT_OF_FRIENDS)
	FROM (SELECT COUNT(*) AS COUNT_OF_FRIENDS
			FROM Friend
			GROUP BY ID1));	      
	      
	      
	      
