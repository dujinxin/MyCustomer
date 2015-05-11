//
//  UserAccount.m
//  THCustomer
//
//  Created by lichentao on 13-8-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//


#import "UserAccount.h"
#import "YHPromotionViewController.h"

@implementation UserAccount
//这是一个单例
+ (UserAccount *)instance {
    static UserAccount *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[UserAccount alloc] init];
    });
    
    return _obj;
}
/*
@property (nonatomic, strong) NSString *user_icon;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *true_name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *session_id;
@property (nonatomic, strong) NSString *region_id;
@property (nonatomic, strong) NSString *location_CityName;
@property (nonatomic, copy) NSString *login_type;     // 0:普通登陆 1:第三方 2:天虹登陆

@property (nonatomic, assign)BOOL  isSinaAuthorize;
@property (nonatomic, assign)BOOL  isTencentAuthorize;
*/
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user_icon forKey:@"user_icon"];
      [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.login_user_name forKey:@"login_user_name"];
      [aCoder encodeObject:self.mobile forKey:@"mobile"];
      [aCoder encodeObject:self.user_name forKey:@"user_name"];
      [aCoder encodeObject:self.email forKey:@"email"];
      [aCoder encodeObject:self.true_name forKey:@"true_name"];
      [aCoder encodeObject:self.gender forKey:@"gender"];
      [aCoder encodeObject:self.intro forKey:@"intro"];
      [aCoder encodeObject:self.session_id forKey:@"session_id"];
      [aCoder encodeObject:self.region_id forKey:@"region_id"];
    [aCoder encodeObject:self.location_CityName forKey:@"location_CityName"];
    [aCoder encodeObject:self.login_type forKey:@"login_type"];
    [aCoder encodeBool:self.isSinaAuthorize forKey:@"isSinaAuthorize"];
     [aCoder encodeBool:self.isTencentAuthorize forKey:@"isTencentAuthorize"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.user_icon = [aDecoder decodeObjectForKey:@"user_icon"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.login_user_name = [aDecoder decodeObjectForKey:@"login_user_name"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.true_name = [aDecoder decodeObjectForKey:@"true_name"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.intro = [aDecoder decodeObjectForKey:@"intro"];
        self.session_id = [aDecoder decodeObjectForKey:@"session_id"];
        self.region_id = [aDecoder decodeObjectForKey:@"region_id"];
        self.location_CityName = [aDecoder decodeObjectForKey:@"location_CityName"];
        self.login_type = [aDecoder decodeObjectForKey:@"login_type"];
        self.isSinaAuthorize = [aDecoder decodeBoolForKey:@"isSinaAuthorize"];
        self.isTencentAuthorize = [aDecoder decodeBoolForKey:@"isTencentAuthorize"];
        }
    return self;
}

- (NSString *)savePath
{
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *preferencePath = [pathArray objectAtIndex:0];
    NSString * strHome = NSHomeDirectory();
    NSString * preferencePath = [NSString stringWithFormat:@"%@/Library/Preferences" , strHome];
    NSString *savePath = [preferencePath stringByAppendingString:@"/Account.plist"];
    NSLog(@"用户信息储存地点：%@",savePath);
    return savePath;
}

- (id)init {
    self = [super init];
    if (self)
    {
        NSString *savePath = [self savePath];
        NSFileManager *df = [NSFileManager defaultManager];
        if ([df fileExistsAtPath:savePath])
        {
            NSDictionary *accountInfo = [NSDictionary dictionaryWithContentsOfFile:savePath];
            [self restoreAccount:accountInfo];
        }
    }
    
    return self;
}

-(void)logoutPassive
{
    //    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"session_id"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"cartNum"];
    
    
    //配送相关保存信息清空
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"address"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"paymentStyle"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"storeInfo"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.session_id = @"";
    self.true_name = nil;
    self.user_id = nil;
    self.login_user_name = nil;
    self.user_name = nil;
    self.mobile = nil;
    self.gender = nil;
    self.intro = nil;
    self.email = nil;
    self.login_type = nil;
    self.user_icon = nil;
    NSString *savePath = [self savePath];
    NSFileManager *df = [NSFileManager defaultManager];
    if ([df fileExistsAtPath:savePath]) {
        [df removeItemAtPath:savePath error:nil];
        //清除登陆用户的信息，但是保留定位城市信息
        [self saveAccount];
    }
}


- (void)restoreAccount:(NSDictionary *)accountInfo{

    if ([accountInfo objectForKey:@"user_id"]) {
        self.user_id = [accountInfo objectForKey:@"user_id"];
    }
    if ([accountInfo objectForKey:@"login_user_name"]) {
        self.login_user_name = [accountInfo objectForKey:@"login_user_name"];
    }
    if ([accountInfo objectForKey:@"mobile"]) {
        self.mobile = [accountInfo objectForKey:@"mobile"];
    }
    if ([accountInfo objectForKey:@"photo_url"]) {
        self.user_icon = [accountInfo objectForKey:@"photo_url"];
    }
    if ([accountInfo objectForKey:@"email"]) {
        self.email = [accountInfo objectForKey:@"email"];
    }
    if ([accountInfo objectForKey:@"user_name"]) {
        self.user_name = [accountInfo objectForKey:@"user_name"];
    }
    if ([accountInfo objectForKey:@"true_name"]) {
        self.true_name = [accountInfo objectForKey:@"true_name"];
    }
    if ([accountInfo objectForKey:@"gender"]) {
        self.gender = [accountInfo objectForKey:@"gender"];
    }
    if ([accountInfo objectForKey:@"intro"]) {
        self.intro = [accountInfo objectForKey:@"intro"];
    }
    if ([accountInfo objectForKey:@"session_id"]) {
        self.session_id = [accountInfo objectForKey:@"session_id"];
    }
    if ([accountInfo objectForKey:@"login_type"]) {
        self.login_type = [accountInfo objectForKey:@"login_type"];
    }
    if ([accountInfo objectForKey:@"region_id"]) {
        self.region_id = [accountInfo objectForKey:@"region_id"];
    }
    if ([accountInfo objectForKey:@"location_CityName"]) {
        self.location_CityName = [accountInfo objectForKey:@"location_CityName"];
    }
}

- (void)updateAccount:(NSDictionary *)accountInfo {
    [self restoreAccount:accountInfo];
    [self saveAccount];
}

- (BOOL)isLogin {
    if (self.session_id && (self.session_id.length > 0)&&self.mobile&&(self.mobile.length > 0))
    {
        return YES;
    }
    NSLog(@"%@",self.mobile);
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
    return NO;
}

//- (void)logout {
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"passWord"];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"session_id"];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"cartNum"];
//    
//    
//    //配送相关保存信息清空
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"address"];
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"paymentStyle"];
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"storeInfo"];
//
//    [[NSUserDefaults standardUserDefaults]synchronize];
////    self.session_id = nil;
//    self.true_name = nil;
//    self.user_id = nil;
//    self.user_name = nil;
//    self.mobile = nil;
//    self.gender = nil;
//    self.intro = nil;
//    self.email = nil;
//    self.login_type = nil;
//    self.user_icon = nil;
////    NSString *savePath = [self savePath];
////    NSFileManager *df = [NSFileManager defaultManager];
////    if ([df fileExistsAtPath:savePath]) {
////        [df removeItemAtPath:savePath error:nil];
////    }
//}
- (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"login_user_name"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"session_id"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"cartNum"];
    
    
    //配送相关保存信息清空
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"address"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"paymentStyle"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"storeInfo"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.session_id = @"";
    self.true_name = nil;
    self.user_id = nil;
    self.user_name = nil;
    self.login_user_name = nil;
    self.mobile = nil;
    self.gender = nil;
    self.intro = nil;
    self.email = nil;
    self.login_type = nil;
    self.user_icon = nil;
    NSString *savePath = [self savePath];
    NSFileManager *df = [NSFileManager defaultManager];
    if ([df fileExistsAtPath:savePath]) {
        [df removeItemAtPath:savePath error:nil];
        //清除登陆用户的信息，但是保留定位城市信息
        [self saveAccount];
    }
    
}


- (void)saveAccount {
    NSString *savePath = [self savePath];
    NSMutableDictionary *saveAccount = [NSMutableDictionary dictionary];

    if (self.user_id) {
        [saveAccount setValue:self.user_id forKey:@"user_id"];
    }
    if (self.login_user_name) {
        [saveAccount setValue:self.login_user_name forKey:@"login_user_name"];
    }
    if (self.mobile) {
        [saveAccount setValue:self.mobile forKey:@"mobile"];
    }
    if (self.email) {
        [saveAccount setValue:self.email forKey:@"email"];
    }
    if (self.user_name) {
        [saveAccount setValue:self.user_name forKey:@"user_name"];
    }
    if (self.true_name) {
        [saveAccount setValue:self.true_name forKey:@"true_name"];
    }
    if (self.gender) {
        [saveAccount setValue:self.gender forKey:@"gender"];
    }
    if (self.intro) {
        [saveAccount setValue:self.intro forKey:@"intro"];
    }
    if (self.login_type) {
        [saveAccount setValue:self.login_type forKey:@"login_type"];
    }
    if (self.user_icon) {
        [saveAccount setValue:self.user_icon forKey:@"photo_url"];
    }
    if (self.session_id) {
        [saveAccount setValue:self.session_id forKey:@"session_id"];
    }else{
        [saveAccount setValue:@"" forKey:@"session_id"];
    }
    if (self.region_id) {
        [saveAccount setValue:self.region_id forKey:@"region_id"];
    }
    if (self.location_CityName) {
        [saveAccount setValue:self.location_CityName forKey:@"location_CityName"];
    }

    [saveAccount writeToFile:savePath atomically:YES];
}

@end


@implementation CityInfo

+ (CityInfo *)instance {
    static CityInfo *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[CityInfo alloc] init];
        [_obj writeToPlist];
    });
    
    return _obj;
}

- (NSString *)savePath1 {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *preferencePath = [pathArray objectAtIndex:0];
    NSString *savePath = [preferencePath stringByAppendingString:@"/CityList.plist"];
    return savePath;
}

-(void)writeToPlist{
    NSString *context1 = @"中国:1,安徽:23,福建:16,甘肃:6,广东:7,广西:17,贵州:24,海南:21,河北:25,黑龙江:2,河南:30,湖北:15,湖南:26,江苏:18,江西:31,吉林省:9,辽宁:19,内蒙古:22,宁夏:20,青海:11,山东:8,山西:10,陕西:27,四川:32,新疆:12,西藏:13,云南:28,浙江:29,北京:131,天津:332,石家庄:150,唐山:265,秦皇岛:148,邯郸:151,邢台:266,保定:307,张家口:264,承德:207,沧州:149,廊坊:191,衡水:208,太原:176,大同:355,阳泉:357,长治:356,晋城:290,朔州:237,晋中:238,运城:328,忻州:367,临汾:368,吕梁:327,呼和浩特:321,包头:229,乌海:123,赤峰:297,通辽:64,鄂尔多斯:283,呼伦贝尔:61,巴彦淖尔:169,乌兰察布:168,兴安盟:62,锡林郭勒盟:63,阿拉善盟:230,沈阳:58,大连:167,鞍山:320,抚顺:184,本溪:227,丹东:282,锦州:166,营口:281,阜新:59,辽阳:351,盘锦:228,铁岭:60,朝阳:280,葫芦岛:319,长春:53,吉林市:55,四平:56,辽源:183,通化:165,白山:57,松原:52,白城:51,延边朝鲜族自治州:54,哈尔滨:48,齐齐哈尔:41,鸡西:46,鹤岗:43,双鸭山:45,大庆:50,伊春:40,佳木斯:42,七台河:47,牡丹江:49,黑河:39,绥化:44,大兴安岭地区:38,上海:289,南京:315,无锡:317,徐州:316,常州:348,苏州:224,南通:161,连云港:347,淮安:162,盐城:223,扬州:346,镇江:160,泰州:276,宿迁:277,杭州:179,宁波:180,温州:178,嘉兴:334,湖州:294,绍兴:293,金华:333,衢州:243,舟山:245,台州:244,丽水:292,合肥:127,芜湖:129,蚌埠:126,淮南:250,马鞍山:358,淮北:253,铜陵:337,安庆:130,黄山:252,滁州:189,阜阳:128,宿州:370,巢湖:251,六安:298,亳州:188,池州:299,宣城:190,福州:300,厦门:194,莆田:195,三明:254,泉州:134,漳州:255,南平:133,龙岩:193,宁德:192,南昌:163,景德镇:225,萍乡:350,九江:349,新余:164,鹰潭:279,赣州:365,吉安:318,宜春:278,抚州:226,上饶:364,济南:288,青岛:236,淄博:354,枣庄:172,东营:174,烟台:326,潍坊:287,济宁:286,泰安:325,威海:175,日照:173,莱芜:124,临沂:234,德州:372,聊城:366,滨州:235,菏泽:353,郑州:268,开封:210,洛阳:153,平顶山:213,安阳:267,鹤壁:215,新乡:152,焦作:211,濮阳:209,许昌:155,漯河:344,三门峡:212,南阳:309,商丘:154,信阳:214,周口:308,驻马店:269,武汉:218,黄石:311,十堰:216,宜昌:270,襄阳:156,鄂州:122,荆门:217,孝感:310,荆州:157,黄冈:271,咸宁:362,随州:371,恩施土家族苗族自治州:373,仙桃:1713,潜江:1293,天门:2654,神农架林区:2734,长沙:158,株洲:222,湘潭:313,衡阳:159,邵阳:273,岳阳:220,常德:219,张家界:312,益阳:272,郴州:275,永州:314,怀化:363,娄底:221,湘西土家族苗族自治州:274,广州:257,韶关:137,深圳:340,珠海:140,汕头:303,佛山:138,江门:302,湛江:198,茂名:139,肇庆:338,惠州:301,梅州:141,汕尾:339,河源:200,阳江:199,清远:197,东莞:119,中山:187,潮州:201,揭阳:259,云浮:258,南宁:261,柳州:305,桂林:142,梧州:304,北海:295,防城港:204,钦州:145,贵港:341,玉林:361,百色:203,贺州:260,河池:143,来宾:202,崇左:144,海口:125,三亚:121,五指山:1644,琼海:2358,儋州:1215,文昌:2758,万宁:1216,东方:2634,定安:1214,屯昌:1641,澄迈:2757,临高:2033,白沙黎族自治:2359,昌江黎族自治:1642,乐东黎族自治:2032,陵水黎族自治:1643,保亭黎族苗族自治:1217,琼中黎族苗族自治:2031,重庆:132,成都:75,自贡:78,攀枝花:81,泸州:331,德阳:74,绵阳:240,广元:329,遂宁:330,内江:248,乐山:79,南充:291,眉山:77,宜宾:186,广安:241,达州:369,雅安:76,巴中:239,资阳:242,阿坝藏族羌族自治州:185,甘孜藏族自治州:73,凉山彝族自治州:80,贵阳:146,六盘水:147,遵义:262,安顺:263,铜仁地区:205,黔西南布依族苗族自治州:343,毕节地区:206,黔东南苗族侗族自治州:342,黔南布依族苗族自治州:306,昆明:104,曲靖:249,玉溪:106,保山:112,昭通:336,丽江:114,临沧:110,楚雄彝族自治州:105,红河哈尼族彝族自治州:107,文山壮族苗族自治州:177,普洱:108,西双版纳傣族自治州:109,大理白族自治州:111,德宏傣族景颇族自治州:116,怒江傈僳族自治州:113,迪庆藏族自治州:115,拉萨:100,昌都地区:99,山南地区:97,日喀则地区:102,那曲地区:101,阿里地区:103,林芝地区:98,西安:233,铜川:232,宝鸡:171,咸阳:323,渭南:170,延安:284,汉中:352,榆林:231,安康:324,商洛:285,兰州:36,嘉峪关:33,金昌:34,白银:35,天水:196,武威:118,张掖:117,平凉:359,酒泉:37,庆阳:135,定西:136,陇南:256,临夏回族自治州:182,甘南藏族自治州:247,西宁:66,海东地区:69,海北藏族自治州:67,黄南藏族自治州:70,海南藏族自治州:68,果洛藏族自治州:72,玉树藏族自治州:71,海西蒙古族藏族自治州:65,银川:360,石嘴山:335,吴忠:322,固原:246,中卫:181,乌鲁木齐:92,克拉玛依:95,吐鲁番地区:89,哈密地区:91,昌吉回族自治州:93,博尔塔拉蒙古自治州:88,巴音郭楞蒙古自治州:86,阿克苏地区:85,克孜勒苏柯尔克孜自治州:84,喀什地区:83,和田地区:82,伊犁哈萨克自治州:90,塔城地区:94,阿勒泰地区:96,石河子:770,阿拉尔:731,图木舒克:792,五家渠:789,香港特别行政区:2912,澳门特别行政区:2911";
    
    NSArray *array1 = [context1 componentsSeparatedByString:@","];

    NSMutableArray *formartArray = [NSMutableArray array];
    for (int i = 0;i < array1.count ;i ++) {
        NSString *oneItem = [array1 objectAtIndex:i];
        NSRange range = [oneItem rangeOfString:@":"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *cityName = [oneItem substringToIndex:range.location];
        NSString *cityCode = [oneItem substringFromIndex:range.location+1];
        
        [dic setObject:cityName forKey:@"cityName"];
        [dic setObject:cityCode forKey:@"cityCode"];
        
        [formartArray addObject:dic];
    }
    [formartArray writeToFile:[self savePath1] atomically:YES];
}

// 通过传入的城市名称－查询对应的城市code
- (NSString *)getCityCode:(NSString *)locationCity{
    NSMutableArray *cityArray = [NSMutableArray arrayWithContentsOfFile:[self savePath1]];
    for (NSDictionary *dic in cityArray) {
        NSString * cityName = [dic objectForKey:@"cityName"];
        if ([locationCity rangeOfString:cityName].length > 0) {
            return [dic objectForKey:@"cityCode"];
        }
    }
    return nil;
}

@end


