//
//  CategoryView.m
//  YHCustomer
//
//  Created by kongbo on 14-9-5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "CategoryView.h"
#import "CategoryEntity.h"

@implementation CategoryView

@synthesize select_row = _select_row;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        select_row = 0;
        self.categoryData = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.isOut = NO;
        [self initView];

    }
    return self;
}

-(void)initView {

    firstList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH /3, SCREEN_HEIGHT-44-35-20) style:UITableViewStylePlain];
    [firstList setDelegate:self];
    [firstList setDataSource:self];
    [firstList setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1]];
    [firstList setBackgroundView:nil];
    [firstList setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [firstList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:firstList];
    
    secondList = [[UITableView alloc]initWithFrame:CGRectMake(firstList.right, 0,SCREEN_WIDTH - firstList.width, SCREEN_HEIGHT-44-35-20) style:UITableViewStylePlain];
    [secondList setDelegate:self];
    [secondList setDataSource:self];
    [secondList setBackgroundColor:[UIColor whiteColor]];
    [secondList setBackgroundView:nil];
    [secondList setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [self addSubview:secondList];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    ges.delegate = self;
    [self addGestureRecognizer:ges];
    
    self.frame = CGRectMake(self.origin.x, self.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT-44-35);
    
}

-(void)request_type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key {
    [self.categoryData removeAllObjects];
    [firstList reloadData];
    [secondList reloadData];
    
    [[PSNetTrans getInstance] get_Category_Screen_list:self type:type bu_brand_id:bu_brand_id tag_id:tag_id key:key];
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == firstList) {
        
//        if (SCREEN_HEIGHT-44-35-20-44 >= [categoryData count]*40) {
//            firstList.frame = CGRectMake(0, 0, 90, [categoryData count]*40);
//        } else {
//            firstList.frame = CGRectMake(0, 0, 90, SCREEN_HEIGHT-44-35-20-44);
//        }
  
        
        return [self.categoryData count];
    } else {
        if ([self.categoryData count]>0) {;

            NewCategoryEntity *entity = [self.categoryData objectAtIndex:select_row];
            
//            if (SCREEN_HEIGHT-44-35-20-44 >= [entity.last_category_list count]*40) {
//                secondList.frame = CGRectMake(firstList.right, 0,SCREEN_WIDTH - firstList.width, [entity.last_category_list count]*40);
//            } else {
//                secondList.frame = CGRectMake(firstList.right, 0,SCREEN_WIDTH - firstList.width, SCREEN_HEIGHT-44-35-20-44);
//            }
            
            if ([entity.last_category_list count]==0) {
                [secondList setHidden:YES];
            } else {
                [secondList setHidden:NO];
            }

            
            return [entity.last_category_list count];
        } else {
            return 0;
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == firstList) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.height, 320, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
            [cell.contentView addSubview:line];
        }
        
        NewCategoryEntity *entity = [self.categoryData objectAtIndex:indexPath.row];

        if (entity.category_name.length>5) {
            cell.textLabel.text = [entity.category_name substringToIndex:5];
        }else{
            cell.textLabel.text = entity.category_name;
        }
        
        if (indexPath.row != select_row) {
            cell.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
        } else {
            cell.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1];
        }
        
        NewCategoryEntity *entity = [self.categoryData objectAtIndex:select_row];
        
        NewCategoryEntity *entity1 = [entity.last_category_list objectAtIndex:indexPath.row];
        cell.textLabel.text = entity1.category_name;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }

}

#pragma mark -------------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == firstList) {
        
        select_row = indexPath.row;
        [firstList reloadData];
        [secondList reloadData];
        
        NewCategoryEntity *entity = [self.categoryData objectAtIndex:select_row];
        
        if ([entity.category_name isEqualToString:@"全部商品"]) {//全部商品

            if (self.block) {
                self.block(nil,nil,entity.category_name);
                return;
            }
        }
        
        if ([entity.last_category_list count]>0) {
            
        } else {//全部
            if (self.block) {
                self.block(@"1",entity.bu_category_id,entity.category_name);
            }
        }
        
    } else {
        
        NewCategoryEntity *entity = [self.categoryData objectAtIndex:select_row];
        
        NewCategoryEntity *entity1 = [entity.last_category_list objectAtIndex:indexPath.row];
        if (self.block) {
            if (indexPath.row == 0) {
                
                if ([entity.last_category_list count]>1) {//全部什么什么
                    self.block(@"1",entity.bu_category_id,entity.category_name);
                } else {
                     self.block(@"2",entity1.bu_category_id,entity1.category_name);
                }
            

            } else {
                
                self.block(@"2",entity1.bu_category_id,entity1.category_name);
            }

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_CATEGORY_SCREEN_LIST == nTag)
    {
        [self.categoryData removeAllObjects];
        [self.categoryData addObjectsFromArray:(NSMutableArray *)netTransObj];
        if (self.isPromotion)
        {
            firstList.frame = CGRectMake(0, 0, SCREEN_WIDTH /3, SCREEN_HEIGHT-44-35-20-44);
            secondList.frame = CGRectMake(firstList.right, 0,SCREEN_WIDTH - firstList.width, SCREEN_HEIGHT-44-35-20-44);
        }
        
        firstEntity = [[NewCategoryEntity alloc] init];
        firstEntity = (NewCategoryEntity *)[self.categoryData objectAtIndex:0];
//        [categoryData removeObjectAtIndex:0];
        
        [firstList reloadData];
        
        [secondList reloadData];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [[iToast makeText:errMsg]show];
}

#pragma mark -------------- 
-(void)tapAction:(UITapGestureRecognizer *)ges {
        
    if (self.tapBlock) {
        self.tapBlock();
    }

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
    
}

#pragma mark ---------------- 
-(void)addFirstEntity {
    NewCategoryEntity *entity = [self.categoryData objectAtIndex:0];
    if (![entity.category_name isEqualToString:@"全部商品"]) {
        [self.categoryData insertObject:firstEntity atIndex:0];
        [firstList reloadData];
        [secondList reloadData];
    }

}
-(void)deleteFirstEntity {
    NewCategoryEntity *entity = [self.categoryData objectAtIndex:0];
    if ([entity.category_name isEqualToString:@"全部商品"])
    {
        [self.categoryData removeObjectAtIndex:0];
        [firstList reloadData];
        [secondList reloadData];
    }

}

-(void)refresh {

    if (select_row == 0) {
        select_row = 1;
    }
    [firstList reloadData];
    [secondList reloadData];
}

@end
