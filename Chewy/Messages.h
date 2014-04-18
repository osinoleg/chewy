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

- (void)parseData:(NSDictionary*)data;

@end
