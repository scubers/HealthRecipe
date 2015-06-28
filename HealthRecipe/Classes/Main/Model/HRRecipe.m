//
//  HRRecipe.m
//  HealthRecipe
//
//  Created by 王俊仁 on 15/6/6.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "HRRecipe.h"
#import "MJExtension.h"
#import <objc/runtime.h>

#define APIBaseURL @"http://www.yi18.net"

@implementation HRRecipe

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (void)setImg:(NSString *)img {
    if (![img hasPrefix:@"http"]) {
        img = [NSString stringWithFormat:@"%@/%@",APIBaseURL,img];
    }
    _img = [img copy];
}

- (void)setMessage:(NSString *)message {
    message = [message stringByReplacingOccurrencesOfString:@"<h2>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    message = [message stringByReplacingOccurrencesOfString:@"</h2>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    message = [message stringByReplacingOccurrencesOfString:@"<p>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    message = [message stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    message = [message stringByReplacingOccurrencesOfString:@"<br.*>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    message = [message stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, message.length)];
    _message = [message copy];
}

- (void)setName:(NSString *)name {
    name = [name stringByReplacingOccurrencesOfString:@"<font color=\"red\">" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, name.length)];
    name = [name stringByReplacingOccurrencesOfString:@"</font>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, name.length)];
    _name = [name copy];
}

- (void)setContent:(NSString *)content {
    content = [content stringByReplacingOccurrencesOfString:@"<font color=\"red\">" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, content.length)];
    content = [content stringByReplacingOccurrencesOfString:@"</font>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, content.length)];
    _content = [content copy];
}

#pragma mark - 重写isEqual方法
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return self.ID == [object ID];
}

#pragma mark - NSCoding协议方法
- (id)initWithCoder:(NSCoder *)decoder {

    unsigned int count;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        NSString *propName = [[NSString stringWithUTF8String:ivar_getName(vars[i])] substringFromIndex:1];
        [self setValue:[decoder decodeObjectForKey:propName] forKey:propName];
        
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    unsigned int count;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        NSString *propName = [[NSString stringWithUTF8String:ivar_getName(vars[i])] substringFromIndex:1];
        
        [encoder encodeObject:[self valueForKey:propName] forKey:propName];
        
    }
}

@end
