//
//  ClickModel.h
//  RedPacket
//
//  Created by mistong on 16/1/27.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClickModel : NSObject

@property (nonatomic, strong)NSString *userNo;   //工号
@property (nonatomic, strong)NSString *userName; //姓名
- (id)initWithDic:(NSDictionary *)dic;
@end
