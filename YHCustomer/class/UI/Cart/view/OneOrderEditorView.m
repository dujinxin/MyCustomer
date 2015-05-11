//
//  OneOrderEditorView.m
//  THCustomer
//
//  Created by 任 清阳 on 13-9-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "OneOrderEditorView.h"
#import "PAStepper.h"
#import "PlusCutView.h"
#import "YHCartViewController.h"
#import "CartAlertView.h"
#import "YHGoodsReturnViewController.h"


#define COUNTLABELTAG             100000001
#define LIFTDISTANCE              10.0
#define GOODSIMAGEWIDTH           50.0
#define GOODSIMAGEHEIGHT          50.0
@implementation OneOrderEditorView
@synthesize mController;
@synthesize myIndexPath;
@synthesize isOneGoodSelect;
@synthesize selectedIndexPath;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)dealloc
{
    [myIndexPath release];
    [super dealloc];
}

// 购物车
-(void)drawEditorView:(GoodsEntity *)entity NSIndex:(NSIndexPath *)indexPath
{
    [self removeAllSubviews];
    self.myIndexPath = indexPath;
    self.myEntity = entity;
    //商品图片//
    UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(LIFTDISTANCE, 15, GOODSIMAGEWIDTH, GOODSIMAGEHEIGHT)];
    [goodsImageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"tianHongLogo.png"]];
    [self addSubview:goodsImageView];
    [goodsImageView release];
    
    if (entity.out_of_stock.integerValue == 1) {//缺货
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(10, goodsImageView.bottom+7, 100, 10)];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        label.text = @"该商品已售完或无库存";
        label.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:label];
    }
    
    // 商品信息
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 40)];
    goodsName.text = entity.goods_name;
    goodsName.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    goodsName.font = [UIFont systemFontOfSize:14];
    goodsName.numberOfLines = 0;
    goodsName.backgroundColor = [UIColor clearColor];
    [self addSubview:goodsName];
    [goodsName release];
    
    //商品价格
    UILabel *goodsPrice =[[UILabel alloc] initWithFrame:CGRectMake(70, 57, 100,14)];
    goodsPrice.backgroundColor=[UIColor clearColor];
    goodsPrice.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    goodsPrice.textAlignment =NSTextAlignmentLeft;
    goodsPrice.text =[NSString stringWithFormat:@"￥%@",entity.discount_price];
    goodsPrice.font =[UIFont systemFontOfSize:12.0];
    [self addSubview:goodsPrice];
    [goodsPrice release];
    
    // 商品原价
    UILabelStrikeThrough *goodsOriginPrice = [[UILabelStrikeThrough alloc] initWithFrame:CGRectMake(140, 56, 100, 18)];
    goodsOriginPrice.isWithStrikeThrough = YES;
    goodsOriginPrice.backgroundColor = [UIColor clearColor];
    goodsOriginPrice.tag = 105;
    goodsOriginPrice.text =[NSString stringWithFormat:@"¥%.2f",[entity.price floatValue]];
    goodsOriginPrice.font =[UIFont systemFontOfSize:10.0];
    goodsOriginPrice.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    CGSize size =  [PublicMethod getLabelSize:[NSString stringWithFormat:@"¥%.2f",[entity.price floatValue]] font:goodsOriginPrice.font constrainedToSize:CGSizeMake(100, 18) lineBreakMode:NSLineBreakByCharWrapping];
    goodsOriginPrice.width = size.width;
    [self addSubview:goodsOriginPrice];
    [goodsOriginPrice release];
    // 现价 》 原价
    if ([entity.discount_price floatValue] >= [entity.price floatValue]) {
        goodsOriginPrice.hidden = YES;
    }
    
    //商品数量
    UILabel *goodsNum =[[UILabel alloc] initWithFrame:CGRectMake(220, 0+54, 80,16)];
    goodsNum.backgroundColor=[UIColor clearColor];
    goodsNum.textColor =[UIColor blackColor];
    goodsNum.textAlignment=NSTextAlignmentRight;
    goodsNum.tag=COUNTLABELTAG;
    goodsNum.text =[NSString stringWithFormat:@"%@",entity.goodNum];
    goodsNum.font =[UIFont systemFontOfSize:15.0];
    [self addSubview:goodsNum];
    [goodsNum release];
    
    //增与减
    PlusCutView *pastepper = [[PlusCutView alloc] initWithFrame:CGRectMake(222, 18, 93, 24) GoodsEntity:self.myEntity Type:cart_Type setPlusBlock:^(NSString *goodsNum){
        [mController requestCartList];
        
    } CutButtonBlock:^(NSString *goodsNum){
        
        [mController requestCartList];
    } ChangeNumBlock:^(){
        [self chageGoodsNumWithAlert];
    }];
    pastepper.userInteractionEnabled = YES;
    [self addSubview:pastepper];
    //删除
    UIButton *deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame =CGRectMake(220+7, 55, 85, 25);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0]];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];;
    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

// 退货商品
-(void)drawGoodsReturnView:(GoodsEntity *)entity IsSelect:(BOOL)isSelect NSIndex:(NSIndexPath *)indexPath ChangeGoodsNumBlock:(ChangeGoodsNumBlock)block OneGoodSelectBlock:(OneGoodSelectBlock)oneBlock1
{
    [self removeAllSubviews];
    self.myIndexPath = indexPath;
    self.myEntity = entity;
    self.changeNumBlock = block;
    self.oneGoodBlock = oneBlock1;
    // 是否是选中状态
    isOneGoodSelect =isSelect;
    NSString *backgroundImage = nil;
    if (isOneGoodSelect) {
        backgroundImage = @"yes-1.png";
    }else{
        backgroundImage = @"yes-2.png";
    }
    UIButton *allSelectBtn = [PublicMethod addButton:CGRectMake(10, 17.5, 25, 25) title:nil backGround:backgroundImage setTag:106 setId:self selector:@selector(selectOne:) setFont:nil setTextColor:nil];
    [self addSubview:allSelectBtn];
    
    //商品图片
    UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(45, 10, 40, 40)];
    goodsImageView.layer.borderWidth = 1.0f;
    goodsImageView.layer.borderColor =LIGHT_GRAY_COLOR.CGColor;
    [goodsImageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    [self addSubview:goodsImageView];
    [goodsImageView release];
    
    // 商品信息
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(95, 5, 110, 32)];
    goodsName.text = entity.goods_name;
    goodsName.font = [UIFont systemFontOfSize:12];
    goodsName.numberOfLines = 0;
    goodsName.backgroundColor = [UIColor clearColor];
    [self addSubview:goodsName];
    [goodsName release];
    
    //商品数量
    UILabel *goodsNum =[[UILabel alloc] initWithFrame:CGRectMake(95,36, 180,16)];
    goodsNum.backgroundColor=[UIColor clearColor];
    goodsNum.textColor =[UIColor blackColor];
    goodsNum.textAlignment=NSTextAlignmentLeft;
    goodsNum.tag=100;
    goodsNum.text =[NSString stringWithFormat:@"已购买数量 %@",entity.goodNum];
    goodsNum.font =[UIFont systemFontOfSize:13.0];
    [self addSubview:goodsNum];
    [goodsNum release];
    //增与减
    PlusCutView *pastepper = [[PlusCutView alloc] initWithFrame:CGRectMake(ScreenSize.width - 98, 18, 93, 24) GoodsEntity:self.myEntity Type:return_Type setPlusBlock:^(NSString *goodsNum)
    {
        [self updateGoodsNum:goodsNum];
    }
                                                 CutButtonBlock:^(NSString *goodsNum)
    {
        [self updateGoodsNum:goodsNum];
    }
                                                 ChangeNumBlock:^()
    {
        selectedIndexPath = indexPath;
        [self chageGoodsNumWithAlert];
        
    }];
    
    if (isOneGoodSelect) {
        pastepper.userInteractionEnabled = YES;
    }else{
        pastepper.userInteractionEnabled = NO;
    }
    pastepper.tag =101;
    [self addSubview:pastepper];
    
    UIView *horignLine = [PublicMethod addBackView:CGRectMake(0, 59, ScreenSize.width, 1) setBackColor:[UIColor lightGrayColor]];
    horignLine.alpha = .2f;
    [self addSubview:horignLine];
}

- (void)updateGoodsNum:(NSString  *)goodsNum
{
    _changeNumBlock(self.myIndexPath,goodsNum);
}

// 弹出对话框 － 修改
- (void)chageGoodsNumWithAlert{
    CartAlertView *alert = [[CartAlertView alloc]init];
    alert.goodsNumField.text = self.myEntity.goodNum;
    [alert setOnButtonTouchUpInside:^(NSString *goodsNum)
     {
        NSLog(@"goodsNum = %@",goodsNum);
        if ([mController isKindOfClass:[YHGoodsReturnViewController class]])
        {
            ((YHGoodsReturnViewController *)mController).indexPathSelected = selectedIndexPath;
        }
        [mController modifyCartGoodsNum:self.myEntity.cart_id GoodsNum:goodsNum];
    }];
    [alert show];
}

/*删除商品*/
-(void)delete
{
    if ([mController isKindOfClass:[YHCartViewController class]])
    {
        [mController deleteOrderById:self.myEntity.cart_id NSIndexPath:self.myIndexPath];
    }
}

- (void)selectOne:(id)sender{
    isOneGoodSelect = !isOneGoodSelect;
    UIButton *btn = (UIButton *)sender;
    PlusCutView *pastepper = (PlusCutView *)[self viewWithTag:101];
    if (isOneGoodSelect) {
        pastepper.userInteractionEnabled = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"yes-1.png"] forState:UIControlStateNormal];
        _oneGoodBlock(isOneGoodSelect,self.myIndexPath);
    }else{
        pastepper.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"yes-2.png"] forState:UIControlStateNormal];
        _oneGoodBlock(isOneGoodSelect,self.myIndexPath);
    }
}


@end
