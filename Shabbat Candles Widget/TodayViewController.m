//
//  TodayViewController.m
//  Shabbat Candles Widget
//
//  Created by Nikita Koniukh on 24/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NSString+DateToString.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceLanguage = [[NSLocale preferredLanguages] firstObject];
    [self setHiddenLabels];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self setupView];

    [self setupImagesForLanguageDirection];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ShabbatCandles"];
    NSString *savedCity = [userDefaults stringForKey:@"slectedCityKey"];

    NSString *urlString = [NSString stringWithFormat: @"https://www.hebcal.com/shabbat/?cfg=json&geonameid=%@&lg=h&leyning=off", savedCity];

    [self fetchItemsWithUrlString:urlString success:^(ShabatItem *itemResult) {
        [self setNotHidenLabels];
        if ([itemResult.category isEqual: @"candles"]) {
            self.titleLabel.text = itemResult.hebrewTitle;
            self.timeLabel.text = [self getTimeFromString:itemResult.date];
            self.dateLabel.text = [self getDateFromString:itemResult.date];
            completionHandler(NCUpdateResultNewData);
        }

    } failure:^(NSError *error) {
        completionHandler(NCUpdateResultFailed);
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}


-(void)setupView {
    self.titleLabel.textColor = UIColor.whiteColor;
    self.timeLabel.textColor = UIColor.whiteColor;
    self.dateLabel.textColor = UIColor.whiteColor;
}

-(void)fetchItemsWithUrlString:(NSString*) urlString success:(completionSuccess)success failure:(completionFailure)failure {
    NSURL *url = [NSURL URLWithString:urlString];

    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            failure(error);
            return;
        }

        NSMutableArray<ShabatItem *> *shabatItems = NSMutableArray.new;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        NSArray *itemsDictionary = [result valueForKeyPath:@"items"];
        NSDictionary *locationDictionary = [result valueForKeyPath:@"location"];
        NSString *city = locationDictionary[@"city"];

        for (NSDictionary *item in itemsDictionary) {
            NSString *titleOriginal = item[@"title_orig"];
            NSString *category = item[@"category"];
            NSString *titleHebrew = item[@"hebrew"];
            NSString *date = item[@"date"];

            ShabatItem *shabatItem = ShabatItem.new;
            shabatItem.originalTitle = titleOriginal;
            shabatItem.category = category;
            shabatItem.hebrewTitle = titleHebrew;
            shabatItem.date = date;
            shabatItem.country = city;

            [shabatItems addObject:shabatItem];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                success(shabatItem);
            });
        }
    }] resume];
}

-(NSString*)getDateFromString:(NSString*) dateString {
    NSDate *date = [dateString getDateFromString];

    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    [dateFormatter setDateFormat:@"EEEE, dd MMM yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

-(NSString*)getTimeFromString:(NSString*) dateString {
    NSString *stringWithoutLocale = [dateString substringToIndex:[dateString length] - 6];
    NSDate *date = [stringWithoutLocale getDateFromString];
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    [dateFormatter setDateFormat: @"hh:mm a"];
    NSString *stringTime = [dateFormatter stringFromDate:date];
    return stringTime;
}

-(void)setHiddenLabels {
    self.titleLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.dateLabel.hidden = YES;
}

-(void)setNotHidenLabels {
    self.titleLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.dateLabel.hidden = NO;
}


-(void)setupImagesForLanguageDirection {
    if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
        self.backgroundImage.image = [UIImage imageNamed:@"candles_background_widget"];
    } else {
        self.backgroundImage.image = [UIImage imageNamed:@"candlecWidgetLTR"];

    }
}

@end
