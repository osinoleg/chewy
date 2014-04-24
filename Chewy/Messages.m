//
//  Messages.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Messages.h"

@implementation Message


@end

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

- (void)parsePushData:(NSDictionary*)data
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
    NSURL* url = [self extractURL:alertValue];
    Message* messsage = [[Message alloc] init];
    messsage.txt = alertValue;
    messsage.url = url;
    
    [_recentMessages insertObject:alertValue atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
}

- (void)parseServerData:(NSDictionary*)data
{
    NSLog(@"Message history result json: %@", data);
    
    for(NSString* msgTxt in data)
    {
        NSNumber* count = [data objectForKey:msgTxt];
        
        Message* messsage = [[Message alloc] init];
        NSURL* url = [self extractURL:msgTxt];
        messsage.txt = msgTxt;
        messsage.url = url;
        messsage.count = count;
        
        [_recentMessages insertObject:messsage atIndex:0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
}

- (NSURL*)extractURL:(NSString*)message
{
    NSURL* url = nil;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:message options:0 range:NSMakeRange(0, [message length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            url = [match URL];
            NSLog(@"found URL: %@", url);
            break;
        }
    }
    return url;
}

@end
