//
//  ChewyView.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "ChewyView.h"

#define MAX_VISIBLE_MSGS 3

@implementation ChewyView {
    UIView* _placeHolderForChewy;
    NSMutableArray* _messageViews;
    Messages* _messages;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int offset = 80;
        int cnt = ([_messages.recentMessages count] < MAX_VISIBLE_MSGS) ? [_messages.recentMessages count] : MAX_VISIBLE_MSGS;
        for(int i = 0; i < cnt; i++)
        {
            UILabel* msg = [[UILabel alloc] initWithFrame:CGRectMake(10, offset, frame.size.width, 40)];
            msg.text = [_messages.recentMessages objectAtIndex:i];
            [self addSubview:msg];
            
            [_messageViews addObject:msg];

            offset += 80;
        }
        
        [_messages addObserver:self forKeyPath:@"recentMessages" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return self;
}

- (id)initWithData:(Messages*)data frame:(CGRect)frame
{    
    _messages = data;
    
    return [self initWithFrame:frame];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"recentMessages"])
    {
//        NSString* oldC = [change objectForKey:NSKeyValueChangeOldKey];
        NSString* newMessage = [change objectForKey:NSKeyValueChangeNewKey];
        // update _messageViews
    }
}

@end
