-- ===============================================================================
-- createTables.sql
-- -------------------------------------------------------------------------------
-- Author: Tanner Crook (@tannercrook)
-- Database: MS SQL Server
-- This script will create the database structures used for the sync.
-- ===============================================================================





-- Category Table
-- ===============================================================================
-- Drop table
-- DROP TABLE lincoln2.dbo.XImportCategory GO
CREATE TABLE XImportCategory (
	endYear int NULL,
	schoolNumber varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	courseNumber varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sectionNumber int NULL,
	canvasCategoryID int NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	seq int NULL,
	weight float NULL
) GO


-- Drop table
-- DROP TABLE lincoln2.dbo.XCategoryMap GO
CREATE TABLE XCategoryMap (
	canvasCategoryID int NULL,
	icSectionID int NULL,
	icCategoryID int NULL
) GO


-- Drop table
-- DROP TABLE lincoln2.dbo.XCanvasCategory GO
CREATE TABLE XCanvasCategory (
	endYear int NULL,
	schoolNumber varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	courseNumber varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sectionNumber int NULL,
	canvasCategoryID int NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	seq int NULL,
	weight float NULL,
	icCategoryID int NULL,
	sectionID int NULL,
	taskID int NULL,
	termID int NULL
) GO

-- ===============================================================================










-- Assignment Table
-- ===============================================================================
-- Drop table
-- DROP TABLE lincoln2.dbo.XImportAssignment GO
CREATE TABLE XImportAssignment (
	endYear int NULL,
	schoolNumber varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	courseNumber varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sectionNumber int NULL,
	canvasAssignmentID int NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	startDate varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dueDate varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pointsPossible float NULL,
	seq float NULL,
	canvasCategoryID int NULL
) GO



-- Drop table
-- DROP TABLE lincoln2.dbo.XAssignmentMap GO
CREATE TABLE XAssignmentMap (
	canvasAssignmentID int NULL,
	icObjectID int NULL
) GO



-- Drop table
-- DROP TABLE lincoln2.dbo.XCanvasAssignment GO
CREATE TABLE XCanvasAssignment (
	endYear int NULL,
	schoolNumber varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	courseNumber varchar(45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	sectionNumber int NULL,
	canvasAssignmentID int NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	startDate date NULL,
	dueDate date NULL,
	pointsPossible float NULL,
	seq float NULL,
	canvasCategoryID int NULL,
	icObjectID int NULL,
	icCategoryID int NULL,
	icSectionID int NULL
) GO
-- ===============================================================================




-- Score Table
-- ===============================================================================
-- Drop table
-- DROP TABLE lincoln2.dbo.XImportScore GO
CREATE TABLE XImportScore (
	canvasAssignmentID int NULL,
	stateID varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	score varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	late int NULL,
	excused int NULL,
	missing int NULL
) GO



-- Drop table
-- DROP TABLE lincoln2.dbo.XScoreMap GO
CREATE TABLE XScoreMap (
	canvasAssignmentID int NULL,
	stateID int NULL,
	icCourseID int NULL,
	icSectionID int NULL,
	icScoreID int NULL
) GO



-- Drop table
-- DROP TABLE lincoln2.dbo.XCanvasScore GO
CREATE TABLE XCanvasScore (
	canvasAssignmentID int NULL,
	stateID int NULL,
	score varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	late int NULL,
	excused int NULL,
	missing int NULL,
	icCourseID int NULL,
	icSectionID int NULL,
	icTermID int NULL,
	personID int NULL,
	icObjectID int NULL,
	objectSectionID int NULL,
	groupActivityID int NULL,
	icScoreID int NULL
) GO
-- ===============================================================================




-- Delete Table
-- ===============================================================================
-- Drop table
-- DROP TABLE lincoln2.dbo.XCanvasDelete GO
CREATE TABLE XCanvasDelete (
	tableName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	keyValue int NULL
) GO
-- ===============================================================================



-- SyncLog Table
-- ===============================================================================
-- Drop table
-- DROP TABLE lincoln2.dbo.XCanvasSyncLog GO
CREATE TABLE XCanvasSyncLog (
	logID int IDENTITY(1,1) NOT NULL,
	tableName varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tableKeyCol varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tableKey1 varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tableKey2 varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	event varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action] varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	errorCode varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	errorText varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	logDate smalldatetime NULL,
	CONSTRAINT PK_XCanvasSyncLog PRIMARY KEY (logID)
) GO
-- ===============================================================================












