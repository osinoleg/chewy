//
//  Messages.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Messages.h"

@implementation Message

- (NSComparisonResult)compare:(Message*)otherObject {
    return [[NSNumber numberWithInteger:self.msgId] compare:[NSNumber numberWithInteger:otherObject.msgId]];
}

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

- (NSInteger)parsePushData:(NSDictionary*)data
{
    NSString *alertValue = [[data valueForKey:@"aps"] valueForKey:@"alert"];
    NSInteger msgId = [[[data valueForKey:@"aps"] valueForKey:@"message_id"] integerValue];
    NSURL* url = [self extractURL:alertValue];
    Message* messsage = [[Message alloc] init];
    messsage.txt = alertValue;
    messsage.url = url;
    messsage.msgId = msgId;
    
    [self insertMessage:messsage];

    [self sortMessages];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
    
    return msgId;
}

- (void)parseAllMessages:(NSDictionary*)data
{
    NSLog(@"Message history result json: %@", data);
    
    for(NSString* msgID in data)
    {
        NSArray* msgData = [data objectForKey:msgID];
        NSString* msgTxt = [msgData objectAtIndex:1];
        Message* messsage = [[Message alloc] init];
        NSURL* url = [self extractURL:msgTxt];
        messsage.txt = msgTxt;
        messsage.url = url;
        messsage.msgId = [msgID integerValue];
        
        [self insertMessage:messsage];
    }
    
    [self sortMessages];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
}

- (void)parseServerData:(NSDictionary*)data
{
    NSLog(@"Message received history result json: %@", data);
    
    for(NSString* msgID in data)
    {
        NSArray* msgData = [data objectForKey:msgID];
        NSString* msgTxt = [msgData objectAtIndex:0];
        Message* messsage = [[Message alloc] init];
        NSURL* url = [self extractURL:msgTxt];
        messsage.txt = msgTxt;
        messsage.url = url;
        messsage.sent = [msgData objectAtIndex:1];
        messsage.received = [msgData objectAtIndex:2];
        messsage.msgId = [msgID integerValue];
        
        [self insertMessage:messsage];
    }
    
    [self sortMessages];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessagesChangedNotification" object:self];
}

- (void)insertMessage:(Message*)msgToInsert
{
    for(Message* msg in _recentMessages)
    {
        if(msg.msgId == msgToInsert.msgId)
            return;
    }
    
    [_recentMessages insertObject:msgToInsert atIndex:0];
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

- (void)sortMessages
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgId"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [_recentMessages sortedArrayUsingDescriptors:sortDescriptors];
        
    _recentMessages = [NSMutableArray arrayWithArray:sortedArray];
}

@end
