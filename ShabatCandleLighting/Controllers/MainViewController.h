//
//  ViewController.h
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 18/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIView_CardView.h"
#import "UIImage+CornerRadius.h"
#import "CountriesListViewController.h"
#import "ShabatCandleLighting-Swift.h"

@interface MainViewController : UIViewController
// Outlets:
@property (strong, nonatomic) IBOutlet UIView *shaabbatStartContainerView;
@property (strong, nonatomic) IBOutlet UIView *parachatContainer;
@property (strong, nonatomic) IBOutlet UIView *avdalahContainer;
@property (strong, nonatomic) IBOutlet UIImageView *shabbatStartImage;
@property (strong, nonatomic) IBOutlet UIImageView *parashatImage;
@property (strong, nonatomic) IBOutlet UIImageView *avdalahImage;


@property (strong, nonatomic) IBOutlet UILabel *candlesTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *parashatTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *avdalahTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *candlesTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *avdalaTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *candlesDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *parashatDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *avdalahDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectCityButton;

@property (strong, nonatomic) IBOutlet UIView *parashatWrapperContainer;



@property (nonatomic, strong) CountriesListViewController *countryPicker;

@property NSString *cityName;
@property BOOL isCountryListShowed;
@property (nonatomic, strong) NSString * deviceLanguage;

@property (nonatomic, strong) Constants *constants;



@end

