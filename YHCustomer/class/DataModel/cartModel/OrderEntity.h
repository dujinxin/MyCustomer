//
//  OrderEntity.h
//  THCustomer
//
//  Created by lichentao on 13-8-29.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  订单信息－封装 - 开arc

#import <Foundation/Foundation.h>

// 我的订单和快速扫瞄后的订单详情是id，确认订单是order_list_id

// 确认订单 || 快速扫瞄生成的订单
@interface OrderSubmitEntity : NSObject

@property (nonatomic, strong) NSString *order_list_no;
@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *bu_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *goods_count;
@property (nonatomic, strong) NSString *total_amount;
@property (nonatomic, strong) NSString *order_Status;
@property (nonatomic, strong) NSString *goods_weight;
@property (nonatomic, strong) NSMutableArray *couponList;

//新接口的字段
@property (nonatomic, strong) NSString  *goods_num;
@property (nonatomic, strong) NSString  *coupon_num;
@property (nonatomic, strong) NSString  *goods_amount;
@property (nonatomic, strong) NSString  *logistics_amount;
@property (nonatomic, strong) NSString  *coupon_amount;

//
@property (nonatomic, strong) NSString *delivery_name;
@property (nonatomic, strong) NSString *lm_title;
@property (nonatomic, strong) NSString *lm_time_title;
@property (nonatomic, strong) NSString *pay_method;
@property (nonatomic, strong) NSString *pay_method_name;
@property (nonatomic, strong) NSString *delivery_id;

@property (nonatomic, strong) NSString *pick_up_time;

@property (nonatomic, strong) NSString *transaction_type;
@property (nonatomic, strong) NSMutableArray *orderArray;
//15-0517立即购买
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) NSMutableDictionary *deliveryDict;//默认信息

//- (void)setMyOrderEntity:(NSDictionary *)dic;
@end

@interface OrderDetailNettransObj : NetTransObj

@end


// 提交订单 商品列表＋优惠信息
@interface GoodList:NSObject
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSString *coupon;
@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, strong) NSString *goods_amount;
- (void)setGoodListEntity:(NSDictionary *)dic;
@end

// 我的订单订单中 单个entity
@interface MyOrderEntity : NSObject
@property (nonatomic, strong) NSString  *order_id;
@property (nonatomic, strong) NSString  *order_list_no;
@property (nonatomic, strong) NSString  *order_list_id;
@property (nonatomic, strong) NSString  *is_handsel;
@property (nonatomic, strong) NSString  *order_type;
@property (nonatomic, strong) NSString  *orderStatus;
@property (nonatomic, strong) NSString  *pay_method;
@property (nonatomic, strong) NSString  *pay_method_name;
@property (nonatomic, strong) NSString  *totalAmount;
@property (nonatomic, strong) NSString  *orderInfo;
@property (nonatomic, strong) NSString  *pay_status;
@property (nonatomic, strong) NSString  *pay_status_name;
@property (nonatomic, strong) NSString  *msg;
@property (nonatomic, strong) NSString  *total_state;
@property (nonatomic, strong) NSString  *total_state_name;
@property (nonatomic, strong) NSString  *delivery_id;
@property (nonatomic, strong) NSString  *region_id;
@property (nonatomic, strong) NSString  *create_date;
@property (nonatomic, strong) NSString  *transaction_type;
@property (nonatomic, strong) NSMutableArray *orderArray;
@end

//@interface NewOrderDetailEntity : MyOrderEntity
//
//@property (nonatomic, strong) NSString  *delivery_name;
//@property (nonatomic, strong) NSString  *bu_name;
//@property (nonatomic, strong) NSString  *pick_up_time;
//@property (nonatomic, strong) NSString  *bu_address;
//@property (nonatomic, strong) NSString  *lm_title;
//@property (nonatomic, strong) NSString * lm_time_title;
//
//@end

// 退货服务中－订单entity
@interface ReturnOrderEntity : MyOrderEntity
@property (nonatomic, strong) NSString *how_to_apply_str;           // 申请方式
@property (nonatomic, strong) NSString *total_state_str;            // 已申请
@property (nonatomic, strong) NSString *returns_reason_id;          // 退货原因标示吗
@property (nonatomic, strong) NSString *returns_reason_info;        // 退货原因
@property (nonatomic, strong) NSString *returns_reason_explanation; // 退货说明
@property (nonatomic, strong) NSMutableArray *returns_goods_images; // 退货图片数组
@property (nonatomic, strong) NSString *returns_name;               // 退货人姓名
@property (nonatomic, strong) NSString *returns_account;            // 退货人开户银行
@property (nonatomic, strong) NSString *returns_card_num;           // 开户卡号
@property (nonatomic, strong) NSString *returns_method;             // 退款方式
@property (nonatomic, strong) NSString *returns_method_a;
@property (nonatomic, strong) NSString *returns_method_b;
@property (nonatomic, strong) NSString *returns_method_c;
@property (nonatomic, strong) NSString *returns_method_d;
@property (nonatomic, strong) NSString *returns_method_e;
@property (nonatomic, strong) NSString *returns_method_f;
@property (nonatomic, strong) NSString *returns_method_g;

@property (nonatomic, strong) NSString *apply_retamt; //8.8版本新增，申请金额
@property (nonatomic, strong) NSString *returns_logistics_amount;  //8.8版本新增，上门取货费
@property (nonatomic, strong) NSString *fc_amt;  //8.8版本新增，运费险金额

@property (nonatomic, strong) NSString *apply_type;                 // 退货方式
@property (nonatomic, strong) NSString *sales_return_id;            // 退货单id
@property (nonatomic, strong) NSString *sales_return_no;            // 退货编号
@property (nonatomic, strong) NSString *sdate;                      // 申请时间
@property (nonatomic, strong) NSString *retamt;                     // 退货金额，8.8版本改名为 实退金额
@property (nonatomic, strong) NSMutableArray *returnsImagesArray; // 退货商品图片数组;
@property (nonatomic, strong) NSString *carry_or_not;               //未提货：0、2，已提货：1、3
@property (nonatomic, strong) NSString *returns_reject_info;        // 取消退货原因

@property (nonatomic, strong )NSString * region_id;//10.30新增区域id

@property (nonatomic, strong)NSString * pay_method_str;//支付方式

- (void)setReturnOrderEntity:(NSDictionary *)dic;

@end

// 提交订单－netTransObj
@interface OrderTransObj: NetTransObj

@end

// 我的订单-netTransObj
@interface MyOrderTransObj: NetTransObj

@end
// 我的订单，订单详情--新增app
@interface AppOrderDetailObj : NetTransObj

@end
// 我的订单，订单详情--新增pda
@interface PdaOrderDetailObj : NetTransObj

@end

// 退货订单-netTransObj
@interface ReturnOrderTransObj : NetTransObj

@end

// 确认订单
@interface ConfirmTransObj : NetTransObj

@end

// 获取支付宝支付字符串
@interface OrderPayTransObj : NetTransObj

@end

