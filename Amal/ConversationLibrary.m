//
//  ConversationLibrary.m
//  Amal
//
//  Created by Mohd Rusman Arief A Rahman on 2/2/12.
//  Copyright (c) 2012 Experience Garage. All rights reserved.
//

#import "ConversationLibrary.h"

@implementation ConversationLibrary

@synthesize conversationYes = _conversationYes;
@synthesize conversationNo = _conversationNo;

-(id)init
{
    if (self = [super init]) 
    {
        self.conversationYes = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Yes I did that",
                            [NSNumber numberWithInt:0],
                            @"Alhamdulillah. I did it",
                            [NSNumber numberWithInt:1],
                            @"Yes. With flying colours",
                            [NSNumber numberWithInt:2],
                            @"Yup",
                            [NSNumber numberWithInt:3],
                            @"Nothing but yes",
                            [NSNumber numberWithInt:4],
                            nil];
    
        self.conversationNo = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Ok I forgot",
                            [NSNumber numberWithInt:0],
                            @"Completely forgot",
                            [NSNumber numberWithInt:1],
                            @"No",
                            [NSNumber numberWithInt:2],
                            @"Sadly, no",
                            [NSNumber numberWithInt:3],
                            @"I will do better next time",
                            [NSNumber numberWithInt:4],
                            nil];
        return self;
    }
    return nil;
}

@end
