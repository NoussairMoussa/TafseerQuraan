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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CHAPTERS_COUNT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    Sura *currentSura = [allChapters objectAtIndex:indexPath.row];
    cell.textLabel.text = currentSura.suraName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}
#pragma mark-
#pragma mark UITableViewDelegate
#pragma mark-

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

#pragma mark-
#pragma mark LifeCycle
#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
	SuraDBManager *suraManager = [[SuraDBManager alloc] init];
    allChapters = [suraManager readRecords];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
