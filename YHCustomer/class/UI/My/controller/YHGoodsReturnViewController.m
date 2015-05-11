//
//  YHGoodsReturnViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  退货商品

#import "YHGoodsReturnViewController.h"
#import "GoodsEntity.h"
#import "OneOrderEditorView.h"
#import "PlusCutView.h"
@interface YHGoodsReturnViewController (){
    @private
    UIImage     *selectAllBgImage;
    UIImage     *selectAllSelectImage;
    BOOL        allSelect;
    
}

@end

@implementation YHGoodsReturnViewController
@synthesize cartArray,calulateArray;
@synthesize selectAllArray;
@synthesize indexPathSelected;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cartArray = [[NSMutableArray alloc] init];
        calulateArray = [[NSMutableArray alloc] init];
        selectAllArray = [[NSMutableArray alloc] init];
        
        selectAllBgImage = [UIImage imageNamed:@"yes-1.png"];
        selectAllSelectImage = [UIImage imageNamed:@"yes-2.png"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"选择退货商品";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self._tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self._tableView.backgroundColor =LIGHT_GRAY_COLOR;
    [self initCalulateArray];
    allSelect = NO;
    if (selectAllArray.count == cartArray.count) {
        allSelect = YES;
    }
    self._tableView.tableHeaderView = [self addTableViewHeader];
    [self.view addSubview:[self drawFootView]];
}

- (void)initCalulateArray
{
    for (GoodsEntity *entity in cartArray)
    {
        NSMutableDictionary *goodsEntityDic =[entity convertGoodsEntityToDictionary];
        [self.calulateArray addObject:goodsEntityDic];
    }
}

// 初始化商品总数量
- (NSString *)getInitTotalNum{
    int total =0 ;
    for (int i = 0; i < calulateArray.count; i ++)
    {
        NSDictionary *dic = [calulateArray objectAtIndex:i];
        total += [[dic objectForKey:@"goods_num"] intValue];
    }
    return [NSString stringWithFormat:@"%d",total];
}

// 选择过程中商品总数量
- (NSString *)getGoodsTotalNum{
    int total =0 ;
    for (int i = 0; i < selectAllArray.count; i ++)
    {
        NSDictionary *dic = [selectAllArray objectAtIndex:i];
        total += [[dic objectForKey:@"goods_num"] intValue];
    }
    return [NSString stringWithFormat:@"%d",total];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshTableHeaderView{

}

- (void)addGetMoreFootView{

}

- (UIView *)addTableViewHeader
{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor =LIGHT_GRAY_COLOR;
    
    UIView *cellBg = [PublicMethod addBackView:CGRectMake(0, 10, 320, 40) setBackColor:[UIColor whiteColor]];
    [view addSubview:cellBg];
    
    UILabel *titleAllSel = [PublicMethod addLabel:CGRectMake(45, 7.5, 50, 25) setTitle:@"全选" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    [cellBg addSubview:titleAllSel];
    
    allSelectBtn = [PublicMethod addButton:CGRectMake(10, 7.5, 25, 25) title:nil backGround:@"yes-2.png" setTag:1000 setId:self selector:@selector(selectAll:) setFont:nil setTextColor:nil];
    if (!allSelect) {
        [allSelectBtn setBackgroundImage:selectAllSelectImage forState:UIControlStateNormal];
    }else{
        [allSelectBtn setBackgroundImage:selectAllBgImage forState:UIControlStateNormal];
    }
    [cellBg addSubview:allSelectBtn];
    
    UILabel *totalNumLabel =[[UILabel alloc] initWithFrame:CGRectMake(140, 10, 170, 20)];
    totalNumLabel.text = [NSString stringWithFormat:@"本订单共有%@件商品",[self getInitTotalNum]];
    totalNumLabel.textColor =[UIColor blackColor];
    totalNumLabel.backgroundColor =[UIColor clearColor];
    totalNumLabel.tag = 1002;
    totalNumLabel.textAlignment = NSTextAlignmentRight;
    totalNumLabel.font =[UIFont systemFontOfSize:14.0];
    [cellBg addSubview:totalNumLabel];
    
    UIView *line = [PublicMethod addBackView:CGRectMake(0, 49, 320, 1) setBackColor:LIGHT_GRAY_COLOR];
    [view addSubview:line];
    return view;
}

#pragma -
#pragma ----------------------------------------------------------- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

/* 全部选中 */
- (void)selectAll:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (!allSelect) {
        [selectAllArray removeAllObjects];
        [selectAllArray addObjectsFromArray:self.calulateArray];
        [btn setBackgroundImage:selectAllBgImage forState:UIControlStateNormal];
    }else{
        [selectAllArray removeAllObjects];
        [btn setBackgroundImage:selectAllSelectImage forState:UIControlStateNormal];
    }
    allSelect = !allSelect;
    [self._tableView reloadData];
    priceInfo.text =[NSString stringWithFormat:@"退货商品%@个",[self getGoodsTotalNum]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (indexPath.row <self.cartArray.count) {
        
        GoodsEntity *entity = [self.cartArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        
        BOOL isExsit = [self isHasInSelectArray:entity];
        if (selectAllArray.count == 0) {
            allSelect = NO;
            isExsit = allSelect;
        }else if (selectAllArray.count == self.cartArray.count){
            allSelect = YES;
            isExsit = allSelect;
        }
        OneOrderEditorView *tempInfoView=[[OneOrderEditorView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [tempInfoView drawGoodsReturnView:entity IsSelect:isExsit NSIndex:indexPath ChangeGoodsNumBlock:^(NSIndexPath *indexPath,NSString *goodsNum)
        {
            // 加减操作block
            [self calculateReturnArray:indexPath GoodNum:goodsNum];
        } OneGoodSelectBlock:^(BOOL isSelect,NSIndexPath *indexPath)
        {
            // 选中Block回调
            indexPathSelected = indexPath;
            
            NSDictionary *dic = [self.calulateArray objectAtIndex:indexPath.row];
            BOOL isExsit = [self isHasDictionaryInCalucateArray:dic isSelect:isSelect];
            if (!isExsit) {
                [selectAllArray addObject:dic];
            }
            if (selectAllArray.count != self.cartArray.count) {
                [allSelectBtn setBackgroundImage:selectAllSelectImage forState:UIControlStateNormal];
                allSelect = NO;
            }else{
                [allSelectBtn setBackgroundImage:selectAllBgImage forState:UIControlStateNormal];
                allSelect = YES;
            }
            priceInfo.text =[NSString stringWithFormat:@"退货商品%@个",[self getGoodsTotalNum]];
        }];
        tempInfoView.mController =self;
        [cell.contentView addSubview:tempInfoView];
    }
    return cell;
}

-(void)modifyCartGoodsNum:(NSString *)_goodsNumOne GoodsNum:(NSString *)_goodsNumTwo
{
    UITableViewCell * cell = [self._tableView cellForRowAtIndexPath:indexPathSelected];
    GoodsEntity *entity = [self.cartArray objectAtIndex:indexPathSelected.row];
    NSString * str_Num = entity.goodNum;
    NSInteger a = [_goodsNumTwo integerValue];
    NSInteger b = [str_Num integerValue];
    if (a > b)
    {
        [[iToast makeText:@"不能超过购买此商品数量！"] show];
    }
    else if (a < 1)
    {
        [[iToast makeText:@"输入商品数量不能小于1！"] show];
    }
    else
    {
        OneOrderEditorView * view_Order = [[cell.contentView subviews] lastObject];
        ((PlusCutView *)[view_Order viewWithTag:101]).numLabel.text = _goodsNumTwo;
        [self calculateReturnArray:indexPathSelected GoodNum:_goodsNumTwo];
    }
}
//- (void)calculateReturnArray:(NSIndexPath *)indexPath GoodNum:(NSString *)num
- (BOOL)isHasDictionaryInCalucateArray:(NSDictionary *)dic isSelect:(BOOL)isSelect{
    BOOL isNotExsit = NO;
    for (int i=0; i< [selectAllArray count]; i ++) {
        NSDictionary *dic1 = [selectAllArray objectAtIndex:i];
        if ([[dic1 objectForKey:@"bu_goods_id"] isEqualToString:[dic objectForKey:@"bu_goods_id"]]) {
            isNotExsit = YES;
            if (isSelect) {
                [selectAllArray replaceObjectAtIndex:i withObject:dic];
            }else{
                [selectAllArray removeObject:dic];
            }
        }
    }
    return isNotExsit;
}

- (BOOL)isHasInSelectArray:(GoodsEntity *)entity{
    BOOL isExsit = NO;
    for (NSDictionary *dic in selectAllArray) {
        if ([entity.bu_goods_id isEqualToString:[dic objectForKey:@"bu_goods_id"]]){
            isExsit = YES;
        }
    }
    return isExsit;
}

/*footView*/
-(UIView *)drawFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height-NAVBAR_HEIGHT-50, 320, 50)];
    footView.backgroundColor =[PublicMethod colorWithHexValue:0x424242 alpha:1];
    priceInfo =[[UILabel alloc] initWithFrame:CGRectMake(20, 11, 150, 24)];
    priceInfo.backgroundColor=[UIColor clearColor];
    priceInfo.textColor =[UIColor whiteColor];
    priceInfo.text =[NSString stringWithFormat:@"退货商品%@个",[self getGoodsTotalNum]];
    priceInfo.font =[UIFont boldSystemFontOfSize:22.0];
    [footView addSubview:priceInfo];
    
    //提交
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame =CGRectMake(220, 0, 100, 50);
    sendButton.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1];
    [sendButton setTitle:@"确定" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont systemFontOfSize:18.0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sendButton];
    return footView;
}

- (void)submitAction:(id)sender{
    _returnBlock(self.selectAllArray, [self getGoodsTotalNum]);
    [self back:nil];
}

/**
 * 更改退货商品数量 计算商品数量差保存字典
 */
- (void)calculateReturnArray:(NSIndexPath *)indexPath GoodNum:(NSString *)num
{
    NSLog(@"indexPath.row is %ld",(long)indexPath.row);
//
    NSMutableDictionary *dicOrigin = [calulateArray objectAtIndex:indexPath.row];
    for (int i=0;i < selectAllArray.count ; i++)
    {
        NSMutableDictionary *dicSelect= [selectAllArray objectAtIndex:i];
        if ([[dicSelect objectForKey:@"bu_goods_id"] isEqualToString:[dicOrigin objectForKey:@"bu_goods_id"]])
        {
            [dicSelect setObject:[NSString stringWithFormat:@"%@",num] forKey:@"goods_num"];
        }
    }
    priceInfo.text =[NSString stringWithFormat:@"退货商品%@个",[self getGoodsTotalNum]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
