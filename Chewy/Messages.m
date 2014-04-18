//
//  Messages.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Messages.h"

@implementation Messages

- (void)parseData:(NSDictionary*)data
{
    /* sample json data */
    /*
     {
     "aps":
     {
     "alert": "SENDER_NAME: MESSAGE_TEXT",
     "sound": "default"
     },
     }
     */
    
    NSString *alertValue = [[data valueForKey:@"aps"] valueForKey:@"alert"];
	NSMutableArray *parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
	
    NSString* senderName = [parts objectAtIndex:0]; // todo: display this?
    [parts removeObjectAtIndex:0];

	NSString* message = [parts componentsJoinedByString:@": "];
    
	[_recentMessages insertObject:message atIndex:0];
}

@end
