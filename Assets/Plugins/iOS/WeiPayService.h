//
//  PayService.h
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//
#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeiPayService : NSObject<WXApiDelegate> {
}

// get instance
+ (WeiPayService*)instance;

// pay
- (void)pay:(NSString*)product_id account_id:(NSString*)account_id;

@end
