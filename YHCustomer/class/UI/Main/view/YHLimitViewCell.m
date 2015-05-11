//
//  YHLimitViewCell.m
//  YHCustomer
//
//  Created by dujinxin on 15-1-5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHLimitViewCell.h"

@implementation YHLimitViewCell

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
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    [self.contentView addSubview:bg];
    //图片
    image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 120, 120)];
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
    //    illustrate.hidden = YES;
    illustrate.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    illustrate.textAlignment = NSTextAlignmentLeft;
    //    illustrate.font = [UIFont boldSystemFontOfSize:13.0];
    [self.contentView addSubview:illustrate];

    //价格
    price = [[UILabel alloc]initWithFrame:CGRectMake(image.right+10, title.bottom, 100, 20)];
    price.backgroundColor = [UIColor clearColor];
    price.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    price.font = [UIFont systemFontOfSize:20.0];
    price.adjustsFontSizeToFitWidth = YES;
    price.contentMode =UIViewContentModeLeft;
    [self.contentView addSubview:price];
    
    //原价
    originalPrice = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(image.right+10, price.bottom+5, 70, 20)];
    originalPrice.backgroundColor = [UIColor clearColor];
    originalPrice.isWithStrikeThrough = YES;
    originalPrice.font = [UIFont systemFontOfSize:12];
    originalPrice.adjustsFontSizeToFitWidth = YES;
    originalPrice.textColor = [PublicMethod colorWithHexValue:0x999999 alpha:1.0];
    [self.contentView addSubview:originalPrice];
    
    //购物车
    cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(SCREEN_WIDTH-70, originalPrice.top+5, 60, 30);
    [cartBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_selected"] forState:UIControlStateHighlighted];
//    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cartBtn];
    
    
    remainder = [[UILabel alloc]initWithFrame:CGRectMake(image.right + 10, originalPrice.bottom +10, 120, 30)];
    remainder.text = @"可抢购库存：";
    remainder.backgroundColor = [UIColor clearColor];
    remainder.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    remainder.font = [UIFont systemFontOfSize:14.0];
    remainder.adjustsFontSizeToFitWidth = YES;
    remainder.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:remainder];
    
    
    progressBg = [[UIView alloc]initWithFrame:CGRectMake(cartBtn.left, originalPrice.bottom +20, cartBtn.width, 10)];
    progressBg.layer.borderColor = [UIColor greenColor].CGColor;
    progressBg.layer.borderWidth = 1.0;
    [self.contentView addSubview:progressBg];
    
    progressTr = [[UIView alloc]initWithFrame:CGRectMake(remainder.right +10, originalPrice.bottom, 100, 10)];
    progressTr.backgroundColor = [UIColor greenColor];
//    [progressBg addSubview:progressTr];
    
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
    if ([entity.out_of_stock intValue] == 1) {
        [cartBtn setHidden:YES];
        [cartStatus setHidden:NO];
    }else{
        [cartBtn setHidden:NO];
        [cartStatus setHidden:YES];
    }
    //    entity.is_or_not_salse = @"1";
    //    entity.limit_the_purchase_type = @"0";
    
    //说明
//    if (title.frame.size.height > 20){
//        image.frame = CGRectMake(10, 20, 90, 90);
//        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y , title.frame.size.width, 40);
//        illustrate.frame = CGRectMake(image.right+10, title.bottom, 210, 20);
//        price.frame = CGRectMake(image.right+10, title.bottom+50, 100, 20);
//        originalPrice.frame = CGRectMake(price.right, price.top+5, 70, 20);
//        cartBtn.frame = CGRectMake(SCREEN_WIDTH-40, originalPrice.bottom-30, 30, 30);
//        cartStatus.frame = CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-30, 50, 30);
//        
//    }else{
//        image.frame = CGRectMake(10, 10, 90, 90);
//        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y , title.frame.size.width, 20);
//        illustrate.frame = CGRectMake(image.right+10, title.bottom, 210, 20);
//        price.frame = CGRectMake(image.right+10, title.bottom+50, 100, 20);
//        originalPrice.frame = CGRectMake(price.right, price.top+5, 70, 20);
//        cartBtn.frame = CGRectMake(SCREEN_WIDTH-40, originalPrice.bottom-30, 30, 30);
//        cartStatus.frame = CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-30, 50, 30);
//    }

    if (1) {
        [cartBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [cartBtn setBackgroundColor:[UIColor redColor]];
        [cartBtn setEnabled:YES];
    }else if (2){
        [cartBtn setTitle:@"原件购买" forState:UIControlStateNormal];
        [cartBtn setBackgroundColor:[UIColor redColor]];
        [cartBtn setEnabled:YES];
    }else if (3){
        [cartBtn setTitle:@"正在补货" forState:UIControlStateNormal];
        [cartBtn setBackgroundColor:[UIColor grayColor]];
        [cartBtn setEnabled:NO];
    }else{
        [cartBtn setTitle:@"敬请期待" forState:UIControlStateNormal];
        [cartBtn setBackgroundColor:[UIColor grayColor]];
        [cartBtn setEnabled:NO];
    }
    illustrate.text = entity.goods_introduction;
    originalPrice.text = [NSString stringWithFormat:@"￥%@",entity.price];
    price.text = [NSString stringWithFormat:@"￥%@",entity.discount_price];
    
    // 现价 >= 原价 将原价隐藏
//    if ([entity.discount_price floatValue] >= [entity.price floatValue]) {
//        originalPrice.hidden = YES;
//    } else {
//        originalPrice.hidden = NO;
//    }
    
    //调整位置
    originalPrice.size = [originalPrice.text sizeWithFont:originalPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
}

-(void)addCart {
    [MTA trackCustomKeyValueEvent:EVENT_ID5 props:nil];
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [[NetTrans getInstance]addCart:self GoodsID:entity.goods_id Total:@"1"];
}

- (void)setBgColor:(NSString *)color {
    bg.backgroundColor = [PublicMethod colorWithHexValue1:color];
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_ADDCART_GOODS) {
        
        [[iToast makeText:@"添加到购物车成功"]show];
        
        //刷新购物车
        if (self.cartBlock) {
            self.cartBlock ();
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

