//
//  QuranPageViewController.m
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "QuranPageViewController.h"

@interface QuranPageViewController ()

@end

@implementation QuranPageViewController
@synthesize pageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   //get image from bundle and set it
    [self.quranPageImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png", pageIndex]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuranPageImageView:nil];
    [super viewDidUnload];
}
@end
