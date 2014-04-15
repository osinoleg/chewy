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

@implementation MainViewController {
    ChewyView* _chewyView;
    Messages* _messages;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messages = [[Messages alloc] init];
    NSMutableArray* sampleMsgs = [NSMutableArray arrayWithArray:@[@"msg 1", @"msg 2", @"msg 3"]];
    _messages.recentMessages = sampleMsgs;
    
    _chewyView = [[ChewyView alloc] initWithData:_messages frame:self.view.frame];
    [self.view addSubview:_chewyView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
