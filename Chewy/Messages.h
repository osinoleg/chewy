//
//  Messages.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic) NSString* txt;
@property (nonatomic) NSURL* url;
@property (nonatomic) NSNumber* sent;
@property (nonatomic) NSNumber* received;
@property (nonatomic) NSInteger msgId;

@end

@interface Messages : NSObject

@property (nonatomic) NSMutableArray* recentMessages;

- (NSInteger)parsePushData:(NSDictionary*)data;
- (void)parseServerData:(NSDictionary*)data;
- (void)parseAllMessages:(NSDictionary*)data;

@end
