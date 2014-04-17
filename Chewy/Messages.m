//
//  Messages.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Messages.h"

@implementation Messages

- (void)parseData:(NSData*)data
{
    for(int i = 0; i < 3; i++)
    {
        [_recentMessages addObject:[NSString stringWithFormat:@"msg: %i", i]];
    }
}

@end
