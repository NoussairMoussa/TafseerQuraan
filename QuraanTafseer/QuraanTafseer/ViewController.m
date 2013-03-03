//
//  ViewController.m
//  QuraanTafseer
//
//  Created by Hossam on 3/3/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    TafseerDBManager *manager = [[TafseerDBManager alloc] init];
    NSMutableArray *tafseers = [manager getTafseerForSurahNo:113];
    
    for (Tafseer *tafseer in tafseers) {
       
        [self.textView setText:[NSString stringWithFormat:@"%@ \n %@", self.textView.text, tafseer.text ]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
