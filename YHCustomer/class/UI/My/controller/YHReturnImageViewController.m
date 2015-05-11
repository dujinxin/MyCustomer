//
//  YHReturnImageViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-5-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHReturnImageViewController.h"

@implementation YHReturnImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     
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
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    self.navigationItem.title = @"清晰图片";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@" 删除", @selector(deleteAction:));
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-originY-44)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [image setImageWithURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:image];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

#pragma mark -------------- action
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除图片"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

}

#pragma mark --------------  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.block) {
            self.block(self.tag);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
