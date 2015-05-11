//
//  YHSearchResultsViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHSearchResultsViewController.h"
#import "YHTabButton.h"
#import "YHPromotionListCell.h"
#import "YHScreenViewCell.h"
#import "YHGoodsDetailViewController.h"
#import "YHCartViewController.h"
#import "YHLeftButton.h"
#import "YHCategoryView.h"
#import "YHNewOrderViewController.h"


typedef enum{
    kLeftItemTag = 1000,
    kRightItemTag,
    
    kRightCellTag = 1010,
    
    kDeleteButtonTag = 1100,
    kRightButtonTag ,
    
    kTopAllButtonTag = 2000,
    kTopSortButtonTag,
    kTopSellNumButtonTag,
    kTopPriseButtonTag,
    
    kSortButtonTag = 2100,
    
}ButtonTag;

@interface YHSearchResultsViewController ()
{
    NSMutableArray * _mainDataArray;
    NSMutableArray * _rightDataArray;
    BOOL showRightView;
    BOOL isSelectedScreen;
    
    UIView * bgView;
    UISwipeGestureRecognizer * swipe1;
    UISwipeGestureRecognizer * swipe2;
    UIImageView * navigationBar;
    UIButton * leftItem;
    UIButton * rightItem;
    UIView * tabBgView;
    
    UIView * rightMainBgView;
    
    NSMutableArray *goodsData;
    NSMutableArray *enoughGoodsData;
    BOOL enoughGoods;
    
    NSMutableDictionary *params;
    
    YHCartView *cartView;
    YHCategoryView * categoryView;
    UIImageView *checkView;
    UIView *sortListView;
    UIView *shadow;
    
    NSString *bu_category_id_default;
    NSString *category_type;
//    NSString *cotegory_code;
    
    UIView *nullView;
    UIImageView *nullImage;
    UILabel * nullInfo;
    BOOL isRequestSuccess;
    
    NSString * _goods_id;
    NSString * _total;
}

@end

@implementation YHSearchResultsViewController

@synthesize textField = _textField;
@synthesize rightTableView = _rightTableView;
@synthesize mainTableView = _mainTableView;
@synthesize index = _index;
@synthesize screenString = _screenString;
@synthesize keyWord = _keyWord;
@synthesize hostReach = _hostReach;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    [MBProgressHUD showHUDAddedTo:nullView animated:YES ];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.5];
//    //开启网络状况的监听
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        [MBProgressHUD hideHUDForView:nullView animated:YES];
        [nullView setHidden:NO];
        [nullView addSubview:nullImage];
        [nullView addSubview:nullInfo];
    }
    //网络判断
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
        NSString * connectionState = [response.allHeaderFields objectForKey:@"Connection"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //连着WiFi但是网络不通 / 没有连接任何网络
            if ([connectionState isEqualToString:@"close"] || response == nil) {
                NSLog(@"没有网络");
                
                [MBProgressHUD hideHUDForView:nullView animated:YES];
                [nullView setHidden:NO];
                [nullView addSubview:nullImage];
                [nullView addSubview:nullInfo];
            }
            else{
                NSLog(@"网络是通的");
            }
        });
        
    });
    
    
    
    if (cartView) {
        [cartView changeCartNum];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE3];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MTA trackPageViewBegin:PAGE3];
    
    self.view.backgroundColor = [UIColor whiteColor];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 2-40, SCREEN_HEIGHT)];
    bgView.userInteractionEnabled = YES;
    
    [self.view insertSubview:bgView atIndex:0];
    
    [self initData];
    
    [self addTableView];
    
    [self initShadowView];
    [self initMoreView];
    [self initCategoryView];
    
    [self addNavigationView];
    [self addTabView];
    
    [self addCartView];
    [self addNullView];
    [self addRightView];
    
//    [self addRefreshTableFooterView];
    
}

#pragma mark - InitData
- (void)initData
{
    _mainDataArray = [[NSMutableArray alloc]init];
    _rightDataArray = [[NSMutableArray alloc]init];
    showRightView = NO;
    isSelectedScreen = NO;
    _index = 0;
    
    goodsData = [NSMutableArray array];
    enoughGoodsData = [NSMutableArray array];
    enoughGoods = NO;
    isRequestSuccess = NO;
    
    
    [_rightDataArray addObject:@"品牌"];

}
#pragma mark - InitUI

- (void)addNavigationView
{
    UIView * statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    statusBar.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:statusBar];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    line.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
    
    navigationBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    navigationBar.image = [UIImage imageNamed:@"nav_Bg"];
    navigationBar.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    navigationBar.userInteractionEnabled = YES;
    [bgView addSubview:navigationBar];
    [navigationBar addSubview:line];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(44, 7.5, SCREEN_WIDTH -96, 29)];
    _textField.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.layer.borderColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate = self;
    [navigationBar addSubview:_textField];
    
    //左边item
    leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(7, 7, 30, 30);
    leftItem.tag = kLeftItemTag;
    [leftItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [navigationBar addSubview:leftItem];
    
    //右边item
    rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH-52, 0, 52, 44);
    rightItem.tag = kRightItemTag;
    [rightItem setEnabled:NO];
    [rightItem setTitle:@"筛选" forState:UIControlStateNormal];
    [rightItem setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect"] forState:UIControlStateNormal];
//    [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect_press.png"] forState:UIControlStateHighlighted];
    [rightItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:rightItem];
}
- (void)addTabView{
    tabBgView = [[UIView alloc]initWithFrame:CGRectMake(0, navigationBar.bottom, SCREEN_WIDTH, 35)];
    [bgView addSubview:tabBgView];
    [self addTopTabView];
}
- (void)addTopTabView{
    NSArray * titleArray = [NSArray arrayWithObjects:@"全部商品",@"默认排序",nil];
    
    for (int i = 0 ; i < 2 ; i ++ ) {
        
        YHTabButton * btn = [[YHTabButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2.f)* i, 0, SCREEN_WIDTH/2.f , 35) title:[titleArray objectAtIndex:i] image:[UIImage imageNamed:@"arrow_selected"]];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        btn.tag = kTopAllButtonTag + i;
        btn.titleView.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
        //竖线
        if (i < 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f -1, 10, 1, 15)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
            [btn addSubview:line];
        }
        if (i == 2) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //下拉箭头
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width - 16, 14, 6, 7)];
            arrow.tag = 1;
            [arrow setImage:[UIImage imageNamed:@"arrow_"]];
            [btn addSubview:arrow];
        }
        [tabBgView addSubview:btn];
    }
    
    UIView *line_sep = [[UIView alloc]initWithFrame:CGRectMake(0,34, 320, 1)];
    line_sep.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [tabBgView addSubview:line_sep];
}
- (void)addTopTabView1{
    NSArray * titleArray = [NSArray arrayWithObjects:@"全部商品",@"更多排序",nil];
    for (int i = 0 ; i < 2 ; i ++ ) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((SCREEN_WIDTH/2.f)* i, 0, SCREEN_WIDTH/2.f , 35);
        [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        btn.contentEdgeInsets = UIEdgeInsetsMake(2,3, 0, 0);
        btn.tag = kTopAllButtonTag + i;
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
        //竖线
        if (i == 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0f -1, 10, 1, 15)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
            [btn addSubview:line];
        }
        if (i < 2) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //下拉箭头
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width - 16, 14, 6, 7)];
            arrow.tag = 1;
            [arrow setImage:[UIImage imageNamed:@"arrow_"]];
            [btn addSubview:arrow];
        }else{
            btn.contentEdgeInsets = UIEdgeInsetsMake(2,3, 0, 0);
            //双向排序箭头
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, 6, 7)];
            arrow.tag = 1;
            [arrow setImage:[UIImage imageNamed:@"arrow_for_order"]];
            [btn addSubview:arrow];
        }
        [tabBgView addSubview:btn];
    }
    
    UIView *line_sep = [[UIView alloc]initWithFrame:CGRectMake(0,34, 320, 1)];
    line_sep.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [tabBgView addSubview:line_sep];
}
- (void)addTableView
{
    self._tableView.frame = CGRectMake(0, 64+35, SCREEN_WIDTH, SCREEN_HEIGHT - 64-35);
    self._tableView.backgroundColor = LIGHT_GRAY_COLOR;
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
    [swipe1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipe1.cancelsTouchesInView = NO;
    [self._tableView addGestureRecognizer:swipe1];

    [bgView addSubview:self._tableView];
}
- (void)addRightView{
    
    UIView * rightHeadView  = [[UIView alloc ]initWithFrame:CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH - 35, 44)];
    rightHeadView.backgroundColor = [PublicMethod colorWithHexValue:0x343434 alpha:1.0];
    [bgView addSubview:rightHeadView];
    

    UIButton * backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    backItem.frame = CGRectMake(SCREEN_WIDTH -40 -80, 7, 50, 30);
    backItem.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [backItem setTitle:@"确定" forState:UIControlStateNormal];
    [backItem setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    backItem.tag = kRightButtonTag ;
    [rightHeadView addSubview:backItem];
    
    
    rightMainBgView = [[UIView alloc ]initWithFrame:CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH - 40 , SCREEN_HEIGHT -20-44)];
    rightMainBgView.backgroundColor = [PublicMethod colorWithHexValue:0x404040 alpha:1.0];
    rightMainBgView.userInteractionEnabled = YES;
    
//    swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeAction:)];
//    [swipe1 setDirection:UISwipeGestureRecognizerDirectionLeft];
//    swipe1.cancelsTouchesInView = NO;
//    [rightMainBgView addGestureRecognizer:swipe1];
    
    swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeAction:)];
    [swipe2 setDirection:UISwipeGestureRecognizerDirectionRight];
    swipe2.cancelsTouchesInView = NO;
    [rightMainBgView addGestureRecognizer:swipe2];
    
    //    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40 , SCREEN_HEIGHT -20-44) style:UITableViewStylePlain];
    //    _rightTableView.backgroundColor = [PublicMethod colorWithHexValue:0x404040 alpha:1.0];
    //    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _rightTableView.scrollEnabled = NO;
    //    _rightTableView.delegate = self;
    //    _rightTableView.dataSource = self;
    //    [rightMainBgView addSubview:_rightTableView];
    
    CGFloat height = 0;
    for (int i = 0 ; i < _rightDataArray.count; i ++) {
        YHLeftButton * btn = [YHLeftButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 , i *45, SCREEN_WIDTH -40, 45);
        btn.tag = kRightCellTag + i;
        btn.backgroundColor = [PublicMethod colorWithHexValue:0x3d3d3d alpha:1.0];
        btn.categoryName.text = [_rightDataArray objectAtIndex:i];
        btn.selectName.text = @"";
        [btn addTarget:self action:@selector(rightCellClick:) forControlEvents:UIControlEventTouchUpInside];
        height += 45;
        [rightMainBgView addSubview:btn];
    }
    NSArray * array = [NSArray arrayWithObjects:@"清空筛选",@"确定", nil];
    for (int i = 0 ; i < array.count ; i ++ ) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
            btn.frame = CGRectMake(10 ,height + 20, 110.f,40);
        }else{
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0]];
            btn.frame = CGRectMake(130,height + 20,140.f,40);
        }
        
        btn.tag = kDeleteButtonTag + i;
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightMainBgView addSubview:btn];
    }
    
    [bgView addSubview:rightMainBgView];
//    [bgView insertSubview:rightMainBgView atIndex:0];
    
}

#pragma mark - ============================================
-(void)addNullView {
    nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44-20)];
    nullView.backgroundColor = [UIColor whiteColor];
    
    [nullView setHidden:NO];
    [bgView addSubview:nullView];
//    [bgView insertSubview:info aboveSubview:self._tableView];
    
    nullImage = [[UIImageView alloc] initWithFrame:CGRectMake(110.75, 100, 98.5, 96)];
    [nullImage setImage:[UIImage imageNamed:@"search_is_null"]];
//    [info addSubview:image];
    
    nullInfo = [PublicMethod addLabel:CGRectMake(0, nullImage.bottom + 20, SCREEN_WIDTH, 20) setTitle:@"抱歉，没有找到符合条件的商品！" setBackColor:[PublicMethod colorWithHexValue:0x999999 alpha:1.0] setFont:[UIFont systemFontOfSize: 12.0]];
    nullInfo.textAlignment = NSTextAlignmentCenter;
//    [info addSubview:nullInfo];
}
-(void)addCartView {
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(260, SCREEN_HEIGHT+20-124, 54, 54)];
    cartView.delegate = self;
    [bgView addSubview:cartView];
}

- (void)initMoreView {
    
    sortListView = [[UIView alloc]initWithFrame:CGRectMake(0, -7*45 +64 +35, SCREEN_WIDTH, 45*7)];
    sortListView.backgroundColor = [UIColor redColor];
    sortListView.tag = 0;
    
    checkView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-34, 10.5, 24, 24)];
    [checkView setImage:[UIImage imageNamed:@"tab_sel"]];
    NSArray * sortArray = [[NSArray alloc]initWithObjects:@"默认排序",@"价格从高到低",@"价格从低到高",@"销量从高到低",@"折扣从高到低",@"最新上架商品",@"品牌名称排序", nil];
    for (int i = 0 ; i < 7 ; i ++ ) {
        UIButton * sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sortBtn.backgroundColor = [UIColor whiteColor];
        sortBtn.frame = CGRectMake(0, 45 * i, SCREEN_WIDTH, 45);
        [sortBtn setTitle:[sortArray objectAtIndex:i] forState:UIControlStateNormal];
        sortBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        sortBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        sortBtn.tag = kSortButtonTag + i;
        sortBtn.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
        [sortBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [sortBtn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [sortBtn addSubview:checkView];
        }
        if (i <6) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, sortBtn.height -1, SCREEN_WIDTH, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
            [sortBtn addSubview:line];
        }
        [sortListView addSubview:sortBtn];
    }
    [sortListView setHidden:YES];
    [bgView addSubview:sortListView];
}

- (void)moreViewIn {
    sortListView.tag = 0;
    if (sortListView.frame.origin.y > 0) {
        
        [shadow setHidden:YES];
        
        sortListView.frame = CGRectMake(0, 64 + 35, 320, 7*45);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        [sortListView setHidden:YES];
        sortListView.frame = CGRectMake(0, - 7* 45 +35 + 64, 320, 45 * 7);
        [UIView commitAnimations];
        
    }
}

- (void)moreViewOut {
    sortListView.tag = 1;
    if (sortListView.frame.origin.y < 0) {
        
        [shadow setHidden:NO];
        
        sortListView.frame = CGRectMake(0,-7*45 +35+ 64, 320, 45 * 7);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        [sortListView setHidden:NO];
        sortListView.frame = CGRectMake(0, 35 +64, 320, 7*45);
        [UIView commitAnimations];
        
    }
}

-(void)initCategoryView {
    
    __unsafe_unretained YHSearchResultsViewController *vc = self;
    
    categoryView = [[YHCategoryView alloc]initWithFrame:CGRectMake(0, -(SCREEN_HEIGHT-64-35), SCREEN_WIDTH, SCREEN_HEIGHT-64-35)];
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if ([type isEqualToString:@"home_dm"]) {//tabBar 促销
        categoryView.isPromotion = YES;
    } else {
        categoryView.isPromotion = NO;
    }
    categoryView.tapBlock = ^(){
        [vc categoryViewIn];
        
        
    };
    categoryView.block = ^(NSString *type,NSString *category_code,NSString *title,NSInteger is_parent_category){
        for (UIView * view in vc->tabBgView.subviews) {
            if ([view isKindOfClass:[YHTabButton class]]) {
                YHTabButton * btn = (YHTabButton *)view;
                if (btn.tag == kTopAllButtonTag) {
                    [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                    [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                    if (title) {
                        [btn setTitleForTitleView:title withFont:btn.titleView.font andImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
                    }
                }else{
                    
                }
                
            }
        }
        vc->rightItem.frame = CGRectMake(SCREEN_WIDTH-52, 0, 52, 44);
//        vc->_textField.frame = CGRectMake(44, 7.5, SCREEN_WIDTH -96, 29);
        
        [vc->rightItem setTitle:@"筛选" forState:UIControlStateNormal];
//        [vc->rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect.png"] forState:UIControlStateNormal];
//        [vc->rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect_press.png"] forState:UIControlStateHighlighted];
        
        [vc categoryViewIn];
        
        vc->countPage = 1;
        vc->requestStyle = Load_RefrshStyle;
        
        if (category_code) {
            [vc->params setObject:category_code forKey:@"category_code"];
            [vc->params setObject:@"" forKey:@"brand_name"];
            [vc->params setObject:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
        }else{
            [vc->params setObject:@"" forKey:@"category_code"];
            [vc->params setObject:@"" forKey:@"brand_name"];
            [vc->params setObject:[NSNumber numberWithInteger: 0] forKey:@"is_parent_category"];
        }
        
        vc->category_type = type;//1,2
        //点击分类列表后---请求数据
        [vc requestData];
        
    };
//    //从网络请求数据给分类初始化
//    [categoryView request_type:[params objectForKey:@"type"] bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
    [categoryView setHidden:YES];
    [bgView addSubview:categoryView];
}

- (void)categoryViewIn {
    categoryView.isOut = NO;
    
    if (categoryView.frame.origin.y > 0) {
        
        [shadow setHidden:YES];
        
        categoryView.frame = CGRectMake(0,64+ 35, SCREEN_WIDTH, categoryView.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        [categoryView setHidden:YES];
        categoryView.frame = CGRectMake(0, -(SCREEN_HEIGHT-64-35), 320, categoryView.height);
//        categoryView.frame = CGRectMake(0, 20, 320, 44 +35);
        [UIView commitAnimations];
        
    }
}

- (void)categoryViewOut {
    categoryView.isOut = YES;
    
    //    if ([tab1.titleLabel.text isEqualToString:@"全部商品"]) {
    //        [categoryView deleteFirstEntity];
    //    } else {
    //        [categoryView addFirstEntity];
    //    }
    
    [categoryView refresh];
    
    if (categoryView.frame.origin.y < 0) {
        
        [shadow setHidden:NO];
        
        categoryView.frame = CGRectMake(0, -(SCREEN_HEIGHT-64-35), 320, categoryView.height);
//        categoryView.frame = CGRectMake(0, 20, 320, 35 +44);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        [categoryView setHidden:NO];
        categoryView.frame = CGRectMake(0,64+ 35, 320, categoryView.height);
        [UIView commitAnimations];
        
    }
}

- (void)initShadowView {
    shadow = [[UIView alloc]initWithFrame:CGRectMake(0,64 + 35, 320, self._tableView.height)];
    shadow.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    shadow.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowAction)];
    
    [shadow addGestureRecognizer:tap];
    [bgView addSubview:shadow];
    [shadow setHidden:YES];
}

-(void)setTopTabSelectedColor:(UIButton *)btn {
    for (UIView *view in tabBgView.subviews) {
        if ([view isKindOfClass:[YHTabButton class]]) {
            YHTabButton * button = (YHTabButton *)view;
            if (btn.tag == button.tag) {
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xdddcdc alpha:1.0]];
                [button setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x999999 alpha:1.0]];
                [button setImageForImageView:[UIImage imageNamed:@"arrow_"]];
            } else {
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                [button setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                [button setImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
            }
        }
        
    }
}


#pragma mark ------------  CartViewDelegate
-(void)cartViewClickAction {
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    YHCartViewController *cart = [[YHCartViewController alloc] init];
    cart.isFromOther = YES;
    [self.navigationController pushViewController:cart animated:YES];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.screenString = [NSString stringWithString:self.textField.text];
    if (self.selectScreenGoods) {
        self.selectScreenGoods(self);
    }
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        //取消
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [params setObject:@"" forKey:@"brand_name"];
//            [params setObject:@"" forKey:@"category_code"];
//            [params setObject:[NSNumber numberWithInteger: 0] forKey:@"is_parent_category"];
            countPage = 1;
            requestStyle = Load_RefrshStyle;
            [self requestData];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                if (isSelectedScreen) {
                    YHLeftButton * leftBtn = (YHLeftButton *)[rightMainBgView viewWithTag:kRightCellTag];
                    leftBtn.selectName.text = @"";
                    isSelectedScreen = NO;
                }
                if (isSelectedScreen == NO) {
                    rightItem.frame = CGRectMake(SCREEN_WIDTH-52, 0, 52, 44);
//                    _textField.frame = CGRectMake(44, 7.5, SCREEN_WIDTH -96, 29);
                    
                    [rightItem setTitle:@"筛选" forState:UIControlStateNormal];
//                    [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect.png"] forState:UIControlStateNormal];
//                    [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect_press.png"] forState:UIControlStateHighlighted];
                }
                [UIView  beginAnimations:nil context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.5];
                
                bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
                self._tableView.scrollEnabled = YES;
                [UIView commitAnimations];
                
            });
        });

    }
}
#pragma mark - Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [self finishLoadTableViewData];
    [MBProgressHUD hideHUDForView:nullView animated:YES];
    isRequestSuccess = YES;
    
    if(t_API_SEARCH_KEY_GOODS_LIST == nTag || t_API_KEY_CATEGORY_SCREEN_LIST == nTag)
    {
        GoodsListEntity *entity = (GoodsListEntity *)netTransObj;
        if (requestStyle == Load_RefrshStyle) {
            [goodsData removeAllObjects];
            [enoughGoodsData removeAllObjects];
            [self._tableView setContentOffset:CGPointZero];
        }else{
            
        }
        
        [goodsData addObjectsFromArray:entity.goodsArray];
        
        for (GoodsEntity *goods in entity.goodsArray) {
            if ([goods.out_of_stock integerValue] == 0) {//有货
                [enoughGoodsData addObject:goods];
            }
        }
        
//        if ([goodsData count] == 0) {
//            [self._tableView setHidden:YES];
//            [cartView setHidden:YES];
//            [categoryView setHidden:YES];
//            [sortListView setHidden:YES];
//            [tabBgView setHidden:YES];
//            [nullView setHidden:NO];
//            [nullView addSubview:nullImage];
//            [nullView addSubview:nullInfo];
//            [rightItem setEnabled:NO];
//            [self._tableView removeGestureRecognizer:swipe1];
//            [rightMainBgView removeGestureRecognizer:swipe2];
//
//        } else {
            [nullView setHidden:YES];
            [nullImage removeFromSuperview];
            [nullInfo removeFromSuperview];
            [self._tableView setHidden:NO];
            [cartView setHidden:NO];
//            [categoryView setHidden:NO];
//            [sortListView setHidden:NO];
            [tabBgView setHidden:NO];
            [rightItem setEnabled:YES];
            [self._tableView addGestureRecognizer:swipe1];
            [rightMainBgView addGestureRecognizer:swipe2];
//        }
        /*
        if (requestStyle == Load_MoreStyle) {
            if (self.total == goodsData.count) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{

            [self._tableView setContentOffset:CGPointZero];
        }
        self.total = goodsData.count;
        [self._tableView reloadData];
        [self testFinishedLoadData];
        [self finishLoadTableViewData];
         */
        [self._tableView reloadData];
    }else if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"1";
        orderCart.goods_id = _goods_id;
        orderCart.total = _total;
        orderCart.immdiateBuy = YES;
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
//    self.dataState = EGOOLoadFail;
//    [self testFinishedLoadData];
    if (isRequestSuccess == YES) {
        
    }else{
        [MBProgressHUD hideHUDForView:nullView animated:YES];
        [nullView setHidden:NO];
        [nullView addSubview:nullImage];
        [nullView addSubview:nullInfo];
    }

}


#pragma mark ---------------RequestMethod
-(void)setRequstParams:(NSMutableDictionary *)param {
    
    bu_category_id_default = [param objectForKey:@"bu_category_id"];
    params = [NSMutableDictionary dictionary];
    params = param;
    [params setValue:@"0" forKey:@"is_stock"];
    
    [[PSNetTrans getInstance]getKeySearchGoodsList:self type:[params objectForKey:@"type"] key:[params objectForKey:@"key"] category_code:nil is_parent_category:0 brand_name:nil order:[params objectForKey:@"order"] page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:@"10"];
    
    [categoryView request_type:nil bu_brand_id:nil tag_id:nil key:[params objectForKey:@"key"]];
    
}
-(void)requestData {
    if (category_type) {
        
        [[PSNetTrans getInstance]getKeySearchGoodsList:self type:[params objectForKey:@"type"] key:[params objectForKey:@"key"] category_code:[params objectForKey:@"category_code"] is_parent_category:[[params objectForKey:@"is_parent_category"] integerValue] brand_name:[params objectForKey:@"brand_name"] order:[params objectForKey:@"order"] page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:nil];
        
        
    } else {//全部商品
        [[PSNetTrans getInstance] getKeySearchGoodsList:self type:[params objectForKey:@"type"] key:[params objectForKey:@"key"]  category_code:[params objectForKey:@"category_code"] is_parent_category:1 brand_name:[params objectForKey:@"brand_name"] order:[params objectForKey:@"order"] page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:@"10"];
        
    }
}


#pragma mark - ===========================================
#pragma mark - UITableViewDelegate

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsEntity *entity;
    //= [[GoodsEntity alloc] init];
    if (enoughGoods) {
        entity = (GoodsEntity *)[enoughGoodsData objectAtIndex:indexPath.row];
    } else {
        entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
    }
    CGSize size ;
    size = [entity.goods_name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(210, 40) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 20 && (entity.goods_introduction && entity.goods_introduction.length != 0) && (entity.is_or_not_salse.integerValue == 1 || entity.limit_the_purchase_type.integerValue != 0))
        return 130;
    else
        return 110;
}
#pragma mark - UITableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        return _rightDataArray.count;
    }else{
        if (enoughGoods) {
            return [enoughGoodsData count];
        } else {
            return [goodsData count];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"mainCell";
    YHPromotionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[YHPromotionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//        
//        pan.delegate = self;
//        
//        [cell.contentView addGestureRecognizer:pan];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __unsafe_unretained YHSearchResultsViewController *vc = self;
        cell.cartBlock = ^(NSString * goods_id,NSString * total){
            if (goods_id && total) {
                vc->_goods_id = goods_id;
                vc->_total = total;
                [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:goods_id total:total];
            }else{
                [vc->cartView changeCartNum];
            }
        };
    }
    
    GoodsEntity *entity;
    //= [[GoodsEntity alloc]init];
    
    if (enoughGoods) {
        entity = (GoodsEntity *)[enoughGoodsData objectAtIndex:indexPath.row];
    } else {
        entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
    }
    [cell setGoodsCellData:entity];
    
    return cell;
    
    
}
//-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (bgView.frame.origin.x<0) {
        tableView.scrollEnabled = NO;
        self._tableView.userInteractionEnabled = NO;
        showRightView = NO;
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
        [UIView commitAnimations];
        tableView.scrollEnabled = YES;
        self._tableView.userInteractionEnabled = YES;
        return;
    }else{
        
        
        GoodsEntity *entity;
        //= [[GoodsEntity alloc]init];
        if (enoughGoods) {
            entity = [enoughGoodsData objectAtIndex:indexPath.row];
        } else {
            entity = [goodsData objectAtIndex:indexPath.row];
        }
        
        YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
        NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        detaiVC.url = url;
        [detaiVC setMainGoodsUrl:url goodsID:entity.goods_id];
        [self.navigationController pushViewController:detaiVC animated:YES];
    }
    
    
}
#pragma mark - UIScrollViewDelegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    NSLog(@"当前手势:%@; 另一个手势:%@", gestureRecognizer, otherGestureRecognizer);
    
    return YES;
    
}
#pragma mark - buttonClickEvents
- (void)itemClick:(UIButton *)btn
{
    
    switch (btn.tag) {
        case kLeftItemTag:
        {
            self.screenString = [NSString stringWithString: self.textField.text];
            if (self.selectScreenGoods) {
                self.selectScreenGoods(self);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case kRightItemTag:
        {
            [UIView  beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            if (! showRightView) {
                bgView.frame = CGRectMake(-SCREEN_WIDTH + 40, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT -20);
                showRightView = YES;
                self._tableView.scrollEnabled = NO;
            }else{
                bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
                showRightView = NO;
                self._tableView.scrollEnabled = YES;
            }
            [UIView commitAnimations];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)topTabAction:(UIButton *)button{
    
    [self setTopTabSelectedColor:button];
    YHTabButton * btn = (YHTabButton *)button;
    switch (btn.tag) {
        case kTopAllButtonTag:
        {
            [self moreViewIn];
            
            if ([categoryView.categoryData count]>0) {
                if (categoryView.isOut) {
                    [self categoryViewIn];
                    [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                    [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                    [btn setImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
                } else {
                    [self categoryViewOut];
                    [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xdddcdc alpha:1.0]];
                    [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x999999 alpha:1.0]];
                    [btn setImageForImageView:[UIImage imageNamed:@"arrow_"]];
                }
            } else {
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
            }
        }
            break;
        case kTopSortButtonTag:{
            [self categoryViewIn];
            
            if (sortListView.tag%2 == 0) {
                [self moreViewOut];
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xdddcdc alpha:1.0]];
                [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x999999 alpha:1.0]];
                [btn setImageForImageView:[UIImage imageNamed:@"arrow_"]];
            } else {
                [self moreViewIn];
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                [btn setImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
            }
        }
            break;
        default:
            break;
    }
}
- (void)sortAction:(UIButton *)btn {
    [checkView removeFromSuperview];
    
    requestStyle = Load_RefrshStyle;
    countPage = 1;
    [self moreViewIn];
    
    NSString * tabString = [[NSString alloc]init ];
    NSInteger  tag;
    NSArray * orderArray = [[NSArray alloc]initWithObjects:@"default",@"price:1",@"price:0",@"sales:1",@"discount:1",@"onsell_time",@"name", nil];
    //    NSArray * orderArray = [[NSArray alloc]initWithObjects:@"default",@"price:1",@"price:0",@"sales:1",@"sales:0",@"discount:1",@"discount:0",@"onsell_time",@"name", nil];
    NSArray * sortArray = [[NSArray alloc]initWithObjects:@"默认排序",@"价格降序",@"价格升序",@"销量降序",@"折扣降序",@"最新上架",@"品名排序", nil];
    for (UIView * view  in sortListView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)view;
            if (btn.tag == button.tag) {
                [btn addSubview:checkView];
                tabString = btn.currentTitle;
                tag = btn.tag - kSortButtonTag;
                [params setValue:[orderArray objectAtIndex:btn.tag -kSortButtonTag] forKey:@"order"];
                [self requestData];
            }
        }
    }
    for (UIView * view in tabBgView.subviews) {
        if ([view isKindOfClass:[YHTabButton class]]) {
            YHTabButton * btn = (YHTabButton *)view;
            if (btn.tag == kTopSortButtonTag) {
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                if (tabString) {
                    [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                    [btn setTitleForTitleView:[sortArray objectAtIndex:tag] withFont:btn.titleView.font andImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
                }
            }else{
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
                [btn setTitleColorForTitleView:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
                [btn setImageForImageView:[UIImage imageNamed:@"arrow_selected"]];
            }
            
        }
    }
    
}

-(void)shadowAction {
    [self moreViewIn];
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case kRightButtonTag:
        {
            if (showRightView) {
                if (self.screenString == nil) {
                    [UIView  beginAnimations:nil context:NULL];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDuration:0.5];
                    
                    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
                    showRightView = NO;
                    self._tableView.scrollEnabled = YES;
                    [UIView commitAnimations];
                    return;
                }
                //启动一个线程。。。 以后再添加
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    if ([self.screenString isEqualToString:[params objectForKey:@"brand_name"]]) {
//                        //品牌名没有变化，不用刷新数据
//                    }else{
                        //有变化，修改brand_name
                        [params setObject:self.screenString forKey:@"brand_name"];
                        countPage = 1;
                        requestStyle = Load_RefrshStyle;
//                        self.dataState = EGOOHasMore;
                        [self requestData];
//                    }
                    dispatch_async( dispatch_get_main_queue(), ^{
                        if (self.screenString.length != 0) {
                            isSelectedScreen = YES;
//                            rightItem.frame = CGRectMake(SCREEN_WIDTH-72, 0, 72, 44);
//                            _textField.frame = CGRectMake(44, 7.5, SCREEN_WIDTH -116, 29);
                            
                            [rightItem setTitle:@"筛选" forState:UIControlStateNormal];
                            
//                            [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_select.png"] forState:UIControlStateNormal];
//                            [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_select_press.png"] forState:UIControlStateHighlighted];
                        }else{
                            isSelectedScreen = NO;
//                            rightItem.frame = CGRectMake(SCREEN_WIDTH-52, 0, 52, 44);
//                            _textField.frame = CGRectMake(44, 7.5, SCREEN_WIDTH -96, 29);
                            
                            [rightItem setTitle:@"筛选" forState:UIControlStateNormal];
//                            [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect.png"] forState:UIControlStateNormal];
//                            [rightItem setBackgroundImage:[UIImage imageNamed:@"btn_unselect_press.png"] forState:UIControlStateHighlighted];
                        }
                        [UIView  beginAnimations:nil context:NULL];
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDuration:0.5];
                        
                        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
                        showRightView = NO;
                        self._tableView.scrollEnabled = YES;
                        [UIView commitAnimations];

                    });
                });
            }
        }
            break;
        case kDeleteButtonTag:
        {
            YHLeftButton * leftBtn = (YHLeftButton *)[btn.superview viewWithTag:kRightCellTag];
            if (leftBtn.selectName.text.length != 0) {
                [self showAlert:self newMessage:@"是否清空品牌筛选"];
            }else{
                [self showAlert:self Message:@"抱歉，您还没有做出筛选哦！"];
            }
            
        }
            break;
            
        default:
            break;
    }
}
- (void)rightCellClick:(YHLeftButton *)btn{
    YHSearchSelectViewController * ssvc = [[YHSearchSelectViewController alloc]init];
    ssvc.string = [NSString stringWithFormat:@"%@", btn.selectName.text];
    ssvc.selectScreenGoods = ^(YHSearchSelectViewController * s){
        self.screenString = s.selectName;
        btn.selectName.text = s.selectName;
        [params setObject:s.selectName forKey:@"brand_name"];

    };
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.keyWord forKey:@"key"];
    [postDic setValue:[params objectForKey:@"is_parent_category"] forKey:@"is_parent_category"];
    [postDic setValue:[params objectForKey:@"category_code"] forKey:@"category_code"];
    [postDic setValue:[params objectForKey:@"order"] forKey:@"order"];
    [postDic setValue:@"search" forKey:@"type"];
    [ssvc setRequstParams:postDic];
    //    ssvc.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:ssvc animated:YES];
}
#pragma mark - UIGestureAction
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    {
        // 输出点击的view的类名
        NSLog(@"%@", NSStringFromClass([touch.view class]));
        
        // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            return NO;
        }
        return  YES;  
    }
}
- (void)leftSwipeAction:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        bgView.frame = CGRectMake(-SCREEN_WIDTH + 40, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT -20);
        [UIView commitAnimations];
        showRightView = YES;
        self._tableView.scrollEnabled = NO;
    }
}
- (void)rightSwipeAction:(UISwipeGestureRecognizer *)swipe{
    
    NSLog(@"滑动");
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT-20);
        [UIView commitAnimations];
        showRightView = NO;
        self._tableView.scrollEnabled = YES;
    }
    
}
//- (void)panAction:(UIPanGestureRecognizer *)pan{
//
//        [UIView  beginAnimations:nil context:NULL];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.5];
//        bgView.frame = CGRectMake(-SCREEN_WIDTH + 40, 0, SCREEN_WIDTH * 2 -40, SCREEN_HEIGHT -20);
//        [UIView commitAnimations];
//        showRightView = YES;
//        self._tableView.scrollEnabled = NO;
//
//}
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
//    self.dataState = EGOOHasMore;
    [self requestData];
    
    NSLog(@"refresh start requestInterface.");
}
/*加载更多接口请求*/
- (void)reloadMoreTableViewDataSource{
    _moreloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    
    [self requestData];
    
    
    NSLog(@"getMore start requestInterface.");
}
/*
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    
    [self requestData];
    
    
    NSLog(@"getMore start requestInterface.");
}
*/

#pragma mark - CustomMethods
- (void)hideHUD{
    [MBProgressHUD hideHUDForView:nullView animated:YES];
}
- (void)changeTabColor:(UIButton *)btn {
    //    if (btn != tab3) {
    //        for (UIButton *button in tabs) {
    //            if (button == btn) {
    //                [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //            } else {
    //                [button setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //            }
    //        }
    //    }
    //
    //    if (enoughGoods) {
    //        [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //    } else {
    //        [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
