//
//  Define.h
//  MZYY(Doctor)
//
//  Created by PengLin on 15-4-17.
//  Copyright (c) 2015年 PengLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Define : NSObject



#ifdef DEBUG
#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...) do { } while (0)
#endif

//********设备属性***********
#define kDeviceVersion [[UIDevice currentDevice] systemVersion]
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES :NO)
#define NavigationBar_HEIGHT  self.navigationController.navigationBar.frame.size.height



#define App_Frame_Height  [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width   [[UIScreen mainScreen] applicationFrame].size.width

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//********ARC********
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif


//手机型号
#define iphone5s  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6p  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define kDeviceModel  ([UIDevice currentDevice].model)
#define iPhone ([kDeviceModel hasPrefix:@"iPhone"])
#define iPad ([kDeviceModel hasPrefix:@"iPad"])
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height


#define DKNotificationCenter [NSNotificationCenter defaultCenter]
#define DKApplication [UIApplication sharedApplication]
#define DKFileManager [NSFileManager defaultManager]
#define DKDevice [UIDevice currentDevice]

//***********G－C－D*************
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),^{block})




#define kMaximumRightDrawerWidth 200

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//*******颜色************
#pragma mark - color functions

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
#define ALPHARGBCOLOR(r,g,b,a) [[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]colorWithAlphaComponent:a]

//*******设置 view 圆角和边框************
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//*******获得字体大小************
#define MULTILINE_TEXTSIZE(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

//*******文件操作***************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//******网络通信************

#define kBaseURL @"cms.dknb.nbtv.cn"
#define MallBaseURL @"apimall.dknb.nbtv.cn"


//Response Code
#define kSuccessCode  1
#define kSatatusKey  @"status"
#define kServiceTimeOut -1001
#define kPageSize  (iPad? @"20": @"10")

//network message
#define kServiceErrorMessage  @"网络异常，请检查网络设置！"
#define kTimeOutMessage  @"连接超时，请重新连接！"
#define kRequestFailedMessage  @"网络链接异常，请稍后再试！"
#define kRequestSuccessMessage  @"查询成功"

//字体
#define kHelvetica  @"Helvetica"
#define kHelveticaBold  @"Helvetica-Bold"
#define kHelveticaLight  @"Helvetica-Light"


#define newsUrl @"https://h5.dknb.nbtv.cn/news/detail?articleId=" //新闻链接
#define DzpUrl @"https://h5.dknb.nbtv.cn/lottery/dzp" //大转盘链接
#define gooddetailUrl @"https://h5.dknb.nbtv.cn/mall/detail" //商品详情
#define guaguaKa @"https://h5.dknb.nbtv.cn/lottery/ggk" //刮刮卡
#define findSecret @"https://h5.dknb.nbtv.cn/user/get-password2"  //找回密码
#define toupiaourl @"https://h5.dknb.nbtv.cn/vote/detail"   //投票
#define kefuurl @"https://h5.dknb.nbtv.cn/feedback"   //客服
#define huodongurl  @"https://h5.dknb.nbtv.cn/activity/detail"   //活动
#define guanyuurl  @"https://h5.dknb.nbtv.cn/about.html"   //关于
#define fuwuurl     @"https://h5.dknb.nbtv.cn/service/list"  //服务
#define yaoqingmaurl @"https://h5.dknb.nbtv.cn/invitation/code" //邀请码
#define showurl @"https://h5.dknb.nbtv.cn/show/detail?showId=" //全民秀
#define  WebSocketURL   @"wss://ws.dknb.nbtv.cn:8688"    //聊天室
#define  LiveRoomOutURL   @"https://h5.dknb.nbtv.cn/live?room_id="    //直播室外链分享
#define LiveApplyURL @"https://h5.dknb.nbtv.cn/live/apply"  //直播申请页

#define dknbUUID @"ios"
#define DeviceID @"ios"
#define SocketKey @"dknb-live"


 #define USER_ID  [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]
 #define USER_TOKEN  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
 #define USER_ICON  [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]
 #define USER_NICKNAME  [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"]
 #define USER_HAVENEWS  [[NSUserDefaults standardUserDefaults] objectForKey:HAVENEWS]
 #define USER_FIRSTUSESHOW [[NSUserDefaults standardUserDefaults] objectForKey:@"allshow"]
 #define USER_POINT [[NSUserDefaults standardUserDefaults] objectForKey:@"integral"]
 #define USER_FIRSTUSECOLORBARRAGE [[NSUserDefaults standardUserDefaults] objectForKey:FIRSTUSECOLORBARRAGE]
 #define USER_USERNAME  [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]


#define HAVENEWS @"havenews"
#define FIRSTUSECOLORBARRAGE @"firstusecolorbarrage"

#define Baidu [BaiduMobStat defaultStat]
#define BaiDu_Start(str)            [[BaiduMobStat defaultStat] pageviewStartWithName:str]
#define BaiDu_End(str)              [[BaiduMobStat defaultStat] pageviewEndWithName:str]

//调试模式下输入NSLog，发布后不再输入。
#define NSLog(...) NSLog(__VA_ARGS__)

//显示行数的LRLog，发布后不再输入
#ifdef DEBUG
#define LRLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LRLog(...)
#endif

typedef enum {
    kPatientType,//本人、本组、本科室
    kPatientPickerType , //病人
} PopTableType;


@end
