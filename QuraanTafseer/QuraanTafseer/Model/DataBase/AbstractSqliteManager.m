//
//  AbstractSqliteManager.m
//  OCE
//
//  Created by Ahmad Badie on 1/18/11.
//  Copyright 2011 Inova LLC. All rights reserved.
//

#import "AbstractSqliteManager.h"

#define DB_NAME @"QuraanTafseer.sqlite"
#define USER_SETTINGS_FOLDER_NAME @"UserSettings"

@implementation AbstractSqliteManager

- (void)buildDB {
    databaseName = DB_NAME;
    
    // Get the path to the documents directory and append the databaseName
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
   	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
}

-(void) checkAndCreateDatabase{
	[self buildDB];
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
}

-(id)init{
	if(self = [super init])
	{
		[self checkAndCreateDatabase];
	}
	return self;
}

#pragma mark -
#pragma mark private SQLIE Manager

- (NSString*) convertDateToString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy MM dd"];
	
	NSString *stringFromDate = [date description];
	return stringFromDate? stringFromDate : @"";
}


- (NSDate*) convertStringToDate: (NSString*)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
    NSDate *date = [dateFormatter dateFromString:strDate];
    return date;
    
	
}
#pragma mark -
#pragma mark mapping columnNameToIndex
#pragma mark -

-(void)setupColumnNameToIndexDictionary:(sqlite3_stmt*) compiledStatement
{
    
        columnNameToIndexMapping  = [[NSMutableDictionary alloc] init];
        
        int numOfColumns = sqlite3_column_count(compiledStatement);

        for (int columnIndex = 0; columnIndex < numOfColumns; columnIndex++) {
            
            [columnNameToIndexMapping setObject:[NSNumber numberWithInt:columnIndex]
                                     forKey:[[NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, columnIndex)] lowercaseString]];
        }
    
}

-(double)getDoubleForColumn:(NSString *)columnName
{
    int columnIndex = [[columnNameToIndexMapping objectForKey:[columnName lowercaseString]] integerValue];
    return sqlite3_column_double(currentCompilesStatement, columnIndex);
}

-(int)getIntForColumn:(NSString *)columnName;
{
    int columnIndex = [[columnNameToIndexMapping objectForKey:[columnName lowercaseString]] integerValue];
    
    return sqlite3_column_int(currentCompilesStatement, columnIndex);
}
-(NSString *)getStringForColumn:(NSString *)columnName;
{
    int columnIndex = [[columnNameToIndexMapping objectForKey:[columnName lowercaseString]] integerValue];
    char* ch = (char *)sqlite3_column_text(currentCompilesStatement, columnIndex);
    return [NSString stringWithUTF8String:ch == NULL? "" : ch];
}

-(BOOL)getBoolForColumn:(NSString *)columnName
{
    return [[NSNumber numberWithInt: [self getIntForColumn:columnName]] boolValue];
}

#pragma mark -
#pragma mark Override These functions
#pragma mark -

- (id)getRecord:(sqlite3_stmt*) compiledStatement
{
	return NULL;
}

- (NSString*)getSelectQuery
{
	return NULL;
}

- (NSString*)getInsertQuery
{
	return NULL;
}

- (void) bindData:(id) record selectStmt:(sqlite3_stmt*)aSelectStmt
{
	
}
- (void) bindData:(id) record addStmt:(sqlite3_stmt*)aAddStmt
{
    
}

- (void) bindData:(id) record deleteStmt:(sqlite3_stmt*)aDeleteStmt
{
	
}
- (void) bindData:(id) record updateStmt:(sqlite3_stmt*)aUpdateStmt
{
    
}
- (NSString*) getSelectByCriteria
{
	return NULL;
}

- (NSString*) getDeleteAllQuery
{
    return NULL;
}

- (NSString*) getDeleteQuery
{
	return NULL;
}

- (NSString*) getUpdateQuery:(id) data
{
	return NULL;
}


#pragma mark -
#pragma mark SQLite Manager methods
#pragma mark -


//Test this function
-(NSMutableArray*)getRecordsByCriteria:(id)aRecord;
{
	// Setup the database objectrecord
	sqlite3 *database;
	NSMutableArray* records = [[NSMutableArray alloc] init];
	id record;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[self getSelectByCriteria] UTF8String];
		sqlite3_stmt *compiledStatement;
			
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			[self bindData:aRecord selectStmt:compiledStatement];

			sqlite3_sql(compiledStatement);
            [self setupColumnNameToIndexDictionary:compiledStatement];
			while(YES) {
				int status = sqlite3_step(compiledStatement);
				if (status != SQLITE_ROW){
					break;
				}
                currentCompilesStatement = compiledStatement;
				record = [self getRecord:compiledStatement];
				// Add the record object to the records Array
				[records addObject:record];

			}
            
            columnNameToIndexMapping = nil;
    
		}else {
			NSAssert1(0, @"Error in getRecordsByCriteria. '%s'", sqlite3_errmsg(database));
		}

		// Release the compiled statement from memory
		sqlite3_reset(compiledStatement);
		
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);

	return records ;
}


- (void)deleteAllRecords
{
	// Setup the database object
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[self getDeleteAllQuery] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
		int result = sqlite3_step(compiledStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"something wrong went while deleting the record");
		}
		// Release the compiled statement from memory
            sqlite3_reset(compiledStatement);
            
            sqlite3_finalize(compiledStatement);
            
            
        }
	}
	sqlite3_close(database);
}


- (void) deleteRecordByID:(id)record
{
	// Setup the database object
	sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[self getDeleteQuery] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            [self bindData:record deleteStmt:compiledStatement];
		}
		int result = sqlite3_step(compiledStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"something wrong went while deleting the record");
		}
		// Release the compiled statement from memory
		sqlite3_reset(compiledStatement);
		
		sqlite3_finalize(compiledStatement);
		
    }
	sqlite3_close(database);
}

-(NSMutableArray*)readRecords
{
	// Setup the database objectrecord
	sqlite3 *database;
	
	// Init the records Array
	NSMutableArray* records = [[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = [[self getSelectQuery] UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the array
			
            [self setupColumnNameToIndexDictionary:compiledStatement];
            
			while( sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                currentCompilesStatement = compiledStatement;
                
				id record = [self getRecord:compiledStatement];
				
				// Add the record object to the records Array
				[records addObject:record];
			}
            columnNameToIndexMapping = nil;
		}
		// Release the compiled statement from memory
		sqlite3_reset(compiledStatement);
		
		sqlite3_finalize(compiledStatement);
		
		
	}
	
	sqlite3_close(database);
    
	return records;
}


-(int)saveRecordToDB:(id)aRecord
{
	
	// Setup the database object
	sqlite3 *database;
	int lastInsertID = -1;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sql = [[self getInsertQuery] UTF8String];
		sqlite3_stmt *addStmt;
		
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
		
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		[self bindData:aRecord addStmt:addStmt];
		
		if(SQLITE_DONE != sqlite3_step(addStmt)) {
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			lastInsertID = -1;
		}else {
			lastInsertID = sqlite3_last_insert_rowid(database);
		}
		
		//Reset the add statement.
		sqlite3_reset(addStmt);	
		
		sqlite3_finalize(addStmt);
		
		
	}
	sqlite3_close(database);
	return lastInsertID;	
}


-(int)updateRecord:(id) aRecord
{
	
	// Setup the database object
	sqlite3 *database;
	int lastInsertID = -1;
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sql = [[self getUpdateQuery:aRecord] UTF8String];
		sqlite3_stmt *updateStmt;
		
		if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		
		[self bindData:aRecord updateStmt:updateStmt];
		
		if(SQLITE_DONE != sqlite3_step(updateStmt)) {
			NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
			lastInsertID = -1;
		}else {
			lastInsertID = sqlite3_last_insert_rowid(database);
		}
		
		//Reset the update statement.
		sqlite3_reset(updateStmt);	
		
		sqlite3_finalize(updateStmt);
		
		//sqlite3_close(database);
	}
	sqlite3_close(database);
    
	return lastInsertID;
}



@end
