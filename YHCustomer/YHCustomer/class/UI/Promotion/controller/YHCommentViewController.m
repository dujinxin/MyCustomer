//
//  YHCommentViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-23.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHCommentViewController.h"
#import "CommentCell.h"
#import "GoodsEntity.h"

@interface YHCommentViewController ()

@end

@implementation YHCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"评论";
        self.view.backgroundColor = [UIColor whiteColor];
        commentDataArray = [NSMutableArray array];
        countPage = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
//    [self addInputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MTA trackPageViewBegin:PAGE6];
    self._tableView.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-40);
    [self._tableView setHidden:YES];
//    [self addInputView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromServer];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE6];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark ------------------------- add UI
-(void)addInputView {
   sendField = [[UITextField alloc]initWithFrame:CGRectMake(5, 3, SCREEN_WIDTH-80, 40)];
    [sendField setBackground:[UIImage imageNamed:@"input_rec_bg"]];
    sendField.returnKeyType = UIReturnKeySend;
    sendField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sendField.delegate = self;
    sendField.placeholder = @"请输入评论内容";

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 3, 60, 40)];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn_selected.png"] forState:UIControlStateHighlighted];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 40)];
    sendField.leftView = leftView;
    sendField.leftViewMode = UITextFieldViewModeAlways;
    
    sendView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVBAR_HEIGHT-20-44, SCREEN_WIDTH, 44)];
    [sendView setImage:[UIImage imageNamed:@"input_bg"]];
    sendView.userInteractionEnabled = YES;
    [sendView addSubview:sendField];
    [sendView addSubview:sendBtn];
    if (self._isBought)
    {
        [self.view addSubview:sendView];
    }

}

-(void)addNoCommentView {
    noCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 150)];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(103, 0, 114, 96)];
    bgView.userInteractionEnabled = YES;
    [bgView setImage:[UIImage imageNamed:@"no_comment"]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(103, bgView.bottom+5, 114, 96)];
    title.text = @"目前没有评论内容";
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor lightGrayColor];
    title.backgroundColor = [UIColor clearColor];
    [noCommentView addSubview:bgView];
    [noCommentView addSubview:title];
//    [self.view insertSubview:noCommentView belowSubview:sendView];
    [self.view insertSubview:noCommentView atIndex:0];
//    [self.view addSubview:noCommentView ];- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
}

#pragma mark -------------------------按钮事件处理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [sendField resignFirstResponder];
}
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)send
{
    if (!self._isBought)
    {
        [[iToast makeText:@"请先购买再评论"]show];
        return;
    }
    if (sendField.text.length == 0) {
        [[iToast makeText:@"评论不能为空"] show];
        return;
    }
    if (self.commentStyle == GOODS_COMMENT_LIST)
    {
        [[NetTrans getInstance] buy_goodOrDMComment:self ID:self.goods_id Comment:sendField.text CommentType:self.commentStyle];
    }else if(self.commentStyle == PROMOTION_COMMENT_LIST)
    {
        [[NetTrans getInstance] buy_goodOrDMComment:self ID:self.dm_id Comment:sendField.text CommentType:self.commentStyle];
    }
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    CommentEntity *entity = [commentDataArray objectAtIndex:indexPath.row];
    
    UIImageView *head = [PublicMethod addImageView:CGRectMake(8, 8, 40, 40) setImage:entity.photo_url];
    [head setOnlineImage:entity.photo_url placeholderImage:[UIImage imageNamed:@"header_default.png"]];
    head.layer.cornerRadius = 8;
    head.layer.masksToBounds = YES;
    [cell.contentView addSubview:head];
    
    UILabel *title = [PublicMethod addLabel:CGRectMake(55, 8, 90, 20) setTitle:entity.user_name setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    [cell.contentView addSubview:title];
    
    UILabel *city = [PublicMethod addLabel:CGRectMake(150, 4, 55, 20) setTitle:entity.region_name setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:10]];
    city.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:city];
    
    UILabel *time = [PublicMethod addLabel:CGRectMake(210, 4, 100, 20) setTitle:entity.time setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:10]];
    [cell.contentView addSubview:time];
    
    CGFloat flot_Comment = [PublicMethod getLabelHeight:entity.comment setLabelWidth:260 setFont:[UIFont systemFontOfSize:12]];

    UILabel *content = [PublicMethod addLabel:CGRectMake(58, 28, 260, flot_Comment) setTitle:entity.comment setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:content];
    
    if (entity.rep_Content.length > 0) {
        CGFloat flot = [PublicMethod getLabelHeight:entity.rep_Content setLabelWidth:260 setFont:[UIFont systemFontOfSize:12]];
        UILabel *rep_Content = [PublicMethod addLabel:CGRectMake(58, flot_Comment + 30, 260, flot+22) setTitle:[NSString stringWithFormat:@"%@ : %@",@"永辉客服",entity.rep_Content] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        rep_Content.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:rep_Content];
        
        UILabel *rep_time = [PublicMethod addLabel:CGRectMake(210, flot+flot_Comment+50, 100, 15) setTitle:entity.rep_add_time setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
        rep_time.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:rep_time];
    }

    return cell;
}

#pragma mark -------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70.f;
    CommentEntity *entity = [commentDataArray objectAtIndex:indexPath.row];
    CGFloat rep_Comment_Height = .0f;
    if (entity.rep_Content.length > 0) {
     rep_Comment_Height  = [PublicMethod getLabelHeight:entity.rep_Content setLabelWidth:260 setFont:[UIFont systemFontOfSize:12]];
    }
    
    CGFloat comment_Height = [PublicMethod getLabelHeight:entity.comment setLabelWidth:260 setFont:[UIFont systemFontOfSize:12]];
    return rep_Comment_Height+ 70 + comment_Height;
}

#pragma mark - KeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    [UIView animateWithDuration:0.2 animations:^{
        sendView.origin = CGPointMake(0, keyboardTop - 44);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        sendView.origin = CGPointMake(0,ScreenSize.height-44.f - sendView.frame.size.height);
        NSLog(@"self.view.frame.size.height is %f",self.view.frame.size.height);
    }];
}

#pragma mark -------------  request data
-(void)getDataFromServer
{
    if (self.commentStyle == GOODS_COMMENT_LIST) {
//        self.navigationItem.title = @"商品评论列表";
        [[NetTrans getInstance] buy_goodOrDMCommentList:self Id:self.goods_id Page:countPage Limit:@"10" CommentType:GOODS_COMMENT_LIST];
    }
    if (self.commentStyle == PROMOTION_COMMENT_LIST) {
//        self.navigationItem.title = @"促销评论列表";
        [[NetTrans getInstance] buy_goodOrDMCommentList:self Id:self.dm_id Page:countPage Limit:@"10" CommentType:PROMOTION_COMMENT_LIST];
    }
    
}

#pragma mark ----------  set
-(void)setCommentListDataAndType:(NSString*)strID Type:(CommentType)type IsBought:(BOOL)isBought
{
    
    self.commentStyle = type;
    self._isBought = isBought;
    if (isBought) {
        [self addInputView];
        self._tableView.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT-40);
    }else{
        self._tableView.frame = CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT);
    }
    if (type == GOODS_COMMENT_LIST)
    {
        self.goods_id = strID;
        [[NetTrans getInstance] buy_GoodDetail:self BuDmOrGoodsId:self.goods_id];
    }else if(type == PROMOTION_COMMENT_LIST)
    {
        self.dm_id = strID;
    }
    
}

#pragma mark --------------------------网络代理
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // 评论列表
    if (t_API_BUY_PLATFORM_GOODS_COMMENTLIST == nTag || t_API_BUY_PLATFORM_PROMOTION_COMMENTLIST == nTag) {
        if (countPage > 1  )
        {
            [commentDataArray addObjectsFromArray:(NSMutableArray *)netTransObj];
            [self._tableView setHidden:NO];
            if (requestStyle == Load_MoreStyle) {
                if (self.total == commentDataArray.count) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            self.total = commentDataArray.count;
            [self._tableView reloadData];
            [self testFinishedLoadData];
        }
        else if (countPage == 1)
        {
            commentDataArray = [NSMutableArray arrayWithArray:(NSMutableArray *)netTransObj];
            [self._tableView setHidden:NO];
            [self._tableView reloadData];
            if ([commentDataArray count] == 0) {
                [self._tableView setHidden:YES];
                [self addNoCommentView];
            }
            else
            {
                if (noCommentView)
                {
                    [noCommentView removeFromSuperview];
                    noCommentView = nil;
                }
            }
            if (commentDataArray.count <10) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
            [self addRefreshTableFooterView];
        }
    }
    // 发表评论
    if (t_API_BUY_PLATFORM_GOODS_COMMENT == nTag || t_API_BUY_PLATFORM_PROMOTION_COMMENT == nTag) {
        [self showNotice:@"评论发布成功"];
        sendField.text = @"";
         countPage = 1;
        [sendField resignFirstResponder];
        [self getDataFromServer];
    }
    
    if (nTag == t_API_BUY_PLATFORM_GOODDS_DETAIL) {
//        GoodsEntity *entity = (GoodsEntity *)netTransObj;
//        self.navigationItem.title = entity.goods_name;
    }
    [self finishLoadTableViewData];

}


-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    if (nTag == t_API_BUY_PLATFORM_GOODS_COMMENT)
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
    else if (nTag == t_API_BUY_PLATFORM_GOODS_COMMENTLIST)
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
    else if (nTag == t_API_BUY_PLATFORM_PROMOTION_COMMENT)
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
    else if (nTag == t_API_BUY_PLATFORM_PROMOTION_COMMENTLIST)
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
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    requestStyle = Load_RefrshStyle;
    countPage = 1;
    self.dataState = EGOOHasMore;
    [self getDataFromServer];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
	_reloading = YES;
    requestStyle = Load_MoreStyle;
    countPage ++;
    [self getDataFromServer];
    NSLog(@"getMore start requestInterface.");
}

#pragma mark ----------------UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self._isBought)
    {
        [[iToast makeText:@"请先购买再评论"]show];
    }
    return self._isBought;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == sendField)
    {
        [sendField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (sendField.text.length == 0) {
        [self showNotice:@"评论内容不能为空!"];
        return NO;
    }

    if (self.commentStyle == GOODS_COMMENT_LIST)
    {
        [[NetTrans getInstance] buy_goodOrDMComment:self ID:self.goods_id Comment:sendField.text CommentType:self.commentStyle];
    }else if(self.commentStyle == PROMOTION_COMMENT_LIST)
    {
        [[NetTrans getInstance] buy_goodOrDMComment:self ID:self.dm_id Comment:sendField.text CommentType:self.commentStyle];
    }
    
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     [sendField resignFirstResponder];
}

@end
