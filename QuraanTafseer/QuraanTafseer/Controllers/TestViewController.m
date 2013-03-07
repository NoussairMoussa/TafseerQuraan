//
//  TestViewController.m
//  QuraanTafseer
//
//  Created by Hossam on 3/7/13.
//  Copyright (c) 2013 Hossam. All rights reserved.
//

#import "TestViewController.h"


@interface TestViewController ()

@end

@implementation TestViewController

NSMutableArray *ayat;

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
    
	NSString *aya1 = @"الم(١)";
    NSString *aya2 = @"ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِلْمُتَّقِينَ ()";
    NSString *aya3 = @"الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ(٣)";
    NSString *aya4 = @"اوَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ(٤)";
    NSString *aya5 = @"أُولَٰئِكَ عَلَىٰ هُدًى مِنْ رَبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ(٥)";
    NSString *aya6 = @"اإِنَّ الَّذِينَ كَفَرُوا سَوَاءٌ عَلَيْهِمْ أَأَنْذَرْتَهُمْ أَمْ لَمْ تُنْذِرْهُمْ لَا يُؤْمِنُونَ(٦)";
    NSString *aya7 = @"خَتَمَ اللَّهُ عَلَىٰ قُلُوبِهِمْ وَعَلَىٰ سَمْعِهِمْ ۖ وَعَلَىٰ أَبْصَارِهِمْ غِشَاوَةٌ ۖ وَلَهُمْ عَذَابٌ عَظِيمٌ(٧)";
    NSString *aya8 = @"وَمِنَ النَّاسِ مَنْ يَقُولُ آمَنَّا بِاللَّهِ وَبِالْيَوْمِ الْآخِرِ وَمَا هُمْ بِمُؤْمِنِينَ(٨)";
    
    ayat = [NSMutableArray arrayWithObjects:aya1, aya2, aya3, aya4, aya5, aya6, aya7, aya8, nil];
    
    self.quranLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.quranLabel.numberOfLines = 0;
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor blackColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    self.quranLabel.linkAttributes = mutableActiveLinkAttributes;
    self.quranLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.quranLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
     self.quranLabel.delegate = self;
    
    
    
    NSRange r; r.location = 0; r.length = 0;
    [self updateQuranTextWithColoredTextInRange:r];
    
    
}


- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@", url];
    int ayaNo = [str integerValue];

    NSRange range;
    range.length = ((NSString *)[ayat objectAtIndex:ayaNo]).length;
    
    int prev = 0;
    for (int i = 0; i < ayaNo; i++) {
        prev += ((NSString *)[ayat objectAtIndex:i]).length;
    }
    
    range.location = prev;
    
    [self updateQuranTextWithColoredTextInRange:range];
    
    NSLog(@"%@", url);
}


-(void) updateQuranTextWithColoredTextInRange:(NSRange)redRange
{
    
    NSString *all = @"";
    
    for (NSString *str in ayat) {
        all  = [all stringByAppendingString:str];
        
    }
    
    [self.quranLabel setText:all afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        UIFont *font = [UIFont fontWithName:@"KFGQPC Uthmanic Script HAFS" size:20];
        NSRange range;
        range.location = 0;
        range.length = all.length;
        
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        if (fontRef) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            [mutableAttributedString replaceCharactersInRange:range withString:[[mutableAttributedString string] substringWithRange:range]];
         
            
        
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:redRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor redColor].CGColor range:redRange];
            [mutableAttributedString replaceCharactersInRange:redRange withString:[[mutableAttributedString string] substringWithRange:redRange]];
            CFRelease(fontRef);
        }
        
        
        return mutableAttributedString;
    }];
    
    
    
    
    
    int i = 0;
    int prevLengh = 0;
    for (NSString *aya in ayat) {
        
        NSRange r;
        r.location = prevLengh;
        r.length = aya.length;
        
        prevLengh += aya.length;
        
        [self.quranLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%d", i]] withRange:r];
        i++;
    }
    self.quranLabel.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQuranLabel:nil];
    [super viewDidUnload];
}
@end
