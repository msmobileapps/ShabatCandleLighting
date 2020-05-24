//
//  ShabatItem.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "ShabatItem.h"

@implementation ShabatItem
-(id) initWithOriginalItem: (NSString *)originalTitle
                  category: (NSString *) category
               hebrewTitle: (NSString *) hebrewTitle
                      date: (NSString *) date
                   country: (NSString *) country {

    self = [super init];

    self.originalTitle = originalTitle;
    self.category = category;
    self.hebrewTitle = hebrewTitle;
    self.date = date;
    self.country = country;
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.originalTitle, self.category, self.hebrewTitle, self.date, self.country];
}
@end
