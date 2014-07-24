//
//  Trace.m
//  OVDexFlight
//
//  Created by Duy on 5/3/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "Trace.h"

@implementation Trace

+(void)log:(NSString*)message, ...
{
    NSMutableString *newContentString = [[NSMutableString alloc] initWithString:@""];
    
    va_list args;
    va_start(args, message);
    
    for (NSString *arg = message; arg != nil; arg = va_arg(args, NSString*))
    {
        [newContentString appendString:arg];
    }
    
    va_end(args);
    
    NSLog(@"%@",newContentString);
}

@end
