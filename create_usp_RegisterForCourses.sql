USE UniversityDb
GO
DROP PROCEDURE IF EXISTS usp_RegisterForCourses
GO
DROP TYPE IF EXISTS CourseOfferingList
GO
CREATE TYPE CourseOfferingList AS TABLE
(
    CourseOfferingId VARCHAR(50)
);
GO

CREATE PROCEDURE usp_RegisterForCourses
@CourseOfferingList CourseOfferingList READONLY,
@StudentId VARCHAR(50)
AS
BEGIN 
    --for each entry in the CourseOfferingList Param insert the row into both Enrolment and courseEnrolment tables
    DECLARE @MyCursor CURSOR;
    DECLARE @MyField VARCHAR(50);
    DECLARE @err_message nvarchar(255);
    CREATE TABLE #TempPreReq 
    (
        CourseId VARCHAR(50),
    );
    --loop over the params courseId
    BEGIN
        SET @MyCursor = CURSOR FOR
        select * FROM @CourseOfferingList    

        OPEN @MyCursor 
        FETCH NEXT FROM @MyCursor 
        INTO @MyField

        WHILE @@FETCH_STATUS = 0
        BEGIN
            --get the pre Requisites for the course in course offering
            DELETE FROM #TempPreReq
            INSERT INTO #TempPreReq 
            SELECT ReqCourseId FROM PreRequisiteCourses 
            FULL OUTER JOIN CourseOffering ON PreRequisiteCourses.CourseId = CourseOffering.CourseId
            WHERE CourseOffering.CourseOfferingId = @MyField
            --declaring variables for 2nd loop
            DECLARE @MyCursor2 CURSOR;
            DECLARE @Course VARCHAR(50);
            DECLARE @Works BIT;
            SET @Works = 1;
            BEGIN
                SET @MyCursor2 = CURSOR FOR
                SELECT * FROM #TempPreReq    

                OPEN @MyCursor2 
                FETCH NEXT FROM @MyCursor2 
                INTO @Course
                --loop over the the pre requisites list and check if the student has already finished them
                WHILE @@FETCH_STATUS = 0
                BEGIN
                 IF NOT EXISTS (SELECT * FROM Enrolment 
                 FULL OUTER JOIN CourseEnrolment ON CourseEnrolment.EnrolmentId = Enrolment.EnrolmentId
                 FULL OUTER JOIN CourseOffering ON CourseOffering.CourseOfferingId =  CourseEnrolment.CourseOfferingId
                 WHERE CourseOffering.CourseId = @Course AND Enrolment.[Status] = 1 AND Enrolment.StudentId = @StudentId)
                    BEGIN
                        --if the pre req is not done then mark the Works flag as false
                        SET @Works = 0;
                        SET @err_message = 'The student has not done the pre Requisite course to enroll in ' + @MyField
                        RAISERROR (@err_message,10, 1)
                    END
                FETCH NEXT FROM @MyCursor2 
                INTO @Course 
                END; 

                CLOSE @MyCursor2 ;
                DEALLOCATE @MyCursor2;
            END;
            --check if the student is not already enrolled in the course and they have finished the pre requisites
            IF NOT EXISTS (SELECT * FROM Enrolment 
                FULL OUTER JOIN CourseEnrolment ON Enrolment.EnrolmentId = CourseEnrolment.EnrolmentId
                WHERE Enrolment.StudentId = @StudentId AND CourseEnrolment.CourseOfferingId = @MyField ) AND @Works = 1
                    BEGIN
                        DECLARE @LastId VARCHAR(50)
                        SET @LastId = CONVERT(varchar(50), NEWID())
                        INSERT INTO Enrolment (EnrolmentId, StudentId, StartingDate, Status)
                        VALUES(@LastId, @StudentId, GETDATE(), 0)
                        INSERT INTO CourseEnrolment (CourseEnrolmentID, EnrolmentId, CourseOfferingId)
                        VALUES(CONVERT(varchar(50), NEWID()), @LastId, @MyField)
                    END
            ELSE
                SET @err_message = 'The student is already enrolled in ' + @MyField
                RAISERROR (@err_message,10, 1)
        FETCH NEXT FROM @MyCursor 
        INTO @MyField 
        END; 

        CLOSE @MyCursor ;
        DEALLOCATE @MyCursor;
    END;
END
GO

USE MASTER