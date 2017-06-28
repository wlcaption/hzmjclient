//
//  PayService.m
//  Unity-iPhone
//
//  Created by wangyan on 17/6/8.
//
//

#import "WeiPayService.h"
#import "AFNetworking.h"
#import "JSONKit.h"

extern "C" void _WeiPay(const char* product_id, const char* account_id) {
    [[WeiPayService instance] pay:[NSString stringWithCString:product_id encoding:NSASCIIStringEncoding]
                        account_id:[NSString stringWithCString:account_id encoding:NSASCIIStringEncoding]];
}

static WeiPayService* instance_ = nil;

@interface WeiPayService ()
@end

@implementation WeiPayService

// get instance
+ (WeiPayService*)instance {
    if (!instance_) {
        instance_ = [[self alloc] init];
        [WXApi registerApp:@"wxa8fd7582c564fa94" enableMTA:false];
    }
    return instance_;
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [self OnSendMessage:@"success"];
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [self OnSendMessage:@"failed"];
                break;
        }
    }
}

-(void) onReq:(BaseReq*)req {
}

-(void)njmjWeChatPay:(NSDictionary *)payinfo{
    // NSLog(@"payinfo=%@",payinfo);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //第一个参数:请求路径(NSString) (URL地址后面无需添加参数)
    //第二个参数:要发送给服务器的参数 (传NSDictionary)
    //第三个参数:progress 进度回调
    //第四个参数:success 成功的回调
    //responseObject:响应体(内部默认已经做了JSON的反序列处理)
    //task.response:响应头信息
    //第五个参数:failure 失败的回调
    [manager GET:@"http://123.206.82.232/hola_sdk_server/pay/create_order.php" parameters:payinfo progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];//服务器返回数据
         if(result != nil){
             NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
             
             if(dict != nil){
                 PayReq *request = [[PayReq alloc] init];
                 
                 request.openID = [dict objectForKey:@"appid"];
                 request.partnerId = [dict objectForKey:@"partnerid"];
                 /** 预支付订单 */
                 request.prepayId= [dict objectForKey:@"prepayid"];
                 /** 商家根据财付通文档填写的数据和签名 */
                 request.package = [dict objectForKey:@"package"];
                 /** 随机串，防重发 */
                 request.nonceStr= [dict objectForKey:@"noncestr"];
                 /** 时间戳，防重发 */
                 NSMutableString * timestamp = [dict objectForKey:@"timestamp"];
                 request.timeStamp= timestamp.intValue;
                 /** 商家根据微信开放平台文档对数据做的签名 */
                 request.sign= [dict objectForKey:@"sign"];
                 BOOL ret = [WXApi sendReq: request];
                 NSLog(@"WXApi sendReq ret = %d", ret);
                 /*! @brief 发送请求到微信，等待微信返回onResp
                  *
                  * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
                  * SendAuthReq、SendMessageToWXReq、PayReq等。
                  * @param req 具体的发送请求，在调用函数后，请自己释放。
                  * @return 成功返回YES，失败返回NO。
                  */
             }else{
                 
             }
             
         }else{
             
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"请求失败--%@",error);
     }];
}

// pay
- (void)pay:(NSString*)product_id account_id:(NSString *)account_id {
    NSArray *listItems = [product_id componentsSeparatedByString:@"_"];
    NSString *a0 = listItems[0];
    NSString *a1 = listItems[1];
    NSString *a2 = listItems[2];
    NSString *a3 = listItems[3];
    NSString *s1 = @"-";
    NSLog(@"a1=%@",a0);
    NSLog(@"a2=%@",a1);
    NSLog(@"a3=%@",a2);
    NSLog(@"a4=%@",a3);
    
    NSMutableString *extension = [NSMutableString string];
    [extension appendString:a2];
    [extension appendString:s1];
    [extension appendString:a1];
    [extension appendString:s1];
    [extension appendString:a3];
    [extension appendString:s1];
    [extension appendString:a0];
    NSLog(@"extension=%@",extension);
    
    NSDictionary *dict = @{
                           @"amount" : a0,
                           @"product_name" : @"钻石",
                           @"channel" : @"wechatpay",
                           @"notify_uri" : @"http://123.206.82.232/hola_sdk_server/pay/trade_notify.php",
                           @"platform" : @"IOS",
                           @"game_name" : @"10004",
                           @"attach" : extension //这里分别是那几个字段分别是： 玩家id 服务器名称 支付类型 发放的钻石
                           };
    [self njmjWeChatPay:dict];
   
}

// on send message
- (void)OnSendMessage:(NSString*)message {
    UnitySendMessage([@"Panel_Home(Clone)" cStringUsingEncoding:NSASCIIStringEncoding],
                     [@"PayCallback" cStringUsingEncoding:NSASCIIStringEncoding],
                     [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end