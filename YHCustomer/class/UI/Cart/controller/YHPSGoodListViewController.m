//
//  YHPSGoodListViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-4-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  配送－商品列表(商品清单)

#import "YHPSGoodListViewController.h"

@interface YHPSGoodListViewController ()

@end

@implementation YHPSGoodListViewController
@synthesize dataArray;
@synthesize goodsWight;
@synthesize logistics_amount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIView *)headerViewLabel{
    UIView *headBg = [PublicMethod addBackView:CGRectMake(0, 0, 320, 52) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    
    
    UIView *bgCell = [PublicMethod addBackView:CGRectMake(0, 7, 320, 45) setBackColor:[UIColor whiteColor]];
    [headBg addSubview:bgCell];

    UILabel *goodsNum = [PublicMethod addLabel:CGRectMake(10, 7, 80, 45) setTitle:[NSString stringWithFormat:@"共%d个商品",self.goods_num.intValue] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
  
    goodsNum.backgroundColor = [UIColor whiteColor];
    
    UILabel *totalWeight = [PublicMethod addLabel:CGRectMake(90, 7, 100, 45) setTitle:[NSString stringWithFormat:@"%@",self.goodsWight] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
    totalWeight.backgroundColor = [UIColor whiteColor];

    
    
    UILabel *yunfeiTitle = [PublicMethod addLabel:CGRectMake(220, 7, 40, 45) setTitle:[NSString stringWithFormat:@"运费:"] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
    yunfeiTitle.backgroundColor = [UIColor whiteColor];

    
//    float total=0.0f;
//    for (NSDictionary *dic in self.dataArray) {
//        total+= [[dic objectForKey:@"discount_price"] floatValue] * [[dic objectForKey:@"total"] floatValue];
//    }
    
    UILabel *yunfeiAmount = [PublicMethod addLabel:CGRectMake(255, 7, 60, 45) setTitle:[NSString stringWithFormat:@"¥ %@",self.logistics_amount] setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:14]];

    yunfeiAmount.backgroundColor = [UIColor whiteColor];

    
    [headBg addSubview:goodsNum];
    [headBg addSubview:totalWeight];
    [headBg addSubview:yunfeiTitle];
    [headBg addSubview:yunfeiAmount
     ];
    
    UIView *bgLine = [PublicMethod addBackView:CGRectMake(0, 51, 320, 1) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    [headBg addSubview:bgLine];
    return headBg;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商品清单";
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-15)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
	// Do any additional setup after loading the view.
    [[PSNetTrans getInstance] ps_getGoodsList:self goods_id:self.goods_id total:self.total];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView =
        [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor =
        [UIColor whiteColor];
        cell.selected = NO;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *headImg = [PublicMethod addImageView:CGRectMake(10, 15, 45, 45) setImage:@""];
        headImg.tag = 100;
//        headImg.layer.masksToBounds = YES;
//        headImg.layer.cornerRadius = 4;
        headImg.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
        headImg.layer.borderWidth = 1.0f;
        [cell.contentView addSubview:headImg];
        
        UILabel *titleLabel = [PublicMethod addLabel:CGRectMake(65, 10, 200, 30) setTitle:@"大豆花生油" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *numLabel = [PublicMethod addLabel:CGRectMake(65, 50, 60, 20) setTitle:@"" setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:12]];
        numLabel.tag = 102;
        [cell.contentView addSubview:numLabel];
        
        UILabel *totalLabel = [PublicMethod addLabel:CGRectMake(260, 50, 60, 20) setTitle:@"¥ 10" setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:12]];
        totalLabel.tag = 103;
        [cell.contentView addSubview:totalLabel];
        
        UIView *bgLine = [PublicMethod addBackView:CGRectMake(0, 79, 320, 1) setBackColor:[UIColor lightGrayColor]];
        bgLine.alpha = .2f;
        [cell.contentView addSubview:bgLine];
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
    [icon setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:101];
    title.text = [dic objectForKey:@"goods_name"];
    
    UILabel *numLabel = (UILabel *)[cell.contentView viewWithTag:102];
    numLabel.text =[NSString stringWithFormat:@"  x %@",[dic objectForKey:@"total"]];

    UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:103];
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",[dic objectForKey:@"discount_price"]];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == t_API_PS_GOODS_LIST)
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
    [[iToast makeText:errMsg]show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    if (nTag == t_API_PS_GOODS_LIST) {
        NSLog(@"%@",(NSMutableArray *)netTransObj);
        self.dataArray = (NSMutableArray *)netTransObj;
        _tableView.tableHeaderView = [self headerViewLabel];
        [_tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
