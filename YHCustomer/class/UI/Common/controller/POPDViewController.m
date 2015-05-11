//
//  POPDViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDViewController.h"

@interface POPDViewController ()
@property (nonatomic, strong) NSMutableArray *popArray;
@end


@implementation POPDViewController
@synthesize delegate;
@synthesize popArray;


+ (POPDViewController *)shareInstance{
    static POPDViewController *pdView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pdView = [[POPDViewController alloc] init];
    });
    return pdView;
}

- (id)initWithMenuSections:(NSMutableArray *) menuSections
{
    self = [super init];
    if (self) {
        self.popArray = menuSections;
    }
    return self;
    
    [self.tableView reloadData];
}

- (void)loadView{
    [super loadView];
//    popArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f];
    self.tableView.backgroundView = nil;
    self.view.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
   return  popArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
       
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *name = [PublicMethod addLabel:CGRectMake(10, 5, 200, 20) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
        name.tag = 1001;
        [cell.contentView addSubview:name];
        
        UILabel *description = [PublicMethod addLabel:CGRectMake(10, 25, 300, 20) setTitle:nil setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:12]];
        description.tag = 1002;
        [cell.contentView addSubview:description];
        
        UIView *darkLine = [PublicMethod addBackView:CGRectMake(0, 53, 320, 1) setBackColor:[UIColor lightGrayColor]];
        darkLine.alpha = .2f;
        [cell.contentView addSubview:darkLine];
    }
    
    BuListEntity *entity = [self.popArray objectAtIndex:indexPath.row];
    UILabel *name_tag = (UILabel *)[cell.contentView viewWithTag:1001];
    name_tag.text =entity.bu_name;
    
    UILabel *description_tag = (UILabel *)[cell.contentView viewWithTag:1002];
    description_tag.text =entity.address;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BuListEntity *dic = [self.popArray objectAtIndex:indexPath.row];
    [self.delegate didSelectRowAtIndexPath:dic];
}

@end
