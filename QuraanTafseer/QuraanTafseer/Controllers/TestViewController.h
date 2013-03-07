//
//  TestViewController.h
//  QuraanTafseer
//
//  Created by Hossam on 3/7/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@interface TestViewController : UIViewController <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *quranLabel;

@end
