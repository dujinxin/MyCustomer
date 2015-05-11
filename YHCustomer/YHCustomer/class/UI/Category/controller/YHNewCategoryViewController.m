//
//  YHNewCategoryViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-10-13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHNewCategoryViewController.h"
#import "YHThirdCategoryViewController.h"
#import "YHGoodsListViewController.h"
#import "CategoryButton.h"
#include "YHSecondCategoryViewController.h"
#import "CateBrandEntity.h"
#import "CategoryGoodsEntity.h"
#import "BrandEntity.h"
#import "YHNewSearchGoodsViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHGoodsTabViewController.h"
#import "YHCategoryBtn.h"

typedef enum{
    kTabButtonLeft = 1000,
    kTabButtonRight,
    
    kHotScreenTag = 1010,
    kFirstCategoryTag = 1100,
    kSecondCategoryTag = 1200,
}kViewTag;

@interface YHNewCategoryViewController ()
{
    
    UIScrollView * categoryScroll;
    UIView *   secondCategoryView;
    UITableView * categoryTable;
    NSInteger unfoldTag;
    BOOL      isUnfold;
    CGFloat   contentHeight;
    NSInteger oldScViewHeight;
    
    
    UITableView * brandTable;
    
    BOOL isFirstEnter;
    MBProgressHUD * mbProgress;
}
@end

@implementation YHNewCategoryViewController

@synthesize categoryArray = _categoryArray;
@synthesize secondCategoryArray = _secondCategoryArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _categoryArray = [[NSMutableArray alloc] init];
        _secondCategoryArray = [[NSMutableArray alloc] init];
        //        countPage = 1;
        unfoldTag =  9999;
        isUnfold = NO;
        oldScViewHeight = 0;
        isFirstEnter = YES;
        mbProgress = [[MBProgressHUD alloc]init ];
        
        
        _selectName = [NSString string];
        //    _string = [NSString string];
        _hotBrandArray = [[NSMutableArray alloc]init];
        _allBrandArray = [[NSMutableArray alloc]init ];
        _sectionTitleArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title= @"商品分类";
    
    // 设置导航条右侧按钮
//    [self setRightBarButton:self Action:@selector(searchBarClick:) SetImage:@"category_Search.png" SelectImg:@"category_Search_Select.png"];
    [self setRightBarButton:self Action:@selector(searchBarClick:) SetImage:@"right_search" SelectImg:@"right_search"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityAction) name:@"changeCity" object:nil];
    
    [self addTabView];
    [self addCategoryView];
    [self addSecondCategoryView];
    
    [self addBrandView];


//    requestStyle =  Load_InitStyle;
//    [self requestWithType:CategoryType];
//    [self requestWithType:BrandType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
    
    if (isFirstEnter == YES){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        requestStyle =  Load_InitStyle;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            [self requestWithType:CategoryType];
        });
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            [self requestWithType:BrandType];
        });
//        [self requestWithType:CategoryType];
//        [self requestWithType:BrandType];
        
        [self performSelector:@selector(hideHUDView) withObject:nil afterDelay:5];
    }

}
- (void)hideHUDView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MTA trackPageViewEnd:PAGE7];
}
#pragma mark- InitUI
- (void)addTabView{
    UIView * tabView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    tabView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    [self.view addSubview:tabView];
    
    categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [categoryBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 35)];
    [categoryBtn setTitle:@"品类" forState:UIControlStateNormal];
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [categoryBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //    [categoryBtn setSelected:YES];
    [categoryBtn setTag:kTabButtonLeft];
    [categoryBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:categoryBtn];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(53.3, 34, 53.3, 1)];
    line.backgroundColor = [UIColor redColor];
    [categoryBtn addSubview:line];
    
    
    brandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [brandBtn setFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 35)];
    [brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
    brandBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [brandBtn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
    //    [brandBtn setSelected:NO];
    [brandBtn setTag:kTabButtonRight];
    [brandBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:brandBtn];
    
    
    UIView * zline =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 10, 1, 14)];
    zline.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
    [tabView addSubview:zline];
    
    
}
- (void)addCategoryView{
    categoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT - 35 - 64 -49)];
    if (IOS_VERSION>=7.0) {
        self.edgesForExtendedLayout=NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    categoryTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, categoryTable.bounds.size.width, 0.001)];
//    categoryTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, categoryTable.bounds.size.width, 0.001)];
    categoryTable.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    categoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryTable.showsVerticalScrollIndicator = NO;
    categoryTable.showsHorizontalScrollIndicator = NO;
    categoryTable.delegate = self;
    categoryTable.dataSource = self;
    [self.view addSubview:categoryTable];
    
}
- (void)addSecondCategoryView{
    secondCategoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 9/3*48 +20)];
    secondCategoryView.backgroundColor = [PublicMethod colorWithHexValue:0xEEEEEE alpha:1.0];
//    [self addSecondCategorySubviews];
    
}
- (void)addSecondCategorySubviews:(NSArray *)array{
    CGRect frame = secondCategoryView.frame;
    if (array.count %3 == 0) {
        frame.size.height = array.count/3 * 38 +25;
    }else{
        frame.size.height = (array.count/3 +1)* 38 +25;
    }
    secondCategoryView.frame = frame;
    
    for (int i = 0; i < array.count; i ++ ) {
        CategoryButton * btn = [CategoryButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(27 + (i %3) * 106 , 25 + (i /3) *(38), 79.66, 38);
        btn.backgroundColor = [PublicMethod colorWithHexValue:0xEEEEEE alpha:1.0];
        CategoryGoodsEntity * entity = [array objectAtIndex:i];
        btn.bu_category_id = [NSNumber numberWithInteger: entity.bu_category_id.integerValue];
        btn.has_son = entity.has_son;
        [btn setTitle:entity.category_name forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        if (IOS_VERSION <8) {
            btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        }else{
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        }
        
        btn.titleLabel.numberOfLines = 2;
        
        //        btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
        //        btn.layer.borderWidth = 0.5f;
        btn.tag = kSecondCategoryTag + i;
        [btn addTarget:self action:@selector(secondCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [secondCategoryView addSubview:btn];
    }
    
}
- (void)addBrandView{
    brandTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT - 35 - 64 -49)];
    if (IOS_VERSION>=7.0) {
        self.edgesForExtendedLayout=NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    brandTable.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
    brandTable.delegate = self;
    brandTable.dataSource = self;

    [self.view addSubview:brandTable];
    [brandTable setHidden:YES];

}
#pragma mark-
#pragma mark-button action
// 搜索
- (void)searchBarClick:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID7 props:nil];
    YHNewSearchGoodsViewController *searchVC = [[YHNewSearchGoodsViewController alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"bu_id"];
    [params setValue:@"default" forKey:@"order"];
    [params setValue:@"search" forKey:@"type"];
    [searchVC setRequstParams:params];
    //    searchVC.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController pushViewController:searchVC animated:NO];
}
- (void)tabBtnClick:(UIButton *)btn{
    if (btn.tag == kTabButtonLeft) {
        subType =  CategoryType;
        [categoryBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [brandBtn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];

        [line removeFromSuperview];
        [categoryBtn addSubview:line];
        
        [categoryTable setHidden:NO];
        [brandTable setHidden:YES];

        if (_categoryArray.count == 0) {
            [_categoryArray removeAllObjects];
            requestStyle =  Load_InitStyle;
            [self requestWithType:CategoryType];
        }
    }else{
        subType =  BrandType;
        [categoryBtn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
        [brandBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];

        [line removeFromSuperview];
        [brandBtn addSubview:line];
        
        [categoryTable setHidden:YES];
        [brandTable setHidden:NO];
        if (_allBrandArray.count == 0 ) {
            [_hotBrandArray removeAllObjects];
            [_allBrandArray removeAllObjects];
            [_sectionTitleArray removeAllObjects];
            requestStyle =  Load_InitStyle;
            [self requestWithType:BrandType];
        }

    }

}
- (void)unfoldSubCategory:(YHCategoryBtn *)btn withIndexPath:(NSIndexPath *)indexPath{
    
    if (isUnfold == YES && btn.tag ==unfoldTag) {
        isUnfold = NO;
    }else if(isUnfold == NO && btn.tag == unfoldTag){
        isUnfold = YES;
    }else if(btn.tag != unfoldTag){
        isUnfold = YES;
        unfoldTag = btn.tag;
    }
    [self.secondCategoryArray removeAllObjects];
    [secondCategoryView removeAllSubviews];
    [secondCategoryView removeFromSuperview];
    
    CategoryGoodsEntity * entity = [self.categoryArray objectAtIndex:btn.tag - kFirstCategoryTag];
    if ([entity.has_son isEqual:@"1"]) {
        [self.secondCategoryArray addObjectsFromArray:entity.next_cate];
    }
    [self addSecondCategorySubviews:self.secondCategoryArray];
    
    [categoryTable reloadData];
    [categoryTable scrollToRowAtIndexPath:btn.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    //    YHCategoryBtn * button  = (YHCategoryBtn *)btn;
    //    [button setSelectedImage:[UIImage imageNamed:@"category_selected_arrow"]];
    //    [button setBackgroundColor:[UIColor yellowColor]];
    
    //    UITableViewCell * cell = [categoryTable cellForRowAtIndexPath:button.indexPath];
    //    for (UIView * view in btn.superview.subviews) {
    //        YHCategoryBtn * button1  = (YHCategoryBtn *)view;
    //        if (button1.tag == button.tag) {
    //            [button1 setSelectedImage:[UIImage imageNamed:@"category_selected_arrow"]];
    //            [button1 setBackgroundColor:[UIColor yellowColor]];
    //        }else{
    //            [button1 setSelectedImage:nil];
    //            [button1 setBackgroundColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
    //        }
    //    }
    //    [self tableView:categoryTable heightForRowAtIndexPath:indexPath];
    //    [categoryTable setRowHeight:216];
    //    [button setSelectedImage:[UIImage imageNamed:@"category_selected_arrow"]];
    //    [button setBackgroundColor:[UIColor yellowColor]];
    //    [self tableView:categoryTable didSelectRowAtIndexPath:button.indexPath];
    
    
}
- (void)secondCategoryBtnClick:(CategoryButton *)btn{
    if ([btn.has_son isEqualToString:@"1"]) {
        YHThirdCategoryViewController * third = [[YHThirdCategoryViewController alloc]init ];
        third.navigationItem.title = btn.currentTitle;
        third.bu_category_id  = btn.bu_category_id;
        [self.navigationController pushViewController:third animated:YES];
    }else{
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        vc.navigationItem.title = btn.currentTitle;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"category" forKey:@"type"];
        [dic setValue:btn.bu_category_id forKey:@"bu_category_id"];
        [dic setValue:@"default" forKey:@"order"];
        [dic setObject:@"1" forKey:@"jump_type"];
        [vc setRequstParams:dic];
        [self.navigationController pushViewController:vc animated:YES];

    }
}
- (void)hotScreenBtnClick:(UIButton *)btn{
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    BrandEntity * selectEntity;
    selectEntity = [_hotBrandArray objectAtIndex:btn.tag - kHotScreenTag];
    self.selectName = selectEntity.brand_name;
    
    if (subType == BrandType) {
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        vc.navigationItem.title = selectEntity.brand_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"brand" forKey:@"type"];
        [dic setValue:selectEntity.bu_brand_id forKey:@"bu_brand_id"];
        [dic setValue:@"default" forKey:@"order"];
        [vc setRequstParams:dic];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)requestWithType:(SubType)type{
    if (type == BrandType) {
        [[NetTrans getInstance] API_New_Brand_List:self];
        
    }else{
        [[NetTrans getInstance] API_New_CategoryList:self  Bu_category_id:nil Page:nil Limit:nil];
    }
}
- (void)changeCityAction{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    requestStyle =  Load_InitStyle;
    [self requestWithType:CategoryType];
    [self requestWithType:BrandType];
    
    [self performSelector:@selector(hideHUDView) withObject:nil afterDelay:5];
}
#pragma -
#pragma -mark-UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == categoryTable) {
        return 1;
    }else{
        if (_hotBrandArray.count) {
            if (_allBrandArray.count) {
                return _allBrandArray.count + 1;
            }else{
                return 1;
            }
        }else{
            if (_allBrandArray.count) {
                return _allBrandArray.count;
            }else{
                return 0;
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == categoryTable) {
        return 0;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == categoryTable) {
        return nil;
    }else{
        UILabel * headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        headerView.font = [UIFont systemFontOfSize:15];
        headerView.text = [NSString stringWithFormat:@"  %@", [ _sectionTitleArray objectAtIndex:section]];
        headerView.textColor = [PublicMethod colorWithHexValue:0xfc5856 alpha:1.0];
        headerView.textAlignment = NSTextAlignmentLeft;
        headerView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        return headerView;
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == categoryTable) {
        return nil;
    }else{
        NSMutableArray * indexTitles = [NSMutableArray array];
        if (_sectionTitleArray.count >0) {
            indexTitles =[NSMutableArray arrayWithArray:_sectionTitleArray];
            if ([[indexTitles objectAtIndex:0]isEqualToString:@"热门品牌"]) {
                [indexTitles replaceObjectAtIndex:0 withObject:@"热门"];
            }else{
                //没有热门品牌
            }
        }
        return indexTitles;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == categoryTable){
        if (indexPath.row == (unfoldTag -kFirstCategoryTag) /3) {
            if (isUnfold == YES) {
                if (self.secondCategoryArray.count != 0) {
                    return secondCategoryView.frame.size.height + 216.0/2;
                }else{
                    return 216.0/2;
                }
                
            }else{
                return 216.0/2;
            }
        }else
            return 216.0/2;
    }else{
        if (_hotBrandArray.count) {
            if (_allBrandArray.count) {
                if (indexPath.section == 0 ) {
                    if (_hotBrandArray.count % 3 == 0) {
                        return (_hotBrandArray.count /3) * 48 +10;
                    }else{
                        return (_hotBrandArray.count /3 +1) * 48 +10;
                    }
                }else{
                    return 40;
                }
            }else{
                return (_hotBrandArray.count /3 +1) * 48 +10;
            }
        }else{
            if (_allBrandArray.count) {
                return 40;
            }else{
                return 0;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == categoryTable) {
        //
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        BrandEntity * selectEntity;
        if (_hotBrandArray.count !=0) {
            if (_allBrandArray.count != 0) {
                if (indexPath.section == 0 ) {
                    //不可选
                }else{
                    selectEntity = [[_allBrandArray objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
                    self.selectName = selectEntity.brand_name;
                }
            }else{
                //不可选
            }
        }else{
            if (_allBrandArray.count != 0) {
                selectEntity = [[_allBrandArray objectAtIndex:indexPath.section ]objectAtIndex:indexPath.row];
                self.selectName = selectEntity.brand_name;
            }else{
                //不可选
            }
        }
        if (subType == BrandType) {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = selectEntity.brand_name;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"brand" forKey:@"type"];
            [dic setValue:selectEntity.bu_brand_id forKey:@"bu_brand_id"];
            [dic setValue:@"default" forKey:@"order"];
            [vc setRequstParams:dic];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }

}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == categoryTable) {
        if (_categoryArray.count == 0) {
            return 0;
        }else{
            if (self.categoryArray.count %3 == 0) {
                return self.categoryArray.count /3;
            }else{
                return _categoryArray.count/3 +1;
            }
        }
    }else{
        if (_hotBrandArray.count) {
            if (_allBrandArray.count) {
                if (section == 0) {
                    return 1;
                }else{
                    return [[_allBrandArray objectAtIndex:section -1]count];
                }
            }else{
                return 1;
            }
        }else{
            if (_allBrandArray.count) {
                return [[_allBrandArray objectAtIndex:section]count];
            }else{
                return 0;
            }
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == categoryTable) {
        NSString *CellIndentifier = [NSString stringWithFormat: @"CellIndentifier%ld",(long)indexPath.row];
        //        NSString *CellIndentifier = @"CellIndentifier";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
            NSInteger numsOfnow = 11%(indexPath.row +1);
            if (self.categoryArray.count != 0) {
                if (self.categoryArray.count %3 == 0) {
                    numsOfnow = 3;
                }else{
                    if (indexPath.row != [categoryTable numberOfRowsInSection:indexPath.section] -1) {
                        numsOfnow = 3;
                    }else{
                        numsOfnow = self.categoryArray.count - ([categoryTable numberOfRowsInSection:indexPath.section] -1) *3;
                    }
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];

            //创建一级品类视图控件
            for (int i = 0; i < numsOfnow; i ++ ) {
                YHCategoryBtn * btn = [[YHCategoryBtn alloc]initWithFrame:CGRectMake(i%3 *(SCREEN_WIDTH/3.0), 0, SCREEN_WIDTH/3.0, 108)];
                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                btn.indexPath = indexPath;
                btn.tag = indexPath.row * 3 + i +kFirstCategoryTag;
                [btn addTarget:self action:@selector(unfoldSubCategory: withIndexPath:) forControlEvents:UIControlEventTouchUpInside];
                btn.userInteractionEnabled = YES;
                [cell.contentView addSubview:btn];
                
                if (i%3 == 0 || i%3 == 1) {
                    UIView * yline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0-1, 0, 1, 108)];
                    yline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                    [btn addSubview:yline];
                }
                if (numsOfnow == 1 || numsOfnow == 2) {
                    UIView * yline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-1, 0, 1, 108)];
                    yline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                    [cell.contentView addSubview:yline];
                }
//                if (i/3 != self.categoryArray.count/3) {
//                    UIView * xline = [[UIView alloc]initWithFrame:CGRectMake(0, 108-1, SCREEN_WIDTH/3.0, 1)];
//                    xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//                    [btn addSubview:xline];
//                }
            }
            UIView * xline = [[UIView alloc]initWithFrame:CGRectMake(0, 108-1, SCREEN_WIDTH, 1)];
            xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
            [cell.contentView addSubview:xline];
        }
        
        
        NSInteger numsOfnow = 3;
        if (self.categoryArray.count != 0) {
            if (self.categoryArray.count %3 == 0) {
                numsOfnow = 3;
            }else{
                if (indexPath.row != [categoryTable numberOfRowsInSection:indexPath.section]-1) {
                    numsOfnow = 3;
                }else{
                    numsOfnow = self.categoryArray.count - ([categoryTable numberOfRowsInSection:indexPath.section] -1) *3;
                }
            }
        }
        //为一级品类赋值
        for (int i = 0; i < numsOfnow; i ++ ){
            CategoryGoodsEntity * categoryEntity = [_categoryArray objectAtIndex:i + indexPath.row *3];
            YHCategoryBtn * button  = (YHCategoryBtn *)[cell.contentView viewWithTag:i + indexPath.row *3 + kFirstCategoryTag];
            [button.icon setImageWithURL:[NSURL URLWithString:categoryEntity.icon] placeholderImage:[UIImage imageNamed:@"goods_default"]];
            [button.name setText:categoryEntity.category_name];
        }
//        for (UIView * view in cell.contentView.subviews) {
//            if ([view isKindOfClass:[YHCategoryBtn class]]){
//                YHCategoryBtn * button  = (YHCategoryBtn *)view;
//                [button.icon setImageWithURL:[NSURL URLWithString:categoryEntity.icon] placeholderImage:[UIImage imageNamed:@"goods_default"]];
//                [button.name setText:categoryEntity.category_name];
//            }
//        }
        //展开/合上二级品类，并添加指示箭头
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[YHCategoryBtn class]]) {
                YHCategoryBtn * button  = (YHCategoryBtn *)view;
                if (button.tag == unfoldTag) {
                    if (isUnfold == YES) {
                        [button setSelectedImage:[UIImage imageNamed:@"category_selected_arrow"]];
                        [UIView  beginAnimations:nil context:NULL];
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDuration:0.5];
                        if (self.secondCategoryArray.count != 0) {
                            [cell.contentView addSubview:secondCategoryView];
                        }
                        [UIView commitAnimations];
                    }else{
                        [button setSelectedImage:nil];
                        [button setBackgroundColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
                        [secondCategoryView removeFromSuperview];
                    }
                    
                }else{
                    [button setSelectedImage:nil];
                    [button setBackgroundColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
                }
            }
        }
        return cell;
    //品牌列表
    }else{
        if (_hotBrandArray.count != 0) {
            if (_allBrandArray.count != 0) {
                if (indexPath.section == 0) {
                    NSString * cellIdentifier = @"hotCell";
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
                        
                        for (int i = 0; i < [_hotBrandArray count]; i ++ ) {
                            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.frame = CGRectMake(10 + (i %3) * 92 , 10 + (i /3) *48, 82, 38);
                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            BrandEntity * entity = [_hotBrandArray objectAtIndex:i];
                            [btn setTitle:entity.brand_name forState:UIControlStateNormal];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
                            btn.titleLabel.font = [UIFont systemFontOfSize:15];
                            btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
                            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                            btn.titleLabel.numberOfLines = 1;
                            btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                            btn.layer.borderWidth = 1.0f;
                            btn.tag = kHotScreenTag + i;
                            [btn addTarget:self action:@selector(hotScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.contentView addSubview:btn];
                        }
                    }
                    return cell;
                }else {
                    NSString * cellIdentifier = @"allCell";
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    }
                    BrandEntity * entity = [[_allBrandArray objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    cell.textLabel.text = entity.brand_name;
                    cell.textLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
//                    //选中全部
//                    if (entity.isSelected == YES) {
//                        cell.arrow.image = [UIImage imageNamed:@"tab_sel"];
//                        //                    [cell setSelected:YES];
//                    }else{
//                        cell.arrow.image = nil;
//                    }
                    return cell;
                }
                
            }else{
                NSString * cellIdentifier = @"hotCell";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
                    
                    for (int i = 0; i < [_hotBrandArray count]; i ++ ) {
                        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(10 + (i %3) * 92 , 10 + (i /3) *48, 82, 38);
                        btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                        BrandEntity * entity = [_hotBrandArray objectAtIndex:i];
                        [btn setTitle:entity.brand_name forState:UIControlStateNormal];
                        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
                        btn.titleLabel.font = [UIFont systemFontOfSize:15];
                        btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
                        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        btn.titleLabel.numberOfLines = 1;
                        btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                        btn.layer.borderWidth = 0.5f;
                        btn.tag = kHotScreenTag + i;
                        [btn addTarget:self action:@selector(hotScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                    }
                }
                return cell;
            }
        }else{
            if (_allBrandArray.count != 0) {
                NSString * cellIdentifier = @"allCell";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                BrandEntity * entity = [[_allBrandArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                cell.textLabel.text = entity.brand_name;
//                //选中全部
//                if (entity.isSelected) {
//                    cell.arrow.image = [UIImage imageNamed:@"tab_sel"];
//                    //                [cell setSelected:YES];
//                }else{
//                    cell.arrow.image = nil;
//                }
                return cell;
            }else{
                return nil;
            }
        }

    }
}

#pragma mark-
#pragma mark-YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
    requestStyle = Load_RefrshStyle;
    
    [self requestWithType:CategoryType];
    [self requestWithType:BrandType];
    NSLog(@"refresh start requestInterface.");
}
//
///*加载更多接口请求*/
//- (void)reloadMoreTableViewDataSource{
//    _moreloading = YES;
//    countPage ++;
//    requestStyle = Load_MoreStyle;
//    [self requestWithType:subType];
//    
//    NSLog(@"getMore start requestInterface.");
//}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    isFirstEnter = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(t_API_NEW_CATEGORY_LIST == nTag)
    {
        isFirstEnter = NO;
        if (requestStyle != Load_MoreStyle) {
            [_categoryArray removeAllObjects];
        }
        NSMutableArray *array  = (NSMutableArray *)netTransObj;
        [self.categoryArray addObjectsFromArray:array];
        
        [categoryTable reloadData];
//        [self._tableView reloadData];
    }else{
        isFirstEnter = NO;
        if (requestStyle != Load_MoreStyle) {
            [_hotBrandArray removeAllObjects];
            [_allBrandArray removeAllObjects];
            [_sectionTitleArray removeAllObjects];
        }
        NSDictionary *dict = (NSDictionary *)netTransObj;
        //        if (requestStyle == Load_RefrshStyle) {
        //            [goodsData removeAllObjects];
        //            [enoughGoodsData removeAllObjects];
        //        }
        //热门品牌数组
        if ([dict objectForKey:@"hot_brand_list"]) {
            [_hotBrandArray addObjectsFromArray:[dict objectForKey:@"hot_brand_list"]];
            
        }
        //品牌数组
        NSMutableArray * wordArray = [[NSMutableArray alloc]init];
        if ([dict objectForKey:@"brand_list"]) {
            NSArray * array = [dict objectForKey:@"brand_list"];
            for (char i = '#'; i <= 'Z'; i ++) {
                NSMutableArray * arr = [[NSMutableArray alloc]init];
                for (BrandEntity * entity in array) {
                    if ([entity.brand_name isEqualToString:self.string]) {
                        entity.isSelected = YES;
                    }
                    if ([entity.letter isEqualToString:[NSString stringWithFormat:@"%c",i]]) {
                        [arr addObject:entity];
                    }
                }
                if (arr.count != 0) {
                    [wordArray addObject:[NSString stringWithFormat:@"%c",i]];
                    [_allBrandArray addObject:arr];
                }
            }
        }
        
//        if (_allBrandArray.count) {
//            NSMutableArray * arr = [[NSMutableArray alloc]init ];
//            BrandEntity * entity = [[BrandEntity alloc]init];
//            entity.brand_name = @"全部品牌";
//            if (self.string.length == 0 || self.string == nil ) {
//                entity.isSelected = YES;
//            }
//            [arr addObject:entity];
//            [_allBrandArray insertObject:arr atIndex:0];
//        }
        //分区标题数组
        if (_hotBrandArray.count) {
            if (_allBrandArray.count) {
                [_sectionTitleArray addObject:@"热门品牌"];
//                [_sectionTitleArray addObject:@"全部"];
                for (int i = 0 ; i < wordArray.count; i ++ ) {
                    [_sectionTitleArray addObject:[wordArray objectAtIndex:i]];
                }
            }else{
                [_sectionTitleArray addObject:@"热门品牌"];;
            }
        }else{
            if (_allBrandArray.count) {
//                [_sectionTitleArray addObject:@"全部"];
                for (int i = 0 ; i < wordArray.count; i ++ ) {
                    [_sectionTitleArray addObject:[wordArray objectAtIndex:i]];
                }
            }else{
                //空
            }
        }
        
        [brandTable reloadData];
    }
//    [self finishLoadTableViewData];
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
//    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
}


@end