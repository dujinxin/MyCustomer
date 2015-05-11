//
//  YHNewSearchGoodsViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHNewSearchGoodsViewController.h"
#import "YHWebGoodListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZbarViewController.h"
typedef enum{
    kHotSearchTag = 100,
    
    kHistorySearchTag = 200,
    kDeleteAllTag = 300,
    kShowAllTag = 1000,
    kUnShowTag ,
    
    
}ButtonTag;

@interface YHNewSearchGoodsViewController ()
{
    NSMutableArray * hotWordArray;
    NSMutableArray * dataArray;
    UITextField *search;
    UIScrollView * searchBgView;
    UIScrollView * hotBgView;
    UIView * historyBgView;
    UILabel * leftLabel;
    BOOL isChangeRow;
    BOOL isShowAll;
    BOOL isFirst;
    
    CGFloat hotSearchWidth;
    CGFloat historyearchHeigth;
}
@end

@implementation YHNewSearchGoodsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.navigationItem.title = @"搜索";
        
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self.navigationItem.hidesBackButton = YES;
    [self addNavigationView];
    [self initData];
    [self addBgView];
    _searchListView = [[YHSearchListTableViewController alloc] initWithStyle:UITableViewStylePlain];
	_searchListView.target = self;
	[_searchListView.view setFrame:CGRectMake(0, 64, 0, 0)];
    [self.view addSubview:_searchListView.view];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    
    isChangeRow = NO;
    isShowAll = NO;
//    hotSearchWidth = 0;
//    historyearchHeigth = 0;
    
//    if (_searchView.text.length == 0) {
//        [_searchView becomeFirstResponder];
//    }else{
//        
//    }
    if (_textField.text.length == 0) {
        [_textField becomeFirstResponder];
    }else{
        
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * historyArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"historySearch"]];
    if(historyArray.count != 0 )
    {
        [dataArray removeAllObjects];
        dataArray = [NSMutableArray arrayWithArray:historyArray];
        [self addHistoryView:dataArray];
        [leftLabel setHidden:YES];
    }
    else
    {
        [leftLabel setHidden:NO];
    }
    //    [self setHidesBottomBarWhenPushed:YES];
    hotBgView.contentOffset = CGPointMake(0, 0);
    searchBgView.contentOffset = CGPointMake(0, 0);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    hiddenStr = @"";
    //    [self setHidesBottomBarWhenPushed:YES];
    //    [self.navigationItem setHidesBackButton:YES];
    //    self.navigationItem.hidesBackButton = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
      NSLog(@"%f" , _searchView.frame.size.width);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
- (void)initData{
    hotWordArray = [[NSMutableArray alloc]init ];
    
    isFirst = YES;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
    if(historyArray.count != 0){
        dataArray = [NSMutableArray arrayWithArray: historyArray];
    }
    else
    {
        dataArray = [[NSMutableArray alloc]init ];
    }
}
#pragma mark ------------------------- add UI
-(void)addNavigationView
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -80, 30)];
    _textField.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.layer.borderColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (IOS_VERSION >= 7){
        _textField.tintColor = [UIColor blueColor];
    }else{
        
    }
    _textField.delegate = self;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"right_search"];
    _textField.leftView = imageView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_textField];
    
    self.navigationItem.titleView = _textField;
    //    [self.navigationController.navigationBar addSubview:_searchView];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(BackButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil action:nil];
    
    
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -5;
    }else{
        negativeSpacer.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
    self.navigationItem.rightBarButtonItems = barItems;
}
-(void)addNavigationView1
{
    _searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 0, 270, 30)];
    _searchView.clipsToBounds = YES;
    _searchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchView.text = @"";
    _searchView.layer.cornerRadius = 2;
    _searchView.barStyle = UIBarStyleBlackTranslucent;
    _searchView.translucent = NO;
    _searchView.tintColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    
    UIView * bgView = [_searchView.subviews objectAtIndex:0];
//    bgView.frame = CGRectMake(0, 7, _searchView.width, 30);
    if (IOS_VERSION < 7) {
        [bgView removeFromSuperview];
        _searchView.backgroundColor = [UIColor clearColor];
    }else{
//        bgView.backgroundColor = [UIColor blueColor];
//        bgView.layer.borderWidth = 1.0;
//        bgView.layer.borderColor = [PublicMethod colorWithHexValue:0xe70012 alpha:1.0].CGColor;
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"search_left"];
    
    _searchView.delegate = self;
    self.navigationItem.titleView = _searchView;
    //    [self.navigationController.navigationBar addSubview:_searchView];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(BackButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil action:nil];
    
    
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -5;
    }else{
        negativeSpacer.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
    self.navigationItem.rightBarButtonItems = barItems;
}
- (void)addBgView{
    searchBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH ,SCREEN_HEIGHT -64)];
    searchBgView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    searchBgView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT -64);
    searchBgView.showsHorizontalScrollIndicator = NO;
    searchBgView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:searchBgView];
    
    hotBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
    hotBgView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    hotBgView.contentSize = CGSizeMake(SCREEN_WIDTH, 58);
    hotBgView.showsHorizontalScrollIndicator = NO;
    hotBgView.showsVerticalScrollIndicator = NO;
    [searchBgView addSubview:hotBgView];
    
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,hotBgView.bottom, 320, 50)];
    leftLabel.textColor = [PublicMethod colorWithHexValue:0x999999 alpha:1.0];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.text = @"您还没有搜索记录";
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [searchBgView addSubview:leftLabel];
    [leftLabel setHidden:YES];
    
    historyBgView = [[UIView alloc]initWithFrame:CGRectMake(0, hotBgView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -58 -64)];
    historyBgView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    
}
- (void)addHotSearchWord:(NSArray *)hotArray{
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:hotArray];
    [newArray insertObject:@"热搜" atIndex:0];
    int j=0;
    for (int i= 0;i<newArray.count; i++) {
        if (i == 0) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 38)];
            label.text = [newArray objectAtIndex:0];
            label.tag = kHotSearchTag+i;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            
            [hotBgView addSubview:label];
            
        }else{
            //            static int j=0;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,30, 38)];
            NSString * title = [newArray objectAtIndex:i];
            label.text = [newArray objectAtIndex:i];
            label.tag = kHotSearchTag+i;
            label.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
            label.layer.borderWidth = 1.0;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            label.textAlignment = NSTextAlignmentCenter;
            //添加手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            
            CGSize size ;
            if (IOS_VERSION >=7) {
                // NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                NSStringDrawingOptions option =NSStringDrawingUsesFontLeading;
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
                
                CGRect rect = [title boundingRectWithSize:CGSizeMake(214, 38) options:option attributes:attributes context:nil];
                size = rect.size;
            }else{
                size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(214, 38) lineBreakMode:NSLineBreakByWordWrapping];
            }
            if ([hotBgView viewWithTag:label.tag-1]) {
                UILabel * lab = (UILabel *)[hotBgView viewWithTag:label.tag-1];
                label.frame = CGRectMake(lab.right +10,10,size.width +20, 38);
                [hotBgView addSubview:label];
            }
            if (i == newArray.count - 1) {
                j = label.right + 10;
                hotBgView.contentSize = CGSizeMake(j, 58);
            }
        }
    }
}
- (void)addHistoryView:(NSArray *)textArray{
    [searchBgView addSubview:historyBgView];
    [leftLabel setHidden:YES];
    
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:textArray];
    [newArray insertObject:@"历史搜索" atIndex:0];
    [newArray addObject:@"清除历史记录"];
    
    for (int i= 0; i<newArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            btn.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
            
        }else if(i> 0 && i < newArray.count -1){
            btn.frame = CGRectMake(0, 40 * i, SCREEN_WIDTH, 40);
        }
        
        if (i < newArray.count - 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, btn.height - 1, SCREEN_WIDTH, 1)];
            [line setBackgroundColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
            [btn addSubview:line];
        }
        [btn setTitle:[newArray objectAtIndex:i] forState:UIControlStateNormal] ;
        btn.tag = kHistorySearchTag +i;
        btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        if (btn.tag == kHistorySearchTag) {
            [btn setTitleColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == newArray.count -1){
            btn.frame = CGRectMake(10, 40 * (newArray.count -1) + 10, SCREEN_WIDTH -20, 40);
            btn.tag = kDeleteAllTag;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            if (btn.bottom < searchBgView.height -240) {
                searchBgView.contentSize = CGSizeMake(SCREEN_WIDTH, searchBgView.height);
                if (hotWordArray.count == 0) {
                    historyBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, searchBgView.height);
                }else{
                    historyBgView.frame = CGRectMake(0, 58, SCREEN_WIDTH, searchBgView.height);
                }
            }else{
                searchBgView.contentSize = CGSizeMake(SCREEN_WIDTH, btn.bottom + 300);
                if (hotWordArray.count == 0) {
                    historyBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, btn.bottom + 300);
                }else{
                    historyBgView.frame = CGRectMake(0, 58, SCREEN_WIDTH, btn.bottom + 300);
                }
            }
        }
        [historyBgView addSubview:btn];
    }
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([searchText length] != 0) {
        //		_searchListView.searchText = searchText;
        //		[_searchListView updateData];
        //        [self.view bringSubviewToFront:_searchListView.view];
        //		[self setSearchListHidden:NO];
        
        postDic = [NSMutableDictionary dictionary];
        
        [[PSNetTrans getInstance ]getKeyWordsSearchList:self keyWord:[NSString stringWithFormat:@"%@",searchText]];
        
	}
	else {
		[self setSearchListHidden:YES];
	}
    NSLog(@"111111111111111111");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	return YES;
    NSLog(@"%f" , searchBar.frame.size.width);
     NSLog(@"2222222222222");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//	searchBar.text = @"";
    NSLog(@"%f" , searchBar.frame.size.width);
     NSLog(@"3333333333333");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
	searchBar.text = @"";
    NSLog(@"%f" , searchBar.frame.size.width);
     NSLog(@"444444444444444444");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     NSLog(@"55555555555555555555");
    if (searchBar.text.length != 0)
    {
        [self setSearchListHidden:YES];
        self.searchStr = searchBar.text;
        YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
        
        [dataArray removeAllObjects];
        [historyBgView removeAllSubviews];
        [historyBgView removeFromSuperview];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
        if([historyArray count]!=0){
            NSUInteger index;
            for (NSString * s in historyArray) {
                if ([s isEqualToString:searchBar.text]){
                    index = [historyArray indexOfObject:s];
                    break;
                }else{
                    index = 999;
                }
            }
            if (index != 999) {
                [historyArray removeObjectAtIndex:index];
            }
            [historyArray insertObject:searchBar.text atIndex:0];
            if (historyArray.count >15) {
                [historyArray removeLastObject];
            }
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }else{
            [historyArray addObject:searchBar.text];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }
        srvc.selectScreenGoods = ^(YHSearchResultsViewController * s)
        {
            self.searchView.text = s.screenString;
        };
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:searchBar.text forKey:@"key"];
        [params setValue:@"1" forKey:@"page"];
        [params setValue:@"default" forKey:@"order"];
        [params setValue:@"search" forKey:@"type"];
        [srvc setRequstParams:params];
        srvc.view.backgroundColor = [UIColor clearColor];
        srvc.textField.text = searchBar.text;
        srvc.keyWord = [NSString stringWithString: searchBar.text];
        
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:srvc animated:YES];
    }else{
        [[iToast makeText:@"搜索内容不能为空"] show];
    }
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self setSearchListHidden:YES];
	[searchBar resignFirstResponder];
    
    YHWebGoodListViewController *searchResult = [[YHWebGoodListViewController alloc] init];
    [searchResult setParamerWihtType:@"6" Id:searchBar.text];
    [self.navigationController pushViewController:searchResult animated:YES];
    searchBar.text = nil;
}
-(void)addSearchBar
{
    //    search = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 40)];
    //    //passwordTxtField.secureTextEntry = YES;
    //    search.autocorrectionType = UITextAutocorrectionTypeNo;
    //    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    search.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    search.returnKeyType = UIReturnKeySearch;
    //    search.placeholder = @"请输入商品名称搜索";
    //    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    //    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    //    [leftView setImage:[UIImage imageNamed:@"search"]];
    //    [left addSubview:leftView];
    //    search.leftView = left;
    //    search.delegate = self;
    //    search.leftViewMode = UITextFieldViewModeAlways;
    //    search.layer.borderWidth = 0.5;
    //    search.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    search.layer.cornerRadius = 3;
    //    [self.view addSubview:search];
    //    _search = search;
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 1)
    {
        [self setSearchListHidden:YES];
        [self.searchView resignFirstResponder];
        
        [[YHAppDelegate appDelegate] hideTabBar:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [MTA trackCustomKeyValueEvent:EVENT_ID20 props:nil];
        [self setSearchListHidden:YES];
        [self.searchView resignFirstResponder];
        //           [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        ZbarViewController *zbar = [[ZbarViewController alloc] init];
        zbar.saoType = Sao_Goods;
        [self.navigationController pushViewController:zbar animated:YES];
    }
    
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    [self.navigationController popViewControllerAnimated:NO];
//    [UIView commitAnimations];
    
}

-(void)searchAction{
    if (_searchView.text.length != 0) {
        YHWebGoodListViewController *searchResult = [[YHWebGoodListViewController alloc] init];
        [searchResult setParamerWihtType:@"6" Id:_searchView.text];
        [self.navigationController pushViewController:searchResult animated:YES];
    } else {
        [[iToast makeText:@"请输入搜索内容"] show];
    }
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    
    UILabel * lab = (UILabel *)tap.view;
    if (lab.tag != kHotSearchTag) {
        YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
        srvc.view.backgroundColor = [UIColor clearColor];
        srvc.textField.text = lab.text;
        srvc.keyWord = [NSString stringWithString: lab.text];
        srvc.selectScreenGoods = ^(YHSearchResultsViewController * s){
            self->_textField.text = s.screenString;
        };
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:lab.text forKey:@"key"];
        [params setValue:@"0" forKey:@"bu_id"];
        [params setValue:@"default" forKey:@"order"];
        [params setValue:@"search" forKey:@"type"];
        [srvc setRequstParams:params];
        
        [dataArray removeAllObjects];
        [historyBgView removeAllSubviews];
        [historyBgView removeFromSuperview];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
        if([historyArray count]!=0){
            NSUInteger index;
            for (NSString * s in historyArray) {
                if ([s isEqualToString:lab.text]){
                    index = [historyArray indexOfObject:s];
                    break;
                }else{
                    index = 999;
                }
            }
            if (index != 999) {
                [historyArray removeObjectAtIndex:index];
            }
            [historyArray insertObject:lab.text atIndex:0];
            if (historyArray.count >15) {
                [historyArray removeLastObject];
            }
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }else{
            [historyArray addObject:lab.text];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }
        if (IOS_VERSION >= 8) {
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:srvc animated:YES];
        }else{
            [self.navigationController pushViewController:srvc animated:NO];
        }
        
    }
}
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag > kHistorySearchTag && btn.tag < kDeleteAllTag)
    {
        YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
        srvc.view.backgroundColor = [UIColor clearColor];
        srvc.textField.text = btn.currentTitle;
        srvc.keyWord = [NSString stringWithString: btn.currentTitle ];
        srvc.selectScreenGoods = ^(YHSearchResultsViewController * s){
            self->_textField.text = s.screenString;
        };
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:btn.currentTitle forKey:@"key"];
        [params setValue:@"0" forKey:@"bu_id"];
        [params setValue:@"default" forKey:@"order"];
        [params setValue:@"search" forKey:@"type"];
        [srvc setRequstParams:params];
        //移除历史记录
        [dataArray removeAllObjects];
        [historyBgView removeAllSubviews];
        [historyBgView removeFromSuperview];
        //历史记录数据重新排序
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
        if([historyArray count]!=0){
            NSUInteger index;
            for (NSString * s in historyArray) {
                if ([s isEqualToString:btn.currentTitle]){
                    index = [historyArray indexOfObject:s];
                    break;
                }else{
                    index = 999;
                }
            }
            if (index != 999) {
                [historyArray removeObjectAtIndex:index];
            }
            [historyArray insertObject:btn.currentTitle atIndex:0];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }else{
            [historyArray addObject:btn.currentTitle];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }
        
        if (IOS_VERSION >= 8) {
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:srvc animated:YES];
        }else{
            [self.navigationController pushViewController:srvc animated:NO];
        }
    }else if (btn.tag == kDeleteAllTag){
        [self showAlert:self newMessage:@"删除全部搜索记录"];
    }
}
- (void)passValue:(NSString *)value{
	if (value) {
        _textField.text = value;
        [self setSearchListHidden:YES];
        //		[self searchBarSearchButtonClicked:search];
	}
	else {
		
	}
}
- (void)setSearchListHidden:(BOOL)hidden {
    if (hidden) {
        [_searchListView.view setHidden:YES];
    }else{
        [_searchListView.view setHidden:NO];
    }
	NSInteger height = hidden ? 0 : 260;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0];
	[_searchListView.view setFrame:CGRectMake(0, 0, 320, height)];
	[UIView commitAnimations];
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //取消
    }else{
        [dataArray removeAllObjects];
        [historyBgView removeAllSubviews];
        [historyBgView removeFromSuperview];
        [leftLabel setHidden:NO];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * historyArray =[NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
        if([historyArray count] != 0){
            [historyArray removeAllObjects];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }
        
        searchBgView.contentOffset = CGPointMake(0, 0);
        searchBgView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT -64);
        
    }
}
#pragma mark - ApiRequestDelegate
-(void)setRequstParams:(NSMutableDictionary *)param {
    
    [[PSNetTrans getInstance] getHotWordsSearchList:self];
    
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_SEARCH_HOT_WORDS_LIST == nTag)
    {
        //        HotWordsEntity  *entity = (HotWordsEntity *)netTransObj;
        NSArray * array = (NSArray *)netTransObj;
        for (HotWordsEntity * entity in array) {
            [hotWordArray addObject:entity.keyString];
        }
        
        if ([hotWordArray count] == 0) {
            [hotBgView removeFromSuperview];
            leftLabel.frame = CGRectMake(20,0, 320, 50);
            historyBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -58 -64);
            
        } else {
//            [searchBgView addSubview:hotBgView];
            leftLabel.frame = CGRectMake(20,hotBgView.bottom, 320, 50);
            [self addHotSearchWord:hotWordArray];
        }
        if (dataArray.count != 0) {
            [self addHistoryView:dataArray];
        }else{
            [historyBgView removeAllSubviews];
            [historyBgView removeFromSuperview];
            [leftLabel setHidden:NO];
        }
    }else if (t_API_SEARCH_KEY_WORDS_LIST == nTag)
    {
        [_searchListView.resultList removeAllObjects];
        NSArray * array = (NSArray *)netTransObj;
        for (KeyWordEntity * entity in array)
        {
            [_searchListView.resultList addObject:entity.keyString];
        }
        if (_searchListView.resultList.count != 0)
        {
            [_searchListView updateData];
            [self.view bringSubviewToFront:_searchListView.view];
            [self setSearchListHidden:NO];
        }
        else
        {
            //
            [self setSearchListHidden:YES];
        }
		
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    //    [[iToast makeText:errMsg]show];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"已经开始编辑");
    if ([textField.text length] != 0) {
        //		_searchListView.searchText = searchText;
        //		[_searchListView updateData];
        //        [self.view bringSubviewToFront:_searchListView.view];
        //		[self setSearchListHidden:NO];
        
        postDic = [NSMutableDictionary dictionary];
        
        [[PSNetTrans getInstance ]getKeyWordsSearchList:self keyWord:[NSString stringWithFormat:@"%@",textField.text]];
        
    }
    else {
        [self setSearchListHidden:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"已经结束编辑");
//    if (textField.text.length != 0) {
//		_searchListView.searchText = textField.text;
//		[_searchListView updateData];
//		[self setSearchListHidden:NO];
//	}
//	else {
//		[self setSearchListHidden:YES];
//	}

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"应该开始编辑");
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"应该结束编辑");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length != 0)
    {
        [self setSearchListHidden:YES];
        self.searchStr = textField.text;
        YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
        srvc.view.backgroundColor = [UIColor clearColor];
        [dataArray removeAllObjects];
        [historyBgView removeAllSubviews];
        [historyBgView removeFromSuperview];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
        if([historyArray count]!=0){
            NSUInteger index;
            for (NSString * s in historyArray) {
                if ([s isEqualToString:textField.text]){
                    index = [historyArray indexOfObject:s];
                    break;
                }else{
                    index = 999;
                }
            }
            if (index != 999) {
                [historyArray removeObjectAtIndex:index];
            }
            [historyArray insertObject:textField.text atIndex:0];
            if (historyArray.count >15) {
                [historyArray removeLastObject];
            }
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }else{
            [historyArray addObject:textField.text];
            [defaults setValue:historyArray forKey:@"historySearch"];
            [defaults synchronize];
        }
        srvc.selectScreenGoods = ^(YHSearchResultsViewController * s)
        {
            self->_textField.text = s.screenString;
        };
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:textField.text forKey:@"key"];
        [params setValue:@"1" forKey:@"page"];
        [params setValue:@"default" forKey:@"order"];
        [params setValue:@"search" forKey:@"type"];
        [srvc setRequstParams:params];
        srvc.textField.text = textField.text;
        srvc.keyWord = [NSString stringWithString: textField.text];
        
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:srvc animated:YES];
    }else{
        [[iToast makeText:@"搜索内容不能为空"] show];
    }

	[textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextFieldTextDidChanged
- (void)textChanged:(id)sender{
    if ([_textField.text length] != 0) {
        postDic = [NSMutableDictionary dictionary];
        [[PSNetTrans getInstance ]getKeyWordsSearchList:self keyWord:[NSString stringWithFormat:@"%@",_textField.text]];
    }
    else {
        [self setSearchListHidden:YES];
    }
}
#if 0
- (void)addOldHistoryView:(NSArray *)textArray
{
    [self.view addSubview:searchHistoryView];
    
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:textArray];
    [newArray insertObject:@"搜索记录" atIndex:0];
    int j=0;
    for (int i= 0;i<newArray.count; i++) {
        if (i == 0) {
            [leftLabel removeFromSuperview];
            leftLabel.text = [newArray objectAtIndex:0];
            leftLabel.frame = CGRectMake(10, 10, 40, 38);
            leftLabel.tag = 100 + i;
            [searchHistoryView addSubview:leftLabel];
            
        }else{
            //            static int j=0;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,0, 38)];
            NSString * title = [newArray objectAtIndex:i];
            label.text = [newArray objectAtIndex:i];
            label.tag = 100+i;
            label.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
            label.font = [UIFont systemFontOfSize:15];
            label.layer.borderWidth = 1.0;
            label.textAlignment = NSTextAlignmentCenter;
            //添加手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            
            CGSize size ;
            if (IOS_VERSION >=7) {
                // NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                NSStringDrawingOptions option =NSStringDrawingUsesFontLeading;
                //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
                
                CGRect rect = [title boundingRectWithSize:CGSizeMake(214, 38) options:option attributes:attributes context:nil];
                size = rect.size;
            }else{
                size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(214, 38) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            //换行
            if (isChangeRow) {
                label.frame = CGRectMake(10 ,10+(38 +10)*j, size.width +20, 38);
                [searchHistoryView addSubview:label];
                isChangeRow = NO;
                //不换行
            }else{
                if ([searchHistoryView viewWithTag:label.tag-1]) {
                    UILabel * lab = (UILabel *)[searchHistoryView viewWithTag:label.tag-1];
                    label.frame = CGRectMake(lab.right +10,lab.top,size.width +20, 38);
                    //是否需要换行
                    if (label.right>300) {
                        i--;
                        j++;
                        isChangeRow = YES;
                    }else{
                        [searchHistoryView addSubview:label];
                    }
                }
            }
            //全部展示
            if (isShowAll) {
                if ((label.bottom > 250 && label.bottom < 300 )&& label.right <= 214 && newArray.count -1 > i) {
                    //创建收起和删除按钮
                    UIButton * unShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    unShowAll.frame = CGRectMake(224, label.top, 38, 38);
                    unShowAll.tag = kUnShowTag;
                    unShowAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    unShowAll.layer.borderWidth = 1.0;
                    [unShowAll setImage:[UIImage imageNamed:@"btn_unShow"] forState:UIControlStateNormal];
                    [unShowAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:unShowAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(unShowAll.right + 10, label.top, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }else if ((label.bottom > 175 && label.bottom < 300 ) && label.right <= 214 && newArray.count -1 == i){
                    //创建收起和删除按钮
                    UIButton * unShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    unShowAll.frame = CGRectMake(224, label.top, 38, 38);
                    unShowAll.tag = kUnShowTag;
                    unShowAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    unShowAll.layer.borderWidth = 1.0;
                    [unShowAll setImage:[UIImage imageNamed:@"btn_unShow"] forState:UIControlStateNormal];
                    [unShowAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:unShowAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(unShowAll.right + 10, label.top, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                    
                }
                
            }//部分展示
            else{
                if ((label.bottom > 100 && label.bottom < 160) && label.right <= 214 && newArray.count -1 > i) {
                    //创建展开和删除按钮
                    UIButton * showAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    showAll.frame = CGRectMake(224, label.top, 38, 38);
                    showAll.tag = kShowAllTag;
                    showAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    showAll.layer.borderWidth = 1.0;
                    [showAll setImage:[UIImage imageNamed:@"btn_show"] forState:UIControlStateNormal];
                    [showAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:showAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(showAll.right + 10, label.top, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }else if ((label.bottom < 100 || ((label.bottom > 100 && label.bottom < 160)  && label.right <= 252 ))&& newArray.count -1 == i){
                    //只创建删除按钮
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(320-58, label.top, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }
            }
            if (label.centerY < 130){
                
            }
            //            if (i==newArray.count-1) {
            //                searchHistoryView.frame = CGRectMake(0,0,320, label.bottom+300);
            //            }
            
            
        }
        
    }
}
- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case kShowAllTag:
        {
            [searchHistoryView removeAllSubviews];
            [searchHistoryView removeFromSuperview];
            isShowAll = YES;
            [self addHistoryView:dataArray];
        }
            break;
        case kUnShowTag:
        {
            [searchHistoryView removeAllSubviews];
            [searchHistoryView removeFromSuperview];
            isShowAll = NO;
            [self addHistoryView:dataArray];
        }
            break;
        case kDeleteAllTag:
        {
            [self showAlert:self newMessage:@"删除全部搜索记录"];
        }
            break;
            
        default:
            break;
    }
}

#endif
@end
