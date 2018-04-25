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

static NSString *const kJPushAppKey = @"APP_KEY";

@implementation JAnalyticsPlugin

- (void) onAppStarted:(NSDictionary*)options {
  [self setup];
}

- (void)setup {
  NSString *path = [[NSBundle mainBundle]pathForResource:@"JAnalyticsConfig" ofType:@"plist"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
  
  JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
  if (dict[kJPushAppKey]) {
    config.appKey = dict[kJPushAppKey];
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


@end
