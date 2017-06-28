//
//  PayService.m
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//

#import "PayService.h"

extern "C" void _Pay(const char* product_id, const char* account_id) {
    [[PayService instance] pay:[NSString stringWithCString:product_id encoding:NSASCIIStringEncoding]
                        account_id:[NSString stringWithCString:account_id encoding:NSASCIIStringEncoding]];
}

static PayService* instance_ = nil;

@interface PayService ()
@end

@implementation PayService

// get instance
+ (PayService*)instance {
    if (!instance_) {
        instance_ = [[self alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:instance_];
    }
    return instance_;
}

- (void)requestProductData:(NSString *)product_id{
    NSSet *nsset = [NSSet setWithObject:product_id];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"receive product request");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"no product");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"count:%d",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        p = pro;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"request pay");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"request failed:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"reqeust finish");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                NSLog(@"transaction purchased");
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"transaction purchasing");
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:tran];
                NSLog(@"transaction restored");
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                NSLog(@"transaction failed");
                break;
            default:
                break;
        }
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
}

-(void)recordTransaction:(NSString *)product{
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"transaction finish");
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        NSLog(@"transaction complete receipt is nil");
        return;
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) {
        NSLog(@"transaction complete receipt is nil");
        return;
    }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"transaction complete connection failed");
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) { NSLog(@"transaction complete jsonResponse nill"); }
                                   /* ... Send a response back to the device ... */
                                   //Parse the Response
                                   NSLog(@"%@",jsonResponse);
                                   if([jsonResponse[@"status"] intValue]==0){
                                      [self OnSendMessage:@"success"];
                                   }else{
                                      [self OnSendMessage:@"failed"];
                                   }
                               }
                           }];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// pay
- (void)pay:(NSString*)product_id account_id:(NSString *)account_id {
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:product_id];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp"
                                                        message:@"不允许程序内付费"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
   
}

// on send message
- (void)OnSendMessage:(NSString*)message {
    UnitySendMessage([@"Panel_Home(Clone)" cStringUsingEncoding:NSASCIIStringEncoding],
                     [@"PayCallback" cStringUsingEncoding:NSASCIIStringEncoding],
                     [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end