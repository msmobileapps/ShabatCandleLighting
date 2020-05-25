//
//  CountriesListViewController.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 20/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "CountriesListViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface CountriesListViewController ()

@end

@implementation CountriesListViewController

//Constants *constants;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.deviceLanguage = [[NSLocale preferredLanguages] firstObject];
    self.constants = Constants.new;

    [self loadCitiesListFromTxtFile];
    [self loadCitiesHeListFromTxtFile];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;

    self.filteredCountryNames = [[NSMutableArray alloc]init];
}

-(void)loadCitiesHeListFromTxtFile {
    self.countryNamesHe = [[NSMutableArray alloc] init];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"cities_he" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString* item in listArray) {
        [self.countryNamesHe addObject:item];
    }
}

-(void)loadCitiesListFromTxtFile {
    self.countryNames = [[NSMutableArray alloc] init];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString* item in listArray) {
        [self.countryNames addObject:item];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isFiltered = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [self.filteredCountryNames removeAllObjects];
        self.isFiltered = NO;
    } else {
        [self.filteredCountryNames removeAllObjects];

        if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
            for (NSString *country in self.countryNamesHe) {
                NSRange range = [country rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    self.isFiltered = YES;
                    [self.filteredCountryNames addObject:country];
                }
            }
        } else {
            for (NSString *country in self.countryNames) {
                NSRange range = [country rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    self.isFiltered = YES;
                    [self.filteredCountryNames addObject:country];
                }
            }
        }

    }
    [self.tableView reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"countriesSelectionCellId" forIndexPath:indexPath];
    NSString *city;

    if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
        if (self.isFiltered) {
            city = self.filteredCountryNames[indexPath.row];
        } else {
            city = self.countryNamesHe[indexPath.row];
        }
        city = [self removeNumbersFromString:city];
        cell.textLabel.text = city;
    } else {
        if (self.isFiltered) {
            city = self.filteredCountryNames[indexPath.row];
        } else {
            city = self.countryNames[indexPath.row];
        }
        city = [self removeNumbersFromString:city];
        cell.textLabel.text = city;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isFiltered)
    {
        return self.filteredCountryNames.count;
    }
    return self.countryNames.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *city;
    if (self.isFiltered) {
        city = self.filteredCountryNames[indexPath.row];
    } else {
        if ([self.deviceLanguage isEqualToString:@"he-IL"]) {
            city = self.countryNamesHe[indexPath.row];
        } else {
            city = self.countryNames[indexPath.row];
        }
    }

    NSString *cityStringWithoutGaps = [self getGeonameid:city];
    // save choosen city to user defaults
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.ShabbatCandles"];
    [userDefaults setObject:cityStringWithoutGaps forKey:@"slectedCityKey"];
    [userDefaults setObject:[self getHebrewCityName:city] forKey:@"slectedCityNameKey"];
    [userDefaults synchronize];
    // dissmiss slide menu
    [self.revealViewController rightRevealToggleAnimated:YES];
    // notify that city was choosen
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:cityStringWithoutGaps forKey:self.constants.NOTIF_CHOSEN_CITY_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     self.constants.NOTIF_CITY_NAME_WAS_CHOOSEN object:nil userInfo:userInfo];

    // deselect cell
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = @"";
    self.isFiltered = NO;
    [self.filteredCountryNames removeAllObjects];
    [self.tableView reloadData];
}

//-(NSString*)removeGapsFromString: (NSString*) cityString {
//    return [cityString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//}

-(NSString*)removeNumbersFromString: (NSString*) cityString {
    NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"1234567890|"];
    NSString *result = [[cityString componentsSeparatedByCharactersInSet:trim] componentsJoinedByString:@""];
    return result;
}

-(NSString*)getGeonameid: (NSString*) cityString {
    NSArray* spliteArray = [cityString componentsSeparatedByString: @"|"];
    return [spliteArray lastObject];
}

-(NSString*)getHebrewCityName: (NSString*) cityString {
    NSArray* spliteArray = [cityString componentsSeparatedByString: @"|"];
    return [spliteArray firstObject];
}

@end
