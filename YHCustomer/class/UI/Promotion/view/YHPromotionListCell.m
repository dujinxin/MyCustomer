//
//  YHPromotionListCell.m
//  YHCustomer
//
//  Created by kongbo on 14-6-23.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHPromotionListCell.h"
#import "NetTrans.h"
#import "YHNewOrderViewController.h"
@implementation YHPromotionListCell
@synthesize title = title;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView {
    bg.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.contentView addSubview:bg];
    //图片
    image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 90)];
    image.backgroundColor = [UIColor clearColor];
    image.tag = 100;
    [self.contentView addSubview:image];
    
    //商品标题
    title = [PublicMethod addLabel:CGRectMake(image.right+10, 10, 210, 40) setTitle:@"" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    
    title.tag = 101;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    title.numberOfLines = 0;
    [self.contentView addSubview:title];
    //说明
    illustrate = [PublicMethod addLabel:CGRectMake(image.right+10, title.bottom, 210, 20) setTitle:@"" setBackColor:[PublicMethod colorWithHexValue:0x398cdd alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    illustrate.backgroundColor = [UIColor clearColor];
    illustrate.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    illustrate.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:illustrate];
    //限
    limit = [PublicMethod addLabel:CGRectMake(image.right+10, illustrate.bottom, 18, 18) setTitle:@"限" setBackColor:[PublicMethod colorWithHexValue:0x398cdd alpha:1.0] setFont:[UIFont systemFontOfSize:13.0]];
    limit.backgroundColor = [PublicMethod colorWithHexValue:0xea49ce alpha:1.0];
    limit.hidden = YES;
    limit.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    limit.textAlignment = NSTextAlignmentCenter;
    limit.font = [UIFont boldSystemFontOfSize:13.0];
    [self.contentView addSubview:limit];
    //专享
    special = [PublicMethod addLabel:CGRectMake(image.right+10, illustrate.bottom, 32, 18) setTitle:@"专享" setBackColor:[PublicMethod colorWithHexValue:0xea49ce alpha:1.0] setFont:[UIFont systemFontOfSize:13.0]];
    special.backgroundColor = [PublicMethod colorWithHexValue:0x53d769 alpha:1.0];

    special.hidden = YES;
    special.font = [UIFont boldSystemFontOfSize:13.0];
    special.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    special.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:special];
    //价格
    price = [[UILabel alloc]initWithFrame:CGRectMake(image.right+10, title.bottom+50, 100, 20)];
    price.backgroundColor = [UIColor clearColor];
    price.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    price.font = [UIFont systemFontOfSize:20.0];
    price.adjustsFontSizeToFitWidth = YES;
    price.contentMode =UIViewContentModeLeft;
    [self.contentView addSubview:price];
    
    //原价
    originalPrice = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(price.right, price.top+5, 70, 20)];
    originalPrice.backgroundColor = [UIColor clearColor];
    originalPrice.isWithStrikeThrough = YES;
    originalPrice.font = [UIFont systemFontOfSize:12];
    originalPrice.adjustsFontSizeToFitWidth = YES;
    originalPrice.textColor = [PublicMethod colorWithHexValue:0x999999 alpha:1.0];
    [self.contentView addSubview:originalPrice];
    
    //购物车
    cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(SCREEN_WIDTH-40, originalPrice.bottom-50, 30, 30);
    [cartBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_selected"] forState:UIControlStateHighlighted];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.contentView addSubview:cartBtn];
    
    //缺货状态
    cartStatus = [PublicMethod addLabel:CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-50, 50, 30) setTitle:@"补货中" setBackColor:[UIColor orangeColor] setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:cartStatus];
    
    sp_V = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom -1, SCREEN_WIDTH, 1)];
    sp_V.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:sp_V];
}
-(void)setGoodsCellData:(GoodsEntity *)goodsEntity
{
    entity = goodsEntity;
    [image setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"goods_default"]];
    if (entity.goods_name.length > 0) {
        title.text = entity.goods_name;
    }else {
        title.text = @"未命名";
    }
    CGSize size ;
    size = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, size.height);
    //1为缺货
    if (entity.out_of_stock.integerValue == 1) {
        [cartBtn setHidden:YES];
        [cartStatus setHidden:NO];
    }else{
        [cartBtn setHidden:NO];
        [cartStatus setHidden:YES];
    }
    //0加入购物车，1立即购买
    if (entity.transaction_type.integerValue == 0) {
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    }else{
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_shopping"] forState:UIControlStateNormal];
    }
//    entity.is_or_not_salse = @"1";
//    entity.limit_the_purchase_type = @"111";
//    entity.goods_introduction = @"说明性文字";
    //说明
    if (title.frame.size.height > 20 && (entity.goods_introduction && entity.goods_introduction.length != 0) && (entity.is_or_not_salse.integerValue == 1 || entity.limit_the_purchase_type.integerValue != 0)){
//        [self updateViewForImageTop:20.0 priceTop:50];
//        [self setSpecialLimitView:illustrate.bottom];
        image.frame = CGRectMake(10, 20, 90, 90);
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y , title.frame.size.width, 40);
        illustrate.frame = CGRectMake(image.right+10, title.bottom, 210, 20);
        illustrate.text = entity.goods_introduction;
        illustrate.hidden = NO;

        price.frame = CGRectMake(image.right+10, title.bottom+50, 100, 20);
        originalPrice.frame = CGRectMake(price.right, price.top+5, 70, 20);
        cartBtn.frame = CGRectMake(SCREEN_WIDTH-40, originalPrice.bottom-30, 30, 30);
        cartStatus.frame = CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-30, 50, 30);
        sp_V.frame = CGRectMake(0, originalPrice.bottom+ 4, SCREEN_WIDTH, 1);
        [self setSpecialLimitView:illustrate.bottom];
    }else{
//        [self updateViewForImageTop:20.0 priceTop:50];
        image.frame = CGRectMake(10, 10, 90, 90);
        if (title.frame.size.height > 20){
            title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y , title.frame.size.width, 40);
            illustrate.frame = CGRectMake(image.right+10, title.bottom, 210, 20);
            if (entity.goods_introduction && entity.goods_introduction.length != 0) {
                illustrate.text = entity.goods_introduction;
                illustrate.hidden = NO;
            }else{
                illustrate.hidden = YES;
                [self setSpecialLimitView:title.bottom];
            }
            price.frame = CGRectMake(image.right+10, title.bottom+30, 100, 20);
        }else{
            title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y , title.frame.size.width, 20);
            illustrate.frame = CGRectMake(image.right+10, title.bottom, 210, 20);
            if (entity.goods_introduction && entity.goods_introduction.length != 0) {
                illustrate.text = entity.goods_introduction;
                illustrate.hidden = NO;
            }else{
                illustrate.hidden = YES;
            }
            [self setSpecialLimitView:illustrate.bottom];
            price.frame = CGRectMake(image.right+10, title.bottom+50, 100, 20);
        }
        
        originalPrice.frame = CGRectMake(price.right, price.top+5, 70, 20);
        cartBtn.frame = CGRectMake(SCREEN_WIDTH-40, originalPrice.bottom-30, 30, 30);
        
        cartStatus.frame = CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-30, 50, 30);
        sp_V.frame = CGRectMake(0, originalPrice.bottom+ 4, SCREEN_WIDTH, 1);
    }

    originalPrice.text = [NSString stringWithFormat:@"￥%@",entity.price];
    price.text = [NSString stringWithFormat:@"￥%@",entity.discount_price];
    
    // 现价 >= 原价 将原价隐藏
    if ([entity.discount_price floatValue] >= [entity.price floatValue]) {
        originalPrice.hidden = YES;
    } else {
        originalPrice.hidden = NO;
    }
    
    //调整位置
    originalPrice.size = [originalPrice.text sizeWithFont:originalPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
}

-(void)addCart:(UIButton *)btn {
    [MTA trackCustomKeyValueEvent:EVENT_ID5 props:nil];
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    //加入购物车
    if (entity.transaction_type.integerValue == 0){
        [[NetTrans getInstance] addCart:self GoodsID:entity.goods_id Total:@"1"];
    }//立即购买
    else{
        if (self.cartBlock)
        {
            self.cartBlock (entity.goods_id,@"1");
        }
    }
    

}
- (void)setBgColor:(NSString *)color {
    bg.backgroundColor = [PublicMethod colorWithHexValue1:color];
}
#pragma mark - privateMethod

- (void)setSpecialLimitView:(CGFloat)viewTop{
    //专享
    if (entity.is_or_not_salse.integerValue == 1){
        special.hidden = NO;
        special.frame = CGRectMake(image.right+10, viewTop, 32, 18);
        //限购
        if (entity.limit_the_purchase_type.integerValue != 0) {
            limit.hidden = NO;
            limit.frame = CGRectMake(special.right+5, viewTop, 18, 18);
        }else{
            limit.hidden = YES;
        }
    }else{
        special.hidden = YES;
        if (entity.limit_the_purchase_type.integerValue != 0) {
            limit.hidden = NO;
            limit.frame = CGRectMake(image.right+10, viewTop, 18, 18);
        }else{
            limit.hidden = YES;
        }
    }
}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_ADDCART_GOODS) {
        
        [[iToast makeText:@"添加到购物车成功"]show];
        
        //刷新购物车
        if (self.cartBlock)
        {
            self.cartBlock (nil,nil);
        }
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if (nTag == t_API_ADDCART_GOODS)
    {
        if ([status isEqualToString:WEB_STATUS_3]) {
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

@end
