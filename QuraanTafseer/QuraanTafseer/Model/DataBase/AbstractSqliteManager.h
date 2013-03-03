//
//  AbstractSqliteManager.h
//  OCE
//
//  Created by Ahmad Badie on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> // Import the SQLite database framework


@interface AbstractSqliteManager : NSObject {
	NSString* databaseName;
	NSString* databasePath;
    __strong NSMutableDictionary *columnNameToIndexMapping;
    sqlite3_stmt* currentCompilesStatement;
    
}


- (NSString*) convertDateToString:(NSDate*)date;
- (NSDate*) convertStringToDate: (NSString*)strDate;


-(NSMutableArray*)getRecordsByCriteria:(id)aRecord;
- (void) deleteRecordByID:(id)record;
-(NSMutableArray*)readRecords;
-(int)saveRecordToDB:(id)aRecord;
-(int)updateRecord:(id) aRecord;
- (void)deleteAllRecords;

//getdata
-(int)getIntForColumn:(NSString *)columnName;
-(NSString *)getStringForColumn:(NSString *)columnName;
-(double)getDoubleForColumn:(NSString *)columnName;

-(BOOL)getBoolForColumn:(NSString *)columnName;
-(void)setupColumnNameToIndexDictionary:(sqlite3_stmt*) compiledStatement;



//Abstract functions
- (id)getRecord:(sqlite3_stmt*) compiledStatement;

- (void) bindData:(id) record addStmt:(sqlite3_stmt*)aAddStmt;
- (void) bindData:(id) record selectStmt:(sqlite3_stmt*)aSelectStmt;
- (void) bindData:(id) record deleteStmt:(sqlite3_stmt*)aDeleteStmt;
- (void) bindData:(id) record updateStmt:(sqlite3_stmt*)aUpdateStmt;

- (NSString*) getSelectByCriteria;
- (NSString*) getDeleteQuery;
- (NSString*) getDeleteAllQuery;
- (NSString*) getUpdateQuery:(id) data;
- (NSString*) getSelectQuery;
- (NSString*) getInsertQuery;

@end
