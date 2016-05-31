//
//  XPushBridget.m
//  XPush
//
//  Created by James Jung on 2016. 5. 29..
//  Copyright © 2016년 xpush. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(XPushCore, NSObject)

RCT_EXTERN_METHOD(connect:(NSDictionary*)config callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(send:(NSString*)message)

@end