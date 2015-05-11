//
//  PublicMethod.m
//  SuNingCustomer
//
//  Created by wangbob on 13-7-22.
//  Copyright (c) 2013年 SuNing. All rights reserved.
//

#import "PublicMethod.h"
#import "AlixPay.h"
#import "pinyin.h"
#import "WeiboSDK.h"
#import "YHAlertView.h"
#import "ShareCustomViewController.h"
#import "YHGoodsDetailViewController.h"
@implementation PublicMethod

@synthesize block = _block;

/**
 *@   生成导航条上的按钮
 */
+(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage
{
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 35, 29);
    
    // Set the stretchable images as the background for the button
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button setImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    
    return button;
}

/**
 *@   生成导航条上的按钮
 */
+(void) addBackButtonWithTarget:(UIViewController *)viewController action:(SEL)action
{
    float originY = 0.f;
    if (IOS_VERSION >= 7) {
        originY = 20.f;
    }
    /*返回按钮*/
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0+originY, 52, 44);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    backBtn.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:backBtn];
}
/**
 *@   生成导航条上的右侧按钮
 */
+(void)addRightViewWithTarget:(UIViewController *)viewController title:(NSString *)title action:(SEL)action
{
    float originY = 0.f;
    if (IOS_VERSION >= 7) {
        originY = 20.f;
    }
//    右侧按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(SCREEN_WIDTH - 52, 0+originY, 52, 44);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:title forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
    backBtn.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:backBtn];

}
/**
 *@   生成导航条上的按钮
 */
+(void) addBackViewWithTarget:(UIViewController *)viewController action:(SEL)action
{
    float originY = 0.f;
    if (IOS_VERSION >= 7) {
        originY = 20.f;
    }
    /*返回按钮*/
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(7, 7+originY, 30, 30);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
    backBtn.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:backBtn];
}

//网络提示修改
+(NSString *)changeStr:(NSString *)_str
{
    NSString * str = @"";
    if ([_str isEqualToString:@"未能找到使用指定主机名的服务器。"])
    {
        str = @"网络异常，请稍后再试！";
    }
    else if ([_str isEqualToString:@"NSURLErrorDomain"])
    {
        str = @"网络异常，请稍后再试！";
        
    }
    else
    {
        str = _str;
    }
    return str;
}


/**
 * 生成导航条背景
 */
+(void)addNavBackground:(UIView *)view title:(NSString *)title
{
//    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_Bg.png"]] autorelease];
    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]] autorelease];
    float originY = 0.f;
    if (IOS_VERSION >= 7) {
        originY = 20.f;
    }
    bgView.frame = CGRectMake(0, originY, ScreenSize.width, NAVBAR_HEIGHT);
    [view addSubview:bgView];
    
    
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, ScreenSize.width, ScreenSize.height)];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [view insertSubview:bgColorView atIndex:0];
    [bgColorView release];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, 320, NAVBAR_HEIGHT)];
    titleLbl.text = title;
    titleLbl.backgroundColor = [UIColor clearColor];
//    titleLbl.textColor = [PublicMethod colorWithHexValue:0xFF986D alpha:1.0f];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:20];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:titleLbl];
    [titleLbl release];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, originY + NAVBAR_HEIGHT -1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    [line release];
    
}
//生成纯色图片的方法
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark 保存图片到document
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}
#pragma mark 从文档目录下获取Documents路径
+ (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
/***
 * @brief 邮箱有效性检查
 */
//怎么判断用户输入了是否正确的邮箱地址
+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet]; NSMutableCharacterSet* tmpInvalidMutableCharSet = [[tmpInvalidCharSet mutableCopy] autorelease]; [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        //使用compare option 来设定比较规则,如 //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数,而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray = [userNameString componentsSeparatedByString:@"."];
    
            for(NSString* string in userNameArray)
            {
                NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                    return NO;
            }
        
       
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
    if ([domainArray count] >3)
    {
        return NO;
    }
    else
    {
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        }
        return YES;
    }
    else // no ''@'' or ''.''present
        return NO;
}

+ (BOOL) NSStringIsValidEmail:(NSString*)checkString
{
    NSString *stricterFilterString = @"/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{1,3}){1,2})$/";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilterString ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
/***
 * @brief 手机号有效性检查
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     移动号段：134、135、136、137、138、139、147、150、151、152、157、158、159、182、 183、184、187、188
     联通号段：130、131、132、155、156、185、186、145
     电信号段：133、153、180、181、189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|4[57]|7[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//6到18位数字和字母组合的密码
+(BOOL)isVaildPassword:(NSString *)passwordNum
{
    //  /[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/
    NSString *regex =  @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *passWord = [NSString stringWithFormat:@"%@",passwordNum];
    BOOL isMatch = [predicate evaluateWithObject:passWord];
    if (!isMatch)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
//    NSScanner扫描传过来的身份证的前17位
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
/***
 * @brief 密码有效性检查
 */
+ (BOOL)isPassword:(NSString *)password
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]{6,20}$" options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex != nil) {
        NSUInteger numberOfMatch = [regex numberOfMatchesInString:password options:0 range:NSMakeRange(0, [password length])];
        if (numberOfMatch == 0) {
            [[iToast  makeText:@"格式错误啦，密码格式为6-20位"] show];
            return NO;
        }
    }
    return  YES;
}

/* 添加公共方法 */
static UIWindow *awindow;

+ (UIButton *)addButton:(CGRect)rect title:(NSString *)title backGround:(NSString *)imgString setTag:(NSInteger)tag setId:(id)_sel selector:(SEL)selector setFont:(UIFont *)font setTextColor:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setBackgroundImage:[UIImage imageNamed:imgString] forState:UIControlStateNormal];
    [btn setTag:tag];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:_sel action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIView *)addBackView:(CGRect)rect setBackColor:(UIColor *)color{
    UIView *view = [[[UIView alloc] initWithFrame:rect] autorelease];
    view.backgroundColor = color;
    return view;
}

+ (UIImageView *)addImageView:(CGRect)rect setImage:(NSString *)imageString{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
//    [imageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:nil];
    imageView.image = [UIImage imageNamed:imageString];
    return imageView;
}

+ (UILabel *)addLabel:(CGRect)rect setTitle:(NSString *)title setBackColor:(UIColor *)color setFont:(UIFont *)font{
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.text = title;
    label.numberOfLines = 0;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    return label;
}

+ (AttributedLabel *)addLabelAttribute:(CGRect)rect setTitle:(NSString *)title setBackColor:(UIColor *)color setFont:(UIFont *)font{
    AttributedLabel *label = [[[AttributedLabel alloc] initWithFrame:rect] autorelease];
    [label setText:title];
    label.numberOfLines = 0;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    return label;
}


/* 加载状态 */
+(void)ShowWaitingView:(BOOL)isShow
{
    if (isShow)
    {
        if (!awindow)
        {
            awindow=[[[UIWindow alloc] initWithFrame:CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height)] autorelease];
            awindow.windowLevel=UIWindowLevelStatusBar;
        }
        [MBProgressHUD hideHUDForView:awindow animated:YES];
        [MBProgressHUD showHUDAddedTo:awindow animated:YES];
        [awindow makeKeyAndVisible];
    }
    else{
        if (awindow) {
            [awindow resignKeyWindow];
            [awindow setHidden:YES];
            [MBProgressHUD hideHUDForView:awindow animated:YES];
        }
    }
}

//通过十六进制和alpha生成颜色
+ (UIColor*)colorWithHexValue:(NSInteger)aHexValue
                        alpha:(CGFloat)aAlpha {
	return [UIColor colorWithRed:((CGFloat)((aHexValue&0xFF0000)>>16))/255.0
						   green:((CGFloat)((aHexValue&0xFF00)>>8))/255.0
							blue:((CGFloat)(aHexValue&0xFF))/255.0
						   alpha:aAlpha];
    
}

// 通过16机制（＃ffffff）-color颜色
+ (UIColor *)colorWithHexValue1:(NSString *)hexColor
{
    if (hexColor.length == 0) {
        return [UIColor whiteColor];
    }
    NSString *newString = [hexColor substringFromIndex:1];
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[newString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[newString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[newString substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (void)AlixPayWithParams:(NSString *)orderStr{
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderStr applicationScheme:@"YHCustomer"];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"取消",@"确定",nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
    }

// 计算UILabl文本高度
+ (CGFloat)getLabelHeight:(NSString *)labelString setLabelWidth:(CGFloat)labelwidth setFont:(UIFont *)font{
    CGFloat height = 0.0f;
    if ([labelString isMemberOfClass:[NSNull class]]) {
        return height;
    }else{
        CGSize labelSize = [labelString sizeWithFont:font constrainedToSize:CGSizeMake(labelwidth, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        height = labelSize.height;
    }
    return height;
}



// 传入时间2014年12月20日 13:30－>转换时间戳
+ (NSString * )NSStringToNSDate: (NSString * )string
{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
    NSDate *date1 = [formatter dateFromString :string];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    NSLog(@"date is %@",date1);
    return timeStamp;
}

// 传入时间2014年12月20日 13:30:00－>转换时间戳
+ (NSString * )NSStringToNSDateToSS: (NSString * )string
{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT_STOREPICK_SS];
    NSDate *date1 = [formatter dateFromString :string];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    NSLog(@"date is %@",date1);
    return timeStamp;
}

//时间戳转换成时间格式timestamp->2014年12月20日 13:30
+ (NSString *)timeStampConvertToFullTime:(NSString *)stampTime{
    NSDateFormatter* formatter =[[[NSDateFormatter alloc] init] autorelease];
    ;
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[stampTime integerValue]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)nsdateConvertToTimeString:(NSDate *)inputDate{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSString *timeStr = [formatter stringFromDate:inputDate];
    return timeStr;
}

//输入的日期字符串形如：@"1992-05-21 13:08"
+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSDate *)dateFromStringOther:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
// 字符串中是否包含汉字
+ (BOOL)isHasHanZiBool:(NSString *)inputStr{
    BOOL ishasHanZi = NO;
    for(int i=0; i< [inputStr length];i++){
        int a = [inputStr characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            ishasHanZi = YES;
            return ishasHanZi;
        }
    }
    return ishasHanZi;
}

// 将城市数组转换 － a-z Section
+ (NSMutableArray *)convertToSectionArray:(NSArray *)originDataArray HotCityArray:(NSMutableArray *)hotCity{
    NSMutableArray *sectionArray= [[NSMutableArray alloc] init];
    // 格式化数组 热门－a-z
    for(int i = 0; i < CITY_FIRST_LETTER.length; i ++) {
		[sectionArray addObject:[NSMutableArray array]];
	}
    // 定位城市
    [[sectionArray objectAtIndex:0] removeAllObjects];
    // 热门城市
    [[sectionArray objectAtIndex:1] addObjectsFromArray:hotCity];
    
    // 字母_a~z姓名排序
	for (int i = 0; i < [originDataArray count]; i ++) {
		NSString *cityName = [[originDataArray objectAtIndex:i] objectForKey:@"region_name"];
        //首字字母分组
		NSString *firstCityNameLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([cityName characterAtIndex:0])] uppercaseString];
        
        NSUInteger firstLetterLocation;
        firstLetterLocation = [CITY_FIRST_LETTER rangeOfString:firstCityNameLetter].location;
        if ([cityName isEqualToString:@"重庆"] || [cityName isEqualToString:@"重庆市"] || [cityName isEqualToString:@"长乐"] || [cityName isEqualToString:@"长乐市"]) {
            firstLetterLocation = [CITY_FIRST_LETTER rangeOfString:@"C"].location;
        }
        if ([cityName isEqualToString:@"厦门"] || [cityName isEqualToString:@"厦门市"]) {
            firstLetterLocation = [CITY_FIRST_LETTER rangeOfString:@"X"].location;
        }
		if (firstLetterLocation != NSNotFound){
            [[sectionArray objectAtIndex:firstLetterLocation] addObject:[originDataArray objectAtIndex:i]];
        }
    }
    return [sectionArray autorelease];
}

//微信分享
+ (void)showShareMainViewWithContent:(NSString *)content title:(NSString *)title url:(NSString *)url description:(NSString *)description shareType:(ShareType)shareType, ... {
    
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //定义菜单分享列表
    NSMutableArray *shareList = [NSMutableArray array];
    int type;
    va_list args;
    if (shareType) {
        [shareList addObjectsFromArray:[ShareSDK getShareListWithType:shareType, nil]];
        va_start(args, shareType);
        while ((type = va_arg(args, ShareType))) {
            [shareList addObjectsFromArray:[ShareSDK getShareListWithType:type, nil]];
            va_end(args);
        }
    }
    NSString *newUrl = [NSString stringWithFormat:@"%@&region_id=%@",url,[UserAccount instance].region_id];
    
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon114" ofType:@"png"];
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:newUrl
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];

}
//微信分享
+ (void)showShareMainViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block shareType:(ShareType)shareType, ... {
    
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //定义菜单分享列表
    NSMutableArray *shareList = [NSMutableArray array];
    int type;
    va_list args;
    if (shareType) {
        [shareList addObjectsFromArray:[ShareSDK getShareListWithType:shareType, nil]];
        va_start(args, shareType);
        while ((type = va_arg(args, ShareType))) {
            [shareList addObjectsFromArray:[ShareSDK getShareListWithType:type, nil]];
            va_end(args);
        }
    }
//    if (shareType == ShareTypeAny) {
//        [ShareSDK shareActionSheetItemWithTitle:@"二维码分享"
//                                           icon:[UIImage imageNamed: @"二维码"]
//                                   clickHandler:nil];
//        [shareList addObject:[ShareSDK getClientNameWithType:shareType]];
//    }
    NSString *newUrl = [NSString stringWithFormat:@"%@&region_id=%@",url,[UserAccount instance].region_id];
    
    //创建分享内容
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon114" ofType:@"png"];
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:newUrl
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    PublicMethod * p = [[PublicMethod alloc]init];
  
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    if (block) {
                                        p.block = [block copy];
                                        p.block(statusInfo);
                                    }
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
}
#pragma mark - CustomShareActionSheetView
+ (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block shareType:(ShareType)shareType, ... {
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType: ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo,nil];
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    PublicMethod * p = [[PublicMethod alloc]init];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:appDelegate.viewDelegate
                                                      friendsViewDelegate:appDelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    if (block) {
                                        p.block = [block copy];
                                        p.block(statusInfo);
                                    }
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
+ (void)showCustomShareListViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController shareType:(ShareType)shareType, ... {
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    PublicMethod * p = [[PublicMethod alloc]init ];
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
//    //朋友圈显示内容
//    id<ISSContent> publishContent1 = [ShareSDK content:content
//                                       defaultContent:@""
//                                                image:[ShareSDK imageWithUrl:imageUrl]
//                                                title:content
//                                                  url:url
//                                          description:description
//                                            mediaType:SSPublishContentMediaTypeNews];
    //定义点击事件
    id clickHandler = ^{
        //        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
        //        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
        //
        //        if ([UIDevice currentDevice].isPad)
        //        {
        //            naVC.modalPresentationStyle = UIModalPresentationFormSheet;
        //        }
        //
        //        [self presentModalViewController:naVC animated:YES];
    };
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //定义菜单分享列表
    /*新浪*/
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                 icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                         clickHandler:^{
        //调用微博客户端来发微博
        if([WeiboSDK isWeiboAppInstalled]){
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeSinaWeibo
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                            if(state == SSPublishContentStateSuccess){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                if (block) {
                                                    p.block = [block copy];
                                                    p.block(statusInfo);
                                                }
                                            }else if (state == SSPublishContentStateFail){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                            }
                                        }];
                                                                              
        }else{
            [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                  container:container
                                    content:publishContent
                              statusBarTips:YES
                                authOptions:authOptions
                               shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                            oneKeyShareList:[NSArray defaultOneKeyShareList]
                             qqButtonHidden:NO
                      wxSessionButtonHidden:NO
                     wxTimelineButtonHidden:NO
                       showKeyboardOnAppear:NO
                          shareViewDelegate:appDelegate.viewDelegate
                        friendsViewDelegate:appDelegate.viewDelegate
                      picViewerViewDelegate:nil]
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                if (state == SSPublishContentStateSuccess){
                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                    if (block) {
                                                        p.block = [block copy];
                                                        p.block(statusInfo);
                                                                                                               }
                                                                                                           }else if (state == SSPublishContentStateFail){
                                                        
                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                                           }
                                                                                                       }];
                                                                              
                                                                          }
                                                                      }];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
        [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                           icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                                   clickHandler:^{
                                       [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                                             container:nil
                                                               content:publishContent
                                                         statusBarTips:YES
                                                           authOptions:authOptions
                                                          shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                               qqButtonHidden:NO
                                                                                        wxSessionButtonHidden:NO
                                                                                       wxTimelineButtonHidden:NO
                                                                                         showKeyboardOnAppear:NO
                                                                                            shareViewDelegate:appDelegate.viewDelegate
                                                                                          friendsViewDelegate:appDelegate.viewDelegate
                                                                                        picViewerViewDelegate:nil]
                                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                    
                                                                    if (state == SSPublishContentStateSuccess)
                                                                    {
                                                                        NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                        if (block) {
                                                                            p.block = [block copy];
                                                                            p.block(statusInfo);
                                                                        }
                                                                    }
                                                                    
                                                                    else if (state == SSPublishContentStateFail)
                                                                    {
                                                                        NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                    }
                                                                }];

                                   }],
        [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                           icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                                   clickHandler:^{
                                       [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                                             container:nil
                                                               content:publishContent
                                                         statusBarTips:YES
                                                           authOptions:authOptions
                                                          shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                               qqButtonHidden:NO
                                                                                        wxSessionButtonHidden:NO
                                                                                       wxTimelineButtonHidden:NO
                                                                                         showKeyboardOnAppear:NO
                                                                                            shareViewDelegate:appDelegate.viewDelegate
                                                                                          friendsViewDelegate:appDelegate.viewDelegate
                                                                                        picViewerViewDelegate:nil]
                                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                    
                                                                    if (state == SSPublishContentStateSuccess)
                                                                    {
                                                                        NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                        if (block) {
                                                                            p.block = [block copy];
                                                                            p.block(statusInfo);
                                                                        }
                                                                    }
                                                                    else if (state == SSPublishContentStateFail)
                                                                    {
                                                                        NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                    }
                                                                }];
                                       
                                   }],
        sinaItem,nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK
                                    defaultShareOptionsWithTitle:nil
                                    oneKeyShareList:[NSArray defaultOneKeyShareList]
                                    qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                    wxTimelineButtonHidden:NO
                                    showKeyboardOnAppear:NO
                                    shareViewDelegate:appDelegate.viewDelegate
                                    friendsViewDelegate:appDelegate.viewDelegate
                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    if (block) {
                                        p.block = [block copy];
                                        p.block(statusInfo);
                                    }
                                }else if (state == SSPublishContentStateFail){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
/*
 + (void)showCustomShareListViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController shareType:(ShareType)shareType, ... {

 */
+ (void)showCustomShareListWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController shareType:(ShareType)shareType, ... {
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    PublicMethod * p = [[PublicMethod alloc]init ];
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    //定义点击事件
    id clickHandler = ^{
//        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
//        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
//        
//        if ([UIDevice currentDevice].isPad)
//        {
//            naVC.modalPresentationStyle = UIModalPresentationFormSheet;
//        }
//        
//        [self presentModalViewController:naVC animated:YES];
        
    };
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //定义菜单分享列表
    /*新浪*/
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                 icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                         clickHandler:^{
        //调用微博客户端来发微博
        if([WeiboSDK isWeiboAppInstalled]){
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeSinaWeibo
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                            if(state == SSPublishContentStateSuccess){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                if (block) {
                                                    p.block = [block copy];
                                                    p.block(statusInfo);
                                                }
                                            }else if (state == SSPublishContentStateFail){                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                            }
                                         }];
            
        }else{
            [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                  container:container
                                    content:publishContent
                              statusBarTips:YES
                                authOptions:authOptions
                               shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                            oneKeyShareList:[NSArray defaultOneKeyShareList]
                             qqButtonHidden:NO
                      wxSessionButtonHidden:NO
                     wxTimelineButtonHidden:NO
                       showKeyboardOnAppear:NO
                          shareViewDelegate:appDelegate.viewDelegate
                        friendsViewDelegate:appDelegate.viewDelegate
                      picViewerViewDelegate:nil]
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                            if (state == SSPublishContentStateSuccess){
                                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                if (block) {
                                                    p.block = [block copy];
                                                    p.block(statusInfo);
                                                }
                                            }else if (state == SSPublishContentStateFail){
                                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                            }
                                        }];

        }
    }];
    /*二维码*/
    id<ISSShareActionSheetItem> codeitem = [ShareSDK shareActionSheetItemWithTitle:@"二维码"
                                 icon:[UIImage imageNamed:@"二维码"]
                         clickHandler:^{
                             YHAlertView * alert = [[YHAlertView alloc]initWithTitle:nil customView:nil delegate:VController buttonTitles:nil];
                             [alert show];
                                                                   }];
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                                                               container:nil
                                                                                 content:publishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                                                               container:nil
                                                                                 content:publishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          sinaItem,nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK
          defaultShareOptionsWithTitle:nil
                       oneKeyShareList:[NSArray defaultOneKeyShareList]
                        qqButtonHidden:NO
                 wxSessionButtonHidden:NO
                wxTimelineButtonHidden:NO
                  showKeyboardOnAppear:NO
                     shareViewDelegate:appDelegate.viewDelegate
                   friendsViewDelegate:appDelegate.viewDelegate
                 picViewerViewDelegate:nil]
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                       if (state == SSPublishContentStateSuccess){
                                       NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                           if (block) {
                                               p.block = [block copy];
                                               p.block(statusInfo);
                                           }
                                       }else if (state == SSPublishContentStateFail){
                                       NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                       }
                                  }];
}
//分享
+(void)showCustomShareListViewWithWxContent:(NSString *)WXcontent sinaWeiboContent:(NSString *)sinaWeiboContent title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description qrCodeSrc:(NSString *)qrCodesrc block:(shareCallBackBlock)block VController:(id)VController shareType:(ShareType)shareType, ...
{
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    PublicMethod * p = [[PublicMethod alloc]init ];
    //创建分享内容
    id<ISSContent> wxpublishContent = [ShareSDK content:WXcontent
                                         defaultContent:@""
                                                  image:[ShareSDK imageWithUrl:imageUrl]
                                                  title:title
                                                    url:url
                                            description:description
                                              mediaType:SSPublishContentMediaTypeNews];
    id<ISSContent>sinaClientpublishContent = [ShareSDK content:sinaWeiboContent
                                          defaultContent:@""
                                                   image:[ShareSDK imageWithUrl:imageUrl]
                                                   title:title
                                                     url:url
                                             description:description
                                               mediaType:SSPublishContentMediaTypeNews];
//    id<ISSContent>sinapublishContent = [ShareSDK content:sinaWeiboContent defaultContent:@"" image:[ShareSDK imageWithUrl:imageUrl] title:title url:url description:description mediaType:SSPublishContentMediaTypeApp];
/*
//    if (ShareTypeSinaWeibo) {
//        publishContent = [ShareSDK content:sinaWeiboContent
//                            defaultContent:@""
//                                     image:[ShareSDK imageWithUrl:imageUrl]
//                                     title:title
//                                       url:url
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//    }else{
//        
//        publishContent = [ShareSDK content:WXcontent
//                            defaultContent:@""
//                                     image:[ShareSDK imageWithUrl:imageUrl]
//                                     title:title
//                                       url:url
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//    
//    
//    
//    }
//    //定义点击事件
//    id clickHandler = ^{
//        //        AGCustomShareViewController *vc = [[[AGCustomShareViewController alloc] initWithImage:shareImage content:CONTENT] autorelease];
//        //        UINavigationController *naVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
//        //
//        //        if ([UIDevice currentDevice].isPad)
//        //        {
//        //            naVC.modalPresentationStyle = UIModalPresentationFormSheet;
//        //        }
//        //
//        //        [self presentModalViewController:naVC animated:YES];
//    };
 */
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //定义菜单分享列表
    /*新浪*/
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:
        ^{
        //调用微博客户端来发微博
        if([WeiboSDK isWeiboAppInstalled])
        {
            [ShareSDK clientShareContent:sinaClientpublishContent type:ShareTypeSinaWeibo statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
             {
                 if(state == SSPublishContentStateSuccess)
                 {                                                          if (block)
                    {
                        p.block = [block copy];
                        p.block(statusInfo);
                    }
                 }
                 else if (state == SSPublishContentStateFail)
                 {                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                 }
             }];
        }
        else
        {
            BOOL isAuth =[ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo];
            if (isAuth)
            {  //弹出一个分享内容界面
                NSDate *date = [NSDate date];
                NSLog(@"%@",date);
                ShareCustomViewController * view_login = [[ShareCustomViewController alloc] init];
                
                view_login.sina_content = sinaWeiboContent;
                view_login.title = title;
                view_login.imageUrl = imageUrl;
                view_login.page_url = url;
                view_login._description = description;
                UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:view_login];
                [VController presentViewController:nac animated:YES completion:^{}];
            }
            else
            {
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:appDelegate.viewDelegate];
                [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
                {
                    if (result)
                    {
                        ShareCustomViewController * view_login = [[ShareCustomViewController alloc] init];
                        view_login.sina_content = sinaWeiboContent;
                        view_login.title = title;
                        view_login.imageUrl = imageUrl;
                        view_login.page_url = url;
                        view_login._description = description;
                        UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:view_login];
                        [VController presentViewController:nac animated:YES completion:^{}];
                    }
                    else
                    {
                        if ([error errorCode] != -103)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")  message:NSLocalizedString(@"TEXT_BING_FAI", @"绑定失败!")  delegate:nil cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了") otherButtonTitles:nil];
                            [alertView show];
                            [alertView release];
                        }
                    }
                }];
            }
                                                                              
                                                                              
 /*
//                                                                              [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
//                                                                                                    container:container
//                                                                                                      content:sinapublishContent
//                                                                                                statusBarTips:YES
//                                                                                                  authOptions:authOptions
//                                                                                                 shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                                                                                                     oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                                                                                                      qqButtonHidden:NO
//                                                                                                                               wxSessionButtonHidden:NO
//                                                                                                                              wxTimelineButtonHidden:NO
//                                                                                                                                showKeyboardOnAppear:NO
//                                                                                                                                   shareViewDelegate:VController
//                                                                                                                                 friendsViewDelegate:appDelegate.viewDelegate
//                                                                                                                               picViewerViewDelegate:nil]
//                                                                                                       result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                                                                                           if (state == SSPublishContentStateSuccess){
//                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
//                                                                                                               if (block) {
//                                                                                                                   p.block = [block copy];
//                                                                                                                   p.block(statusInfo);
//                                                                                                               }
//                                                                                                           }else if (state == SSPublishContentStateFail){
//                                                                                                               
//                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                                                                                                           }
//                                                                                                       }];
                                                                              
    */                                                                      }
                                                                      }];
    /*二维码*/
       id<ISSShareActionSheetItem> codeitem = [ShareSDK shareActionSheetItemWithTitle:@"二维码"
                                                                              icon:[UIImage imageNamed:@"logo_qr_code"]
                                                                      clickHandler:^{
                                                                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 68,181 )];
                                                    view.backgroundColor = [UIColor clearColor];
                                                                          UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((view.width-156)/2, 0, 156, 156)];
                                                                          imageView.tag = 111;                      NSLog(@"%@",qrCodesrc);                      [imageView setImageWithURL:[NSURL URLWithString:qrCodesrc]];
                                                    [view addSubview:imageView];
                                                                          UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom, view.width, 15)];
                                                                          titleLabel.text = @"快让小伙伴们扫一扫";
                                                                          titleLabel.textAlignment = NSTextAlignmentCenter;
                                                                          titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
                                                                          titleLabel.font = [UIFont systemFontOfSize:15];
                                                                          [view addSubview:titleLabel];
                                                                                         YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"" customView:view
                                                    delegate:VController buttonTitle:@"保存"];
//                                                                          UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 296)];
//                                                                          [alert addSubview:view];
                                                    [alert showCodeView];
                                                            
                                                                      }];
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                                                               container:nil
                                                                                 content:wxpublishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                                                               container:nil
                                                                                 content:wxpublishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          sinaItem,codeitem,nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:nil
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK
                                    defaultShareOptionsWithTitle:nil
                                    oneKeyShareList:[NSArray defaultOneKeyShareList]
                                    qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                    wxTimelineButtonHidden:NO
                                    showKeyboardOnAppear:NO
                                    shareViewDelegate:appDelegate.viewDelegate
                                    friendsViewDelegate:appDelegate.viewDelegate
                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    if (block) {
                                        p.block = [block copy];
                                        p.block(statusInfo);
                                    }
                                }else if (state == SSPublishContentStateFail){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];



}
+ (void)showCustomShareListViewWithWxContent:(NSString *)WXcontent sinaWeiboContent:(NSString *)sinaWeiboContent flat:(NSInteger)flat title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description qrCodeSrc:(NSString *)qrCodesrc block:(shareCallBackBlock)block VController:(id)VController AlertViewController:(id)AlertViewController shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION
{
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    PublicMethod * p = [[PublicMethod alloc]init ];
    //创建分享内容
    id<ISSContent> wxpublishContent = [ShareSDK content:WXcontent
                                         defaultContent:@""
                                                  image:[ShareSDK imageWithUrl:imageUrl]
                                                  title:title
                                                    url:url
                                            description:description
                                              mediaType:SSPublishContentMediaTypeNews];
    id<ISSContent>sinaClientpublishContent = [ShareSDK content:sinaWeiboContent
                                                defaultContent:@""
                                                         image:[ShareSDK imageWithUrl:imageUrl]
                                                         title:title
                                                           url:url
                                                   description:description
                                                     mediaType:SSPublishContentMediaTypeNews];
//    id<ISSContent>sinapublishContent = [ShareSDK content:sinaWeiboContent defaultContent:@"" image:[ShareSDK imageWithUrl:imageUrl] title:title url:url description:description mediaType:SSPublishContentMediaTypeApp];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //定义菜单分享列表
    /*新浪*/
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo] clickHandler:
                                            ^{
                                                //调用微博客户端来发微博
                                                if([WeiboSDK isWeiboAppInstalled])
                                                {
                                                    [ShareSDK clientShareContent:sinaClientpublishContent type:ShareTypeSinaWeibo statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
                                                     {
                                                         if(state == SSPublishContentStateSuccess)
                                                         {                                                          if (block)
                                                         {
                                                             p.block = [block copy];
                                                             p.block(statusInfo);
                                                         }
                                                         }
                                                         else if (state == SSPublishContentStateFail)
                                                         {                                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                                         }
                                                     }];
                                                }
                                                else
                                                {
                                                    BOOL isAuth =[ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo];
                                                    if (isAuth)
                                                    {  //弹出一个分享内容界面
                                                        NSDate *date = [NSDate date];
                                                        NSLog(@"%@",date);
                                                        ShareCustomViewController * view_login = [[ShareCustomViewController alloc] init];
                                                        
                                                        view_login.sina_content = sinaWeiboContent;
                                                        view_login.title = title;
                                                        view_login.imageUrl = imageUrl;
                                                        view_login.page_url = url;
                                                        view_login._description = description;
                                                        UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:view_login];
                                                        [VController presentViewController:nac animated:YES completion:^{}];
                                                    }
                                                    else
                                                    {
                                                        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:appDelegate.viewDelegate];
                                                        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
                                                         {
                                                             if (result)
                                                             {
                                                                 ShareCustomViewController * view_login = [[ShareCustomViewController alloc] init];
                                                                 view_login.sina_content = sinaWeiboContent;
                                                                 view_login.title = title;
                                                                 view_login.imageUrl = imageUrl;
                                                                 view_login.page_url = url;
                                                                 view_login._description = description;
                                                                 UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:view_login];
                                                                 [VController presentViewController:nac animated:YES completion:^{}];
                                                             }
                                                             else
                                                             {
                                                                 if ([error errorCode] != -103)
                                                                 {
                                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")  message:NSLocalizedString(@"TEXT_BING_FAI", @"绑定失败!")  delegate:nil cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了") otherButtonTitles:nil];
                                                                     [alertView show];
                                                                     [alertView release];
                                                                 }
                                                             }
                                                         }];
                                                    }
                                                    
                                                    
                                                    /*
                                                     //                                                                              [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                                     //                                                                                                    container:container
                                                     //                                                                                                      content:sinapublishContent
                                                     //                                                                                                statusBarTips:YES
                                                     //                                                                                                  authOptions:authOptions
                                                     //                                                                                                 shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                     //                                                                                                                                     oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                     //                                                                                                                                      qqButtonHidden:NO
                                                     //                                                                                                                               wxSessionButtonHidden:NO
                                                     //                                                                                                                              wxTimelineButtonHidden:NO
                                                     //                                                                                                                                showKeyboardOnAppear:NO
                                                     //                                                                                                                                   shareViewDelegate:VController
                                                     //                                                                                                                                 friendsViewDelegate:appDelegate.viewDelegate
                                                     //                                                                                                                               picViewerViewDelegate:nil]
                                                     //                                                                                                       result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                     //                                                                                                           if (state == SSPublishContentStateSuccess){
                                                     //                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                     //                                                                                                               if (block) {
                                                     //                                                                                                                   p.block = [block copy];
                                                     //                                                                                                                   p.block(statusInfo);
                                                     //                                                                                                               }
                                                     //                                                                                                           }else if (state == SSPublishContentStateFail){
                                                     //
                                                     //                                                                                                               NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                     //                                                                                                           }
                                                     //                                                                                                       }];
                                                     
                                                     */                                                                      }
                                            }];
    /*二维码*/
    NSString *title1;
    if(flat == 1){
        title1 = @"商品二维码分享";
    }else if(flat == 0){
        title1 = @"活动二维码分享";
    }else{
        title1 = @"菜谱二维码分享";
    }
    id<ISSShareActionSheetItem> codeitem = [ShareSDK shareActionSheetItemWithTitle:@"二维码"
                                                                              icon:[UIImage imageNamed:@"logo_qr_code"]
                                                                      clickHandler:^{
                                                                          UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 68,181 )];
                                                                          view.backgroundColor = [UIColor clearColor];
                                                                          UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((view.width-156)/2, 0, 156, 156)];
                                                                          imageView.tag = 111;                      NSLog(@"%@",qrCodesrc);                      [imageView setImageWithURL:[NSURL URLWithString:qrCodesrc]];
                                                                          [view addSubview:imageView];
                                                                          UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom, view.width, 15)];
                                                                          titleLabel.text = @"快让小伙伴们扫一扫";
                                                                          titleLabel.textAlignment = NSTextAlignmentCenter;
                                                                          titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
                                                                          titleLabel.font = [UIFont systemFontOfSize:15];
                                                                          [view addSubview:titleLabel];
                                                                          YHAlertView * alert = [[YHAlertView alloc]initWithTitle:title1 customView:view
                                                                                                                         delegate:AlertViewController buttonTitle:@"保存"];
                                                                          //                                                                          UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 296)];
                                                                          //                                                                          [alert addSubview:view];
                                                                          [alert showCodeView];
                                                                          
                                                                      }];
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiSession]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiSession]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                                                                               container:nil
                                                                                 content:wxpublishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeWeixiTimeline]
                                                             icon:[ShareSDK getClientIconWithType:ShareTypeWeixiTimeline]
                                                     clickHandler:^{
                                                         [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                                                                               container:nil
                                                                                 content:wxpublishContent
                                                                           statusBarTips:YES
                                                                             authOptions:authOptions
                                                                            shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                                                                oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                                                                 qqButtonHidden:NO
                                                                                                          wxSessionButtonHidden:NO
                                                                                                         wxTimelineButtonHidden:NO
                                                                                                           showKeyboardOnAppear:NO
                                                                                                              shareViewDelegate:appDelegate.viewDelegate
                                                                                                            friendsViewDelegate:appDelegate.viewDelegate
                                                                                                          picViewerViewDelegate:nil]
                                                                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                      
                                                                                      if (state == SSPublishContentStateSuccess)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                                                                      }
                                                                                      else if (state == SSPublishContentStateFail)
                                                                                      {
                                                                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                                                                      }
                                                                                  }];
                                                         
                                                     }],
                          sinaItem,codeitem,nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:nil
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK
                                    defaultShareOptionsWithTitle:nil
                                    oneKeyShareList:[NSArray defaultOneKeyShareList]
                                    qqButtonHidden:NO
                                    wxSessionButtonHidden:NO
                                    wxTimelineButtonHidden:NO
                                    showKeyboardOnAppear:NO
                                    shareViewDelegate:appDelegate.viewDelegate
                                    friendsViewDelegate:appDelegate.viewDelegate
                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    if (block) {
                                        p.block = [block copy];
                                        p.block(statusInfo);
                                    }
                                }else if (state == SSPublishContentStateFail){
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];





}

+(CGSize)getLabelSize:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    CGSize labelSize = [text sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:lineBreakMode];
    return labelSize;
}

@end
