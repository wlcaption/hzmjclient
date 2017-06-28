//
//  PayService.h
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h> 

@interface PayService : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate> {
}

// get instance
+ (PayService*)instance;

// pay
- (void)pay:(NSString*)product_id account_id:(NSString*)account_id;

@end
