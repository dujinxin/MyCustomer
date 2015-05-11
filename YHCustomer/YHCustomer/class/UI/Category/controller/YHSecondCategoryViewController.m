//
//  YHSecondCategoryViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  二级分类列表

#import "YHSecondCategoryViewController.h"
#import "CateBrandEntity.h"
#import "YHWebGoodListViewController.h"
#import "YHGoodsTabViewController.h"

@interface YHSecondCategoryViewController ()

@end

@implementation YHSecondCategoryViewController
@synthesize cateSecondArray;
@synthesize entity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cateSecondArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title= entity.category_name;
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self._tableView.frame = CGRectMake(0, 0, 320, ScreenSize.height - NAVBAR_HEIGHT);
    [[NetTrans getInstance] API_CateGoryList:self Bu_id:@"0" Bu_category_id:entity.bu_category_id Page:[NSString stringWithFormat:@"%ld",(long)countPage] Limit:@"10"];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CateBrandEntity *cateGory = [cateSecondArray objectAtIndex:indexPath.row];
    YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
    vc.navigationItem.title = cateGory.category_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"category" forKey:@"type"];
    [dic setValue:cateGory.bu_category_id forKey:@"bu_category_id"];
    [dic setValue:@"default" forKey:@"order"];
    [dic setObject:@"1" forKey:@"jump_type"];
    [vc setRequstParams:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    CateBrandEntity *cateGory = [cateSecondArray objectAtIndex:indexPath.row];
//    YHWebGoodListViewController *goodList = [[YHWebGoodListViewController alloc] init];
//    [goodList setParamerWihtType:@"5" Id:cateGory.bu_category_id];
//    goodList.navigationItem.title = cateGory.category_name;
//    [self.navigationController pushViewController:goodList animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cateSecondArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    [cell.contentView removeAllSubviews];
    CateBrandEntity *cateGory = [cateSecondArray objectAtIndex:indexPath.row];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)];
    [icon setImageWithURL:[NSURL URLWithString:cateGory.icon] placeholderImage:[UIImage imageNamed:@"icon.png"]];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 8;
    [cell.contentView addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 200, 40)];
    nameLabel.text = cateGory.category_name;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:nameLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark-
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    requestStyle = Load_RefrshStyle;
    countPage = 1;
    [[NetTrans getInstance] API_CateGoryList:self Bu_id:@"0" Bu_category_id:entity.bu_category_id Page:[NSString stringWithFormat:@"%ld",(long)countPage] Limit:@"10"];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
	_reloading = YES;
    requestStyle = Load_MoreStyle;
    countPage ++;
    self.dataState = EGOOHasMore;
    [[NetTrans getInstance] API_CateGoryList:self Bu_id:@"0" Bu_category_id:entity.bu_category_id Page:[NSString stringWithFormat:@"%ld",(long)countPage] Limit:@"10"];
    NSLog(@"getMore start requestInterface.");
}

#pragma mark-
#pragma mark -----------------------------------------ConnectRequestDelegate
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_CATEGORY_LIST == nTag)
    {
        if (requestStyle == Load_MoreStyle) {
           [self.cateSecondArray addObjectsFromArray:(NSMutableArray *)netTransObj];
        } else {
            [self.cateSecondArray removeAllObjects];
            self.cateSecondArray = (NSMutableArray *)netTransObj;
            [self addRefreshTableFooterView];
        }

        if (requestStyle == Load_MoreStyle) {
            if (self.total == cateSecondArray.count) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{
            if (cateSecondArray.count <10) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
        }
        self.total = cateSecondArray.count;
        [self._tableView reloadData];
        [self testFinishedLoadData];
        [self finishLoadTableViewData];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
