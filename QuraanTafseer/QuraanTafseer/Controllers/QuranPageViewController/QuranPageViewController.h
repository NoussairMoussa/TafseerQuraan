//
//  QuranPageViewController.h
// Represent One page of Quran (just the image)
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuranPageViewController : UIViewController



@property (nonatomic, assign) int pageIndex;

@property (weak, nonatomic) IBOutlet UIImageView *quranPageImageView;

@end
