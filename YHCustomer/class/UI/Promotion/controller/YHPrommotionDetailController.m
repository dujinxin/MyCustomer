//
//  YHPrommotionDetailController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-22.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  促销详情

#import "YHPrommotionDetailController.h"
#import "YHCommentViewController.h"
#import "GoodDetailEntity.h"
#import "YHCartViewController.h"
#import "YHGoodsDetailViewController.h"
#import "PromotionShareEntity.h"
#define SHARE_BTN_TAG 100
#define COMMENT_BTN_TAG 101

@interface YHPrommotionDetailController ()<YHAlertViewDelegate>

@end

@implementation YHPrommotionDetailController
@synthesize dm_id;
@synthesize goodsEntity;
@synthesize promotionShareEntity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"活动详情";
        GoodDetailEntity *tmpEntity = [[GoodDetailEntity alloc] init];
        self.goodsEntity = tmpEntity;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [self addWebView]; 
    [self addBottomButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MTA trackPageViewBegin:PAGE2];
    
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));

}

// 收藏
- (void)collectAction:(id)sender{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [[NetTrans getInstance] buy_collectPromotion:self Type:@"dm" DM_id:self.dm_id];
    [MTA trackCustomKeyValueEvent:EVENT_ID1 props:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    
    if ([[UserAccount instance] isLogin]) {
        [[NetTrans getInstance] buy_collectStatus:self Type:@"dm" DM_id:self.dm_id];
    }else{
//        [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"category_Collect.png" SelectImg:@"category_Collect_Select.png"];
        [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:@"right_collected"];
    }
    
    [self loadRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE2];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -------------------  add ui
-(void)addBottomButton {
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = SHARE_BTN_TAG;
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, SCREEN_HEIGHT-NAVBAR_HEIGHT-22-38-9, 160, 49);
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_selected"] forState:UIControlStateHighlighted];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.tag = COMMENT_BTN_TAG;
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
    commentBtn.frame = CGRectMake(160, SCREEN_HEIGHT-NAVBAR_HEIGHT-22-38-9, 160, 49);
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected"] forState:UIControlStateHighlighted];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
}
-(void)addWebView {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 49)];

    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    [self.view addSubview:webView];
}

#pragma mark --------------------------webView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSString *decode =[requestString URLDecodeString];
    if([decode rangeOfString:@"#myrainbowparams#"].length > 0){
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        NSString *urlStr = [decode getGoodUrlWithParmer:@"#myrainbowparams#"];
        NSDictionary *paramDic = [finalStr objectFromJSONString];
        BOOL isSkip = [self webRequestStringAnalytics:paramDic URL:urlStr];
        return isSkip;
    }
    return YES;
}

#pragma mark --------------------------webview字符解析
-(BOOL)webRequestStringAnalytics:(NSDictionary*)dicParam URL:(NSString*)url1
{
    // 关于商品详细
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"000"]) {
        return YES;
    }
    // 进入购物车
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"001"])
    {
        YHCartViewController *cart = [[YHCartViewController alloc] init];
        cart.isFromOther = YES;
        [self.navigationController pushViewController:cart animated:YES];
    }
    // 进入商品评论列表
    else if([[dicParam objectForKey:@"actionid"]isEqualToString:@"002"])
    {

    }
    // 登陆页面
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"003"])
    {
        [[YHAppDelegate appDelegate]  checkLogin];
    }
    // 商品详情页面
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"004"])
    {
        
        YHGoodsDetailViewController *goodsDetail = [[YHGoodsDetailViewController alloc] init];
        goodsDetail.navigationItem.title = [[dicParam objectForKey:@"params"] objectForKey:@"title"];
        [goodsDetail setBu_GoodsUrl:url1 Paramer:dicParam
         ];
        [self.navigationController pushViewController:goodsDetail animated:YES];
        return NO;

    }
    // 获取数量
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"005"])
    {
        [self showNotice:@"已成功加入购物车"];
        [MTA trackCustomKeyValueEvent :EVENT_ID5 props:nil];
        NSString *totalNum = [NSString stringWithFormat:@"%@",[[dicParam objectForKey:@"params"] objectForKey:@"total"]];
        [[NSUserDefaults standardUserDefaults] setObject:totalNum forKey:@"cartNum"];
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
        
    }
    // 达到购买上线
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"006"]) {
        [self showNotice:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
    }
    // 确认加入购物车／*本地调用api*/
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"007"])
    {
        
    }
    // 门店首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"008"])
    {
        
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showNotice:@"加载失败"];
}
#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:requestObj];
}

- (void)setDMId:(NSString *)dmId{
    dm_id = dmId;
    self.dm_id = dmId;
    url = [NSString stringWithFormat:PROMOTION_DETAIL_URL,dmId,[UserAccount instance].session_id,[UserAccount instance].region_id];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonAction:(UIButton *)button {
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    if (button.tag == SHARE_BTN_TAG) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MTA trackCustomKeyValueEvent :EVENT_ID2 props:nil];
        [[NetTrans getInstance] buy_GoodDetailForShare:self BuDmOrGoodsId:self.dm_id Type:DM_DETAIL_SHARE];
        //促销分享
        NSLog(@"%@",self.dm_id);
        [[NetTrans getInstance]promotion_share:self dm_id:self.dm_id];

    } else if (button.tag == COMMENT_BTN_TAG) {
        [MTA trackCustomKeyValueEvent :EVENT_ID3 props:nil];
        YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
        [commentVC setCommentListDataAndType:dm_id Type:PROMOTION_COMMENT_LIST IsBought:YES];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}
-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //保存
        //NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
        UIImage * image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:promotionShareEntity.qr_code_src]]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//        [defautls setObject:image forKey:@"codeImage"];
//        [defautls synchronize];
        
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        [[iToast makeText:message ]show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"您的照片功能未开启，请去(设置>隐私>照片)开启一下吧！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"message is %@",message);
}
- (void)showShareMainViewWithParamer{
    [MTA trackCustomKeyValueEvent :EVENT_ID2 props:nil];
   
    NSLog(@"%@",promotionShareEntity.description);
    NSInteger flat = 0;

//    [PublicMethod showCustomShareListViewWithWxContent:promotionShareEntity.wx_content sinaWeiboContent:promotionShareEntity.sina_content flat:flat title:promotionShareEntity.title imageUrl:promotionShareEntity.photo url:promotionShareEntity.page_url description:promotionShareEntity.page_url qrCodeSrc:promotionShareEntity.qr_code_src block:nil VController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
    [PublicMethod showCustomShareListViewWithWxContent:promotionShareEntity.wx_content sinaWeiboContent:promotionShareEntity.sina_content flat:flat title:promotionShareEntity.title imageUrl:promotionShareEntity.photo url:promotionShareEntity.page_url description:promotionShareEntity.description qrCodeSrc:promotionShareEntity.qr_code_src block:^(id obj) {
        
    } VController:self AlertViewController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
    
}


#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_PROMOTION_COLLECT)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
    else if (nTag == t_API_BUY_PLATFORM_DM_COLLECT_STATUS)
    {
      
    }
    [[iToast makeText:errMsg]show];
    
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSNumber *collectStatus = (NSNumber *)netTransObj;
    if (nTag == t_API_BUY_PLATFORM_PROMOTION_COLLECT) {
        if ([collectStatus integerValue] == 1) {
//            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"category_Collect_Cancel.png" SelectImg:@"category_CancelCollect_Select.png"];
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:@"right_collecting"];
            [self showNotice:@"收藏成功!"];
        }
        if ([collectStatus integerValue] == 0) {
            [self showNotice:@"取消收藏成功!"];
//            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"category_Collect.png" SelectImg:@"category_Collect_Select.png"];
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:@"right_collected"];
        }
    }
    if (nTag == t_API_BUY_PLATFORM_DM_COLLECT_STATUS) {
        if ([collectStatus integerValue] == 1) {
//            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"category_Collect_Cancel.png" SelectImg:@"category_CancelCollect_Select.png"];
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:@"right_collecting"];
        }
        if ([collectStatus integerValue] == 0) {
//            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"category_Collect.png" SelectImg:@"category_Collect_Select.png"];
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:@"right_collected"];
        }
    }
    if(t_API_BUY_PLATFORM_PROMOTION_DETAIL == nTag){
        self.goodsEntity = (GoodDetailEntity *)netTransObj;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //[self showShareMainViewWithParamer];
    }
    if (t_API_PROMOTION_SHARE == nTag) {
        self.promotionShareEntity = (PromotionShareEntity *)netTransObj;
        [self showShareMainViewWithParamer];
        
    }
    
}
@end
