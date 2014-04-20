//
//  Messages.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Messages.h"

@implementation Messages

- (id)init
{
    if(self = [super init])
    {
        _recentMessages = [[NSMutableArray alloc] init];
        return self;
    }
    
    return self;
}

- (void)parseData:(NSDictionary*)data
{
    /* sample json data */
    /*
     {
     "aps":
     {
     "alert": "SENDER_NAME: MESSAGE_TEXT",
     },
     }
     */
    
    NSString *alertValue = [[data valueForKey:@"aps"] valueForKey:@"alert"];
	[_recentMessages insertObject:alertValue atIndex:0];
    
    
    NSURL* url = nil;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:alertValue options:0 range:NSMakeRange(0, [alertValue length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            url = [match URL];
            NSLog(@"found URL: %@", url);
            break;
        }
    }
    [_messageURLs insertObject:url atIndex:0];

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
}

@end
