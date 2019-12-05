Start-Transcript -Path "logs/latest.txt" # This can be adjusted for your log files

# Connection Variables
# ===============================================
$sqlserver = "#CONNECTIONSTRING#"
$user = "#USERNAME#"
$password = "#PASSWORD#"
# Set Schema to either production or sandbox
$database = "#DATABASE#"

# Set the overall connection string
$connectionstring = 'Data Source='+$sqlserver+'; Initial Catalog='+$database+'; User Id='+$user+'; Password='+$password+';'


# Data Variables
# ================================================
# End Year
$endYear = 2020

# Modified_by personID: The Person.personID of the person who will be recorded as having modified the records where applicable. (Super helpful for troubleshooting, debugging, and repairing.)
$modPersonID = 525

# Set assignment startDate and endDate. Sorry for the language but I hate typing. LOL
$defAssStart = '08/26/2019' 
$defAssEnd = '08/26/2019'


# These can be copied to include as many schools as you would like. They are organized by Calendar.name and Term.name.
# 1
$calendarName1 = ""
$termName1 = ""
# 2
$calendarName2 = ""
$termName2 = ""







$connection = New-Object System.Data.SqlClient.SqlConnection($connectionstring)
$connection.Open()

Write-Host "Start the script"
Write-Host ""

# Delete the old import records since they have been merged with the XCanvasCategory table
$query = "DELETE FROM XImportCategory"
$command = $connection.CreateCommand()
$command.CommandText = $query
$command.commandTimeout = 0
$command.ExecuteNonQuery()
Write-Host "Precautionary delete of import table"
Write-Host ""

# Delete the old import records since they have been merged with the XCanvasAssignment table
$query = "DELETE FROM XImportAssignment"
$command = $connection.CreateCommand()
$command.CommandText = $query
$command.commandTimeout = 0
$command.ExecuteNonQuery()
Write-Host "Precautionary delete of import table"
Write-Host ""

# Delete the old import records since they have been merged with the XCanvasScore table
$query = "DELETE FROM XImportScore"
$command = $connection.CreateCommand()
$command.CommandText = $query
$command.commandTimeout = 0
$command.ExecuteNonQuery()
Write-Host "Precautionary delete of import table"
Write-Host ""


#BEGIN a transaction so we can rollback if needed
$query = "BEGIN TRANSACTION;"
$command = $connection.CreateCommand()
$command.CommandText = $query
$command.ExecuteNonQuery()
Write-Host "Started Transaction"
Write-Host ""

# Lets try it
try {

    # CATEGORY IMPORT
    #------------------------------------
    $table = "XImportCategory"
    # CSV Variables
    $csvfile = "/home/admin/CanvasSync/gradeSync/output/XCategories.csv"
    $csvdelimiter = "|"
    $FirstRowColumnNames = $true


    Write-Host "Category started..." 
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()  
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data") 
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient") 
    
    # 50k worked fastest and kept memory usage to a minimum 
    $batchsize = 50000 
    
    # Build the sqlbulkcopy connection, and set the timeout to infinite 
    $bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
    $bulkcopy.DestinationTableName = $table 
    $bulkcopy.bulkcopyTimeout = 0 
    $bulkcopy.batchsize = $batchsize 
    
    # Create the datatable, and autogenerate the columns. 
    $datatable = New-Object System.Data.DataTable 
    
    # Open the text file from disk 
    $reader = New-Object System.IO.StreamReader($csvfile) 
    $columns = (Get-Content $csvfile -First 1).Split($csvdelimiter) 
    if ($FirstRowColumnNames -eq $true) { $null = $reader.readLine() } 
    
    foreach ($column in $columns) {  
        $null = $datatable.Columns.Add() 
    } 
    
    # Read in the data, line by line, not column by column 
    while (($line = $reader.ReadLine()) -ne $null)  { 
        
        $null = $datatable.Rows.Add($line.Split($csvdelimiter)) 
    
    # Import and empty the datatable before it starts taking up too much RAM, but  
    # after it has enough rows to make the import efficient. 
        $i++; if (($i % $batchsize) -eq 0) {  
            $bulkcopy.WriteToServer($datatable)  
            Write-Host "$i rows have been inserted in $($elapsed.Elapsed.ToString())." 
            $datatable.Clear()  
        }  
    }  
    
    # Add in all the remaining rows since the last clear 
    if($datatable.Rows.Count -gt 0) { 
        $bulkcopy.WriteToServer($datatable) 
        $datatable.Clear() 
    } 
    
    # Clean Up 
    $reader.Close(); $reader.Dispose() 
    $bulkcopy.Close(); $bulkcopy.Dispose() 
    $datatable.Dispose() 
    
    Write-Host "Section complete. $i rows have been inserted into the database." 
    Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 
    # Sometimes the Garbage Collector takes too long to clear the huge datatable. 
    [System.GC]::Collect()

    ####################################################################################




    # Assignments
    # ----------------------------------------------------------------------------------
    $table = "XImportAssignment"
    # CSV Variables
    $csvfile = "/home/admin/CanvasSync/gradeSync/output/XAssignments.csv"
    $csvdelimiter = "|"
    $FirstRowColumnNames = $true

    Write-Host "Assignments started..." 
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()  
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data") 
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient") 
    
    # 50k worked fastest and kept memory usage to a minimum 
    $batchsize = 50000 
    
    # Build the sqlbulkcopy connection, and set the timeout to infinite 
    $bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
    $bulkcopy.DestinationTableName = $table 
    $bulkcopy.bulkcopyTimeout = 0 
    $bulkcopy.batchsize = $batchsize 
    
    # Create the datatable, and autogenerate the columns. 
    $datatable = New-Object System.Data.DataTable 
    
    # Open the text file from disk 
    $reader = New-Object System.IO.StreamReader($csvfile) 
    $columns = (Get-Content $csvfile -First 1).Split($csvdelimiter) 
    if ($FirstRowColumnNames -eq $true) { $null = $reader.readLine() } 
    
    foreach ($column in $columns) {  
        $null = $datatable.Columns.Add() 
    } 
    
    # Read in the data, line by line, not column by column 
    while (($line = $reader.ReadLine()) -ne $null)  { 
        
        $null = $datatable.Rows.Add($line.Split($csvdelimiter)) 
    
    # Import and empty the datatable before it starts taking up too much RAM, but  
    # after it has enough rows to make the import efficient. 
        $i++; if (($i % $batchsize) -eq 0) {  
            $bulkcopy.WriteToServer($datatable)  
            Write-Host "$i rows have been inserted in $($elapsed.Elapsed.ToString())." 
            $datatable.Clear()  
        }  
    }  
    
    # Add in all the remaining rows since the last clear 
    if($datatable.Rows.Count -gt 0) { 
        $bulkcopy.WriteToServer($datatable) 
        $datatable.Clear() 
    } 
    
    # Clean Up 
    $reader.Close(); $reader.Dispose() 
    $bulkcopy.Close(); $bulkcopy.Dispose() 
    $datatable.Dispose() 
    
    Write-Host "Section complete. $i rows have been inserted into the database." 
    Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 
    # Sometimes the Garbage Collector takes too long to clear the huge datatable. 
    [System.GC]::Collect()

    ####################################################################################




    # Scores 
    # -----------------------------------------------------------------------------------
    $table = "XImportScore"
    # CSV Variables
    $csvfile = "/home/admin/CanvasSync/gradeSync/output/XSubmissions.csv"
    $csvdelimiter = "|"
    $FirstRowColumnNames = $true

    Write-Host "Scores started..." 
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()  
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data") 
    [void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient") 
    
    # 50k worked fastest and kept memory usage to a minimum 
    $batchsize = 50000 
    
    # Build the sqlbulkcopy connection, and set the timeout to infinite 
    $bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
    $bulkcopy.DestinationTableName = $table 
    $bulkcopy.bulkcopyTimeout = 0 
    $bulkcopy.batchsize = $batchsize 
    
    # Create the datatable, and autogenerate the columns. 
    $datatable = New-Object System.Data.DataTable 
    
    # Open the text file from disk 
    $reader = New-Object System.IO.StreamReader($csvfile) 
    $columns = (Get-Content $csvfile -First 1).Split($csvdelimiter) 
    if ($FirstRowColumnNames -eq $true) { $null = $reader.readLine() } 
    
    foreach ($column in $columns) {  
        $null = $datatable.Columns.Add() 
    } 
    
    # Read in the data, line by line, not column by column 
    while (($line = $reader.ReadLine()) -ne $null)  { 
        
        $null = $datatable.Rows.Add($line.Split($csvdelimiter)) 
    
    # Import and empty the datatable before it starts taking up too much RAM, but  
    # after it has enough rows to make the import efficient. 
        $i++; if (($i % $batchsize) -eq 0) {  
            $bulkcopy.WriteToServer($datatable)  
            Write-Host "$i rows have been inserted in $($elapsed.Elapsed.ToString())." 
            $datatable.Clear()  
        }  
    }  
    
    # Add in all the remaining rows since the last clear 
    if($datatable.Rows.Count -gt 0) { 
        $bulkcopy.WriteToServer($datatable) 
        $datatable.Clear() 
    } 
    
    # Clean Up 
    $reader.Close(); $reader.Dispose() 
    $bulkcopy.Close(); $bulkcopy.Dispose() 
    $datatable.Dispose() 
    
    Write-Host "Section complete. $i rows have been inserted into the database." 
    Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 
    # Sometimes the Garbage Collector takes too long to clear the huge datatable. 
    [System.GC]::Collect()

    ####################################################################################




    ### AT THIS POINT THE INSERTS ARE COMPLETE. ALL THE DATA IS IN THE TABLES. ###
    # NOW WE NEED TO RUN ALL THE STUFF #

    # Categories
    # ------------------------------------

    # Merge the holding pen into the permanent matching table.
    $query = "MERGE INTO XCanvasCategory AS cc
    USING (SELECT DISTINCT * FROM XImportCategory) AS xc
    ON (xc.canvasCategoryID = cc.canvasCategoryID)
    AND (xc.sectionNumber = cc.sectionNumber)
    AND (xc.courseNumber = cc.courseNumber)
    WHEN MATCHED THEN
    UPDATE
    SET cc.name = LEFT(xc.name, 50)
    , cc.seq = xc.seq
    , cc.weight = xc.weight
    WHEN NOT MATCHED BY SOURCE THEN
    DELETE
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT
    VALUES
    ( xc.endYear
    , xc.schoolNumber
    , xc.courseNumber
    , xc.sectionNumber
    , xc.canvasCategoryID
    , LEFT(xc.name, 50)
    , xc.seq
    , xc.weight
    , NULL
    , NULL
    , NULL
    , NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Merged into XCanvasCategory"
    Write-Host ""


    # Delete the old import records since they have been merged with the XCanvasCategory table
    $query = "DELETE FROM XImportCategory"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Deleted import records after merge"
    Write-Host ""


    # Update the XCanvasCategory table with IC foreign keys.
    $query = "UPDATE cc 
    SET cc.sectionID = sec.sectionID
    , cc.taskID = gt.taskID
    , cc.termID = t.termID
    FROM XCanvasCategory cc 
    INNER JOIN course c 
    ON cc.courseNumber = c.number 
    INNER JOIN section sec 
    ON c.courseID = sec.courseID
    AND cc.sectionNumber = sec.number
    INNER JOIN sectionPlacement sp 
    ON sec.sectionID = sp.sectionID
    INNER JOIN term t 
    ON sp.termID = t.termID
    INNER JOIN calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN school sch 
    ON cal.schoolID = sch.schoolID
    INNER JOIN gradingTaskCredit gtc 
    ON c.courseID = gtc.courseID
    INNER JOIN gradingTask gt 
    ON gtc.taskID = gt.taskID
    WHERE cal.endYear = cc.endYear
    AND sch.number = cc.schoolNumber
    AND gt.name IN ('"+$termName1+"','"+$termName2+"')
    --AND ((t.startDate <= CURRENT_TIMESTAMP) AND (t.endDate >= CURRENT_TIMESTAMP))"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Updated with match data"
    Write-Host ""


    # Update any pre-existing categories
    $query = "UPDATE xcc 
    SET xcc.icCategoryID = lpg.groupID
    FROM XCanvasCategory xcc 
    INNER JOIN LessonPlanGroup lpg 
    ON xcc.sectionID = lpg.sectionID 
    AND xcc.name = lpg.name;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.Transaction = $transaction
    $command.ExecuteNonQuery()
    Write-Host "Pre-Existing Categories Matched"
    Write-Host ""


    # Delete Unique Constraint Issues
    $query = "DELETE xcc 
    OUTPUT
    'XCanvasCategory'
    , 'sectionID'
    , DELETED.sectionID
    , DELETED.name
    , 'Unique Constraint Delete'
    , 'DELETED'
    , 15000
    , 'Deleted due to Unique Constraint Violation'
    , CURRENT_TIMESTAMP
    INTO XCanvasSyncLog
    FROM XCanvasCategory xcc 
    INNER JOIN LessonPlanGroup lpg 
    ON xcc.sectionID = lpg.sectionID
    AND xcc.name = lpg.name
    AND (xcc.termID = lpg.termID OR lpg.termID IS NULL)
    WHERE (xcc.icCategoryID != lpg.groupID OR xcc.icCategoryID IS NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Categories Deleted due to Unique Constriant"
    Write-Host ""

    # Delete non-matching records
    $query = "DELETE FROM XCanvasCategory
    OUTPUT
    'XCanvasCategory'
    , 'Course/Section Number'
    , DELETED.courseNumber
    , DELETED.sectionNumber
    , 'Non-Match Delete'
    , 'DELETED'
    , 16000
    , 'Deleted due to Non-Matching '
    , CURRENT_TIMESTAMP
    INTO XCanvasSyncLog
    WHERE (sectionID IS NULL
    OR taskID IS NULL
    OR termID IS NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Categories Deleted due to non-matching"
    Write-Host ""


    # Delete duplicates cause some people cant think gud
    $query = "DELETE FROM XCanvasCategory
    WHERE icCategoryID IN 
    (SELECT d.categoryID
    FROM
    (SELECT
    xcc.schoolNumber AS numbersch
    , xcc.courseNumber AS course
    , xcc.sectionNumber AS number
    , xcc.name AS name
    , xcc.icCategoryID AS categoryID
    , COUNT(lpg.groupID) AS countin FROM XCanvasCategory xcc 
    INNER JOIN LessonPlanGroup lpg 
    ON xcc.icCategoryID = lpg.groupID
    GROUP BY xcc.schoolNumber, xcc.courseNumber, xcc.sectionNumber, xcc.name, xcc.icCategoryID
    HAVING COUNT(lpg.groupID) > 1) AS d);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Categories Deleted due to duplication"
    Write-Host ""





    # Merge into the actual table and copy the mapping combo of primary keys 
    $query = "MERGE INTO LessonPlanGroup AS lpg 
    USING XCanvasCategory AS cc
    ON cc.icCategoryID = lpg.groupID
    WHEN MATCHED THEN
    UPDATE
    SET lpg.name = cc.name
    , lpg.seq = cc.seq
    , lpg.weight = cc.weight
    , lpg.termID = cc.termID
    WHEN NOT MATCHED THEN
    INSERT
    ( sectionID
    , taskID
    , termID
    , name
    , weight
    , seq 
    , modifiedDate
    , modifiedByID)
    VALUES
    ( cc.sectionID
    , cc.taskID
    , cc.termID
    , LEFT(cc.name, 50)
    , cc.weight
    , cc.seq 
    , CURRENT_TIMESTAMP 
    , "+$modPersonID+")
    OUTPUT
    cc.canvasCategoryID
    , INSERTED.sectionID
    , INSERTED.groupID
    INTO XCategoryMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Categories Merged with IC Stock table"
    Write-Host ""


    # Update mapping column
    $query = "UPDATE xcc
    SET icCategoryID = xcm.icCategoryID
    FROM XCanvasCategory xcc
    INNER JOIN XCategoryMap xcm 
    ON xcc.sectionID = xcm.icSectionID
    AND xcc.canvasCategoryID = xcm.canvasCategoryID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Categories Updated with IC Primary Key"
    Write-Host ""


    # Delete old records from temp mapping table
    $query = "DELETE FROM XCategoryMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Deleted category temp mappings"
    Write-Host ""



    # Assignments
    # ------------------------------------
    # Delete the data from the temp table
    $query = "UPDATE XImportAssignment
    SET startDate = '"+$defAssStart+"'
    WHERE startDate < '"+$defAssEnd+"';"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records with no startDate fixed."
    Write-Host ""

    # Merge the holding pen into the permanent matching table.
    $query = "MERGE INTO XCanvasAssignment AS xca
    USING XImportAssignment AS xia
    ON (xca.canvasAssignmentID = xia.canvasAssignmentID)
    AND (xca.courseNumber = xia.courseNumber)
    AND (xca.sectionNumber = xia.sectionNumber)
    WHEN MATCHED THEN
    UPDATE
        SET xca.name = xia.name
        ,   xca.startDate = xia.startDate
        ,   xca.dueDate = xia.dueDate
        ,   xca.pointsPossible = xia.pointsPossible
        ,   xca.seq = xia.seq
    WHEN NOT MATCHED BY SOURCE THEN 
    DELETE
    WHEN NOT MATCHED BY TARGET THEN
    INSERT VALUES
    ( xia.endYear
    , xia.schoolNumber
    , xia.courseNumber
    , xia.sectionNumber
    , xia.canvasAssignmentID
    , xia.name
    , xia.startDate
    , xia.dueDate
    , xia.pointsPossible
    , xia.seq
    , xia.canvasCategoryID
    , NULL
    , NULL
    , NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Merged into XCanvasAssignment"
    Write-Host ""


    # Delete the data from the temp table
    $query = "DELETE FROM XImportAssignment;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records deleted from the temp table"
    Write-Host ""



    # Update Section
    $query = "UPDATE xca
    SET xca.icSectionID = sec.sectionID
    FROM XCanvasAssignment xca 
    INNER JOIN calendar cal 
    ON xca.endYear = cal.endYear
    INNER JOIN school sch 
    ON xca.schoolNumber = sch.number
    INNER JOIN course c 
    ON cal.calendarID = c.calendarID
    AND cal.schoolID = sch.schoolID
    AND xca.courseNumber = c.number
    INNER JOIN section sec 
    ON c.courseID = sec.courseID
    AND xca.sectionNumber = sec.number;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records matched with Section"
    Write-Host ""


    # Update the perm table to map to the ICCategory
    $query = "UPDATE xca 
    SET icCategoryID = xcc.icCategoryID
    FROM XCanvasAssignment xca
    INNER JOIN XCanvasCategory xcc
    ON xca.canvasCategoryID = xcc.canvasCategoryID
    AND xca.icSectionID = xcc.sectionID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records matched with Category"
    Write-Host ""



    # Delete records where there is not a matching category or section
    $query = "DELETE FROM XCanvasAssignment
    WHERE (icCategoryID IS NULL
    OR icSectionID IS NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Non-matching records deleted"
    Write-Host ""



    # Merge into IMLearningObject
    $query = "MERGE INTO IMLearningObject AS lo 
    USING 
    (SELECT DISTINCT 
    xca1.canvasAssignmentID AS canvasAssignmentID
    , xca1.name AS name
    , xca1.icObjectID AS icObjectID
    FROM XCanvasAssignment xca1)  AS xca
    ON (lo.objectID = xca.icObjectID)
    WHEN MATCHED THEN
        UPDATE
            SET lo.name = xca.name
            , lo.modifiedByID = "+$modPersonID+"
            , lo.modifiedDate = CURRENT_TIMESTAMP 
    WHEN NOT MATCHED THEN
        INSERT
        ( name
        , createdByID
        , createdDate
        , modifiedByID
        , modifiedDate
        , objectGUID
        , type 
        , draft 
        , publish
        , durationDays
        , versionNumber
        , importedFromLMS)
        VALUES
        ( xca.name
        , "+$modPersonID+"
        , CURRENT_TIMESTAMP
        , "+$modPersonID+"
        , CURRENT_TIMESTAMP 
        , newID() 
        , 7
        , 'T'
        , 0
        , 1
        , 1
        , 1)
    OUTPUT
        xca.canvasAssignmentID
        , INSERTED.objectID
    INTO XAssignmentMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records Merged into IMLearningObject"
    Write-Host ""



    # Update from temp mapping
    $query = "UPDATE xca
    SET xca.icObjectID = xam.icObjectID
    FROM XCanvasAssignment xca 
    INNER JOIN XAssignmentMap xam
    ON xca.canvasAssignmentID = xam.canvasAssignmentID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "New Mappings Created"
    Write-Host ""



    # Delete from temp mapping
    $query = "DELETE FROM XAssignmentMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Temp Mappings Deleted"
    Write-Host ""



    # Merge into IMLearningObjectSchedulingSet
    $query = "MERGE INTO IMLearningObjectSchedulingSet AS loss
    USING 
    ( SELECT DISTINCT
    icObjectID
    , canvasAssignmentID
    FROM XCanvasAssignment) AS xca
    ON xca.icObjectID = loss.objectID
    WHEN MATCHED THEN
    UPDATE
        SET modifiedByID = "+$modPersonID+"
        ,   modifiedDate = CURRENT_TIMESTAMP
    WHEN NOT MATCHED THEN
    INSERT
        ( objectID
        , parentSchedulingSetID
        , abbrev
        , notGraded
        , wysiwygSubmission
        , upload
        , driveSubmission
        , assessmentInstanceID
        , modifiedByID
        , modifiedDate )
    VALUES
        ( xca.icObjectID
        , NULL
        , xca.canvasAssignmentID
        , 0
        , 0
        , 0
        , 0
        , NULL
        , "+$modPersonID+"
        , CURRENT_TIMESTAMP );"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records Merged into IMLearningObjectSchedulingSet"
    Write-Host ""


    # Perform merge into IMLearningObjectSection
    $query = "MERGE INTO IMLearningObjectSection los 
    USING 
    ( SELECT DISTINCT
        xca.icSectionID AS sectionID
        , CASE 
                    WHEN xca.startDate >= CURRENT_TIMESTAMP THEN CURRENT_TIMESTAMP
                    WHEN xca.startDate IS NULL THEN xca.dueDate
                    ELSE xca.startDate
        END AS startDate
        , xca.dueDate AS endDate 
        , loss.schedulingSetID AS schedulingSetID
        , xca.seq AS seq
    FROM XCanvasAssignment xca
    INNER JOIN IMLearningObject lo 
    ON xca.icObjectID = lo.objectID
    AND lo.importedFromLMS = 1
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON lo.objectID = loss.objectID
    INNER JOIN section sec 
    ON xca.icSectionID = sec.sectionID
    WHERE lo.importedFromLMS = 1) AS [source]
    ON (source.sectionID = los.sectionID)
    AND (source.schedulingSetID = los.schedulingSetID)
    WHEN MATCHED THEN
    UPDATE
        SET 
        los.startDate = source.startDate
        , los.endDate = source.endDate
        , los.seq = source.seq
    WHEN NOT MATCHED THEN
    INSERT
    ( sectionID
    , startDate
    , endDate
    , plannerSeq
    , schedulingSetID
    , externalLMSSourcedID
    , active
    , seq )
    VALUES
    ( source.sectionID
    , source.startDate
    , source.endDate
    , NULL
    , source.schedulingSetID
    , newID()
    , 1
    , source.seq);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records Merged with IMLearningObjectSection"
    Write-Host ""



    # Perform Merge into the LessonPlanGroupActivity
    $query = "MERGE INTO LessonPlanGroupActivity lpga 
    USING 
    ( SELECT
        lpg.groupID AS groupID
    , xca.icSectionID AS sectionID
    , xca.pointsPossible AS totalPoints
    , los.objectSectionID AS objectSectionID
    , lpg.taskID AS taskID
    , lpg.termID AS termID
    FROM XCanvasAssignment xca
    INNER JOIN IMLearningObject lo 
    ON xca.icObjectID = lo.objectID
    AND lo.importedFromLMS = 1
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON lo.objectID = loss.objectID
    INNER JOIN IMLearningObjectSection los
    ON loss.schedulingSetID = los.schedulingSetID
    AND los.sectionID = xca.icSectionID
    INNER JOIN LessonPlanGroup lpg 
    ON xca.icCategoryID = lpg.groupID
    INNER JOIN section sec 
    ON xca.icSectionID = sec.sectionID
    WHERE lo.importedFromLMS = 1) AS [source]
    ON lpga.objectSectionID = source.objectSectionID
    WHEN MATCHED THEN 
    UPDATE
        SET
        lpga.modifiedByID = "+$modPersonID+"
        , lpga.modifiedDate = CURRENT_TIMESTAMP 
        , lpga.totalPoints = source.totalPoints
        , lpga.groupID = source.groupID
        , lpga.termID = source.termID
    WHEN NOT MATCHED THEN
    INSERT
    ( groupID
    , sectionID
    , modifiedByID
    , modifiedDate
    , totalPoints
    , weight
    , scoringType
    , objectSectionID
    , taskID
    , termID )
    VALUES
    ( source.groupID
    , source.sectionID
    , "+$modPersonID+"
    , CURRENT_TIMESTAMP
    , source.totalPoints
    , 1
    , 'p'
    , source.objectSectionID
    , source.taskID
    , source.termID);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records Merged with LessonPlanGroupActivity"
    Write-Host ""


    # Scores
    # ------------------------------------
    # Merge into the permanent table

    # Match with the personID
    $query = "DELETE FROM XImportScore
    WHERE stateID LIKE 'staff%';"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Staff people deleted."
    Write-Host ""


    $query = "MERGE INTO XCanvasScore AS xcs
    USING XImportScore as xis
    ON (xcs.canvasAssignmentID = xis.canvasAssignmentID) 
    AND (xcs.stateID = xis.stateID)
    WHEN MATCHED THEN
        UPDATE
            SET xcs.score = xis.score
            , xcs.late = xis.late 
            , xcs.excused = xis.excused
            , xcs.missing = xis.missing
    WHEN NOT MATCHED THEN
        INSERT VALUES
        ( xis.canvasAssignmentID
        , xis.stateID
        , xis.score
        , xis.late 
        , xis.excused
        , xis.missing
        , NULL
        , NULL
        , NULL
        , NULL
        , NULL
        , NULL
        , NULL
        , NULL );"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Merged into permanent table"
    Write-Host ""


    # Delete the temp import data
    $query = "DELETE FROM XImportScore;"
    # $command = $connection.CreateCommand()
    # $command.CommandText = $query
    # $command.ExecuteNonQuery()
    # Write-Host "Records deleted from the temp Import"
    # Write-Host ""


    # Match with the personID
    $query = "UPDATE xcs
        SET xcs.personID = p.personID
    FROM XCanvasScore xcs
    INNER JOIN Person p 
    ON xcs.stateID = p.stateID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Records matched with a Person"
    Write-Host ""


    # Change missing tags if the score is a score and if grade is null
    $query = "UPDATE XCanvasScore
    SET missing = 0
    WHERE ((CAST(score AS FLOAT) > 0 AND missing = 1) OR (score = '' AND missing=1));"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Bad missing tags fixed"
    Write-Host ""

    # Match with the course ID in IC
    $query = "UPDATE xcs
        SET xcs.icCourseID = c.courseID
        , xcs.icObjectID = xca.icObjectID
    FROM XCanvasScore xcs
    INNER JOIN XCanvasAssignment xca
    ON xcs.canvasAssignmentID = xca.canvasAssignmentID
    INNER JOIN School sch 
    ON xca.schoolNumber = sch.number
    INNER JOIN calendar cal 
    ON xca.endYear = cal.endYear
    AND sch.schoolID = cal.schoolID
    INNER JOIN course c 
    ON xca.courseNumber = c.number
    AND cal.calendarID = c.calendarID
    AND c.active = 1
    WHERE xca.endYear = "+$endYear+";"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Records matched with a Course"
    Write-Host ""



    # Match with the sectionID, term, and others in IC
    $query = "UPDATE xcs
        SET xcs.icSectionID = r.sectionID
        ,   xcs.icTermID = t.termID
        ,   xcs.objectSectionID = los.objectSectionID
        ,   xcs.groupActivityID = lpga.groupActivityID
    FROM XCanvasScore xcs
    INNER JOIN XCanvasAssignment xca
    ON xcs.canvasAssignmentID = xca.canvasAssignmentID
    INNER JOIN course c 
    ON xca.courseNumber = c.number
    INNER JOIN section sec
    ON c.courseID = sec.courseID
    INNER JOIN roster r 
    ON xcs.personID = r.personID
    AND sec.sectionID = r.sectionID
    INNER JOIN SectionPlacement sp 
    ON sec.sectionID = sp.sectionID
    INNER JOIN term t 
    ON sp.termID = t.termID
    INNER JOIN calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN IMLearningObject ilo 
    ON xca.icObjectID = ilo.objectID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON ilo.objectID = loss.objectID
    INNER JOIN IMLearningObjectSection los 
    ON loss.schedulingSetID = los.schedulingSetID
    AND r.sectionID = los.sectionID
    INNER JOIN LessonPlanGroupActivity lpga 
    ON los.objectSectionID = lpga.objectSectionID
    AND t.termID = lpga.termID
    WHERE cal.name IN ('"+$calendarName1+"','"+$calendarName2+"')
    AND t.name IN ('"+$termName1+"','"+$termName1+"')
    AND (r.endDate IS NULL OR r.endDate >= CURRENT_TIMESTAMP)
    AND xca.endYear = "+$endYear+";"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Records matched with the rest of the data"
    Write-Host ""

    # Try to match to pre-existing records using Unique Key
    $query = "UPDATE xcs 
    SET xcs.icScoreID = lps.scoreID
    FROM XCanvasScore xcs 
    INNER JOIN LessonPlanScore lps 
    ON xcs.icSectionID = lps.sectionID
    AND xcs.objectSectionID = lps.objectSectionID
    AND xcs.groupActivityID = lps.groupActivityID
    AND xcs.personID = lps.personID
    WHERE xcs.icScoreID != lps.scoreID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "records matched to existing scores"
    Write-Host ""



    # Delete non-matching records
    $query = "DELETE FROM XCanvasScore 
    OUTPUT
    'XCanvasScore'
    , 'sectionID'
    , DELETED.icSectionID
    , DELETED.canvasAssignmentID
    , 'Non-Match Delete'
    , 'DELETED'
    , 15000
    , CONCAT('person:',DELETED.personID,'course:',DELETED.icCourseID,'object:',DELETED.icObjectID,'section:',DELETED.icSectionID,'term:',DELETED.icTermID,'cat:',DELETED.groupActivityID)
    , CURRENT_TIMESTAMP
    INTO XCanvasSyncLog
    WHERE (personID IS NULL
    OR icCourseID IS NULL
    OR icObjectID IS NULL
    OR icSectionID IS NULL
    OR icTermID IS NULL
    OR groupActivityID IS NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Non-matching records deleted"
    Write-Host ""


    # Delete non-matching records
    $query = "DELETE xcs 
    FROM XCanvasScore xcs
    LEFT JOIN LessonPlanGroupActivity lpga 
    ON xcs.groupActivityID = lpga.groupActivityID 
    WHERE lpga.groupActivityID IS NULL;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "FK_LessonPlanGroupActivity break records deleted"
    Write-Host ""



    # Delete non-matching records
    $query = "DELETE FROM XCanvasScore 
    WHERE (personID IS NULL
    OR icCourseID IS NULL
    OR icObjectID IS NULL
    OR icSectionID IS NULL
    OR icTermID IS NULL);"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Non-matching records deleted"
    Write-Host ""


    # Merge into LessonPlanScore
    $query = "MERGE INTO LessonPlanScore AS lps 
    USING XCanvasScore AS xcs 
    ON (xcs.icScoreID = lps.scoreID)
    WHEN MATCHED THEN 
        UPDATE
            SET
            lps.score = xcs.score
            , lps.sectionID = xcs.icSectionID
            , lps.groupActivityID = xcs.groupActivityID
            , lps.objectSectionID = xcs.objectSectionID
            , lps.late = xcs.late 
            , lps.exempt = xcs.excused
            , lps.missing = xcs.missing
            , lps.modifiedDate = CURRENT_TIMESTAMP 
            , lps.modifiedByID = "+$modPersonID+"
    WHEN NOT MATCHED THEN
        INSERT
        ( sectionID
        , personID
        , score
        , late 
        , exempt
        , missing
        , modifiedDate
        , modifiedByID
        , objectSectionID
        , groupActivityID )
        VALUES
        ( xcs.icSectionID
        , xcs.personID
        , xcs.score
        , xcs.late 
        , xcs.excused 
        , xcs.missing
        , CURRENT_TIMESTAMP
        , "+$modPersonID+"
        , xcs.objectSectionID
        , xcs.groupActivityID )
    OUTPUT
        xcs.canvasAssignmentID
        , xcs.stateID
        , xcs.icCourseID
        , xcs.icSectionID
        , INSERTED.scoreID
    INTO XScoreMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Records merged into LessonPlanScore"
    Write-Host ""



    # Update the mapping
    $query = "UPDATE xcs
    SET xcs.icScoreID = xsm.icScoreID
    FROM XCanvasScore xcs
    INNER JOIN XScoreMap xsm 
    ON xcs.canvasAssignmentID = xsm.canvasAssignmentID
    AND xcs.stateID = xsm.stateID
    AND xcs.icCourseID = xsm.icCourseID
    AND xcs.icSectionID = xsm.icSectionID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Records mapped"
    Write-Host ""


    # Delete from temp Mapping
    $query = "DELETE FROM XScoreMap;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Temp Records Deleted"
    Write-Host ""



    # Delete Section
    # ----------------------------------------

    # Delete Scores
    $query = "DELETE lps
    FROM LessonPlanScore lps 
    INNER JOIN IMLearningObjectSection los
    ON lps.objectSectionID = los.objectSectionID 
    INNER JOIN Section sec 
    ON los.sectionID = sec.sectionID
    INNER JOIN Course c 
    ON sec.courseID = c.courseID
    INNER JOIN Calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN SectionPlacement sp 
    ON sec.sectionID = sp.sectionID
    INNER JOIN Term t 
    ON sp.termID = t.termID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN IMLearningObject lo 
    ON loss.objectID = lo.objectID
    AND lo.importedFromLMS = 1
    LEFT JOIN XCanvasAssignment xca 
    ON lo.objectID = xca.icObjectID
    AND los.sectionID = xca.icSectionID
    WHERE cal.endYear = "+$endYear+"
    AND xca.icObjectID IS NULL
    AND lo.importedFromLMS = 1
    AND CURRENT_TIMESTAMP BETWEEN t.startDate AND t.endDate;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Deleted scores"
    Write-Host ""





    # Delete LPGA
    $query = "DELETE lpga
    FROM LessonPlanGroupActivity lpga
    INNER JOIN IMLearningObjectSection los
    ON lpga.objectSectionID = los.objectSectionID
    INNER JOIN Section sec 
    ON los.sectionID = sec.sectionID
    INNER JOIN Course c 
    ON sec.courseID = c.courseID
    INNER JOIN Calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN SectionPlacement sp 
    ON sec.sectionID = sp.sectionID
    INNER JOIN Term t 
    ON sp.termID = t.termID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN IMLearningObject lo 
    ON loss.objectID = lo.objectID
    AND lo.importedFromLMS = 1
    LEFT JOIN XCanvasAssignment xca 
    ON lo.objectID = xca.icObjectID
    AND los.sectionID = xca.icSectionID
    WHERE cal.endYear = "+$endYear+"
    AND xca.icObjectID IS NULL
    AND lo.importedFromLMS = 1
    AND CURRENT_TIMESTAMP BETWEEN t.startDate AND t.endDate;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Deleted LPGA"
    Write-Host ""

    # Precautionary delete of the delete table
    $query = "DELETE FROM XCanvasDelete;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Precautionary Delete of XCanvasDelete"
    Write-Host ""


    # Temp Store Marked for DELETION - LOS
    $query = "INSERT INTO XCanvasDelete 
    ( tableName 
    , keyValue)
    SELECT 
      'IMLearningObjectSection' AS tableName 
    , los.objectSectionID AS keyValue
    FROM IMLearningObjectSection los
    INNER JOIN Section sec 
    ON los.sectionID = sec.sectionID
    INNER JOIN Course c 
    ON sec.courseID = c.courseID
    INNER JOIN Calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN SectionPlacement sp 
    ON sec.sectionID = sp.sectionID
    INNER JOIN Term t 
    ON sp.termID = t.termID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN IMLearningObject lo 
    ON loss.objectID = lo.objectID
    AND lo.importedFromLMS = 1
    LEFT JOIN XCanvasAssignment xca 
    ON lo.objectID = xca.icObjectID
    AND los.sectionID = xca.icSectionID
    WHERE cal.endYear = "+$endYear+"
    AND xca.icObjectID IS NULL
    AND lo.importedFromLMS = 1
    AND CURRENT_TIMESTAMP BETWEEN t.startDate AND t.endDate;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Marked LOS for DELETION"
    Write-Host ""

    # Temp Store Marked for DELETION - LOSS
    $query = "INSERT INTO XCanvasDelete 
	( tableName 
	, keyValue)
	SELECT 
  	'IMLearningObjectSchedulingSet' AS tableName 
	, loss.schedulingSetID AS keyValue
	FROM IMLearningObjectSection los
    INNER JOIN Section sec 
    ON los.sectionID = sec.sectionID
    INNER JOIN Course c 
    ON sec.courseID = c.courseID
    INNER JOIN Calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN SectionPlacement sp 
	ON sec.sectionID = sp.sectionID
	INNER JOIN Term t 
	ON sp.termID = t.termID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN IMLearningObject lo 
    ON loss.objectID = lo.objectID
    AND lo.importedFromLMS = 1
    LEFT JOIN XCanvasAssignment xca 
    ON lo.objectID = xca.icObjectID
    AND los.sectionID = xca.icSectionID
    WHERE cal.endYear = "+$endYear+"
    AND xca.icObjectID IS NULL
    AND lo.importedFromLMS = 1
    AND CURRENT_TIMESTAMP BETWEEN t.startDate AND t.endDate;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Marked LOSS for DELETION"
    Write-Host ""

    # Temp Store Marked for DELETION - LO
    $query = "INSERT INTO XCanvasDelete 
	( tableName 
	, keyValue)
	SELECT 
  	'IMLearningObject' AS tableName 
	, lo.objectID AS keyValue
	FROM IMLearningObjectSection los
    INNER JOIN Section sec 
    ON los.sectionID = sec.sectionID
    INNER JOIN Course c 
    ON sec.courseID = c.courseID
    INNER JOIN Calendar cal 
    ON c.calendarID = cal.calendarID
    INNER JOIN SectionPlacement sp 
	ON sec.sectionID = sp.sectionID
	INNER JOIN Term t 
	ON sp.termID = t.termID
    INNER JOIN IMLearningObjectSchedulingSet loss 
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN IMLearningObject lo 
    ON loss.objectID = lo.objectID
    AND lo.importedFromLMS = 1
    LEFT JOIN XCanvasAssignment xca 
    ON lo.objectID = xca.icObjectID
    AND los.sectionID = xca.icSectionID
    WHERE cal.endYear = "+$endYear+"
    AND xca.icObjectID IS NULL
    AND lo.importedFromLMS = 1
    AND CURRENT_TIMESTAMP BETWEEN t.startDate AND t.endDate;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Marked LO for DELETION"
    Write-Host ""

    # Delete LOS
    $query = "DELETE los
    FROM IMLearningObjectSection los
    INNER JOIN XCanvasDelete xcd 
    ON xcd.tableName = 'IMLearningObjectSection'
    AND los.objectSectionID = xcd.keyValue
    INNER JOIN IMLearningObjectSchedulingSet loss
    ON los.schedulingSetID = loss.schedulingSetID
    INNER JOIN XCanvasDelete xcd2 
    ON xcd2.tableName = 'IMLearningObjectSchedulingSet'
    AND loss.schedulingSetID = xcd2.keyValue;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Deleted LOS"
    Write-Host ""


    # Deleted rows with dependencies
    $query = "DELETE xcd 
	FROM XCanvasDelete xcd 
	INNER JOIN IMLearningObjectSchedulingSet loss 
	ON xcd.tableName = 'IMLearningObjectSchedulingSet'
	AND xcd.keyValue = loss.schedulingSetID
	INNER JOIN IMLearningObjectSection los 
	ON los.schedulingSetID = loss.schedulingSetID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.commandTimeout = 0
    $command.ExecuteNonQuery()
    Write-Host "Deleted rows with dependencies"
    Write-Host ""




    # Delete LOSS
    $query = "DELETE loss
    FROM IMLearningObjectSchedulingSet loss 
    INNER JOIN XCanvasDelete xcd 
    ON xcd.tableName = 'IMLearningObjectSchedulingSet'
    AND loss.schedulingSetID = xcd.keyValue;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Deleted LOSS"
    Write-Host ""

    # Deleted rows with dependencies
    $query = "DELETE xcd 
	FROM XCanvasDelete xcd 
	INNER JOIN IMLearningObject lo 
	ON xcd.tableName = 'IMLearningObject'
	AND xcd.keyValue = lo.objectID
	INNER JOIN IMLearningObjectSchedulingSet loss
	ON lo.objectID = loss.objectID;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Deleted rows with dependencies"
    Write-Host ""


    # Delete LO
    $query = "DELETE lo
    FROM IMLearningObject lo 
    INNER JOIN XCanvasDelete xcd 
    ON xcd.tableName = 'IMLearningObject'
    AND lo.objectID = xcd.keyValue;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Deleted LO"
    Write-Host ""

    # Clear Delete Table
    $query = "DELETE FROM XCanvasDelete;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Cleared Delete Table"
    Write-Host ""


    
    Write-Host "The Delete section has completed."

    # BEGIN a transaction so we can rollback if needed
    $query = "COMMIT;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "Committed Transaction"
    Write-Host ""


    # DONE
    $connection.Close()






}
catch {
    # An Error has occurred.

    #Lets rollback the transaction first thing.
    $query = "ROLLBACK TRANSACTION;"
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    Write-Host "ERROR: An Error has occured and the transaction has been rolled back."
    Write-Host ""

    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName

    Write-Host "ERROR MESSAGE: $ErrorMessage"
    Write-Host "FAILED ITEM: $FailedItem"

}




