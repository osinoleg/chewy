//
//  MainViewController.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"

@interface MessageCell : UITableViewCell

@property (nonatomic) NSString* messageText;

@end

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>

@end
