//
//  UIImage+CornerRadius.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImageView (CornerRadius)
- (void) setCornerRadiusforImage {
    self.layer.cornerRadius = 8;
}
@end
