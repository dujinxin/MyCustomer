//
//  YHGoodsListViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-13.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHGoodsListViewController.h"

@interface YHGoodsListViewController ()

@end

@implementation YHGoodsListViewController
@synthesize goodsList;
@synthesize goodsListEntity;
@synthesize cateGory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        goodsListEntity = [[GoodsListEntity alloc] init];
        goodsList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"热销商品";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [[NetTrans getInstance] buy_getGoodsList:self Type:@"brand" TypeId:cateGory.bu_brand_id ApiTag:t_API_CART_GOODSLISET_API];
    
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
	_reloading = YES;
    NSLog(@"getMore start requestInterface.");
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    GoodsEntity *goods = [goodsList objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.contentView removeAllSubviews];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 65, 65)];
    [icon setOnlineImage:goods.goods_image placeholderImage:[UIImage imageNamed:@"tianHongLogo.png"]];
    [cell.contentView addSubview:icon];
    
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(95, 13, 200, 20)];
    goodsName.text = goods.goods_name;
    [cell.contentView addSubview:goodsName];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(95, 50, 80, 20)];
    price.text = [NSString stringWithFormat:@"¥: %@",goods.price];
    price.font = [UIFont boldSystemFontOfSize:16];
    price.textColor = [UIColor redColor];
    [cell.contentView addSubview:price];
    
    UILabel *originPrice = [[UILabel alloc] initWithFrame:CGRectMake(175, 50, 80, 20)];
    originPrice.font = [UIFont systemFontOfSize:16];
    originPrice.textColor = [UIColor grayColor];
    
    UIButton *addCart = [PublicMethod addButton:CGRectMake(220, 45, 80, 30) title:@"加入购物车" backGround:@"login.png" setTag:indexPath.row setId:self selector:@selector(accCart:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview:addCart];
    
    return cell;
}
- (void)accCart:(id)sender{
    UIButton *btn = (UIButton *)sender;
    GoodsEntity *goods = [goodsList objectAtIndex:btn.tag];
    [[NetTrans getInstance] addCart:self GoodsID:goods.bu_goods_id Total:@"1"];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    if (nTag == t_API_CART_GOODSLISET_API) {
        self.goodsListEntity = (GoodsListEntity *)netTransObj;
        self.goodsList = goodsListEntity.goodsArray;
        [self._tableView reloadData];
    }
    if (nTag == t_API_ADDCART_GOODS) {
        [self showNotice:@"添加成功!"];
    }
    [self finishLoadTableViewData];
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    [self finishLoadTableViewData];
    if (nTag == t_API_CART_GOODSLISET_API)
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
    else if (nTag == t_API_ADDCART_GOODS)
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
    [self showNotice:errMsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
