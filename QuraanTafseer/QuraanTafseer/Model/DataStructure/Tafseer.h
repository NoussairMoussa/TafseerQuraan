//
//  Tafseer.h
//  QuraanTafseer
//
//  Created by Hossam on 3/3/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tafseer : NSObject
{
    int surahNumber;
    int ayaNumber;
    NSString *text;
}

@property (nonatomic, assign) int surahNumber;
@property (nonatomic, assign) int ayaNumber;
@property (nonatomic, strong) NSString *text;
@end
