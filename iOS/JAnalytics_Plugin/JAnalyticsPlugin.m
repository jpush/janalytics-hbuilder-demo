//
//  JAnalyticsPlugin.m
//  HBuilder
//
//  Created by oshumini on 2018/4/25.
//  Copyright © 2018年 DCloud. All rights reserved.
//
#include "PGMethod.h"

#import "JAnalyticsPlugin.h"
#import "JANALYTICSService.h"
#import "JANALYTICSEventObject.h"

static NSString *const kJAnalyticsAppKey = @"APP_KEY";
static NSString *const kJAnalyticsChannel = @"channel";
static NSString *const kJAnalyticsAdvertisingId =  @"advertisingId";
static NSString *const kJAnalyticsIsProduction =  @"isProduction";

@implementation JAnalyticsPlugin

- (void) onAppStarted:(NSDictionary*)options {
  [self setup];
}

- (void)handleResultWithValue:(id)value command:(PGMethod *)command{
  
  PDRPluginResult *result = nil;
  PDRCommandStatus status = PDRCommandStatusOK;
  
  if ([value isKindOfClass:[NSString class]]) {
    value  = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [PDRPluginResult resultWithStatus:status messageAsString:value];
  }else if ([value isKindOfClass:[NSArray class]]) {
    result = [PDRPluginResult resultWithStatus:status messageAsArray:value];
  }else if ([value isKindOfClass:[NSDictionary class]]){
    result = [PDRPluginResult resultWithStatus:status messageAsDictionary:value];
  }else if ([value isKindOfClass:[NSNull class]]){
    result = [PDRPluginResult resultWithStatus:status];
  }else if ([value isKindOfClass:[NSNumber class]]){
    CFNumberType numberType = CFNumberGetType((CFNumberRef)value);
    if (numberType == kCFNumberIntType) {
      result = [PDRPluginResult resultWithStatus:status messageAsInt:[value intValue]];
    } else  {
      result = [PDRPluginResult resultWithStatus:status messageAsDouble:[value doubleValue]];
    }
  }else if ([value isKindOfClass:[NSError class]]) {
    NSError *error = value;
    result = [PDRPluginResult resultWithInnerError:(int)error.code withMessage:error.description];
  }else if (value == nil) {
    result = [PDRPluginResult resultWithStatus:status];
  } else {
    NSString *error = [NSString stringWithFormat:@"unrecognized type: %@",NSStringFromClass([value class])];
    NSLog(@"%@",error);
    result = [PDRPluginResult resultWithStatus:PDRCommandStatusError messageAsString:error];
  }
  
  [self toCallback:command.arguments[0] withReslut:[result toJSONString]];
}

- (void)setup {
  NSString *path = [[NSBundle mainBundle]pathForResource:@"JAnalyticsConfig" ofType:@"plist"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
  
  JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
  if (dict[kJAnalyticsAppKey]) {
    config.appKey = dict[kJAnalyticsAppKey];
  }
  
  if (dict[kJAnalyticsChannel]) {
    config.channel = dict[kJAnalyticsChannel];
  }
  
  if (dict[kJAnalyticsAdvertisingId]) {
    config.advertisingId = dict[kJAnalyticsAdvertisingId];
  }
  
  if (dict[kJAnalyticsAdvertisingId]) {
    config.advertisingId = dict[kJAnalyticsAdvertisingId];
  }
  
  if (dict[kJAnalyticsIsProduction]) {
    NSNumber *isProduction = dict[kJAnalyticsIsProduction];
    config.isProduction = isProduction.boolValue;
  }
  
  [JANALYTICSService setupWithConfig:config];
}

- (void)startLogPageView:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  
  NSString *pageName = @"";
  if (param[@"pageName"]) {
    pageName = param[@"pageName"];
  }
  [JANALYTICSService startLogPageView: pageName];
}

- (void)stopLogPageView:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  NSString *pageName = @"";
  if (param[@"pageName"]) {
    pageName = param[@"pageName"];
  }
  [JANALYTICSService stopLogPageView: pageName];
}

- (void)uploadLocation:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  
  double latitude = 0.0;
  double longitude = 0.0;
  
  if (param[@"latitude"]) {
    NSNumber *latitudeNum = param[@"latitude"];
    latitude = [latitudeNum doubleValue];
  }
  
  if (param[@"latitude"]) {
    NSNumber *latitudeNum = param[@"latitude"];
    latitude = [latitudeNum doubleValue];
  }
  
  [JANALYTICSService setLatitude: latitude longitude: longitude];
}

- (void)crashLogON {
  [JANALYTICSService crashLogON];
}

- (void)setDebug:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  
  BOOL enable = false;
  if (param[@"enable"]) {
    NSNumber *enableNum = param[@"enable"];
    enable = [enableNum boolValue];
  }
  [JANALYTICSService setDebug: enable];
}

- (void)postEvent:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  
  NSString *type = @"";
  if (param[@"type"]) {
    type = param[@"type"];
  }
  
  if ([type isEqualToString: @"login"]) {
    JANALYTICSLoginEvent *loginEvent = [[JANALYTICSLoginEvent alloc] init];
    
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      loginEvent.extra = extra;
    }
    
    if (param[@"method"]) {
      NSString *method = param[@"method"];
      loginEvent.method = method;
    }
    
    if (param[@"success"]) {
      NSNumber *success = param[@"success"];
      loginEvent.success = [success boolValue];
    }
    
    [JANALYTICSService eventRecord: loginEvent];
  }
  
  if ([type isEqualToString: @"register"]) {
    JANALYTICSRegisterEvent *registerEvent = [[JANALYTICSRegisterEvent alloc] init];
    
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      registerEvent.extra = extra;
    }
    
    if (param[@"method"]) {
      NSString *method = param[@"method"];
      registerEvent.method = method;
    }
    
    if (param[@"success"]) {
      NSNumber *success = param[@"success"];
      registerEvent.success = [success boolValue];
    }
    [JANALYTICSService eventRecord: registerEvent];
  }
  
  if ([type isEqualToString: @"purchase"]) {
    JANALYTICSPurchaseEvent *purchaseEvent = [[JANALYTICSPurchaseEvent alloc] init];
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      purchaseEvent.extra = extra;
    }
    
    if (param[@"goodsType"]) {
      NSString *goodsType = param[@"goodsType"];
      purchaseEvent.goodsType = goodsType;
    }
    
    if (param[@"goodsId"]) {
      NSString *goodsId = param[@"goodsId"];
      purchaseEvent.goodsID = goodsId;
    }
    
    if (param[@"goodsName"]) {
      NSString *goodsName = param[@"goodsName"];
      purchaseEvent.goodsName = goodsName;
    }
    
    if (param[@"success"]) {
      NSNumber *success = param[@"success"];
      purchaseEvent.success = [success boolValue];
    }
    
    if (param[@"price"]) {
      NSNumber *price = param[@"price"];
      purchaseEvent.price = [price floatValue];
    }
    
    if (param[@"currency"]) {
      NSString *currency = param[@"currency"];
      if ([currency isEqualToString:@"CNY"]) {
        purchaseEvent.currency = JANALYTICSCurrencyCNY;
      }
      
      if ([currency isEqualToString:@"USD"]) {
        purchaseEvent.currency = JANALYTICSCurrencyUSD;
      }
    }
    [JANALYTICSService eventRecord: purchaseEvent];
  }
  
  if ([type isEqualToString: @"browse"]) {
    
    JANALYTICSBrowseEvent *browseEvent = [[JANALYTICSBrowseEvent alloc] init];
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      browseEvent.extra = extra;
    }
    
    if (param[@"name"]) {
      NSString *name = param[@"name"];
      browseEvent.name = name;
    }
    
    if (param[@"id"]) {
      browseEvent.contentID = param[@"id"];
    }
    
    if (param[@"contentType"]) {
      NSString *contentType = param[@"contentType"];
      browseEvent.type = contentType;
    }
    
    if (param[@"duration"]) {
      NSNumber *duration = param[@"duration"];
      browseEvent.duration = [duration floatValue];
    }
    [JANALYTICSService eventRecord: browseEvent];
  }
  
  if ([type isEqualToString: @"count"]) {
    JANALYTICSCountEvent *countEvent = [[JANALYTICSCountEvent alloc] init];
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      countEvent.extra = extra;
    }
    
    if (param[@"id"]) {
      countEvent.eventID = param[@"id"];
    }
    [JANALYTICSService eventRecord: countEvent];
  }
  
  if ([type isEqualToString: @"calculate"]) {
    JANALYTICSCalculateEvent *calculateEvent = [[JANALYTICSCalculateEvent alloc] init];
    if (param[@"extra"]) {
      NSDictionary *extra = param[@"extra"];
      calculateEvent.extra = extra;
    }
    
    if (param[@"id"]) {
      calculateEvent.eventID = param[@"id"];
    }
    
    if (param[@"value"]) {
      NSNumber *value = param[@"value"];
      calculateEvent.value = [value floatValue];
    }
    [JANALYTICSService eventRecord: calculateEvent];
  }
}

- (void)identifyAccount:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  
  JANALYTICSUserInfo *userInfo = [[JANALYTICSUserInfo alloc] init];
  if (param[@"accountID"]) {
    userInfo.accountID = param[@"accountID"];
  } else {
    NSError *error = [NSError errorWithDomain:@"params error!" code: 1 userInfo: nil];
    [self handleResultWithValue:error command:command];
    return;
  }
  
  if (param[@"creationTime"]) {
    NSNumber *creationTime = param[@"creationTime"];
    userInfo.creationTime = creationTime.doubleValue;
  }

  // crash
//  if (param[@"birthdate"]) {
//    NSString *birthdate = param[@"birthdate"];
//    userInfo.birthdate = birthdate;
//  }

  if (param[@"sex"]) {
    if ([param[@"sex"] isEqualToString:@"male"]) {
      userInfo.sex = JANALYTICSSexMale;
    } else if ([param[@"sex"] isEqualToString:@"female"]) {
      userInfo.sex = JANALYTICSSexFemale;
    } else {
      userInfo.sex = JANALYTICSSexUnknown;
    }

  }

  if (param[@"paid"]) {
    if ([param[@"paid"] isEqualToString:@"paid"]) {
      userInfo.paid = JANALYTICSPaidPaid;
    } else if ([param[@"paid"] isEqualToString:@"unpaid"]) {
      userInfo.paid = JANALYTICSPaidUnpaid;
    } else {
      userInfo.paid = JANALYTICSPaidUnknown;
    }
  }

  if (param[@"phone"]) {
    NSString *phone = param[@"phone"];
    userInfo.phone = phone;
  }

  if (param[@"email"]) {
    NSString *email = param[@"email"];
    userInfo.email = email;
  }

  if (param[@"name"]) {
    NSString *name = param[@"name"];
    userInfo.name = name;
  }

  if (param[@"wechatID"]) {
    NSString *wechatID = param[@"wechatID"];
    userInfo.wechatID = wechatID;
  }

  if (param[@"qqID"]) {
    NSString *qqID = param[@"qqID"];
    userInfo.qqID = qqID;
  }

  if (param[@"weiboID"]) {
    NSString *weiboID = param[@"weiboID"];
    userInfo.weiboID = weiboID;
  }

  if (param[@"extras"]) {
    NSDictionary *extras = param[@"extras"];
    for (NSString* key in extras) {
      id value = [extras objectForKey:key];
      [userInfo setExtraObject:value forKey:key];
    }
  }
  
  
  [JANALYTICSService identifyAccount:userInfo with:^(NSInteger err, NSString *msg) {
    if (err != 0) {
      NSError *error = [NSError errorWithDomain:msg?msg:@"" code: err userInfo: nil];
      [self handleResultWithValue:error command:command];
    } else {
      [self handleResultWithValue:msg command:command];
    }
  }];
}

/**
 * 解绑当前的用户信息
 */
- (void)detachAccount:(PGMethod*)command {
  [JANALYTICSService detachAccount:^(NSInteger err, NSString *msg) {
    if (err != 0) {
      NSError *error = [NSError errorWithDomain: msg?msg:@"" code: err userInfo: nil];
      [self handleResultWithValue:error command:command];
    } else {
      [self handleResultWithValue:msg command:command];
    }
  }];
}

- (void)setFrequency:(PGMethod*)command {
  NSDictionary *param = command.arguments[1];
  if (param[@"frequency"]) {
    NSNumber *fre = param[@"frequency"];
    [JANALYTICSService setFrequency:fre.integerValue];
  }
}
@end
