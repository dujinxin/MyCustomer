//
//  YHMainViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  首页

#import "YHRootViewController.h"
#import "DMGoodsEntity.h"
#import "YHOperationView.h"
#import "YHThemeView.h"

@interface YHMainViewController : YHBaseTableViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIApplicationDelegate,YHOperationDelegate,YHThemeDelegate> {
    UIScrollView *hotScr;
    NSMutableArray *hotGoodsData;//热销商品
    NSMutableArray *allGoodsData;
    NSMutableArray *categoryData;//分类商品
    NSMutableArray *dmPromotionData;//促销大图数组
    NSMutableArray *themeData;//主题
    NSMutableArray *activityData;//运营区
    NSMutableArray *speedEntryData;//快速通道区
    UIScrollView   *scrollview;//dm滑动视图
    UIPageControl  *pageCtr;
    UILabel        *pageLabel;
    NSInteger       currentPage;
    NSInteger       totalPages;
    NSTimer        *timer;
    UIView         *headView;//dm、快速通道区、热销商品、运营区
    DMGoodsEntity  *goods;//
    DMGoodsEntity * newGoods;
    UIButton       *hotGoodsBtn;
    UIView         *hotGoodsView;
    UIView         *eventView;//运营视图
    // 定位城市－btn-label
    UIButton       *rightBtn;
    UILabel        *cityLabel;
    
    UIView         *tipsBg;
}

@property (nonatomic, strong)NSMutableArray *dmPromotionData;//促销大图数组
@property (nonatomic, copy) NSString *locationCityId;

- (void)hideLaunchImage;
@end
