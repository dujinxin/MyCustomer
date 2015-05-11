 //
//  YHThirdCategoryViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-10-17.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHThirdCategoryViewController.h"
#import "YHNewSearchGoodsViewController.h"
#import "YHGoodsTabViewController.h"
#import "CategoryGoodsEntity.h"

@interface YHThirdCategoryViewController ()
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
}
@end

@implementation YHThirdCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIButton * leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftItem.frame = CGRectMake(7, 7, 30, 30);
//    [leftItem addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
//    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.leftBarButtonItems= BACKBARBUTTON(@"返回", @selector(back:));
    // 设置导航条右侧按钮
//    [self setRightBarButton:self Action:@selector(search:) SetImage:@"category_Search.png" SelectImg:@"category_Search_Select.png"];
    [self setRightBarButton:self Action:@selector(search:) SetImage:@"right_search" SelectImg:@"right_search"];
    _dataArray = [[NSMutableArray alloc]init ];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [[NetTrans getInstance] API_New_CategoryList:self  Bu_category_id:self.bu_category_id Page:nil Limit:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------------------------ButtonClickMethod
- (void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)search:(id)sender{
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
#pragma mark --------------------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count ;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        
        cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        cell.textLabel.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
        cell.textLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
        line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [cell.contentView addSubview:line];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
        [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
        [cell.contentView addSubview:arrow];
    }
    CategoryGoodsEntity * entity = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = entity.category_name;
    
    return cell;
}
#pragma mark --------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CategoryGoodsEntity * entity = [_dataArray objectAtIndex:indexPath.row];
    if ([entity.has_son isEqualToString:@"1"]) {
        YHThirdCategoryViewController * third = [[YHThirdCategoryViewController alloc]init ];
        third.navigationItem.title = entity.category_name;
        third.bu_category_id  = [NSNumber numberWithInteger: entity.bu_category_id.integerValue];
        [self.navigationController pushViewController:third animated:YES];
    }else{
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        CategoryGoodsEntity * entity = [_dataArray objectAtIndex:indexPath.row];
        vc.navigationItem.title = entity.category_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"category" forKey:@"type"];
        [dic setValue:entity.bu_category_id forKey:@"bu_category_id"];
        [dic setValue:@"default" forKey:@"order"];
        [dic setObject:@"1" forKey:@"jump_type"];
        [vc setRequstParams:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{

    if(t_API_NEW_CATEGORY_LIST == nTag)
    {
        NSMutableArray *array  = (NSMutableArray *)netTransObj;
        [_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
    }
//    [self finishLoadTableViewData];
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    //    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
