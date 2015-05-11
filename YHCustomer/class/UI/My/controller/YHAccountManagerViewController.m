//
//  YHAccountManagerViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHAccountManagerViewController.h"
#import "YHAppDelegate.h"
#import "YHModifyNameViewController.h"
#import "YHGenderSettingViewController.h"
#import "RefleshManager.h"
#import "UserUploadImageEntity.h"
#import "YHModifyContactViewController.h"
@interface YHAccountManagerViewController ()

@end

@implementation YHAccountManagerViewController

@synthesize _tableView;
@synthesize _userInfoEntity;

#pragma mark --------------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"个人资料设置";
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addTableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[RefleshManager sharedRefleshManager] getAccountManagerRefresh]) {
        [[NetTrans getInstance] user_getPersonInfo:self setUserId:[UserAccount instance].user_id];
    }
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
-(void)addTableView
{
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    /* uitable view */
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height-NAVBAR_HEIGHT) style:UITableViewStyleGrouped];
    tableview.backgroundView = bgview;
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];
    self._tableView = tableview;
}
-(void)addUserInfoHead
{
    
}
#pragma mark ------------------------- UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_one"]]];
    switch (indexPath.section)
    {
                case 1://联系方式
                {
                    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 100, 20)];
                    labName.backgroundColor = [UIColor clearColor];
                    labName.font = [UIFont systemFontOfSize:18];
                    labName.text = @"联系方式:";
                    [cell.contentView addSubview:labName];
                    
                    UILabel *labNick = [[UILabel alloc]init];
                    if (IOS_VERSION >= 7)
                    {
                        labNick.frame = CGRectMake(50, 11, cell.frame.size.width-60-35, 20);
                    }else
                    {
                        labNick.frame = CGRectMake(50, 11, cell.frame.size.width-60-55, 20);
                    }
                    labNick.backgroundColor = [UIColor clearColor];
                    labNick.textAlignment = NSTextAlignmentRight;
                    labNick.font = [UIFont systemFontOfSize:18];
                    //联系方式要从后台mobile字段获取手机号
                    labNick.text = self._userInfoEntity.mobile;
                    [cell.contentView addSubview:labNick];
                    
                    
                    //小箭头
                    UIImageView *imgvDic = nil;
                    if (IOS_VERSION >= 7) {
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 10, 22, 22)];
                    }else{
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 10, 22, 22)];
                    }            [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
                    [cell.contentView addSubview:imgvDic];
                    
                }
                    break;
                case 2://头像
                {
                    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 50, 20)];
                    labName.backgroundColor = [UIColor clearColor];
                    labName.font = [UIFont systemFontOfSize:18];
                    labName.text = @"头像:";
                    [cell.contentView addSubview:labName];
                    
                    //头像
                    UIImageView *imagev = [[UIImageView alloc]init];
                    
                    if (IOS_VERSION >= 7)
                    {
                        imagev.frame = CGRectMake(self.view.frame.size.width-90, 10, 40, 40);
                    }else
                    {
                        imagev.frame = CGRectMake(self.view.frame.size.width-105, 10, 40, 40);
                    }
                    [imagev setImageWithURL:[NSURL URLWithString:self._userInfoEntity.photo_url] placeholderImage:[UIImage imageNamed:@"header_default"]];
                    CALayer *layer = [imagev layer];
                    layer.masksToBounds = YES;
                    layer.cornerRadius = 5.0;
                    layer.borderWidth = 1.0;
                    layer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
                    
                    [cell.contentView addSubview:imagev];
                    
                    
                    //小箭头
                    UIImageView *imgvDic = nil;
                    if (IOS_VERSION >= 7) {
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 19, 22, 22)];
                    }else{
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 19, 22, 22)];
                    }            [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
                    [cell.contentView addSubview:imgvDic];
                }
                    break;
                case 3://昵称
                {
                    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 50, 20)];
                    labName.backgroundColor = [UIColor clearColor];
                    labName.font = [UIFont systemFontOfSize:18];
                    labName.text = @"昵称: ";
                    [cell.contentView addSubview:labName];
                    
                    UILabel *labNick = [[UILabel alloc]init];
                    if (IOS_VERSION >= 7)
                    {
                        labNick.frame = CGRectMake(labName.right-10, 11, cell.frame.size.width-labName.width-55, 20);
                    }else
                    {
                        labNick.frame = CGRectMake(labName.right-10, 11, cell.frame.size.width-labName.width-75, 20);
                    }
                    labNick.backgroundColor = [UIColor clearColor];
                    labNick.textAlignment = NSTextAlignmentRight;
                    labNick.font = [UIFont systemFontOfSize:18];
                    labNick.text = self._userInfoEntity.user_name;
                    [cell.contentView addSubview:labNick];
                    
                    
                    //小箭头
                    UIImageView *imgvDic = nil;
                    if (IOS_VERSION >= 7) {
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 10, 22, 22)];
                    }else{
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 10, 22, 22)];
                    }            [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
                    [cell.contentView addSubview:imgvDic];
 
                }
                    break;
                case 0://账号
                {
                    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 80, 20)];
                    labName.backgroundColor = [UIColor clearColor];
                    labName.font = [UIFont systemFontOfSize:18];
                    labName.text = @"账号:";
                    [cell.contentView addSubview:labName];

                    UILabel *labMobile = [[UILabel alloc]init];
                    if (IOS_VERSION >= 7)
                    {
                        labMobile.frame = CGRectMake(60, 11, cell.frame.size.width-60-35, 20);
                    }else
                    {
                        labMobile.frame = CGRectMake(60, 11, cell.frame.size.width-60-55, 20);
                    }
                    labMobile.backgroundColor = [UIColor clearColor];
                    labMobile.font = [UIFont systemFontOfSize:18];
                    labMobile.text = self._userInfoEntity.login_user_name;
                    labMobile.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:labMobile];
                    
                }
                    break;
                case 4://性别
                {
                    UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 50, 20)];
                    labName.backgroundColor = [UIColor clearColor];
                    labName.font = [UIFont systemFontOfSize:18];
                    labName.text = @"性别:";
                    [cell.contentView addSubview:labName];
                    
                    UILabel *labGender = [[UILabel alloc]init];
                    if (IOS_VERSION >= 7)
                    {
                        labGender.frame = CGRectMake(50, 11, cell.frame.size.width-60-35, 20);
                    }else
                    {
                        labGender.frame = CGRectMake(50, 11, cell.frame.size.width-60-55, 20);
                    }
                    labGender.backgroundColor = [UIColor clearColor];
                    labGender.font = [UIFont systemFontOfSize:18];
                    //1为男2为女0为保密
                    if ([self._userInfoEntity.gender isEqualToString:@"0"]) {
                        labGender.text = @"未选择";
                    }else if([self._userInfoEntity.gender isEqualToString:@"1"]){
                        labGender.text = @"男";;
                    }else if([self._userInfoEntity.gender isEqualToString:@"2"]){
                        labGender.text = @"女";;
                    }
                
                    labGender.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:labGender];
                    
                    //小箭头
                    UIImageView *imgvDic = nil;
                    if (IOS_VERSION >= 7) {
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 10, 22, 22)];
                    }else{
                        imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 10, 22, 22)];
                    }            [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
                    [cell.contentView addSubview:imgvDic];

                }
                    break;
            
        default:
            break;
    }
    
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {

        case 0:
           return 44;
                case 2: return 60;
                    break;
                case 1:
                case 3:
                case 4:
                    return 44.0;
                default:
                    break;

    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 1)];
    head.backgroundColor = [UIColor clearColor];
    return head;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
                case 1:
                {
                    //修改联系方式
                    YHModifyContactViewController *mvc = [[YHModifyContactViewController alloc]init];
                   // [mvc setMobile:self._userInfoEntity.mobile];
                    mvc.mobile = self._userInfoEntity.mobile;
                    NSLog(@"%@",mvc.mobile);
                    [self.navigationController pushViewController:mvc animated:YES];
//                    YHModifyNameViewController *modifyVC = [[YHModifyNameViewController alloc] init];
//                    [modifyVC setOriName:self._userInfoEntity.user_name];
//                    [self.navigationController pushViewController:modifyVC animated:YES];
                }
                    break;
                case 2:
                {
                    [self changeUserIconInfoImage];
                }
                    break;
                case 0:
                {
 
                }
                    break;
                case 3: {
                    YHModifyNameViewController *modifyVC = [[YHModifyNameViewController alloc] init];
                    [modifyVC setOriName:self._userInfoEntity.user_name];
                    [self.navigationController pushViewController:modifyVC animated:YES];
                }
                    break;
                case 4:
                {
                    YHGenderSettingViewController *genderVC = [[YHGenderSettingViewController alloc] init];
                    [genderVC setGender:self._userInfoEntity.gender];
                    [self.navigationController pushViewController:genderVC animated:YES];
                }

                    break;
                default:
                    break;
            }
}

-(void)setUserInfoEntity:(UserInfoEntity*)entity
{
    self._userInfoEntity = entity;
}
#pragma mark -------------------------更新事件处理
-(void)updateUserInfo:(id)entity
{
    if (entity) {
        self._userInfoEntity = (UserInfoEntity*)entity;
        [self._tableView reloadData];
    }
}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [[YHAppDelegate appDelegate] hideTabBar:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)MButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.selected) {
        
    }else{
        btn.selected = YES;
        self._userInfoEntity.gender = @"1";
        [[NetTrans getInstance] user_modifyPersonInfo:self UserName:nil Email:nil Mobile:nil Intro:nil TrueName:nil Gender:@"1" PhotoId:nil ShoppingWall:nil];
    }
}
-(void)FButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.selected) {
        
    }else{
        btn.selected = YES;
        self._userInfoEntity.gender = @"2";
        [[NetTrans getInstance] user_modifyPersonInfo:self UserName:nil Email:nil Mobile:nil Intro:nil TrueName:nil Gender:@"2" PhotoId:nil ShoppingWall:nil];
    }
}

#pragma mark -------------------------更新头像事件处理
-(void)changeUserIconInfoImage
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"user info icon click");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从相册获取", nil];
    [actionSheet showInView:self.view];

}
#pragma mark –-------------------------UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
		//拍照
		[self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypeCamera]];
	}
	if (buttonIndex == 1) {
		//相册选择
		[self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypePhotoLibrary]];
	}
}
- (void)showImagePicker:(NSNumber*)sourceType
{
	//sourceType=0相机，1相册
	UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
	[imagepicker setDelegate:self];
	[imagepicker setAllowsEditing:YES];
    [imagepicker setSourceType:[sourceType intValue]];
    
    [self presentViewController:imagepicker animated:NO completion:nil];
}
#pragma mark –-------------------------Camera View Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
		[picker dismissViewControllerAnimated:NO completion:nil];
        
		UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        originImage = [PublicMethod imageWithImageSimple:originImage scaledToSize:CGSizeMake(160, 160)];
        [PublicMethod saveImage:originImage WithName:@"userImage.jpg"];
        
        //imageV.image = originImage;
        
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userImage.jpg"];
        NSFileManager *fileMag = [NSFileManager defaultManager];
        if ([fileMag fileExistsAtPath:filePath])
        {
            [[NetTrans getInstance] user_upLoadImage:self Type:@"upload" Image:filePath];
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (t_API_USER_PLATFORM_UPLOAD_IMAGE_API == nTag)
    {
        UserUploadImageEntity *useren = (UserUploadImageEntity *)netTransObj;
        [[NetTrans getInstance] user_modifyPersonInfo:self UserName:nil Email:nil Mobile:nil Intro:nil TrueName:nil Gender:nil PhotoId:useren.image_id ShoppingWall:nil];
        self._userInfoEntity.photo_url = useren.image_url;
        [self._tableView reloadData];
    }else if(t_API_USER_PLATFORM_PERSONINFO_API == nTag)
    {
        [self updateUserInfo:netTransObj];
        [[RefleshManager sharedRefleshManager] setAccountManagerRefresh:NO];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (t_API_USER_PLATFORM_UPLOAD_IMAGE_API == nTag)
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
        [[iToast makeText:errMsg] show];
    }
    else if(nTag == t_API_USER_PLATFORM_PERSONINFO_API)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
    }
}

@end
