//
//  MainViewController.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "MainViewController.h"
#import "ChewyView.h"
#import "Messages.h"
#import "LoginViewController.h"
#import "AdminViewController.h"

@implementation MainViewController {
    ChewyView* _chewyView;
    Messages* _messages;
    LoginViewController* _loginController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messages = [[Messages alloc] init];
    NSMutableArray* sampleMsgs = [NSMutableArray arrayWithArray:@[@"msg 1", @"msg 2", @"msg 3"]];
    _messages.recentMessages = sampleMsgs;
    
    _chewyView = [[ChewyView alloc] initWithData:_messages frame:self.view.frame];
    [self.view addSubview:_chewyView];
    
    self.navigationItem.title = @"Chewy";
    
    UIBarButtonItem *admin = [[UIBarButtonItem alloc] initWithTitle:@"Admin" style:UIBarButtonItemStylePlain target:self action:@selector(admin)];
    self.navigationItem.rightBarButtonItem = admin;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)admin
{
    if(_loginController == nil)
        _loginController = [[LoginViewController alloc] init];
    
    if(_loginController.loggedIn)
    {
        AdminViewController* controller = [[AdminViewController alloc] init];
        [self.navigationController pushViewController:controller animated:NO];
    }
    else
    {
        [self.navigationController pushViewController:_loginController animated:NO];
    }
}

@end
