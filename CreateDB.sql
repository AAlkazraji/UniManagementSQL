
USE MASTER
GO

DROP DATABASE IF EXISTS UniversityDb
GO

CREATE DATABASE UniversityDb
GO
USE UniversityDb
--Creating tables
CREATE TABLE Campus
(
    CampusId VARCHAR(50) UNIQUE NOT NULL,
    name varchar(70) NOT NULL,
    PRIMARY KEY(CampusId)
);
CREATE TABLE Person 
(
    PersonId VARCHAR(50) UNIQUE NOT NULL,
    FirstName varchar(20) NOT NULL,
	LastName varchar(20) NOT NULL,
	PRIMARY KEY(PersonId)
);

CREATE TABLE Staff
(
    StaffId VARCHAR(50) UNIQUE NOT NULL,
    PersonId VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(StaffId),
    FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
    ON UPDATE CASCADE ON DELETE CASCADE, 
    
);

CREATE TABLE Student 
(
    StudentId VARCHAR(50) UNIQUE NOT NULL,
    PersonId VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(StudentId),
    FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
    ON UPDATE CASCADE ON DELETE CASCADE, 
    
);

CREATE TABLE ContactNumber
(
    ContactNumberId VARCHAR(50) UNIQUE NOT NULL,
    ContactNumber CHAR(16) NOT NULL,
    PersonId VARCHAR(50) NOT NULL,
    PRIMARY KEY(ContactNumberId),
    FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
    ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE Address
(
    AddressId VARCHAR(50) UNIQUE NOT NULL,
    StreetNo SMALLINT,
    City  VARCHAR(90),
    State VARCHAR(20),
    Postcode SMALLINT,
    Country VARCHAR(60),
    PersonId VARCHAR(50),
    CampusId VARCHAR(50),
    PRIMARY KEY(AddressId),
    FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(CampusId) REFERENCES Campus(CampusId)
    ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE Facility
(
    FacilityId VARCHAR(50) UNIQUE NOT NULL,
    RoomNumber SMALLINT,
    BulidingName VARCHAR(90),
    Capacity SMALLINT,
    Type VARCHAR(60),
    CampusId VARCHAR(50),
    PRIMARY KEY(FacilityId),
    FOREIGN KEY(CampusId) REFERENCES Campus(CampusId)
    ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE OrganisationalUnit
(
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(90),
    description TEXT,
    contactNumber CHAR(16) NOT NULL,
    CampusId VARCHAR(50),
    PRIMARY KEY(code),
    FOREIGN KEY(CampusId) REFERENCES Campus(CampusId)
    ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE SubOrganisationalUnit
(
    subOrganisationalcode VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(90),
    code VARCHAR(50),
    PRIMARY KEY(subOrganisationalcode),
    FOREIGN KEY(code) REFERENCES OrganisationalUnit(code)
    ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE Role
(
    RoleId VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(90),
    Description TEXT,
    PRIMARY KEY(RoleId)
);

CREATE TABLE Employment
(
    EmploymentId VARCHAR(50) UNIQUE NOT NULL,
    StartDate DATE,
    EndDate DATE,
    RoleId VARCHAR(50),
    StaffId VARCHAR(50),
    code VARCHAR(50),
    PRIMARY KEY(EmploymentId),
    FOREIGN KEY(RoleId) REFERENCES Role(RoleId)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(StaffId) REFERENCES Staff(StaffId)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(code) REFERENCES OrganisationalUnit(code)
    ON UPDATE CASCADE ON DELETE SET NULL,
);
CREATE TABLE Certification
(
  CertificationId VARCHAR(50) UNIQUE NOT NULL,
  Name VARCHAR(60) UNIQUE NOT NULL,
  PRIMARY KEY(CertificationId)
);

CREATE TABLE Level
(
  LevelId VARCHAR(50) UNIQUE NOT NULL,
  Name VARCHAR(60) UNIQUE NOT NULL,
  PRIMARY KEY(LevelId)
);

CREATE TABLE Programme
(
    ProgrammeId VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(60) UNIQUE NOT NULL,
    TotalCridits TINYINT,
    CertificationId VARCHAR(50),
    LevelId VARCHAR(50),
    CampusId VARCHAR(50),
    code VARCHAR(50),
    EmploymentId VARCHAR(50),
    PRIMARY KEY(ProgrammeId),
    FOREIGN KEY(CertificationId) REFERENCES Certification(CertificationId)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(CampusId) REFERENCES Campus(CampusId)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(code) REFERENCES OrganisationalUnit(code)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY(EmploymentId) REFERENCES Employment(EmploymentId)
    ON UPDATE NO ACTION ON DELETE SET NULL,
);

CREATE TABLE MajorMinor
(
    MajorId VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(60),
    Conditions VARCHAR(60),
    Description TEXT,
    totalCredit TINYINT,
    Type VARCHAR(100),
    ProgrammeId VARCHAR(50),
    PRIMARY KEY(MajorId),
    FOREIGN KEY(ProgrammeId) REFERENCES Programme(ProgrammeId)
    ON UPDATE NO ACTION ON DELETE SET NULL,
);

CREATE TABLE Course
(
    CourseId VARCHAR(50) UNIQUE NOT NULL,
    CourseName  VARCHAR(60) UNIQUE NOT NULL,
    NumberOfCredit TINYINT,
    Description TEXT,
    PRIMARY KEY(CourseId)
);

CREATE TABLE PreRequisiteCourses
(
    preListId VARCHAR(50) UNIQUE NOT NULL,
    CourseId VARCHAR(50),
    ReqCourseId VARCHAR(50),
    PRIMARY KEY(preListId),
    FOREIGN KEY(CourseId) REFERENCES Course(CourseId)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(ReqCourseId) REFERENCES Course(CourseId)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
);

CREATE TABLE CourseList
(
    listId VARCHAR(50) UNIQUE NOT NULL,
    CourseId VARCHAR(50) NOT NULL,
    startDate DATE,
    endDate DATE,
    Type VARCHAR(100),
    ProgrammeId VARCHAR(50),
    MajorId VARCHAR(50),
    PRIMARY KEY(ListId),
    FOREIGN KEY(CourseId) REFERENCES Course(CourseId)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(ProgrammeId) REFERENCES Programme(ProgrammeId)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(MajorId) REFERENCES MajorMinor(MajorId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

CREATE TABLE Semester
(
    SemesterId VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(60),
    StartDate DATE,
    Enddate DATE,
    PRIMARY KEY(SemesterId)
);

CREATE TABLE CourseOffering
(
    CourseOfferingId VARCHAR(50) UNIQUE NOT NULL,
    CourseId VARCHAR(50) NOT NULL,
    CampusId VARCHAR(50),
    EmploymentId VARCHAR(50),
    SemesterId VARCHAR(50) NOT NULL,
    PRIMARY KEY(CourseOfferingId),
    FOREIGN KEY(CourseId) REFERENCES Course(CourseId)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(CampusId) REFERENCES Campus(CampusId)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(EmploymentId) REFERENCES Employment(EmploymentId)
    ON UPDATE NO ACTION ON DELETE SET NULL,
    FOREIGN KEY(SemesterID) REFERENCES Semester(SemesterID)
    ON UPDATE CASCADE ON DELETE NO ACTION,
);

CREATE TABLE Enrolment
(
    EnrolmentId VARCHAR(50) UNIQUE NOT NULL,
    StudentId VARCHAR(50) NOT NULL,
    StartingDate DATE,
    FinishingDate DATE,
    Status BIT,
    PRIMARY KEY(EnrolmentId),
    FOREIGN KEY(StudentId) REFERENCES Student(StudentId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

CREATE TABLE ProgrammeEnrolment
(
    PorgrammeEnrolmentID VARCHAR(50) UNIQUE NOT NULL,
    EnrolmentId VARCHAR(50) UNIQUE NOT NULL,
    ProgrammeId VARCHAR(50) NOT NULL,
    PRIMARY KEY(PorgrammeEnrolmentID),
    FOREIGN KEY(EnrolmentId) REFERENCES Enrolment(EnrolmentId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
    FOREIGN KEY(ProgrammeId) REFERENCES Programme(ProgrammeId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

CREATE TABLE CourseEnrolment
(
    CourseEnrolmentID VARCHAR(50) UNIQUE NOT NULL,
    EnrolmentId VARCHAR(50) UNIQUE NOT NULL,
    CourseOfferingId VARCHAR(50),
    Grades VARCHAR(40),
    FinalMarks TINYINT,
    PRIMARY KEY(CourseEnrolmentID),
    FOREIGN KEY(EnrolmentId) REFERENCES Enrolment(EnrolmentId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
    FOREIGN KEY(CourseOfferingId) REFERENCES CourseOffering(CourseOfferingId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

CREATE TABLE TimeSlot
(
    TimeSlotId VARCHAR(50) UNIQUE NOT NULL,
    StartTime TIME,
    FinishTime TIME,
    Reason VARCHAR(50),
    CourseOfferingId VARCHAR(50) NOT NULL,
    FacilityId VARCHAR(50),
    PRIMARY KEY(TimeSlotId),
    FOREIGN KEY(CourseOfferingId) REFERENCES CourseOffering(CourseOfferingId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
    FOREIGN KEY(FacilityId) REFERENCES Facility(FacilityId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

CREATE TABLE TimeTable
(
    timeTableId VARCHAR(50) UNIQUE NOT NULL,
    StudentId VARCHAR(50) ,
	StaffId VARCHAR(50) ,
    TimeSlotId VARCHAR(50) NOT NULL,
    PRIMARY KEY(timeTableId),
    FOREIGN KEY(StudentId) REFERENCES Student(StudentId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
	FOREIGN KEY(StaffId) REFERENCES Staff(StaffId)
    ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY(TimeSlotId) REFERENCES TimeSlot(TimeSlotId)
    ON UPDATE NO ACTION ON DELETE CASCADE,
);

GO


INSERT INTO Campus 
 VALUES ('AA0001', 'city'),
        ('AA0002', 'Newcastle'),
        ('AA0003', 'central coast'),
        ('AA0004', 'sydney')
-------------------------------
INSERT INTO Person 
 VALUES ('BB0001', 'Jack', 'Student1'),
        ('BB0002', 'Mike', 'Student2'),
        ('BB0003', 'Grant', 'Student3'),
        ('BB0004', 'Ana', 'Staff1'),
        ('BB0005', 'Ross', 'Staff2'),
        ('BB0006', 'Jaramo', 'Staff3')
-------------------------------
INSERT INTO Staff 
 VALUES ('CC0001', 'BB0004'),
        ('CC0002', 'BB0005'),
        ('CC0003', 'BB0006')
-------------------------------
INSERT INTO Student 
 VALUES ('DD0001', 'BB0001'),
        ('DD0002', 'BB0002'),
        ('DD0003', 'BB0003')
-------------------------------
INSERT INTO ContactNumber 
 VALUES ('EE0001', '111111111', 'BB0001'),
        ('EE0002', '222222222', 'BB0002'),
        ('EE0003', '333333333', 'BB0003'),
        ('EE0004', '444444444', 'BB0004'),
        ('EE0005', '555555555', 'BB0005'),
        ('EE0006', '666666666', 'BB0006')
-------------------------------
INSERT INTO Address 
 VALUES ('FF0001', 1,  'streetA', 'NSW', 2000, 'AustraliaA', 'BB0001', null),
        ('FF0002', 2,  'streetB', 'QLD', 2001, 'AustraliaB', 'BB0002', null),
        ('FF0003', 3,  'streetC', 'VT', 2002, 'AustraliaC', 'BB0003',  null),
        ('FF0004', 3,  'streetD', 'WA', 2002, 'AustraliaD', 'BB0004',  null),
        ('FF0005', 3,  'streetE', 'SA', 2002, 'AustraliaE', 'BB0005',  null),
        ('FF0006', 3,  'streetF', 'NA', 2002, 'AustraliaF', 'BB0006',  null)
-------------------------------
INSERT INTO Facility 
 VALUES ('GG0001', 1,  'MathsBuliding',100, 'lab', 'AA0001'),
        ('GG0002', 2,  'EnglishBuliding',101, 'workshop', 'AA0002'),
        ('GG0003', 3,  'SoftwareBuliding',102, 'lucture', 'AA0003')
-------------------------------
INSERT INTO OrganisationalUnit 
 VALUES ('HH0001', 'Scince', 'Scince organisation', 111111111, 'AA0001'),
        ('HH0002', 'Health','Health organisation',  222222222, 'AA0002'),
        ('HH0003', 'Reaserch','Reaserch organisation', 333333333, 'AA0003')
-------------------------------
INSERT INTO SubOrganisationalUnit 
 VALUES ('II0001', 'sup-Scince organisation', 'HH0001'),
        ('II0002', 'sup-Health organisation', 'HH0002'),
        ('II0003', 'sup-Reaserch organisation', 'HH0003')
-------------------------------
INSERT INTO Role 
 VALUES ('JJ0001', 'Boos', 'postion of anoying people'),
        ('JJ0002', 'Manager', 'postion of sick people'),
        ('JJ0003', 'Cleaner', 'postion of mad people')
-------------------------------
INSERT INTO Employment 
 VALUES ('KK0001', '2022-07-19',  '2025-12-02', 'JJ0001', 'CC0001', 'HH0001'),
        ('KK0002', '2019-08-11',  '2027-11-09', 'JJ0002', 'CC0002', 'HH0002'),
        ('KK0003', '2025-05-02',  '2028-04-11', 'JJ0003', 'CC0003', 'HH0003')
-------------------------------
INSERT INTO Certification 
 VALUES ('LL0001', 'bacholar of Software eng'),
        ('LL0002', 'bacholar of Computer SCi'),
        ('LL0003','bacholar of Computer Art')
-------------------------------
INSERT INTO Level
 VALUES ('MM0001', 'Master of Software eng'),
        ('MM0002', 'PHD of Computer SCi'),
        ('MM0003','Master of Art')
-------------------------------
INSERT INTO Programme
 VALUES ('NN0001', 'undergraduates', 120, 'LL0001', 'MM0001', 'AA0001', 'HH0001', 'KK0001'),
        ('NN0002', 'fundation', 180, 'LL0002', 'MM0002', 'AA0002', 'HH0002', 'KK0002'),
        ('NN0003', 'coursework', 123, 'LL0003', 'MM0003', 'AA0003', 'HH0003', 'KK0003')
-------------------------------
INSERT INTO MajorMinor
 VALUES ('OO0001', 'software devlopment', 'done', 'coding study', 11, 'Major', 'NN0001'),
        ('OO0002', 'rebortics', 'done', 'hardware study', 22, 'Mainor', 'NN0002'),
        ('OO0003', 'aporginal arts', 'done', 'i dont know what to say here', 33, 'Major', 'NN0003')
-------------------------------
INSERT INTO Course 
 VALUES ('PP0001', 'Data Stracture',  10, 'studies of data structure'),
        ('PP0002', 'Computer-humman intraction',  10, 'studies of data Computer-humman intraction'),
        ('PP0003', 'Advance art',  10, 'studies of data art'),
        ('PP0004', 'Advance databse',  10, 'studies of data art'),
        ('PP0005', 'Advance projects',  10, 'studies of data art'),
        ('PP0006', 'project managment',  10, 'studies of data art')
-------------------------------
INSERT INTO PreRequisiteCourses 
 VALUES ('RR0001', 'PP0001','PP0002'),
        ('RR0002', 'PP0002','PP0002'),
        ('RR0003', 'PP0003','PP0003'),
        ('RR0004', 'PP0004','PP0004'),
        ('RR0005', 'PP0004','PP0006'),
        ('RR0006', 'PP0004','PP0005'),
        ('RR0007', 'PP0005','PP0005'),
        ('RR0008', 'PP0006','PP0006')
-------------------------------
INSERT INTO CourseList
 VALUES ('SS0001', 'PP0001', '2022-07-19', '2025-12-02', 'core', 'NN0001', 'OO0001'),
        ('SS0002', 'PP0002', '2019-08-11', '2027-11-09', 'elective', 'NN0002', 'OO0002'),
        ('SS0003', 'PP0003', '2025-05-02', '2028-04-11', 'diracted', 'NN0003', 'OO0003'),
        ('SS0004', 'PP0004', '2022-01-02', '2028-04-11', 'diracted', 'NN0003', 'OO0003'),
        ('SS0005', 'PP0005', '2022-06-02', '2028-04-11', 'diracted', 'NN0003', 'OO0003'),
        ('SS0006', 'PP0006', '2022-05-02', '2028-04-11', 'diracted', 'NN0003', 'OO0003')
-------------------------------
INSERT INTO Semester
 VALUES ('TT0001', 'First Semster', '2022-07-19', '2025-12-02'),
        ('TT0002', 'Secound Semester', '2019-08-11', '2027-11-09'),
        ('TT0003', 'Trimnster', '2025-05-02', '2028-04-11')
-------------------------------
INSERT INTO CourseOffering
 VALUES ('UU0001', 'PP0001', 'AA0001', 'KK0001', 'TT0001'),
        ('UU0002', 'PP0002', 'AA0002', 'KK0002', 'TT0002'),
        ('UU0003', 'PP0003', 'AA0003', 'KK0003', 'TT0003'),
        ('UU0004', 'PP0004', 'AA0003', 'KK0003', 'TT0003'),
        ('UU0005', 'PP0005', 'AA0003', 'KK0003', 'TT0003'),
        ('UU0006', 'PP0006', 'AA0003', 'KK0003', 'TT0003')
-------------------------------
INSERT INTO Enrolment
 VALUES ('VV0001', 'DD0001', '2022-07-19', '2025-12-02', 1),
        ('VV0002', 'DD0002', '2019-08-11', '2027-11-09', 0),
        ('VV0003', 'DD0003', '2025-05-02', '2028-04-11', 1),
        ('VV0004', 'DD0001', '2025-05-02', '2028-04-11', 1)
-------------------------------
INSERT INTO ProgrammeEnrolment
 VALUES ('XX0001', 'VV0001', 'NN0001'),
        ('XX0002', 'VV0002', 'NN0002'),
        ('XX0003', 'VV0003', 'NN0003')
-------------------------------
INSERT INTO CourseEnrolment
 VALUES ('YY0002', 'VV0002', 'UU0002', 'C', 60),
        ('YY0003', 'VV0003', 'UU0003', 'D', 81),
        ('YY0004', 'VV0004', 'UU0002', 'D', 81)
-------------------------------
INSERT INTO TimeSlot 
 VALUES ('ZZ0001', '13:30:00',  '15:30:00', 'lab', 'UU0001', 'GG0001'),
        ('ZZ0002', '10:30:00',  '12:30:00', 'workshop', 'UU0002', 'GG0002'),
        ('ZZ0003', '08:30:00',  '10:30:00', 'lecture', 'UU0003', 'GG0003'),
        ('ZZ0004', '01:30:00',  '03:30:00', 'lecture', 'UU0001', 'GG0001'),
        ('ZZ0005', '05:30:00',  '07:30:00', 'lecture', 'UU0002', 'GG0002'),
        ('ZZ0006', '09:30:00',  '11:30:00', 'lecture', 'UU0003', 'GG0003'),
        ('ZZ0007', '09:30:00',  '11:30:00', 'lecture', 'UU0003', 'GG0001'),
        ('ZZ0008', '01:30:00',  '03:30:00', 'lecture', 'UU0002', 'GG0002'),
        ('ZZ0009', '07:30:00',  '09:30:00', 'lecture', 'UU0003', 'GG0003')
-------------------------------
INSERT INTO TimeTable
 VALUES ('AB0001', 'DD0001', null, 'ZZ0001'),
        ('AB0002', 'DD0002', null, 'ZZ0002'),
        ('AB0003', 'DD0003', null, 'ZZ0003'),
        ('AB0004', null, 'CC0001', 'ZZ0004'),
        ('AB0005', null, 'CC0002', 'ZZ0005'),
        ('AB0006', null, 'CC0003', 'ZZ0006')
-------------------------------

SELECT * from Campus
SELECT * from Person
SELECT * from Staff 
SELECT * from Student 
SELECT * from ContactNumber 
SELECT * from Address
SELECT * from Facility
SELECT * from OrganisationalUnit
SELECT * from SubOrganisationalUnit
SELECT * from Role
SELECT * from Employment
SELECT * from Certification
SELECT * from Level
SELECT * from Programme
SELECT * from MajorMinor
SELECT * from Course
SELECT * from PreRequisiteCourses
SELECT * from CourseList
SELECT * from Semester
SELECT * from CourseOffering
SELECT * from Enrolment
SELECT * from ProgrammeEnrolment
SELECT * from CourseEnrolment
SELECT * from TimeSlot
SELECT * from TimeTable


USE MASTER
GO