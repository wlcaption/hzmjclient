//
//  ShareSDKUnity3DBridge.m
//  Unity-iPhone
//
//  Created by 陈 剑东 on 15/7/28.
//  Copyright (c) 2015年 mob. All rights reserved.
//

#import "ShareSDKUnity3DBridge.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKExtension/SSDKFriendsPaging.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKConfigFile/ShareSDK+XML.h>
#import <MOBFoundation/MOBFJson.h>
#import <MOBFoundation/MOBFRegex.h>
#import <MOBFoundation/MOBFDevice.h>

#import "WeiPayService.h"
#import "WXApi.h"

static UIView *_refView = nil;
#if defined (__cplusplus)
extern "C" {
#endif
    
    /**
     *	@brief	配置SDK并初始化
     *
     *	@param 	appKey      ShareSDK的AppKey
     *  @param  configInfo  配置信息
     */
    extern void __iosShareSDKRegisterAppAndSetPltformsConfig (void *appKey, void*configInfo);
    
    /**
     *  用户授权
     *
     *  @param reqID    流水号
     *  @param platType 平台类型
     *  @param observer 观察回调对象名称
     */
    extern void __iosShareSDKAuthorize (int reqID, int platType, void *observer);
    
    /**
     *	@brief	取消用户授权
     *
     *	@param 	platType 	平台类型
     */
    extern void __iosShareSDKCancelAuthorize (int platType);
    
    /**
     *	@brief	判断用户是否授权
     *
     *	@param 	platType 	平台类型
     *
     *	@return	YES 表示已经授权，NO 表示尚未授权
     */
    extern bool __iosShareSDKHasAuthorized (int platType);
    
    /**
     *	@brief	检测是否安装客户端
     *
     *	@param 	platType 	平台类型
     *
     *	@return	YES 表示已经安装，NO 表示尚未安装
     */
    extern bool __iosShareSDKIsClientInstalled (int platType);
    
    /**
     *	@brief	获取用户信息
     *
     *  @param  reqID       流水号
     *	@param 	platType 	平台类型
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKGetUserInfo (int reqID, int platType, void *observer);
    
    /**
     *	@brief	分享内容
     *
     *  @param  reqID       流水号
     *	@param 	platType 	平台类型
     *	@param 	content 	分享内容
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKShare (int reqID, int platType, void *content, void *observer);
    
    /**
     *	@brief	一键分享内容
     *
     *  @param  reqID       流水号
     *	@param 	platTypes 	平台类型列表
     *	@param 	content 	分享内容
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKOneKeyShare (int reqID, void *platTypes, void *content, void *observer);
    
    /**
     *	@brief	显示分享菜单
     *
     *  @param  reqID       流水号
     *	@param 	platTypes 	平台类型列表
     *	@param 	content 	分享内容
     *	@param 	x 	弹出菜单的箭头的横坐标，仅用于iPad
     *	@param 	y 	弹出菜单的箭头的纵坐标，仅用于iPad
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKShowShareMenu (int reqID, void *platTypes, void *content, int x, int y, void *observer);
    
    /**
     *	@brief	显示分享编辑界面
     *
     *  @param  reqID       流水号
     *	@param 	platType 	平台类型
     *	@param 	content 	分享内容
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKShowShareView (int reqID, int platType, void *content, void *observer);
    
    /**
     *  @brief 获取授权用户好友列表
     *
     *  @param reqID    流水号
     *  @param platType 平台类型
     *  @param count    单页好友数量
     *  @param page     页码/游标cusor
     *  @param observer 观察回调对象名称
     */
    extern void __iosShareSDKGetFriendsList (int reqID, int platType, int count , int page, void *observer);
    
    /**
     *	@brief	获取授权信息
     *
     *	@param 	platType 	平台类型
     *  @param  observer    观察回调对象名称
     */
    extern const char* __iosShareSDKGetCredential (int platType);
    
    /**
     *	@brief	关注/添加好友
     *
     *	@param 	platType 	平台类型
     *  @param  observer    观察回调对象名称
     */
    extern void __iosShareSDKFollowFriend (int reqID, int platType, void *account, void *observer);
    
    
    /**
     *  @brief  根据配置文件分享
     *
     *  @param reqID            流水号
     *  @param contentName      配置文件节点标识
     *  @param customHashtable  自定义字段表
     *  @param platType         平台类型
     *  @param observer         观察回调对象名称
     */
    extern void __iosShareSDKShareWithContentName(int reqID,
                                                  int platType,
                                                  void *contentName,
                                                  void *customHashtable,
                                                  void *observer);
    
    /**
     *  @brief  根据配置文件展示分享菜单
     *
     *  @param reqID            流水号
     *  @param contentName      配置文件节点标识
     *  @param customHashtable  自定义字段表
     *  @param 	platTypes 	平台类型列表
     *  @param 	x 	弹出菜单的箭头的横坐标，仅用于iPad
     *	@param 	y 	弹出菜单的箭头的纵坐标，仅用于iPad
     *  @param observer         观察回调对象名称
     */
    extern void __iosShareSDKShowShareMenuWithContentName(int reqID,
                                                          void *contentName,
                                                          void *customHashtable,
                                                          void *platTypes,
                                                          int x,
                                                          int y,
                                                          void *observer);
    
    /**
     *  @brief  根据配置文件展示分享编辑界面
     *
     *  @param reqID            流水号
     *  @param contentName      配置文件节点标识
     *  @param customHashtable  自定义字段表
     *  @param platType         平台类型
     *  @param observer         观察回调对象名称
     */
    extern void __iosShareSDKShowShareViewWithContentName(int reqID,
                                                          int platType,
                                                          void *contentName,
                                                          void *customHashtable,
                                                          void *observer);
    
#if defined (__cplusplus)
}
#endif


#if defined (__cplusplus)
extern "C" {
#endif
    
    NSMutableDictionary *__parseWithHashtable (void*configInfo)
    {
        NSString *confCs = [NSString stringWithCString:configInfo encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MOBFJson objectFromJSONString:confCs]];
        return dic;
    }
    
    SSDKPlatformType __convertContentType(NSInteger type)
    {
        switch (type)
        {
            case 0:
                return SSDKContentTypeAuto;
            case 1:
                return SSDKContentTypeText;
            case 2:
                return SSDKContentTypeImage;
            case 4:
                return SSDKContentTypeWebPage;
            case 5:
                return SSDKContentTypeAudio;
            case 6:
                return SSDKContentTypeVideo;
            case 7:
                return SSDKContentTypeApp;
            case 8:
                return SSDKContentTypeFile;
            case 9:
                return SSDKContentTypeImage;
            default:
                return SSDKContentTypeText;
        }
    }
    
    void __setWechatParams(NSDictionary *value,NSMutableDictionary *params,SSDKPlatformType subType)
    {
        NSString *text = nil;
        NSString *title = nil;
        NSString *url = nil;
        NSString *thumbImg = nil;
        NSString *image = nil;
        NSString *musicFileUrl = nil;
        NSString *extInfo = nil;
        NSData *fileData = nil;
        NSData *emoData = nil;
        NSString *sourceFileExtension = nil;
        NSData *sourceFileData = nil;
        
        SSDKContentType type = SSDKContentTypeText;
        
        if ([[value objectForKey:@"text"] isKindOfClass:[NSString class]])
        {
            text = [value objectForKey:@"text"];
        }
        if ([[value objectForKey:@"title"] isKindOfClass:[NSString class]])
        {
            title = [value objectForKey:@"title"];
        }
        if ([[value objectForKey:@"url"] isKindOfClass:[NSString class]])
        {
            url = [value objectForKey:@"url"];
        }
        if ([[value objectForKey:@"thumbImageUrl"] isKindOfClass:[NSString class]])
        {
            thumbImg = [value objectForKey:@"thumbImageUrl"];
        }
        if ([[value objectForKey:@"imageUrl"] isKindOfClass:[NSString class]])
        {
            image = [value objectForKey:@"imageUrl"];
        }
        if ([[value objectForKey:@"musicUrl"] isKindOfClass:[NSString class]])
        {
            musicFileUrl = [value objectForKey:@"musicUrl"];
        }
        if ([[value objectForKey:@"extInfoPath"] isKindOfClass:[NSString class]])
        {
            extInfo = [value objectForKey:@"extInfoPath"];
        }
        if ([[value objectForKey:@"filePath"] isKindOfClass:[NSString class]])
        {
            fileData = [NSData dataWithContentsOfFile:[value objectForKey:@"filePath"]];
        }
        if ([[value objectForKey:@"emotionPath"] isKindOfClass:[NSString class]])
        {
            emoData = [NSData dataWithContentsOfFile:[value objectForKey:@"emotionPath"]];
        }
        
        if ([[value objectForKey:@"sourceFileExtension"] isKindOfClass:[NSString class]])
        {
            sourceFileExtension = [value objectForKey:@"sourceFileExtension"];
        }
        if ([[value objectForKey:@"sourceFilePath"] isKindOfClass:[NSString class]])
        {
            sourceFileData = [NSData dataWithContentsOfFile:[value objectForKey:@"sourceFilePath"]];
        }
        
        if ([[value objectForKey:@"shareType"] isKindOfClass:[NSNumber class]])
        {
            type = __convertContentType([[value objectForKey:@"shareType"] integerValue]);
        }

        [params SSDKSetupWeChatParamsByText:text
                                      title:title
                                        url:[NSURL URLWithString:url]
                                 thumbImage:thumbImg
                                      image:image
                               musicFileURL:[NSURL URLWithString:musicFileUrl]
                                    extInfo:extInfo
                                   fileData:fileData
                               emoticonData:emoData
                        sourceFileExtension:sourceFileExtension
                             sourceFileData:sourceFileData
                                       type:type
                         forPlatformSubType:subType];
        
    }
    
    NSMutableDictionary *__getShareParamsWithString(NSString *dataStr)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSString *text = nil;
        NSString *title = nil;
        NSString *url = nil;
        SSDKContentType type = SSDKContentTypeText;
        
        NSDictionary *shareParamsDic = [MOBFJson objectFromJSONString:dataStr];

        if (shareParamsDic)
        {
            
            if ([[shareParamsDic objectForKey:@"text"] isKindOfClass:[NSString class]])
            {
                text = [shareParamsDic objectForKey:@"text"];
            }
            
            id img = [shareParamsDic objectForKey:@"imageUrl"];
            if ([img isKindOfClass:[NSString class]])
            {
                NSString *imgPath = img;
                SSDKImage *image = nil;
                if ([MOBFRegex isMatchedByRegex:@"\\w://.*"
                                        options:MOBFRegexOptionsNoOptions
                                        inRange:NSMakeRange(0, imgPath.length)
                                     withString:imgPath])
                {
                    image = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:imgPath]];
                }
                else
                {
                    UIImage *localImg = [UIImage imageWithContentsOfFile:imgPath];
                    image = [[SSDKImage alloc] initWithImage:localImg
                                                      format:SSDKImageFormatJpeg
                                                    settings:nil];
                }
                
                if (image)
                {
                   
                    [imageArray addObject:imgPath];
                }
                else
                {
                    NSLog(@"#waring : 检测不到有效图片路径,请检查传入图片的路径的有效性");
                }
            }
            else if([img isKindOfClass:[NSArray class]])
            {
                NSArray *paths = [img copy];
                for (NSString *path in paths)
                {
                    
                    SSDKImage *image = nil;
                    
                    if ([MOBFRegex isMatchedByRegex:@"\\w://.*"
                                            options:MOBFRegexOptionsNoOptions
                                            inRange:NSMakeRange(0, path.length)
                                         withString:path])
                    {
                        image = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:path]];
                    }
                    else
                    {
                        UIImage *localImg = [UIImage imageWithContentsOfFile:path];
                        image = [[SSDKImage alloc] initWithImage:localImg
                                                          format:SSDKImageFormatJpeg
                                                        settings:nil];
                    }
                    
                    if (image)
                    {
                        [imageArray addObject:path];
                    }
                    else
                    {
                        NSLog(@"#waring : 检测不到有效图片路径,请检查传入图片的路径的有效性");
                    }
                }
            }
            
            if ([[shareParamsDic objectForKey:@"title"] isKindOfClass:[NSString class]])
            {
                title = [shareParamsDic objectForKey:@"title"];
                
            }
            
            if ([[shareParamsDic objectForKey:@"url"] isKindOfClass:[NSString class]])
            {
                url = [shareParamsDic objectForKey:@"url"];
                
            }
            if ([[shareParamsDic objectForKey:@"shareType"] isKindOfClass:[NSNumber class]])
            {
                type = __convertContentType([[shareParamsDic objectForKey:@"shareType"] integerValue]);
            }
            
            if ([[shareParamsDic objectForKey:@"clientShare"] isKindOfClass:[NSNumber class]])
            {
                NSInteger enable = [[shareParamsDic objectForKey:@"clientShare"] integerValue];
                if (enable > 0)
                {
                    [params SSDKEnableUseClientShare];
                }
            }
                    
            
            [params SSDKSetupShareParamsByText:text
                                        images:imageArray
                                           url:[NSURL URLWithString:url]
                                         title:title
                                          type:type];
            
            
            NSDictionary *customizeShareParams = [shareParamsDic objectForKey:@"customizeShareParams"];
            
            if (customizeShareParams && [[customizeShareParams allKeys] count] > 0)
            {
                //微信系列
                id value = [MOBFJson objectFromJSONString:[customizeShareParams objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)SSDKPlatformSubTypeWechatSession]]];
                if ([value isKindOfClass:[NSDictionary class]])
                {
                    __setWechatParams(value,params,SSDKPlatformSubTypeWechatSession);
                }
                value = [MOBFJson objectFromJSONString:[customizeShareParams objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)SSDKPlatformSubTypeWechatTimeline]]];
                if ([value isKindOfClass:[NSDictionary class]])
                {
                    __setWechatParams(value,params,SSDKPlatformSubTypeWechatTimeline);
                }
                value = [MOBFJson objectFromJSONString:[customizeShareParams objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)SSDKPlatformSubTypeWechatFav]]];
                if ([value isKindOfClass:[NSDictionary class]])
                {
                    __setWechatParams(value,params,SSDKPlatformSubTypeWechatFav);
                }
            }
        }
        return params;
    }
    
    void __iosShareSDKRegisterAppAndSetPltformsConfig (void *appKey, void*configInfo)
    {
        NSMutableArray *activePlatforms = [NSMutableArray array];
        NSMutableDictionary *platformsDict = [NSMutableDictionary dictionary];
        NSString *appKeyStr = [NSString stringWithCString:appKey encoding:NSUTF8StringEncoding];
        
        if (configInfo)
        {
            platformsDict = __parseWithHashtable(configInfo);
        }
        for (id obj in [platformsDict allKeys])
        {
            NSInteger platformInterger = [obj integerValue];
            NSDictionary *dict = [platformsDict objectForKey:[NSString stringWithFormat:@"%@",obj]];
            
            if ([[dict objectForKey:@"Enable"] isEqualToString:@"true"])
            {
                [activePlatforms addObject:[NSNumber numberWithInteger:platformInterger]];
            }
            
            
        }
        [ShareSDK registerApp:appKeyStr
              activePlatforms:activePlatforms
                     onImport:^(SSDKPlatformType platformType) {
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                             {
                                 [WeiPayService instance];
                                 //[ShareSDKConnector connectWeChat:[WXApi class] delegate:[WeiPayService instance]];
                             }
                                 break;
                             default:
                                 break;
                         }
                     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                         
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                             {
                                 
                                 NSArray *weChatTypes = @[@(SSDKPlatformTypeWechat),
                                                          @(SSDKPlatformSubTypeWechatSession),
                                                          @(SSDKPlatformSubTypeWechatTimeline),
                                                          @(SSDKPlatformSubTypeWechatFav)];
                                 
                                 [weChatTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     
                                     NSDictionary *wechatDict = [platformsDict objectForKey:[NSString stringWithFormat:@"%@",obj]];
                                     
                                     if (wechatDict && [[wechatDict allKeys] count] > 0)
                                     {
                                         [appInfo SSDKSetupWeChatByAppId:[wechatDict objectForKey:@"app_id"]
                                                               appSecret:[wechatDict objectForKey:@"app_secret"]];
                                         *stop = YES;
                                     }
                                     
                                 }];
                                 break;
                             }
                             default:
                             {
                                 NSDictionary *platformDict = [platformsDict objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)platformType]];
                                 [appInfo addEntriesFromDictionary:platformDict];
                                 
                                 break;
                             }
                         }
                         
                     }];
    }
    
    
    void __iosShareSDKAuthorize (int reqID, int platType, void *observer)
    {
        
        NSString *observerStr = nil;
        if (observer)
        {
            observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        }
        
        [ShareSDK authorize:platType
                   settings:nil
             onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                 NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                 [resultDict setObject:[NSNumber numberWithInteger:1] forKey:@"action"];
                 [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                 [resultDict setObject:[NSNumber numberWithInteger:platType] forKey:@"platform"];
                 [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                 
                 if (state == SSDKResponseStateFail && error)
                 {
                     NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                     [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                     if ([[error userInfo] objectForKey:@"error_message"])
                     {
                         if ([[error userInfo] objectForKey:@"error_message"])
                         {
                             [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                             
                         }
                     }
                     else if ([[error userInfo] objectForKey:@"user_data"])
                     {
                         NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                         if ([error_data objectForKey:@"error"])
                         {
                             [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                         }
                         if ([error_data objectForKey:@"error_code"])
                         {
                             [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]] forKey:@"error_code"];
                         }
                     }
                     
                     [resultDict setObject:errorDict forKey:@"res"];
                     
                 }
                 if (state == SSDKResponseStateSuccess)
                 {
                     if ([user rawData])
                     {
                         [resultDict setObject:[[user credential] rawData] forKey:@"res"];
                     }
                 }
                 
                 NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                 UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                 
             }];
    }
    
    void __iosShareSDKCancelAuthorize (int platType)
    {
        [ShareSDK cancelAuthorize:platType];
    }
    
    bool __iosShareSDKHasAuthorized (int platType)
    {
        return [ShareSDK hasAuthorized:platType];
    }
    
    bool __iosShareSDKIsClientInstalled(int platType)
    {
        return [ShareSDK isClientInstalled:platType];
    }
    
    void __iosShareSDKGetUserInfo (int reqID, int platType, void *observer)
    {
        NSString *observerStr = nil;
        if (observer)
        {
            observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        }
        
        [ShareSDK getUserInfo:platType
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             
             NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
             [resultDict setObject:[NSNumber numberWithInteger:8] forKey:@"action"];
             [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
             [resultDict setObject:[NSNumber numberWithInteger:platType] forKey:@"platform"];
             [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
             
             if (state == SSDKResponseStateFail && error)
             {
                 NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                 [errorDict setObject:[NSNumber numberWithInteger:[error code]]
                               forKey:@"error_code"];
                 
                 if ([[error userInfo] objectForKey:@"error_message"])
                 {
                     if ([[error userInfo] objectForKey:@"error_message"])
                     {
                         [errorDict setObject:[[error userInfo] objectForKey:@"error_message"]
                                       forKey:@"error_msg"];
                         
                     }
                 }
                 else if ([[error userInfo] objectForKey:@"user_data"])
                 {
                     NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                     if ([error_data objectForKey:@"error"])
                     {
                         [errorDict setObject:[error_data objectForKey:@"error"]
                                       forKey:@"error_msg"];
                     }
                     if ([error_data objectForKey:@"error_code"])
                     {
                         [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                       forKey:@"error_code"];
                     }
                 }
                 
                 
                 [resultDict setObject:errorDict forKey:@"res"];
             }
             if (state == SSDKResponseStateSuccess && user)
             {
                 [resultDict setObject:[user rawData] forKey:@"res"];
             }
             
             NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
             UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
             
         }];
    }
    
    void __iosShareSDKShare (int reqID, int platType, void *content, void *observer)
    {
        NSString *observerStr = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        
        if (content)
        {
            NSString *contentStr = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
            shareParams = __getShareParamsWithString(contentStr);
        }
        
        [ShareSDK share:platType
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
             [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
             [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
             [resultDict setObject:[NSNumber numberWithInteger:platType] forKey:@"platform"];
             [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
             
             if (state == SSDKResponseStateFail && error)
             {
                 NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                 [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                 if ([[error userInfo] objectForKey:@"error_message"])
                 {
                     if ([[error userInfo] objectForKey:@"error_message"])
                     {
                         [errorDict setObject:[[error userInfo] objectForKey:@"error_message"]
                                       forKey:@"error_msg"];
                         
                     }
                 }
                 else if ([[error userInfo] objectForKey:@"user_data"])
                 {
                     NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                     if ([error_data objectForKey:@"error"])
                     {
                         [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                     }
                     if ([error_data objectForKey:@"error_code"])
                     {
                         [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                       forKey:@"error_code"];
                     }
                 }
                 
                 [resultDict setObject:errorDict forKey:@"res"];
                 
             }
             
             if (state == SSDKResponseStateSuccess)
             {
                 if ([contentEntity rawData])
                 {
                     [resultDict setObject:[contentEntity rawData]  forKey:@"res"];
                 }
             }
             NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
             
             UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
             
         }];
        
    }
    
    void __iosShareSDKOneKeyShare (int reqID, void *platTypes, void *content, void *observer)
    {
        NSArray *platTypesArr = nil;
        NSString *observerStr = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        
        if (platTypes)
        {
            NSString *platTypesStr = [NSString stringWithCString:platTypes encoding:NSUTF8StringEncoding];
            platTypesArr = [MOBFJson objectFromJSONString:platTypesStr];
        }
        
        if (content)
        {
            NSString *contentStr = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
            shareParams = __getShareParamsWithString(contentStr);
        }
        
        [SSEShareHelper oneKeyShare:platTypesArr
                         parameters:shareParams
                     onStateChanged:^(SSDKPlatformType platformType, SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                         
                         NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                         [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                         [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                         [resultDict setObject:[NSNumber numberWithInteger:platformType] forKey:@"platform"];
                         [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                         
                         if (state == SSDKResponseStateFail && error)
                         {
                             NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                             [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                             
                             
                             
                             
                             if ([[error userInfo] objectForKey:@"error_message"])
                             {
                                 if ([[error userInfo] objectForKey:@"error_message"])
                                 {
                                     [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                                     
                                 }
                             }
                             else if ([[error userInfo] objectForKey:@"user_data"])
                             {
                                 NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                                 
                                 if ([error_data objectForKey:@"error"])
                                 {
                                     [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                                 }
                                 
                                 if ([error_data objectForKey:@"error_code"])
                                 {
                                     [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                                   forKey:@"error_code"];
                                 }
                             }
                             
                             [resultDict setObject:errorDict forKey:@"res"];
                         }
                         
                         if (state == SSDKResponseStateSuccess)
                         {
                             if ([contentEntity rawData])
                             {
                                 [resultDict setObject:[contentEntity rawData] forKey:@"res"];
                             }
                         }
                         
                         NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                         UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                         
                     }];
    }
    
    void __iosShareSDKShowShareMenu (int reqID, void *platTypes, void *content, int x, int y, void *observer)
    {
       
        NSArray *platTypesArr = nil;
        NSMutableArray *actionSheetItems = [NSMutableArray array];
        NSString *observerStr = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        
        if (platTypes)
        {
            NSString *platTypesStr = [NSString stringWithCString:platTypes encoding:NSUTF8StringEncoding];
            platTypesArr = [MOBFJson objectFromJSONString:platTypesStr];
        }
        else
        {
            platTypesArr = [ShareSDK activePlatforms];
            for (id obj in platTypesArr)
            {
                NSInteger platformInterger = [obj integerValue];
                [actionSheetItems addObject:[NSNumber numberWithInteger:platformInterger]];
            }
            platTypesArr = [actionSheetItems mutableCopy];
            
        }
        
        if (content)
        {
            NSString *contentStr = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
            shareParams = __getShareParamsWithString(contentStr);
        }
        
        if ([MOBFDevice isPad])
        {
            if (!_refView)
            {
                _refView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_refView];
            
        }
        
        [ShareSDK showShareActionSheet:_refView
                                 items:platTypesArr
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                       [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                       [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                       [resultDict setObject:[NSNumber numberWithInteger:platformType] forKey:@"platform"];
                       [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                       
                       if (state == SSDKResponseStateFail && error)
                       {
                           
                           NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                           [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                           if ([[error userInfo] objectForKey:@"error_message"])
                           {
                               if ([[error userInfo] objectForKey:@"error_message"])
                               {
                                   [errorDict setObject:[[error userInfo] objectForKey:@"error_message"]
                                                 forKey:@"error_msg"];
                                   
                               }
                           }
                           else if ([[error userInfo] objectForKey:@"user_data"])
                           {
                               NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                               if ([error_data objectForKey:@"error"])
                               {
                                   [errorDict setObject:[error_data objectForKey:@"error"]
                                                 forKey:@"error_msg"];
                               }
                               else if ([error_data objectForKey:@"error_message"])
                               {
                                   [errorDict setObject:[error_data objectForKey:@"error_message"]
                                                 forKey:@"error_msg"];
                               }
                               
                               if ([error_data objectForKey:@"error_code"])
                               {
                                   [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                                 forKey:@"error_code"];
                               }
                           }
                           
                           [resultDict setObject:errorDict forKey:@"res"];
                       }
                       
                       if (state == SSDKResponseStateSuccess)
                       {
                           if ([contentEntity rawData])
                           {
                               [resultDict setObject:[contentEntity rawData] forKey:@"res"];
                           }
                       }
                       
                       NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                       UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                       if (_refView)
                       {
                           //移除视图
                           [_refView removeFromSuperview];
                       }
                       
                   }];
        
    }
    
    void __iosShareSDKShowShareView (int reqID, int platType, void *content, void *observer)
    {
        NSString *observerStr = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        
        observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        
        if (content)
        {
            NSString *contentStr = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
            shareParams = __getShareParamsWithString(contentStr);
        }
        
        
        [ShareSDK showShareEditor:platType
               otherPlatformTypes:nil
                      shareParams:shareParams
              onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                  
                  NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                  [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                  [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                  [resultDict setObject:[NSNumber numberWithInteger:platformType] forKey:@"platform"];
                  [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                  
                  if (state == SSDKResponseStateFail && error)
                  {
                      NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                      [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                      if ([[error userInfo] objectForKey:@"error_message"])
                      {
                          if ([[error userInfo] objectForKey:@"error_message"])
                          {
                              [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                              
                          }
                      }
                      else if ([[error userInfo] objectForKey:@"user_data"])
                      {
                          NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                          if ([error_data objectForKey:@"error"])
                          {
                              [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                          }
                          if ([error_data objectForKey:@"error_code"])
                          {
                              [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]] forKey:@"error_code"];
                          }
                      }
                      
                      [resultDict setObject:errorDict forKey:@"res"];
                  }
                  
                  if (state == SSDKResponseStateSuccess)
                  {
                      
                      if ([contentEntity rawData])
                      {
                          [resultDict setObject:[contentEntity rawData] forKey:@"res"];
                      }
                  }
                  
                  NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                  UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
              }];
    }
    
    void __iosShareSDKGetFriendsList (int reqID, int platType, int count , int page, void *observer)
    {
        
        SSDKPlatformType shareType = (SSDKPlatformType)platType;
        NSString *observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        NSInteger cursor = page;
        NSInteger size = count;
        
        if (shareType == SSDKPlatformTypeTwitter)
        {
            cursor = -1;
        }
        
        [ShareSDK getFriends:platType
                      cursor:cursor
                        size:size
              onStateChanged:^(SSDKResponseState state, SSDKFriendsPaging *paging, NSError *error)
         {
             NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
             [resultDict setObject:[NSNumber numberWithInteger:2] forKey:@"action"];
             [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
             [resultDict setObject:[NSNumber numberWithInteger:shareType] forKey:@"platform"];
             [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
             
             if (state == SSDKResponseStateFail && error)
             {
                 NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                 [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                 if ([[error userInfo] objectForKey:@"error_message"])
                 {
                     if ([[error userInfo] objectForKey:@"error_message"])
                     {
                         [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                         
                     }
                 }
                 else if ([[error userInfo] objectForKey:@"user_data"])
                 {
                     NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                     if ([error_data objectForKey:@"error"])
                     {
                         [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                     }
                     if ([error_data objectForKey:@"error_code"])
                     {
                         [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]] forKey:@"error_code"];
                     }
                 }
                 
                 [resultDict setObject:errorDict forKey:@"res"];
                 
             }
             
             if (state == SSDKResponseStateSuccess)
             {
                 if (paging)
                 {
                     NSArray *friends = [NSArray array];
                     friends = paging.users;
                     NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
                     [resDict setObject:friends forKey:@"users"];
                     [resDict setObject:[NSNumber numberWithInteger:paging.prevCursor] forKey:@"prev_cursor"];
                     [resDict setObject:[NSNumber numberWithInteger:paging.nextCursor] forKey:@"next_cursor"];
                     [resDict setObject:[NSNumber numberWithUnsignedInteger:paging.total] forKey:@"total"];
                     [resDict setObject:[NSNumber numberWithBool:paging.hasNext] forKey:@"has_next"];
                     [resultDict setObject:resDict forKey:@"res"];
                     
                 }
             }
             NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
             UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
             
         }];
        
    }
    char * __StringCopy( const char *string)
    {
        if (string != NULL)
        {
            char *copyStr = (char*)malloc(strlen(string)+1);
            strcpy(copyStr, string);
            return copyStr;
        }
        else
        {
            return NULL;
        }
    }
    
    extern const char* __iosShareSDKGetCredential (int platType)
    {
        SSDKPlatformType shareType = (SSDKPlatformType)platType;
        SSDKUser *userInfo = [ShareSDK currentUser:shareType];
        SSDKCredential *credential = userInfo.credential;
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        [resultDict setObject:[NSNumber numberWithInteger:shareType] forKey:@"type"];
        
        if ([credential available])
        {
            if ([credential uid])
            {
                [resultDict setObject:[credential uid] forKey:@"uid"];
            }
            if ([credential token])
            {
                [resultDict setObject:[credential token] forKey:@"token"];
            }
            if ([credential secret])
            {
                [resultDict setObject:[credential secret] forKey:@"secret"];
            }
            if ([credential expired])
            {
                [resultDict setObject:@([[credential expired] timeIntervalSince1970]) forKey:@"expired"];
            }
            
            [resultDict setObject:[NSNumber numberWithBool:[credential available]] forKey:@"available"];
            
        }
        else
        {
            [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"available"];
            [resultDict setObject:@"Invalid Authorization" forKey:@"error"];
        }
        
        NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
        return __StringCopy([resultStr UTF8String]);
    }
    
    void __iosShareSDKFollowFriend (int reqID, int platType,void *account, void *observer)
    {
        SSDKPlatformType shareType = (SSDKPlatformType)platType;
        NSString *observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        SSDKUser *user = [[SSDKUser alloc]init];
        user.uid = [NSString stringWithCString:account encoding:NSUTF8StringEncoding];
        if (shareType == SSDKPlatformTypeTencentWeibo)
        {
            user.uid = nil;
            user.nickname = [NSString stringWithCString:account encoding:NSUTF8StringEncoding];
        }
        
        [ShareSDK addFriend:shareType
                       user:user
             onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                 NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                 [resultDict setObject:[NSNumber numberWithInteger:6] forKey:@"action"];
                 [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                 [resultDict setObject:[NSNumber numberWithInteger:shareType] forKey:@"platform"];
                 [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                 
                 if (state == SSDKResponseStateFail && error)
                 {
                     NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                     [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                     if ([[error userInfo] objectForKey:@"error_message"])
                     {
                         if ([[error userInfo] objectForKey:@"error_message"])
                         {
                             [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                             
                         }
                     }
                     else if ([[error userInfo] objectForKey:@"user_data"])
                     {
                         NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                         if ([error_data objectForKey:@"error"])
                         {
                             [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                         }
                         if ([error_data objectForKey:@"error_code"])
                         {
                             [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                           forKey:@"error_code"];
                         }
                     }
                     
                     [resultDict setObject:errorDict forKey:@"res"];
                 }
                 
                 if (state == SSDKResponseStateSuccess)
                 {
                     NSDictionary *userRawdata = [NSDictionary dictionaryWithDictionary:[user rawData]];
                     [resultDict setObject:userRawdata forKey:@"res"];
                 }
                 
                 NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                 UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
             }];
    }
    
    void __iosShareSDKShareWithContentName(int reqID, int platType, void *contentName, void *customHashtable,  void *observer)
    {
        SSDKPlatformType shareType = (SSDKPlatformType)platType;
        NSString *contentNodeName = [NSString stringWithCString:contentName encoding:NSUTF8StringEncoding];
        NSString *observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        NSDictionary *customFields = nil;
        
        if (customHashtable)
        {
            customFields = __parseWithHashtable(customHashtable);
        }
        
        [ShareSDK shareWithContentName:contentNodeName
                              platform:shareType
                          customFields:customFields
                        onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                            
                            NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                            [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                            [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                            [resultDict setObject:[NSNumber numberWithInteger:platType] forKey:@"platform"];
                            [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                            
                            if (state == SSDKResponseStateFail && error)
                            {
                                NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                                [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                                if ([[error userInfo] objectForKey:@"error_message"])
                                {
                                    if ([[error userInfo] objectForKey:@"error_message"])
                                    {
                                        [errorDict setObject:[[error userInfo] objectForKey:@"error_message"]
                                                      forKey:@"error_msg"];
                                    }
                                }
                                else if ([[error userInfo] objectForKey:@"user_data"])
                                {
                                    NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                                    if ([error_data objectForKey:@"error"])
                                    {
                                        [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                                    }
                                    if ([error_data objectForKey:@"error_code"])
                                    {
                                        [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                                      forKey:@"error_code"];
                                    }
                                }
                                else if([[error userInfo] objectForKey:@"error_msg"])
                                {
                                    if ([[error userInfo] objectForKey:@"error_msg"])
                                    {
                                        [errorDict setObject:[[error userInfo] objectForKey:@"error_msg"]
                                                      forKey:@"error_msg"];
                                    }
                                }
                                
                                [resultDict setObject:errorDict forKey:@"res"];
                            }
                            
                            if (state == SSDKResponseStateSuccess)
                            {
                                if ([contentEntity rawData])
                                {
                                    [resultDict setObject:[contentEntity rawData]  forKey:@"res"];
                                }
                            }
                            
                            NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                            UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                        }];
        
    }
    
    void __iosShareSDKShowShareMenuWithContentName(int reqID, void *contentName, void *customHashtable, void *platTypes, int x, int y, void *observer)
    {
        NSString *contentNodeName = [NSString stringWithCString:contentName encoding:NSUTF8StringEncoding];
        NSDictionary *customFields = nil;
        if (customHashtable)
        {
            customFields = __parseWithHashtable(customHashtable);
        }
        NSArray *platTypesArr = nil;
        NSMutableArray *actionSheetItems = [NSMutableArray array];
        NSString *observerStr = nil;
        
        observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        
        if (platTypes)
        {
            NSString *platTypesStr = [NSString stringWithCString:platTypes encoding:NSUTF8StringEncoding];
            platTypesArr = [MOBFJson objectFromJSONString:platTypesStr];
        }
        else
        {
            platTypesArr = [ShareSDK activePlatforms];
            for (id obj in platTypesArr)
            {
                NSInteger platformInterger = [obj integerValue];
                [actionSheetItems addObject:[NSNumber numberWithInteger:platformInterger]];
            }
            platTypesArr = [actionSheetItems mutableCopy];
            
        }
        

        if ([MOBFDevice isPad])
        {
            if (!_refView)
            {
                _refView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_refView];
            
        }
        
        [ShareSDK showShareActionSheet:_refView
                                 items:platTypesArr
                           contentName:contentNodeName
                          customFields:customFields
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                       [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                       [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                       [resultDict setObject:[NSNumber numberWithInteger:platformType] forKey:@"platform"];
                       [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                       
                       if (state == SSDKResponseStateFail && error)
                       {
                           
                           NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                           [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                           if ([[error userInfo] objectForKey:@"error_message"])
                           {
                               if ([[error userInfo] objectForKey:@"error_message"])
                               {
                                   [errorDict setObject:[[error userInfo] objectForKey:@"error_message"]
                                                 forKey:@"error_msg"];
                                   
                               }
                           }
                           else if ([[error userInfo] objectForKey:@"user_data"])
                           {
                               NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                               if ([error_data objectForKey:@"error"])
                               {
                                   [errorDict setObject:[error_data objectForKey:@"error"]
                                                 forKey:@"error_msg"];
                               }
                               else if ([error_data objectForKey:@"error_message"])
                               {
                                   [errorDict setObject:[error_data objectForKey:@"error_message"]
                                                 forKey:@"error_msg"];
                               }
                               
                               if ([error_data objectForKey:@"error_code"])
                               {
                                   [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]]
                                                 forKey:@"error_code"];
                               }
                           }
                           
                           [resultDict setObject:errorDict forKey:@"res"];
                       }
                       
                       if (state == SSDKResponseStateSuccess)
                       {
                           if ([contentEntity rawData])
                           {
                               [resultDict setObject:[contentEntity rawData] forKey:@"res"];
                           }
                       }
                       
                       NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                       UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                       if (_refView)
                       {
                           //移除视图
                           [_refView removeFromSuperview];
                       }

                   }];
        
    }
    
    void __iosShareSDKShowShareViewWithContentName(int reqID, int platType, void *contentName, void *customHashtable, void *observer)
    {
        SSDKPlatformType shareType = (SSDKPlatformType)platType;
        NSString *contentNodeName = [NSString stringWithCString:contentName encoding:NSUTF8StringEncoding];
        NSString *observerStr = [NSString stringWithCString:observer encoding:NSUTF8StringEncoding];
        NSDictionary *customFields = nil;
        
        if (customHashtable)
        {
            customFields = __parseWithHashtable(customHashtable);
        }
        
        [ShareSDK showShareEditor:shareType
               otherPlatformTypes:nil
                      contentName:contentNodeName
                     customFields:customFields
              onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                 
                  NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                  [resultDict setObject:[NSNumber numberWithInteger:9] forKey:@"action"];
                  [resultDict setObject:[NSNumber numberWithInteger:state] forKey:@"status"];
                  [resultDict setObject:[NSNumber numberWithInteger:platformType] forKey:@"platform"];
                  [resultDict setObject:[NSNumber numberWithInteger:reqID] forKey:@"reqID"];
                  
                  if (state == SSDKResponseStateFail && error)
                  {
                      NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
                      [errorDict setObject:[NSNumber numberWithInteger:[error code]] forKey:@"error_code"];
                      if ([[error userInfo] objectForKey:@"error_message"])
                      {
                          if ([[error userInfo] objectForKey:@"error_message"])
                          {
                              [errorDict setObject:[[error userInfo] objectForKey:@"error_message"] forKey:@"error_msg"];
                              
                          }
                      }
                      else if ([[error userInfo] objectForKey:@"user_data"])
                      {
                          NSDictionary *error_data = [[error userInfo] objectForKey:@"user_data"];
                          if ([error_data objectForKey:@"error"])
                          {
                              [errorDict setObject:[error_data objectForKey:@"error"] forKey:@"error_msg"];
                          }
                          if ([error_data objectForKey:@"error_code"])
                          {
                              [errorDict setObject:[NSNumber numberWithInteger:[[error_data objectForKey:@"error_code"] integerValue]] forKey:@"error_code"];
                          }
                      }
                      
                      [resultDict setObject:errorDict forKey:@"res"];
                  }
                  
                  if (state == SSDKResponseStateSuccess)
                  {
                      
                      if ([contentEntity rawData])
                      {
                          [resultDict setObject:[contentEntity rawData] forKey:@"res"];
                      }
                  }
                  
                  NSString *resultStr = [MOBFJson jsonStringFromObject:resultDict];
                  UnitySendMessage([observerStr UTF8String], "_Callback", [resultStr UTF8String]);
                  
              }];
    }
    
#if defined (__cplusplus)
}
#endif
@implementation ShareSDKUnity3DBridge

@end
