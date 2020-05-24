//
//  ItemsService.h
//  ShabatCandleLighting
//
//  Created by Nikita Koniukh on 19/05/2020.
//  Copyright © 2020 Nikita Koniukh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShabatItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface ItemsService : NSObject

typedef void(^completionSuccess)(ShabatItem*);
typedef void(^completionFailure)(NSError*);

-(void) fetchItemsWithUrlString:(NSString*) urlString success:(completionSuccess)success failure:(completionFailure)failure;

@end

NS_ASSUME_NONNULL_END
