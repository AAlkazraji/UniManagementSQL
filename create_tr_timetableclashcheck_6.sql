USE [UniversityDb]    --refaring to the database

go 


DROP TRIGGER CheckTimeTable 

GO

CREATE TRIGGER [dbo].[CheckTimeTable] ON [dbo].[TimeTable]  --sepecfing the trigger would oprates on line on timetable when inserting or updating
FOR UPDATE, INSERT 
AS 
BEGIN 
    DECLARE

        --declring the varble of the inserted entry
        @studentIdOfTheInsertedData VARCHAR(50),
        @staffIdOfTheInsertedData VARCHAR(50),
        @timeSlotOfTheInsertedData VARCHAR(50),
 

        @startingTimeOftheInsertedSlot Time,
        @finishingTimeOftheInsertedSlot Time


        --getting the time detalis for the inserted slot by comparing the IDs
        SELECT @startingTimeOftheInsertedSlot = (select StartTime From TimeSlot WHERE TimeSlotId = @timeSlotOfTheInsertedData)
        SELECT @finishingTimeOftheInsertedSlot = (select FinishTime From TimeSlot WHERE TimeSlotId = @timeSlotOfTheInsertedData)


        SELECT @studentIdOfTheInsertedData = StudentId FROM INSERTED
        SELECT @staffIdOfTheInsertedData = StaffId FROM INSERTED
        SELECT @timeSlotOfTheInsertedData = TimeSlotId FROM INSERTED


        
        --selecting the time details and comparing them by using the outer joining table 
        --the intered slot time should be start and finish befor the starting time or more 
        --than the finish time of the slot
        IF EXISTS(SELECT * FROM TimeTable
            FULL OUTER JOIN TimeSlot ON TimeSlot.TimeSlotId = TimeTable.TimeSlotId OR (TimeTable.StaffId = @staffIdOfTheInsertedData)
            WHERE (TimeSlot.StartTime >  @startingTimeOftheInsertedSlot AND  @startingTimeOftheInsertedSlot > TimeSlot.FinishTime)
            OR (TimeSlot.StartTime >  @finishingTimeOftheInsertedSlot AND  @finishingTimeOftheInsertedSlot < TimeSlot.FinishTime))
                BEGIN
                    --showing a worning messages
                    RAISERROR('ERROR THERE IS A CLASH', 10, 1)
                    --if the trigger is triggered than undo the scripts or the transection 
                    ROLLBACK TRANSACTION
                END 

END

        --testing values
        INSERT INTO TimeTable VALUES ('ASA22AAecdc0A3k', null, 'CC0001', 'ZZ0006')

        SELECT * FROM TimeTable

        SELECT * FROM TimeSlot

        DELETE  From TimeTable where StaffId = 'CC0001'


 