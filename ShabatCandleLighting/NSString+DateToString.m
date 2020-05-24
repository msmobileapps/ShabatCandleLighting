//
//  NSString+DateToString.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 20/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "NSString+DateToString.h"

@implementation NSString (DateToString)

-(NSDate *)getDateFromString {
    __block NSDate *detectedDate;

    //Detect.
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
    [detector enumerateMatchesInString:self
                               options:kNilOptions
                                 range:NSMakeRange(0, [self length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        detectedDate = result.date;
    }];
    return detectedDate;
}

@end
