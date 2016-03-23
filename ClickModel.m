//
//  ClickModel.m
//  RedPacket
//
//  Created by mistong on 16/1/27.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "ClickModel.h"

@implementation ClickModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.userNo = [NSString stringWithFormat:@"%@", [dic objectForKey:@"userno"]];
        self.userName = [NSString stringWithFormat:@"%@", [dic objectForKey:@"realname"]];
    }
    return self;
}
@end
