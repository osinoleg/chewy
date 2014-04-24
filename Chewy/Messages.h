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
@property (nonatomic) NSNumber* count;

@end

@interface Messages : NSObject

@property (nonatomic) NSMutableArray* recentMessages;

- (void)parsePushData:(NSDictionary*)data;
- (void)parseServerData:(NSDictionary*)data;

@end
