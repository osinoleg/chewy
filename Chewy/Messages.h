//
//  Messages.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Messages : NSObject

@property (nonatomic) NSMutableArray* recentMessages;
@property (nonatomic) NSMutableArray* messageURLs;

- (void)parsePushData:(NSDictionary*)data;
- (void)parseServerData:(NSDictionary*)data;

@end
