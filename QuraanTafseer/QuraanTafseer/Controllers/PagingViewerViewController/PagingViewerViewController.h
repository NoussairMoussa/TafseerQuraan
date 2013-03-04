//
//  PagingViewerViewController.h
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuranPageViewController.h"
#import "Constants.h"

@interface PagingViewerViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pagingController;
@property (nonatomic, assign) int currentPageIndex;

@end
