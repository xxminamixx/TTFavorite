//
//  Utils.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)decodeJSONString:(NSString *)input
{
    
    NSString *esc1 = [input stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData *data = [quoted dataUsingEncoding:NSUTF8StringEncoding];

    NSString *unesc = [NSPropertyListSerialization propertyListWithData:data
                                                               options:NSPropertyListImmutable
                                                                format:NULL
                                                                 error:nil];
    assert([unesc isKindOfClass:[NSString class]]);
    return unesc;
}

@end
