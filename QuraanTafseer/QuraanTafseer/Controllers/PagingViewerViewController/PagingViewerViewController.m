//
//  PagingViewerViewController.m
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "PagingViewerViewController.h"

@interface PagingViewerViewController ()

@end

@implementation PagingViewerViewController


@synthesize pagingController, currentPageIndex;

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
    //create options of UIPageController
	NSDictionary *options = [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pagingController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    [[pagingController view] setFrame:[[self view] bounds]];
    
    QuranPageViewController *pageToBeDisplayed = [self.storyboard instantiateViewControllerWithIdentifier:@"QuranPage"];
    pageToBeDisplayed.pageIndex = currentPageIndex;
    
    [self.pagingController setViewControllers:[NSArray arrayWithObject:pageToBeDisplayed] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    self.pagingController.dataSource = self;
    self.pagingController.delegate = self;
    
    [self addChildViewController:pagingController];
    [self.view addSubview:pagingController.view];
    [pagingController didMoveToParentViewController:self];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource
#pragma mark -

//Here i get the page 'after' not before. becaue it is Arabic
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
 
    //check if i have reached the last page
    if (currentPageIndex == PAGES_COUNT) {
        return nil;
    }
    
    currentPageIndex ++;
    //get new page from storyBoard
    QuranPageViewController *pageToBeDisplayed = [self.storyboard instantiateViewControllerWithIdentifier:@"QuranPage"];
    pageToBeDisplayed.pageIndex = currentPageIndex;
    
    return pageToBeDisplayed;

}

//Here i get the page 'before' not After. becaue it is Arabic
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (currentPageIndex == 1) { //check if i have reached the first page
        return nil;
    }
    currentPageIndex--;
    //get new page from storyBoard
    QuranPageViewController *pageToBeDisplayed = [self.storyboard instantiateViewControllerWithIdentifier:@"QuranPage"];
    pageToBeDisplayed.pageIndex = currentPageIndex;
    
    return pageToBeDisplayed;
}

#pragma mark -
#pragma mark UIPageViewControllerDelegate
#pragma mark -

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
