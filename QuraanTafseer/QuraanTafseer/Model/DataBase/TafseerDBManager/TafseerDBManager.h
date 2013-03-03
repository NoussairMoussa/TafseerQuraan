//
//  TafseerDBManager.h
//  QuraanTafseer
//
//  Created by Hossam on 3/3/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "AbstractSqliteManager.h"
#import "Tafseer.h"
@interface TafseerDBManager : AbstractSqliteManager


-(NSMutableArray *)getTafseerForSurahNo:(int)surahNo;
@end
