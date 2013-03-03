//
//  TafseerDBManager.m
//  QuraanTafseer
//
//  Created by Hossam on 3/3/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "TafseerDBManager.h"

@implementation TafseerDBManager

- (void) bindData:(id) record selectStmt:(sqlite3_stmt*)aSelectStmt
{
    
	sqlite3_bind_int(aSelectStmt, 1, [(NSNumber *)record integerValue]);
}

- (id)getRecord:(sqlite3_stmt*) compiledStatement
{
    Tafseer *tafseer = [[Tafseer alloc] init];
    tafseer.surahNumber = [self getIntForColumn:@"sura"];
    tafseer.ayaNumber = [self getIntForColumn:@"aya"];
    tafseer.text = [self getStringForColumn:@"tafser"];
    
	return tafseer;
}


- (NSString*) getSelectByCriteria
{
	return @"SELECT sura, aya, tafser FROM ar_muyassar WHERE sura = ?";
}

-(NSMutableArray *)getTafseerForSurahNo:(int)surahNo
{
    return [self getRecordsByCriteria:[NSNumber numberWithInt:surahNo]];
}
@end
