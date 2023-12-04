USE UniversityDb

DECLARE @CourseOfferingList CourseOfferingList

INSERT INTO @CourseOfferingList VALUES('UU0001')
INSERT INTO @CourseOfferingList VALUES('UU0002')
INSERT INTO @CourseOfferingList VALUES('UU0003')
INSERT INTO @CourseOfferingList VALUES('UU0004')
INSERT INTO @CourseOfferingList VALUES('UU0005')

DECLARE @StudentId VARCHAR(50)

SET @StudentId = 'DD0001'

EXECUTE usp_RegisterForCourses @CourseOfferingList, @StudentId 
SELECT * from Enrolment
SELECT * FROM CourseEnrolment

USE master