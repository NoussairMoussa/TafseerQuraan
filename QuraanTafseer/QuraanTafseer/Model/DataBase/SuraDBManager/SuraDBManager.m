//
//  SuraDBManager.m
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "SuraDBManager.h"

@implementation SuraDBManager

- (NSString*)getSelectQuery
{
	return @"SELECT suraNumber,suraName FROM Sura";
}


- (id)getRecord:(sqlite3_stmt*) compiledStatement
{
	Sura *sura = [[Sura alloc] init];
    sura.suraName = [self getStringForColumn:@"suraName"];
    sura.suraNumber = [self getIntForColumn:@"suraNumber"];
    return sura;
}


@end
