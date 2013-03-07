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

//take the Juz number 7 and return corresponding section 
-(int)getSectionOfJuz:(int) juz
{
    int section = 0;
    switch (juz) {
        case 1:
            section = 0;
            break;
        case 3:
            section = 1;
            break;
        case 4:
            section = 2;
            break;
        default:
            section = juz - 3;
            break;
    }
    return section;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [NSMutableArray array];
    //for loop over sections
    for (int i = 0; i < 28; i++) {
        int juz = [self getJuzOfSection:i];
        NSString *indexTitle = [NSString stringWithFormat:@" %d", juz];
        [titles addObject:indexTitle];
    }
    
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    
    return titles;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
 
    return index;
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
    cell.textLabel.font = [UIFont fontWithName:@"KFGQPC Uthmanic Script HAFS" size:33];
    ArabicConverter *converter = [[ArabicConverter alloc] init];
    
	NSString* convertedString = [converter convertArabic:[NSString stringWithFormat:@"%@  ١ %d", currentSura.suraName, currentSura.suraNumber]];
    
    NSString *str =[NSString stringWithFormat:@"%@  ١", currentSura.suraName];
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
