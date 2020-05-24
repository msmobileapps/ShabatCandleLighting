 //
//  ShabatItem.h
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShabatItem : NSObject

@property(strong) NSString *originalTitle;
@property(strong) NSString *category;
@property(strong) NSString *hebrewTitle;
@property(strong) NSString *date;
@property(strong) NSString *country;


-(id)initWithOriginalItem: (NSString *) originalTitle
                 category: (NSString *) category
              hebrewTitle: (NSString *) hebrewTitle
                     date: (NSString *) date
                  country: (NSString *) country;

-(NSString *) description;

@end

NS_ASSUME_NONNULL_END
