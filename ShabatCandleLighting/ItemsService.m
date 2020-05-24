//
//  ItemsService.m
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import "ItemsService.h"

@implementation ItemsService

-(void)fetchItemsWithUrlString:(NSString*) urlString success:(completionSuccess)success failure:(completionFailure)failure {
    NSURL *url = [NSURL URLWithString:urlString];

    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            failure(error);
            return;
        }

        NSMutableArray<ShabatItem *> *shabatItems = NSMutableArray.new;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        NSArray *itemsDictionary = [result valueForKeyPath:@"items"];
        NSDictionary *locationDictionary = [result valueForKeyPath:@"location"];
        NSString *city = locationDictionary[@"city"];

        for (NSDictionary *item in itemsDictionary) {
            NSString *titleOriginal = item[@"title_orig"];
            NSString *category = item[@"category"];
            NSString *titleHebrew = item[@"hebrew"];
            NSString *date = item[@"date"];

            ShabatItem *shabatItem = ShabatItem.new;
            shabatItem.originalTitle = titleOriginal;
            shabatItem.category = category;
            shabatItem.hebrewTitle = titleHebrew;
            shabatItem.date = date;
            shabatItem.country = city;

            [shabatItems addObject:shabatItem];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                success(shabatItem);
            });
        }
    }] resume];
}

@end
