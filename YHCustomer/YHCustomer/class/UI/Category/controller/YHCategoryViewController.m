//
//  YHCategoryViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  分类

#import "YHCategoryViewController.h"
#import "YHGoodsListViewController.h"
#import "YHOrderViewController.h"
#import "CategoryButton.h"
#include "YHSecondCategoryViewController.h"
#import "CateBrandEntity.h"
#import "YHNewSearchGoodsViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHGoodsTabViewController.h"
@interface YHCategoryViewController (){

    NSString *categoryImage;
    NSString *categoryImageSelect;
    NSString *brandImage;
    NSString *brandImageSelect;
}

@end

@implementation YHCategoryViewController

@synthesize categoryArray;
@synthesize cateSecondArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        categoryArray = [[NSMutableArray alloc] init];
        cateSecondArray = [[NSMutableArray alloc] init];
        countPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MTA trackPageViewBegin:PAGE7];

	// Do any additional setup after loading the view.
    self.navigationItem.title= @"分类";
    categoryImage = @"categoryBrandBg.png";
    categoryImageSelect = @"categoryBrand_Select";
    
    brandImage = @"category_Brand.png";
    brandImageSelect = @"category_Brand_Select.png";
    // 设置导航条右侧按钮
    [self setRightBarButton:self Action:@selector(searchBarClick:) SetImage:@"category_Search.png" SelectImg:@"category_Search_Select.png"];

    self._tableView.frame = CGRectMake(0, 50, 320, ScreenSize.height - NAVBAR_HEIGHT - kTabBarHeight - 50);
    [self setCategoryBrandBtn];
    requestStyle =  Load_InitStyle;
    [self requestWithType:CategoryType];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MTA trackPageViewEnd:PAGE7];
}

#pragma mark-
#pragma mark ------------------------------------------------------button action
// 搜索
- (void)searchBarClick:(id)sender{
    [MTA trackCustomKeyValueEvent :EVENT_ID7 props:nil];
    YHNewSearchGoodsViewController *searchVC = [[YHNewSearchGoodsViewController alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"bu_id"];
    [params setValue:@"default" forKey:@"order"];
    [params setValue:@"search" forKey:@"type"];
    [searchVC setRequstParams:params];
    //    searchVC.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (void)requestWithType:(SubType)type{
    if (subType == BrandType) {
        [[NetTrans getInstance] API_Brand_List:self Bu_id:@"0" Page:[NSString stringWithFormat:@"%ld",(long)countPage] Limit:@"10"];
        
    }else{
        [[NetTrans getInstance] API_CateGoryList:self Bu_id:@"0" Bu_category_id:nil Page:[NSString stringWithFormat:@"%ld",(long)countPage] Limit:@"10"];
//        [[NetTrans getInstance]API_New_CategoryList:self  Bu_category_id:nil Region_id:[UserAccount instance].region_id Page:nil Limit:nil];
    }
}

- (void)setCategoryBrandBtn{
    categoryBtn = [PublicMethod addButton:CGRectMake(55, 10, 110, 30) title:@"品类" backGround:categoryImageSelect setTag:1000 setId:self selector:@selector(buttonClickTag:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    
    brandBtn = [PublicMethod addButton:CGRectMake(165, 10, 100, 30) title:@"品牌" backGround:brandImage setTag:1001 setId:self selector:@selector(buttonClickTag:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor blackColor]];
    [self.view addSubview:categoryBtn];
    [self.view addSubview:brandBtn];
}

- (void)buttonClickTag:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn == categoryBtn) {
        subType =  CategoryType;
        [categoryBtn setBackgroundImage:[UIImage imageNamed:categoryImageSelect] forState:UIControlStateNormal];
        [categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [brandBtn setBackgroundImage:[UIImage imageNamed:brandImage] forState:UIControlStateNormal];
        [brandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        subType =  BrandType;
        [categoryBtn setBackgroundImage:[UIImage imageNamed:categoryImage] forState:UIControlStateNormal];
        [brandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [brandBtn setBackgroundImage:[UIImage imageNamed:brandImageSelect] forState:UIControlStateNormal];
        [categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    countPage = 1;
    [categoryArray removeAllObjects];
    [self requestWithType:subType];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    CateBrandEntity *cateGory = [categoryArray objectAtIndex:indexPath.row];
    if (subType == BrandType) {
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        vc.navigationItem.title = cateGory.brand_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"brand" forKey:@"type"];
        [dic setValue:cateGory.bu_brand_id forKey:@"bu_brand_id"];
        [dic setValue:@"default" forKey:@"order"];
        [vc setRequstParams:dic];
        [self.navigationController pushViewController:vc animated:YES];
        
        
//        YHWebGoodListViewController *goodList = [[YHWebGoodListViewController alloc] init];
//        [goodList setParamerWihtType:@"4" Id:cateGory.bu_brand_id];
//        goodList.navigationItem.title = cateGory.brand_name;
//        [self.navigationController pushViewController:goodList animated:YES];

    }else{
        YHSecondCategoryViewController *goodList = [[YHSecondCategoryViewController alloc] init];
        goodList.entity = cateGory;
        
        [self.navigationController pushViewController:goodList animated:YES];
    }
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    [cell.contentView removeAllSubviews];
    CateBrandEntity *cateGory = [categoryArray objectAtIndex:indexPath.row];
    
    if (subType == BrandType) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 200, 40)];
        nameLabel.text = cateGory.brand_name;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
    }else{
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15.5, 48, 48)];
        [icon setImageWithURL:[NSURL URLWithString:cateGory.icon] placeholderImage:[UIImage imageNamed:@"category_default.png"]];
//        icon.layer.masksToBounds = YES;
//        icon.layer.cornerRadius = 8;
        [cell.contentView addSubview:icon];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, 200, 16)];
        nameLabel.text = cateGory.category_name;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
    }
    
    UIImageView *accessImg= [[UIImageView alloc] initWithFrame:CGRectMake(290, 30, 20, 20)];
    accessImg.image = [UIImage imageNamed:@"category_Access.png"];
    [cell.contentView addSubview:accessImg];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark-
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    [self requestWithType:subType];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)reloadMoreTableViewDataSource{
	_moreloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    [self requestWithType:subType];

    NSLog(@"getMore start requestInterface.");
}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [self finishLoadTableViewData];
    if(t_API_CATEGORY_LIST == nTag || nTag == t_API_BRAND_LIST)
    {
        if (requestStyle != Load_MoreStyle) {
            [categoryArray removeAllObjects];
        }
        NSMutableArray *array  = (NSMutableArray *)netTransObj;
        [self.categoryArray addObjectsFromArray:array];
        
        [self._tableView reloadData];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
}


@end
