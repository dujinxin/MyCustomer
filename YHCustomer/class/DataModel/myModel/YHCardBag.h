//
//  YHCardBag.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/9.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

//永辉钱包信息
@interface YHCardBag : NSObject
@property (nonatomic , strong) NSString * type;
@property (nonatomic , strong) NSString * info;
@property (nonatomic , strong) NSString * card_no;
@property (nonatomic , strong) NSString * email;
@property (nonatomic , strong) NSString * total_amount;


@end

//已经注册成功获取用户永辉钱包信息
@interface YHCardBagTransObj : NetTransObj

@end

//进行注册成功后获取用户永辉钱包信息
@interface YHCardBagOtherTransObj : NetTransObj

@end

//购买永辉卡时，卡面额
@interface YHCardDenomination : NSObject

@property (nonatomic , strong) NSString * the_cards_id;
@property (nonatomic , strong) NSString * the_cards_name;

@end

@interface YHCardDenominationTransObj : NetTransObj

@end

//转赠永辉卡列表
@interface YHCardVice : NSObject

@property(nonatomic , strong)NSString * image_url;
@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * card_amount;
@property(nonatomic , strong)NSString * validity_date;
@property(nonatomic , strong)NSString * total;

@end

@interface YHCardViceTransObj : NetTransObj

@end
//超市支付
@interface YHCardPay : NSObject

@property(nonatomic , strong)NSString * barcode_url;
@property(nonatomic , strong)NSString * barcode_num;
@property(nonatomic , strong)NSString * amount_available;
@property(nonatomic , strong)NSString * countdown;

@end

@interface YHCardPayTransObj : NetTransObj

@end

//永辉充值界面信息
@interface YHCardRecharge : NSObject

@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * balance;
@property(nonatomic , strong)NSString * ceiling;
@property(nonatomic , strong)NSString * type;

@end

@interface YHCardRechargeTransObj : NetTransObj

@end

//充值方式列表
@interface YHCardMethodes : NSObject

@property(nonatomic , strong) NSString * str_ID;
@property(nonatomic , strong) NSString * name;

@end

@interface YHCardMethodesTransObj : NetTransObj

@end

//永辉卡充值--在线充值
@interface YHCardRechargePay : NSObject

@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * money;
@property(nonatomic , strong)NSString * pay_method;
@property(nonatomic , strong)NSString * pay_str;
@property(nonatomic , strong)NSString * message;

@end

@interface YHCardRechargePayTransObj : NetTransObj

@end

//永辉卡超市支付，信息接口
@interface YHCardOffline : NSObject

@property(nonatomic , strong)NSString *card_no;
@property(nonatomic , strong)NSString *total_amount;

@end

@interface YHCardOfflineTransObj : NetTransObj

@end
//我的永辉钱包
@interface YHCardBag_Main : NSObject

@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * amount;
@property(nonatomic , strong)NSString * total_state;
@property(nonatomic , strong)NSString * total_state_str;

@end
@interface YHCardBag_MainTransObj : NetTransObj

@end
//我的永辉钱包--永辉卡
@interface YHCardBag_Vice : NSObject

@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * card_amount;
@property(nonatomic , strong)NSString * validity_date;
@property(nonatomic , strong)NSString * total_state_str;
@property(nonatomic , strong)NSString * image_url;
@property(nonatomic , strong)NSString * total;

@end
@interface YHCardBag_ViceTransObj : NetTransObj

@end
//永辉卡收支明细接口API
@interface YHCardTransList : NSObject

@property(nonatomic , strong)NSString *transaction_store;
@property(nonatomic , strong)NSString *transaction_type;
@property(nonatomic , strong)NSString *transaction_amount;
@property(nonatomic , strong)NSString *transaction_time;
@property(nonatomic , strong)NSString *balance_of_payments;
@property(nonatomic , strong)NSString * total;
@end
@interface YHCardTransListTransObj : NetTransObj

@end
//历史转赠信息列表展示接口
@interface YHCardHistoryList : NSObject

@property(nonatomic , strong)NSString *image_url;
@property(nonatomic , strong)NSString *card_no;
@property(nonatomic , strong)NSString *examples_of_object;
@property(nonatomic , strong)NSString *total_amount;
@property(nonatomic , strong)NSString *validity_date;
@property(nonatomic , strong)NSString *total;
@end
@interface YHCardHistoryListTransObj : NetTransObj

@end

//转赠永辉卡列表接口API
@interface YHCardExamplesList : NSObject

@property(nonatomic , strong)NSString *image_url;
@property(nonatomic , strong)NSString *card_no;
@property(nonatomic , strong)NSString *total_amount;
@property(nonatomic , strong)NSString *validity_date;

@end
@interface YHCardExamplesListTransObj : NetTransObj

@end