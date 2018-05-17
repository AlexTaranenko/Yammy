//
//  DirectConnectionClient.m
//  Yammy
//
//  Created by Paul Yevchenko on 16/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "DirectConnectionClient.h"
#import "NotificationsHelper.h"

@implementation DirectConnectionClient {
  SRHubConnection *_hubConnection;
  BOOL _connected;
}

+ (instancetype)shared {
  static DirectConnectionClient *sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedClient = [[self alloc] init];
  });
  return sharedClient;
}

- (void)connect {
  if(!_connected || _hubConnection == nil) {
    [self connectInternal];
  }
}

- (void)disconnect {
  if(_hubConnection != nil)
    [_hubConnection disconnect];
  _hubConnection = nil;
  _connected = NO;
}

- (void)onNotification:(NSString *)jsonData {
  NSData *objectData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
  NSError *jsonError = nil;
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
  
  ActivityLineMapping *activityEvent = nil; // TODO: parse jsonData -> into activityEvent
  
  NSDictionary *mappingsDictionary = @{[NSNull null] : [ActivityLineMapping objectMapping]};
  RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:json mappingsDictionary:mappingsDictionary];
  NSError *mappingError = nil;
  BOOL isMapped = [mapper execute:&mappingError];
  if (isMapped && !mappingError) { // parsed success
    NSLog(@"%@", mapper.mappingResult.dictionary);
    activityEvent = [mapper.mappingResult.dictionary objectForKey:[NSNull null]];
    ActivityLineEventTypes eventType = [activityEvent.EventType integerValue];
    NSString *localNotificationName = nil;
    
    switch (eventType) {
      case Chated: // NEW MESSAGE
        localNotificationName = NotificationActivityEventChated;
        break;
      case ChatStatusChangedToDelivered: // MESSAGE has been delivered
        localNotificationName = NotificationActivityEventChatStatusChangedToDelivered;
        break;
      case ChatStatusChangedToSeen: // MESSAGE has been seen
        localNotificationName = NotificationActivityEventChatStatusChangedToSeen;
        break;
      default:
        // Ignore other notifications
        return;
    }
    
    if(localNotificationName != nil) {
      NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: activityEvent, @"activityEvent", nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:localNotificationName object:self userInfo:options];
    }
  } else {
    NSLog(@"error desc: %@, reason: %@", mappingError.localizedDescription, mappingError.localizedFailureReason);
  }
}


- (void)connectInternal {
  // Connect to the service
  _hubConnection = [SRHubConnection connectionWithURLString:@"http://api.yammydating.com/directnotifications"];
  //    _hubConnection.delegate = self;
  // AUTHENTICATION
  [_hubConnection addValue:[Helpers getAccessToken] forHTTPHeaderField:@"Token"];
  
  // Create a proxy to the chat service
  SRHubProxy *chat = [_hubConnection createHubProxy:@"directNotificationsHub"];
  [chat on:@"onNotification" perform:self selector:@selector(onNotification:)];
  
  // Register for connection lifecycle events
  [_hubConnection setStarted:^{
    NSLog(@"Connection Started");
    _connected = YES;
  }];
  
  [_hubConnection setReceived:^(NSString *message) {
    NSLog(@"Connection Recieved Data: %@",message);
  }];
  
  [_hubConnection setConnectionSlow:^{
    NSLog(@"Connection Slow");
  }];
  
  [_hubConnection setReconnecting:^{
    NSLog(@"Connection Reconnecting");
  }];
  
  [_hubConnection setReconnected:^{
    NSLog(@"Connection Reconnected");
    _connected = YES;
  }];
  
  [_hubConnection setClosed:^{
    NSLog(@"Connection Closed");
    _connected = NO;
  }];
  
  [_hubConnection setError:^(NSError *error) {
    NSLog(@"Connection Error %@",error);
    _connected = NO;
  }];
  
  // Start the connection
  [_hubConnection start];
}
@end

