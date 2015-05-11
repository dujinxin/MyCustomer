//
//  YHSearchListTableViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHSearchListTableViewController.h"
#import "YHSearchResultsViewController.h"
#import "KeyWordsEntity.h"

@interface YHSearchListTableViewController ()

@end

@implementation YHSearchListTableViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	self.tableView.layer.borderWidth = 1;
//	self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    if(IOS_VERSION <7){
        //
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
	_searchText = nil;
	_selectedText = nil;
	_resultList = [[NSMutableArray alloc] init];
}
- (void)updateData {
    //	[_resultList removeAllObjects];
    //	[_resultList addObject:_searchText];
    //	for (int i = 1; i<10; i++) {
    //		[_resultList addObject:[NSString stringWithFormat:@"%@%d",_searchText,i]];
    //	}
	[self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, 320, 1.0f)];
        line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
        [cell.contentView addSubview:line];
    }
    
    
    
	NSUInteger row = [indexPath row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
	cell.textLabel.text = [_resultList objectAtIndex:row];
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedText = [self.resultList objectAtIndex:indexPath.row];
    [self.target passValue:self.selectedText];
    
//    YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
//    srvc.view.backgroundColor = [UIColor clearColor];
//    srvc.textField.text = entity.keyString;
//    srvc.keyWord = [NSString stringWithString: entity.keyString];
//    srvc.selectScreenGoods = ^(YHSearchResultsViewController * s){
//        self.searchView.text = s.screenString;
//    };
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:entity.keyString forKey:@"key"];
//    [params setValue:@"0" forKey:@"bu_id"];
//    [params setValue:@"default" forKey:@"order"];
//    [params setValue:@"search" forKey:@"type"];
//    [srvc setRequstParams:params];
//    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray * historyArray = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"historySearch"]];
//    if([historyArray count]!=0){
//        NSUInteger index;
//        for (NSString * s in historyArray) {
//            if ([s isEqualToString:entity.keyString]){
//                index = [historyArray indexOfObject:s];
//                break;
//            }else{
//                index = 999;
//            }
//        }
//        if (index != 999) {
//            [historyArray removeObjectAtIndex:index];
//        }
//        [historyArray insertObject:entity.keyString atIndex:0];
//        [defaults setValue:historyArray forKey:@"historySearch"];
//        [defaults synchronize];
//    }else{
//        [historyArray addObject:entity.keyString];
//        [defaults setValue:historyArray forKey:@"historySearch"];
//        [defaults synchronize];
//    }
//    
//    [self.navigationController pushViewController:srvc animated:NO];

}

@end
