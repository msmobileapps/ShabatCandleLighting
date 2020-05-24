//
//  MainViewController.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 18/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "MainViewController.h"
#import "ShabatItem.h"
#import "ItemsService.h"
#import "NSString+DateToString.h"
#import "SWRevealViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

    [self.selectCityButton addTarget:self.revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];


    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(getCityNameFromSlideMenu:)
        name:@"cityNameWasChoosen" object:nil];
}


- (void)getCityNameFromSlideMenu:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSString *chosenCityName = [userInfo objectForKey:@"cityNameFromSlideMenu"];
    [self fetchDataWithCityName:chosenCityName];
}

-(void)fetchDataWithCityName: (NSString *) cityName {
    ItemsService *servise = ItemsService.new;
    NSString *urlString = [NSString stringWithFormat: @"https://www.hebcal.com/shabbat/?cfg=json&city=%@&lg=h&leyning=off", cityName];

    [servise fetchItemsWithUrlString:urlString success:^(ShabatItem * itemResult) {
        self.currentCityLabel.text = itemResult.country;
        if ([itemResult.category isEqual: @"candles"]) {
            self.candlesTitleLabel.text = itemResult.hebrewTitle;
            self.candlesTimeLabel.text = [self getTimeFromString:itemResult.date];
            self.candlesDateLabel.text = [self getDateFromString:itemResult.date];
        } else if ([itemResult.category isEqual: @"parashat"]) {
            self.parashatTitleLabel.text = itemResult.hebrewTitle;
            self.parashatDateLabel.text = [self getDateFromString:itemResult.date];
        } else if ([itemResult.category isEqual: @"havdalah"]) {
            self.avdalahTitleLabel.text = itemResult.hebrewTitle;
            self.avdalahDateLabel.text = [self getDateFromString:itemResult.date];
            self.avdalaTimeLabel.text = [self getTimeFromString:itemResult.date];
        }
    } failure:^(NSError * error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];

}



-(void)setupView {
    [self.shaabbatStartContainerView addCardViewForContainer];
    [self.parachatContainer addCardViewForContainer];
    [self.avdalahContainer addCardViewForContainer];
    [self.shabbatStartImage setCornerRadiusforImage];
    [self.parashatImage setCornerRadiusforImage];
    [self.avdalahImage setCornerRadiusforImage];
    self.isCountryListShowed = NO;

    NSString *savedCity = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"slectedCityKey"];
    if (savedCity == nil) {
       [self.revealViewController revealToggleAnimated:YES];
       [self.revealViewController setFrontViewController:self];
    } else {
        [self fetchDataWithCityName:savedCity];
    }
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



@end
