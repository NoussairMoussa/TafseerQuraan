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
	return @"SELECT suraNumber,pageNum,juz,numberOfAyat,type,suraName FROM Sura";
}


- (id)getRecord:(sqlite3_stmt*) compiledStatement
{
	Sura *sura = [[Sura alloc] init];
    sura.suraName = [self getStringForColumn:@"suraName"];
    sura.suraNumber = [self getIntForColumn:@"suraNumber"];
    sura.pageNumber = [self getIntForColumn:@"pageNum"];
    sura.juz = [self getIntForColumn:@"juz"];
    sura.numberOfAyat = [self getIntForColumn:@"numberOfAyat"];
    int type = [self getIntForColumn:@"type"];
    if (type == 1) {
        sura.suraType = MAKEYYA;
    }else if (type == 2)
    {
        sura.suraType = MADANEYYA;
    }
  
    return sura;
}


@end
