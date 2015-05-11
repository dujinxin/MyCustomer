//
//  YHCartViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  购物车

#import "YHCartViewController.h"
#import "YHMainViewController.h"
#import "YHOrderViewController.h"
#import "YHNewOrderViewController.h"
#import "OneOrderEditorView.h"
#import "OneOrderInfoView.h"
#import "YHGoodsDetailViewController.h"

#define ALL_SELECT_BTNTAG 1000
#define ALL_DELETE_BTNTAG 1001
#define TABLEVIEW_HEADER_TOTAL_NUM_TAG 1002
@interface YHCartViewController (){
@private
    UIImage     *selectAllBgImage;
    UIImage     *selectAllSelectImage;
    BOOL        isAction;
    //暂定
    NSString   *allSelectedNum;
    BOOL        isFirst;
}

@end

@implementation YHCartViewController

@synthesize cartArray;
@synthesize contentTable;
@synthesize editor;
@synthesize totolPrice;
@synthesize listEntity;
@synthesize totalGoodsLabel;
@synthesize savePriceLabel;
@synthesize allSelect,isFromOther;
@synthesize totalAmount,totalNum;
@synthesize bu_Goods_Id;
#pragma mark -
#pragma mark ------------------------------------------------------------------生命周期

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        //  Custom initialization
        isAction   = YES;
        listEntity = [[GoodsListEntity alloc] init];
        cartArray  = [[NSMutableArray alloc] init];
        allSelect  = YES;
        isFirst    = YES;
        self.totalNum = @"0";
        allSelectedNum = @"0";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
//    //临时测试所用
//    [self showAlert:[NSString stringWithFormat:@"当前门店编码：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]]];
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
//    [MTA trackCustomKeyValueEvent:EVENT_ID40 props:nil];
}

- (void)requestCartList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetTrans getInstance] getBuyCartList:self Page:[NSString stringWithFormat:@"%d",1]];
    });
}

- (void)viewDidDisappear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    queue = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 将购物车商品全部改为勾选状态
    if ([[UserAccount instance] isLogin]) {
        //开启线程会导致无网络的时候提示信息为空
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NetTrans getInstance] update_pay:self CartId:nil Type:@"0"];
//        });
    }
    
    editor =NO;
	//  Do any additional setup after loading the view.
    cartArray =[[NSMutableArray alloc] init];
    selectAllBgImage = [UIImage imageNamed:@"agreeBg.png"];
    selectAllSelectImage = [UIImage imageNamed:@"agreeArg.png"];
    
    self.navigationItem.title = @"购物车";
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 52, 44);
    
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [backBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
    
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -15;
    }else{
        negativeSpacer.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
    self.navigationItem.leftBarButtonItems =barItems;
    
    // 设置导航条右侧按钮
//    [self setRightBarButton:self Action:@selector(editor:) SetImage:@"cart_Edit.png" SelectImg:@"cart_Edit_Select.png"];
    [self setRightBarButton:self Action:@selector(editor:) SetImage:nil SelectImg:nil title:@"编辑"];
    // tableView
    contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-50) style:UITableViewStylePlain];
    contentTable.delegate = self;
    contentTable.dataSource = self;
    contentTable.backgroundColor = [UIColor clearColor];
    contentTable.backgroundView = nil;
    contentTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentTable];
    contentTable.tableFooterView = [self footTableView];
    [self.view addSubview:[self drawFootView]];
}

#pragma mark ---------------   UI
- (UIView *)addTableViewHeaderView:(GoodsListEntity *)entity{
    UILabel *title = [PublicMethod addLabel:CGRectMake(0, 0, SCREEN_WIDTH, 27) setTitle:[NSString stringWithFormat:@" %@",entity.title] setBackColor:[PublicMethod colorWithHexValue:0x877b6e alpha:1] setFont:[UIFont systemFontOfSize:14]];
    title.textAlignment = NSTextAlignmentLeft;
    title.backgroundColor = [PublicMethod colorWithHexValue:0xf5f1ea alpha:1.0f];
    
    UILabel *content = [PublicMethod addLabel:CGRectMake(0, 20, SCREEN_WIDTH, 54) setTitle:[NSString stringWithFormat:@" %@",entity.content] setBackColor:[PublicMethod colorWithHexValue:0x877b6e alpha:1] setFont:[UIFont systemFontOfSize:11]];
    content.textAlignment = NSTextAlignmentLeft;
    content.backgroundColor = [PublicMethod colorWithHexValue:0xf5f1ea alpha:1.0f];
    content.text = entity.content;
    [content setFrame:CGRectMake(4, 22, SCREEN_WIDTH,self.height+3)];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 27+self.height)];
    headView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f1ea alpha:1.0];
    [headView addSubview:title];
    [headView addSubview:content];

    return headView;
}


/*tableViewFoot*/
- (UIView *)footTableView{
    UIView *foot = [PublicMethod addBackView:CGRectMake(0, 0, 320, 28) setBackColor:[UIColor clearColor]];
    
    UILabel *footTitle = [PublicMethod addLabel:CGRectMake(10, 0, 100, 28) setTitle:[NSString stringWithFormat:@"共%d件商品",0] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1] setFont:[UIFont systemFontOfSize:14]];
    self.totalGoodsLabel = footTitle;
    [foot addSubview:footTitle];
    
    UILabel *weight = [PublicMethod addLabel:CGRectMake(94, 0, 100, 28) setTitle:[NSString stringWithFormat:@"重量%0.1f公斤",0.0] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1] setFont:[UIFont systemFontOfSize:14]];
    self.weightLabel = weight;
    [foot addSubview:weight];
    
    UILabel *savePrice = [PublicMethod addLabel:CGRectMake(190, 0, 130, 28) setTitle:[NSString stringWithFormat:@"为您节省%.2f",0.00] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1] setFont:[UIFont systemFontOfSize:14]];
    self.savePriceLabel = savePrice;
    [foot addSubview:savePrice];
    return foot;
}

/*footView*/
-(UIView *)drawFootView
{
    footView =[[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height-NAVBAR_HEIGHT-50, 320, 50)];
    footView.backgroundColor =[PublicMethod colorWithHexValue:0xd3d3d4 alpha:1];
    
    UILabel *priceInfo =[[UILabel alloc] initWithFrame:CGRectMake(20, 11, 200, 24)];
    priceInfo.backgroundColor=[UIColor clearColor];
    priceInfo.textColor =[PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    priceInfo.text =[NSString stringWithFormat:@"¥ %@",@"0.00"];
    priceInfo.font =[UIFont boldSystemFontOfSize:22.0];
    self.totalAmount = priceInfo;
    [footView addSubview:priceInfo];
    
    //提交
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame =CGRectMake(220, 0, 100, 50);
    //    sendButton.backgroundColor = [PublicMethod colorWithHexValue:0xFC7F4A alpha:1];
    sendButton.backgroundColor= RGBCOLOR(255, 126, 0);
    [sendButton setTitle:@"去结算" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont systemFontOfSize:17.0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sendButton];
    return footView;
}


#pragma -
#pragma mark ----------------------------- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.listEntity.content.length > 0)
    {
        self.height = [PublicMethod getLabelHeight:self.listEntity.content setLabelWidth:SCREEN_WIDTH setFont:[UIFont systemFontOfSize:11.0]];
        return 35.0+self.height+27;
    } else if (self.listEntity.content.length == 0) {
        return 35.0+27;
    } else{
        return 35.0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    view.backgroundColor =[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    
    allSelectBtn = [PublicMethod addButton:CGRectMake(5, 8, 20, 20) title:nil backGround:@"agreeArg.png" setTag:ALL_SELECT_BTNTAG setId:self selector:@selector(selectAll:) setFont:nil setTextColor:nil];
    if (allSelect) {
        [allSelectBtn setBackgroundImage:selectAllSelectImage forState:UIControlStateNormal];
    }else{
        [allSelectBtn setBackgroundImage:selectAllBgImage forState:UIControlStateNormal];
    }
    [view addSubview:allSelectBtn];
    
    UIButton *deleteAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(220+7, 5, 85, 25)];
    [deleteAllBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [deleteAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteAllBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0]];
    deleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteAllBtn addTarget:self action:@selector(delegateAll:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteAllBtn];
    
    if (editor) {
        allSelectBtn.hidden = YES;
        deleteAllBtn.hidden = NO;
    }else{
        allSelectBtn.hidden = NO;
        deleteAllBtn.hidden = YES;
    }
    
    UILabel *totalNumLabel =[[UILabel alloc] initWithFrame:CGRectMake(40, 9, 180, 20)];
    
    totalNumLabel.text = [NSString stringWithFormat:@"全选%@件商品",allSelectedNum];
   
    
    if (editor) {
        totalNumLabel.text = [NSString stringWithFormat:@"%@件商品",allSelectedNum];
        totalNumLabel.frame = CGRectMake(10, 9, 180, 20);
    }
    totalNumLabel.textColor =[UIColor blackColor];
    totalNumLabel.backgroundColor =[UIColor clearColor];
    totalNumLabel.tag = TABLEVIEW_HEADER_TOTAL_NUM_TAG;
    totalNumLabel.font =[UIFont systemFontOfSize:15.0];
    [view addSubview:totalNumLabel];
    
    if (self.listEntity.title.length>0) {
        [head addSubview:[self addTableViewHeaderView:self.listEntity]];
        head.frame = CGRectMake(0, 0, 320, 35+self.height+27);
        view.frame = CGRectMake(0, self.height+27, 320, 35);
    } else if (self.listEntity.content.length == 0) {
        UILabel *title = [PublicMethod addLabel:CGRectMake(0, 0, SCREEN_WIDTH, 27) setTitle:@" 用永辉微店购物：贴心、方便、省钱！" setBackColor:[PublicMethod colorWithHexValue:0x877b6e alpha:1] setFont:[UIFont systemFontOfSize:14]];
        title.textAlignment = NSTextAlignmentLeft;
        title.backgroundColor = [PublicMethod colorWithHexValue:0xf5f1ea alpha:1.0f];
        [head addSubview:title];
        
       head.frame = CGRectMake(0, 0, 320, 35+27);
       view.frame = CGRectMake(0, 27, 320, 35);
    } else {
        self.height = 0;
    }
    
    [head addSubview:view];
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(!editor) {
        GoodsEntity *entity = [self.cartArray objectAtIndex:indexPath.row];
        YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
        detailVC.fromCart = YES;
        detailVC.refresh = ^(){
            [self requestCartList];
        };
        NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.bu_goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        [detailVC setMainGoodsUrl:url goodsID:entity.bu_goods_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -
#pragma mark ----------------------------------------------- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    GoodsEntity *entity = [self.cartArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    if (editor) {
        OneOrderEditorView *tempInfoView=[[OneOrderEditorView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        [tempInfoView drawEditorView:entity NSIndex:indexPath];
        tempInfoView.mController =self;
        [cell.contentView addSubview:tempInfoView];
    }
    else{
        OneOrderInfoView *tempInfoView=[[OneOrderInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        tempInfoView.controller = self;
        [tempInfoView setOrderCartInfoGoodEntity:entity];
        [cell.contentView addSubview:tempInfoView];  
    }
    return cell;
}

#pragma mark -----------------------------------------------button action
- (void)modifyCartGoodsNum:(NSString *)bu_goods_id GoodsNum:(NSString *)goodsNum{
    [[PSNetTrans getInstance] API_cart_change_count:self cart_id:bu_goods_id num:goodsNum];
}

- (void)back:(id)sender{
    
    if (isFromOther) {
        
        if (editor) {
//            [self setRightBarButton:self Action:@selector(editor:) SetImage:@"cart_Edit.png" SelectImg:@"cart_Edit_Select.png"];
            [self setRightBarButton:self Action:@selector(editor:) SetImage:nil SelectImg:nil title:@"编辑"];
            editor =NO;
            [contentTable reloadData];
            
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
            
            [self.view addSubview:footView];
            contentTable.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-50);

        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }

    }else{
        if (editor) {
//            [self setRightBarButton:self Action:@selector(editor:) SetImage:@"cart_Edit.png" SelectImg:@"cart_Edit_Select.png"];
            [self setRightBarButton:self Action:@selector(editor:) SetImage:nil SelectImg:nil title:@"编辑"];
            editor =NO;
            [contentTable reloadData];
            
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
            
            [self.view addSubview:footView];
            contentTable.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-50);
            
        } else {
            _callBack();
            [self dismissViewControllerAnimated:YES completion:^(){
                
            }];
        }

    }
}

- (void)editor:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID12 props:nil];
    UIButton *btn = (UIButton *)sender;
    if (editor) {
//        [btn setBackgroundImage:[UIImage imageNamed:@"cart_Edit.png"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"cart_Edit_Select.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        editor =NO;
        [self performSelector:@selector(done:) withObject:nil];
        
        
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
        
        [self.view addSubview:footView];
        contentTable.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-50);
    }
    else{
//        [btn setBackgroundImage:[UIImage imageNamed:@"cart_Finish.png"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"cart_Finish_Select.png"] forState:UIControlStateHighlighted];
        editor =YES;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        
        
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
        
        [footView removeFromSuperview];
         contentTable.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT);
    }
    [contentTable reloadData];
}

/* 删除购物车单个商品 */
-(void)deleteOrderById:(NSString*)bu_goods_id NSIndexPath:(NSIndexPath *)indexPath
{
    self.bu_Goods_Id = bu_goods_id;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定从购物车中删除所有选中商品？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    alert.tag = 1002;
    [alert show];
}

/* 结算 */
- (void)submitAction:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID13 props:nil];
    if ([self.totalNum intValue] == 0) {
        if ([stockoutArray count]>0) {
            iToast *toast = [iToast makeText:@"购物车商品已售完或库存不足!"];
            [toast setDuration:5000];
            [toast show];
//            [self showNotice:@"购物车商品已售完或库存不足!"];
            return;
        } else {
            [self showNotice:@"购物车数量不能为空!"];
            return;
        }
    }
    
    if (isAction) {
        isAction = NO;
        //此功能现在由后台来做
//        if ([stockoutArray count]>0) {//无库存商品
//            stockoutCount = [stockoutArray count];
//            queue = [[NSOperationQueue alloc]init];
//            [queue setMaxConcurrentOperationCount:3];
//            
//            for (GoodsEntity *good in stockoutArray) {
//                
//                NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(cancelSeletct:) object:good];
//                [queue addOperation:operation];
//                
//            }
//        } else {
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:nil total:nil];
//        }


    }
    
    
}

- (void)cancelSeletct:(id) object {
    GoodsEntity *good = (GoodsEntity *)object;
    [self selectOneGood:good Type:@"1"];
}

/* 编辑后完成 */
- (void)done:(id)sender{
    
}

/* 选中商品 */
-(void)selectOneGood:(GoodsEntity *)cellGoodEntity Type:(NSString *)type{
    [[NetTrans getInstance] update_pay:self CartId:cellGoodEntity.cart_id Type:type];
}

/* 全部选中 */
- (void)selectAll:(id)sender {
    if (allSelect) {
        [[NetTrans getInstance] update_pay:self CartId:nil Type:@"1"];
    }else{
        [[NetTrans getInstance] update_pay:self CartId:nil Type:@"0"];
    }
    allSelect = !allSelect;
}
/*全部删除*/
- (void)delegateAll:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定从购物车中删除所选的商品？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    alert.tag = 1001;
    [alert show];
}

/*计算购物车总金额*/
- (void)calculateCart:(NSMutableArray *)filterArray{
    float savePriceAmount = 0.0f;
    float totalPriceAmount= 0.0f;
    float weightAmount= 0.0f;
    int totalGoodsNum=0;
    int selectPayNumber = 0;
    int totalPayNumber = 0;
        
    for (GoodsEntity *goods in filterArray) {
        if (goods.pay_type.integerValue == 0 && !goods.out_of_stock.integerValue == 1) {
            
            if ([goods.price doubleValue]-[goods.discount_price doubleValue]>=0) {
                savePriceAmount += ([goods.price doubleValue]-[goods.discount_price doubleValue])*[goods.goodNum intValue];
            }
    
            totalPriceAmount += [goods.discount_price doubleValue]*[goods.goodNum intValue];
            weightAmount += [goods.goods_weight doubleValue]*[goods.goodNum intValue];
            totalGoodsNum += [goods.goodNum intValue];
                selectPayNumber ++;
        }
        if (goods.out_of_stock.integerValue == 0 && goods.transaction_type.integerValue == 0) {
            totalPayNumber ++;
        }
    }
    allSelectedNum = [NSString stringWithFormat:@"%d",totalPayNumber];
    if (totalPayNumber == selectPayNumber) {
        allSelect = YES;
    }else{
        allSelect = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){

        
        if (selectPayNumber > 0) {
            NSString *strSave = [NSString stringWithFormat:@"%.2f",savePriceAmount];
            // 选中商品
            [self.totalGoodsLabel setText:[NSString stringWithFormat:@"选中%d件商品",selectPayNumber]];
            // 节省金额
            self.savePriceLabel.text = [NSString stringWithFormat:@"为您节省:￥%@元",strSave];
            // 重量
            self.weightLabel.text = [NSString stringWithFormat:@"重量%.1f公斤",weightAmount/1000.0];
            
            self.totalAmount.text = [NSString stringWithFormat:@"¥%.2f",totalPriceAmount];
            
            self.totalNum = [NSString stringWithFormat:@"%d",totalGoodsNum];
            [[YHAppDelegate appDelegate] changeCartNum:[NSString stringWithFormat:@"%d",totalGoodsNum]];
        }else{
            self.totalGoodsLabel.text = [NSString stringWithFormat:@"选中%d件商品",0];
            self.savePriceLabel.text = [NSString stringWithFormat:@"为您节省:￥%@元",@"0.0"];
            self.weightLabel.text = [NSString stringWithFormat:@"重量%.1f公斤",weightAmount/1000.0];
            self.totalAmount.text = [NSString stringWithFormat:@"¥ %.2f",0.00];
            self.totalNum = @"0";
        }
    });
 }

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    isAction = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([status isEqualToString:WEB_STATUS_3]){
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
        return;
    }
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
//        isFirst = YES;
        allSelect = NO;
        [self requestCartList];
    }
//    [self showAlert:errMsg];
    [[iToast makeText:errMsg] show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_CART_GOODSLISET_API) {
        
        self.listEntity = (GoodsListEntity *)netTransObj;
        
        NSArray *sortArry = [listEntity.goodsArray sortedArrayUsingFunction:sortByID context:nil];
        
        [self.cartArray removeAllObjects];
        [self.cartArray addObjectsFromArray:sortArry];
        
        //此功能现在由后台来做
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            stockoutArray = [NSMutableArray array];
//            for (GoodsEntity *good in self.cartArray) {
//    
//                if (good.out_of_stock.integerValue == 1) {//缺货
//                    
//                    [stockoutArray addObject:good];
//                    
//                }
//            }
//            stockoutCount = [stockoutArray count];
//        });
        
        // 没有优惠券信息
        if (self.listEntity.title.length > 0) {
            //            contentTable.tableHeaderView = [self addTableViewHeaderView:self.listEntity];
            self.active_info = [NSMutableDictionary dictionary];
            [self.active_info setObject:self.listEntity.title forKey:@"title"];
            [self.active_info setObject:self.listEntity.content forKey:@"content"];
            [contentTable reloadData];
        }
        if ([self.cartArray count] == 0) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:nil forKey:@"cartNum"];
        }
        
  
        [self calculateCart:self.cartArray];
        
        if (self.callBack) {//刷新商品详情购物车
            self.callBack(nil,nil);
        }
        
        [contentTable reloadData];
    }
    
    if (nTag == t_API_DELETEGOODS_API) {
        [self requestCartList];
    }
    
    // 选中某一个商品
    if (nTag == t_API_BUY_PLATFORM_CARTUPDATE) {
        
        if (queue) {

            stockoutCount --;
            
            if (stockoutCount == 0) {
                
                 [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:nil total:nil];

            }
            
        } else {
            [self requestCartList];
        }

    }
    
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API) {
        isAction = YES;
        queue = nil;
        // 提交订单
//        YHOrderViewController *orderCart = [[YHOrderViewController alloc] init];
//        orderCart.entity = (OrderSubmitEntity *)netTransObj;
//        [self.navigationController pushViewController:orderCart animated:YES];
        
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"0";
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
    
    if (nTag == t_API_PS_CART_UPDATE_GOODS_NUM) {
        [self requestCartList];
    }
}

NSInteger sortByID(id obj1, id obj2, void *context){
    
    GoodsEntity *str1 =(GoodsEntity*) obj1; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    GoodsEntity *str2 =(GoodsEntity *) obj2;
    
    if ([str1.bu_goods_id integerValue] < [str2.bu_goods_id integerValue]) {
        return NSOrderedDescending;
    }
    else if([str1.bu_goods_id integerValue] == [str2.bu_goods_id integerValue])
    {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}


#pragma mark -------------- UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001 && buttonIndex == 1) {
        // 删除购物车商品
        [[NetTrans getInstance] deleteGoods:self ByGoodsId:@"" Type:@"1"];
    }
    if (alertView.tag == 1002 && buttonIndex == 1) {
        // 删除购物车单件商品
        [[NetTrans getInstance] deleteGoods:self ByGoodsId:self.bu_Goods_Id Type:@"0"];
    }
}


@end
