//
//  ChewyView.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"

@interface ChewyView : UIView

- (id)initWithData:(Messages*)data frame:(CGRect)frame;

@end
