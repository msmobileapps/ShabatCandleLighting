//
//  TodayViewController.h
//  Shabbat Candles Widget
//
//  Created by Nikita Koniukh on 24/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShabatItem.h"


@interface TodayViewController : UIViewController

typedef void(^completionSuccess)(ShabatItem*);
typedef void(^completionFailure)(NSError*);

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) NSString * deviceLanguage;



@end
