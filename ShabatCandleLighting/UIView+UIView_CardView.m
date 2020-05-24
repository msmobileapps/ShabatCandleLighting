//
//  UIView+UIView_CardView.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "UIView+UIView_CardView.h"

@implementation UIView (UIView_CardView)

- (void) addCardViewForContainer {
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(4, 4);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 4;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = NO;
    }
@end
