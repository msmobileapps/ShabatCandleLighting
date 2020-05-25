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
#import <SafariServices/SafariServices.h>


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceLanguage = [[NSLocale preferredLanguages] firstObject];
    [self setHidenLabels];
    [self setupView];
    [self setupRevealVC];
    
    self.constants = Constants.new;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCityNameFromSlideMenu:)
                                                 name: self.constants.NOTIF_CITY_NAME_WAS_CHOOSEN object:nil];
}

- (void)getCityNameFromSlideMenu:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSString *chosenCityId = [userInfo objectForKey:self.constants.NOTIF_CHOSEN_CITY_KEY];
    [self fetchDataWithCityId:chosenCityId];
}

-(void)fetchDataWithCityId: (NSString *) cityId {
    ItemsService *servise = ItemsService.new;
    NSString *urlString = [NSString stringWithFormat: @"https://www.hebcal.com/shabbat/?cfg=json&geonameid=%@&lg=h&leyning=off", cityId];
    
    [servise fetchItemsWithUrlString:urlString success:^(ShabatItem * itemResult) {
        [self setNotHiddenLabels];
        
        // get saved city name
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName: self.constants.USER_DEF_GROUP_KEY];
        NSString *savedCity = [userDefaults objectForKey:@"slectedCityNameKey"];
        self.currentCityLabel.text = savedCity;
        
        if ([itemResult.category isEqual: @"candles"]) {
            self.candlesTitleLabel.text = [self.deviceLanguage isEqualToString:@"he-IL"] ? itemResult.hebrewTitle : itemResult.originalTitle;
            self.candlesTimeLabel.text = [self getTimeFromString:itemResult.date];
            self.candlesDateLabel.text = [self getDateFromString:itemResult.date];
        } else if ([itemResult.category isEqual: @"parashat"] || [itemResult.category isEqual: @"holiday"]) {
            self.parashatTitleLabel.text = [self.deviceLanguage isEqualToString:@"he-IL"] ? itemResult.hebrewTitle : itemResult.originalTitle;
            self.parashatDateLabel.text = [self getDateFromString:itemResult.date];
        } else if ([itemResult.category isEqual: @"havdalah"]) {
            self.avdalahTitleLabel.text = [self.deviceLanguage isEqualToString:@"he-IL"] ? itemResult.hebrewTitle : itemResult.originalTitle;
            self.avdalahDateLabel.text = [self getDateFromString:itemResult.date];
            self.avdalaTimeLabel.text = [self getTimeFromString:itemResult.date];
        }
    } failure:^(NSError * error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
}


-(void)setupView {
    [self setupImagesForLanguageDirection];
    [self.shaabbatStartContainerView addCardViewForContainer];
    [self.parachatContainer addCardViewForContainer];
    [self.avdalahContainer addCardViewForContainer];
    [self.shabbatStartImage setCornerRadiusforImage];
    [self.parashatImage setCornerRadiusforImage];
    [self.avdalahImage setCornerRadiusforImage];
    self.isCountryListShowed = NO;
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ShabbatCandles"];
    NSString *savedCity = [userDefaults objectForKey:@"slectedCityKey"];
    if (savedCity == nil) {
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
            revealViewController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyViewController"];
            [revealViewController rightRevealToggleAnimated:YES];
            [revealViewController setFrontViewController:self];
        } else {
            [self.revealViewController revealToggleAnimated:YES];
            [self.revealViewController setFrontViewController:self];
        }
    } else {
        [self fetchDataWithCityId:savedCity];
    }
}

-(NSString*)getDateFromString:(NSString*) dateString {
    NSDate *date = [dateString getDateFromString];
    
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:self.deviceLanguage];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"EEEE, dd MMM yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

-(NSString*)getTimeFromString:(NSString*) dateString {
    NSString *stringWithoutLocale = [dateString substringToIndex:[dateString length] - 6];
    NSDate *date = [stringWithoutLocale getDateFromString];
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:self.deviceLanguage];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat: @"hh:mm a"];
    NSString *stringTime = [dateFormatter stringFromDate:date];
    return stringTime;
}

- (IBAction)goToMSAppsWebPage:(UIButton *)sender {
    NSURL *url = [[NSURL alloc]initWithString:@"https://msapps.mobi/#about-us"];
    SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:sfvc animated:YES completion:nil];
}

-(void) setHidenLabels {
    self.candlesTitleLabel.hidden = YES;
    self.parashatTitleLabel.hidden = YES;
    self.avdalahTitleLabel.hidden = YES;
    self.candlesTimeLabel.hidden = YES;
    self.avdalaTimeLabel.hidden = YES;
    self.candlesDateLabel.hidden = YES;
    self.parashatDateLabel.hidden = YES;
    self.avdalahDateLabel.hidden = YES;
    self.currentCityLabel.hidden = YES;
}

-(void) setNotHiddenLabels {
    self.candlesTitleLabel.hidden = NO;
    self.parashatTitleLabel.hidden = NO;
    self.avdalahTitleLabel.hidden = NO;
    self.candlesTimeLabel.hidden = NO;
    self.avdalaTimeLabel.hidden = NO;
    self.candlesDateLabel.hidden = NO;
    self.parashatDateLabel.hidden = NO;
    self.avdalahDateLabel.hidden = NO;
    self.currentCityLabel.hidden = NO;
}

-(void)setupImagesForLanguageDirection {
    if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
        self.shabbatStartImage.image = [UIImage imageNamed:@"candles_background"];
        self.parashatImage.image = [UIImage imageNamed:@"parasha"];
        self.avdalahImage.image = [UIImage imageNamed:@"avdala"];
    } else {
        self.shabbatStartImage.image = [UIImage imageNamed:@"candlesLTR"];
        self.parashatImage.image = [UIImage imageNamed:@"parashaLTR"];
        self.avdalahImage.image = [UIImage imageNamed:@"avdalaLTR"];
    }
}

-(void)setupRevealVC {
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
            [self.selectCityButton addTarget:self.revealViewController action:@selector( rightRevealToggle: ) forControlEvents:UIControlEventTouchUpInside];
            [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
            self.revealViewController.rearViewRevealWidth = self.view.frame.size.width - 100;
            revealViewController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyViewController"];
        } else {
            [self.selectCityButton addTarget:self.revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
            [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
            self.revealViewController.rearViewRevealWidth = self.view.frame.size.width - 100;
        }
    }
}


@end
