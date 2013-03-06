//
//  QuranChaptersViewController.m
//  QuraanTafseer
//
//  Created by Hossam on 3/4/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "QuranChaptersViewController.h"

@interface QuranChaptersViewController ()

@end

@implementation QuranChaptersViewController


NSMutableArray *allChapters;
NSMutableArray *quranPartitions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark-
#pragma mark UITableViewDataSource
#pragma mark-

//take the section number 0...27 and return corresponding juz2 of this section
-(int)getJuzOfSection:(int) section
{
    int juz = 0;
    switch (section) {
        case 0:
            juz = 1;
            break;
        case 1:
            juz = 3;
            break;
        case 2:
            juz = 4;
            break;
        default:
            juz = section + 3;
            break;
    }
    return juz;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 28;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int juz = [self getJuzOfSection:section];
    return [NSString stringWithFormat:@"Juz' %d", juz];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int juz = [self getJuzOfSection:section];
    NSArray *chaptersInJuz  = [allChapters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.juz == %d", juz]];
    
    return chaptersInJuz.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    int juz = [self getJuzOfSection:indexPath.section];
    NSArray *chaptersInJuz  = [allChapters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.juz == %d", juz]];
    
    Sura *currentSura = [chaptersInJuz objectAtIndex:indexPath.row];
    //B Elham, Diwani Letter
    cell.textLabel.font = [UIFont fontWithName:@"Diwani Letter" size:33];
    ArabicConverter *converter = [[ArabicConverter alloc] init];
    
	NSString* convertedString = [converter convertArabic:currentSura.suraName];
    cell.textLabel.text = convertedString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}
#pragma mark-
#pragma mark UITableViewDelegate
#pragma mark-

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark-
#pragma mark LifeCycle
#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.###"];
    NSNumber *n = [NSNumber numberWithFloat:12.50];
    NSLog(@"%@", [fmt stringFromNumber:n]);
    
	SuraDBManager *suraManager = [[SuraDBManager alloc] init];
    allChapters = [suraManager readRecords];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int pageIndex = 5;
    PagingViewerViewController *pagingViewer = (PagingViewerViewController *)segue.destinationViewController;
    pagingViewer.currentPageIndex = pageIndex;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
