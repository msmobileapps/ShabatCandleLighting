//
//  CountriesListViewController.h
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 20/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShabatCandleLighting-Swift.h"

NS_ASSUME_NONNULL_BEGIN


@interface CountriesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *countryNames;
@property (nonatomic, strong) NSMutableArray *filteredCountryNames;

@property (nonatomic, strong) NSMutableArray *countryNamesHe;
@property (nonatomic, strong) NSMutableArray *filteredCountryNamesHe;
@property BOOL isFiltered;

@property (nonatomic, strong) NSString * deviceLanguage;
@property (nonatomic, strong) Constants *constants;


@end

NS_ASSUME_NONNULL_END
