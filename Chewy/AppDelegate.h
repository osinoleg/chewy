//
//  AppDelegate.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(nonatomic) Messages* messages;

// Note: obviously move this into it's own model if this prototype evolves.
@property(nonatomic) NSString* username;
@property(nonatomic) NSString* password;

- (void)fetchAllMessages;

@end
