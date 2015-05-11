//
//  ShareCustomViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-11-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "ShareCustomViewController.h"

@interface ShareCustomViewController ()
{
    UIButton *trueButton;
    UILabel *titleLabel;
    UILabel *_wordCountLabel;
    BOOL isSelected;
}
@end

@implementation ShareCustomViewController
@synthesize shareTextView;
@synthesize imageView;
@synthesize title;
@synthesize description;
@synthesize download_url;
@synthesize sina_content;
@synthesize imageUrl;
@synthesize page_url;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
    UINavigationBar *navBar = self.navigationController.navigationBar; if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) { [navBar setBackgroundImage:[UIImage imageNamed:@"nav_Bg.png"] forBarMetrics:UIBarMetricsDefault]; }
    [self addNav];
    self.navigationItem.title = @"分享到新浪微博";
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0f];
    isSelected = YES;
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)addNav
{
   
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.frame = CGRectMake(0, 0, 52, 44);
    [leftNavButton setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -15;
    }else{
        negativeSpacer.width = -15;
    }
    NSArray * arr = [NSArray arrayWithObjects:negativeSpacer , leftItem, nil];
    self.navigationItem.leftBarButtonItems = arr;
    
    UIButton *rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavButton.frame = CGRectMake(0, 0, 52, 44);
    [rightNavButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightNavButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    
    if (IOS_VERSION >= 7) {
        negativeSpacer1.width = -15;
    }else{
        negativeSpacer1.width = -15;
    }
    NSArray * arr1 = [NSArray arrayWithObjects:negativeSpacer1 , rightItem, nil];
    self.navigationItem.rightBarButtonItems = arr1;

}
-(void)createUI
{
    
    shareTextView = [[UITextView alloc]init];
    if (iPhone5) {
        shareTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 208);
    }else{
        shareTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 150);
    }
    shareTextView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    shareTextView.font = [UIFont systemFontOfSize:15];
    shareTextView.delegate = self;
    shareTextView.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0f];
    shareTextView.text = sina_content;
    shareTextView.layer.borderWidth = 1.0f;
    shareTextView.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f].CGColor;
    [self.view addSubview:shareTextView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, shareTextView.bottom + 10, 40, 40)];
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f].CGColor;
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"goods_default@2x"]];
    imageView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:imageView];
    
    trueButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.right + 10, shareTextView.bottom +18, 24, 24)];
    trueButton.tag = 101;
    
    [trueButton addTarget:self action:@selector(trueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [trueButton setBackgroundImage:[UIImage imageNamed:@"yes-1.png"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:trueButton];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(trueButton.right+2, shareTextView.bottom +16 , 150, 30)];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    titleLabel.text = @"关注永辉微店";
    [self.view addSubview:titleLabel];

    _wordCountLabel = [[UILabel alloc] init];
   // _wordCountLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _wordCountLabel.backgroundColor = [UIColor clearColor];
    _wordCountLabel.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0f];
    _wordCountLabel.text = @"140";
    _wordCountLabel.font = [UIFont boldSystemFontOfSize:12];
    [_wordCountLabel sizeToFit];
    _wordCountLabel.frame = CGRectMake(SCREEN_WIDTH - 50, shareTextView.bottom + 15, 40, 12);
    [self.view addSubview:_wordCountLabel];
    [self updateWordCount];
    UILabel *_wordCountLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_wordCountLabel.right, shareTextView.bottom + 15, 40, 12)];
    _wordCountLabel1.text = @"/140";
    _wordCountLabel1.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0f];
     _wordCountLabel1.font = [UIFont boldSystemFontOfSize:12];
    [self.view addSubview:_wordCountLabel1];




}
-(void)trueButtonClick:(UIButton *)button
{
    
    if (isSelected) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"yes-2.png"] forState:UIControlStateNormal];
        isSelected = NO;
        
    }else{
        
        [button setBackgroundImage:[UIImage imageNamed:@"yes-1.png"] forState:UIControlStateNormal];
        isSelected = YES;
    }
}
-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}
- (void)updateWordCount
{
//    int a = [shareTextView.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
//    int b;
//    if (a%2 == 0)
//    {
//        b = a/2;
//    }
//    else
//    {
//        b = a/2+1;
//    }
    NSUInteger length = [self unicodeLengthOfString:shareTextView.text];
    NSInteger count = 140 - length;
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    [_wordCountLabel sizeToFit];
}

//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [shareTextView resignFirstResponder];
//}
-(void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
    
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    [self updateWordCount];
//    return YES;
//}
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    //[shareTextView resignFirstResponder];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    //[shareTextView resignFirstResponder];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [shareTextView resignFirstResponder];

}

-(void)publish:(UIButton *)button
{
    
    YHAppDelegate *appDelegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *selectedClients = [[NSMutableArray alloc] initWithObjects:SHARE_TYPE_NUMBER(ShareTypeSinaWeibo) , nil];
    id<ISSContent> publishContent = [ShareSDK content:shareTextView.text
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:page_url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:appDelegate.viewDelegate];
    //在授权页面中添加关注官方微博
    if (isSelected) {
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"永辉微店"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        nil]];
        [ShareSDK followUserWithType:ShareTypeSinaWeibo
                               field:@"永辉微店"
                           fieldType:SSUserFieldTypeName
                         authOptions:authOptions
         
                        viewDelegate:appDelegate.viewDelegate
                              result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                  
                                  NSString *msg = nil;
                                  if (state == SSResponseStateSuccess)
                                  {
                                      msg = @"关注成功";
                                  }
                                  else if (state == SSResponseStateFail)
                                  {
                                      msg = @"关注失败";
                                  }
                                  
                                  if (msg)
                                  {
                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                          message:msg
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"确定"
                                                                                otherButtonTitles:nil];
                                      [alertView show];
                                }
                              }];
    }
    

    [ShareSDK oneKeyShareContent:publishContent
                       shareList:selectedClients
                     authOptions:authOptions
                   statusBarTips:YES
                          result:nil];
    
    [self dismissModalViewControllerAnimated:YES];

}
-(void)back:(UIButton *)button
{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
