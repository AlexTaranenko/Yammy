

#import "ResponseStatusModel.h"

// ErrorString Mapping

@implementation ErrorString

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"text"]];
  
  return mapping;
}

@end

// Main Mapping

@implementation ResponseStatusModel

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:
   @{
     @"message" : @"errorMessage",
     @"data" : @"dataSuccess",
     @"code" : @"code",
     @"status" : @"status",
     @"localized" : @"localized"
     }];
  
  return mapping;
}

- (void)setupRegisterErrorsByResponse:(NSData *)responseData {
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
  NSDictionary *errorDictionary = [dictionary objectForKey:@"errors"];
  NSDictionary *childrenDictionary = [errorDictionary objectForKey:@"children"];
  
  NSDictionary *birthdayDictionary = [childrenDictionary objectForKey:@"birthday"];
  NSDictionary *emailDictionary = [childrenDictionary objectForKey:@"email"];
  NSDictionary *fullNameDictionary = [childrenDictionary objectForKey:@"fullName"];
  NSDictionary *genderDictionary = [childrenDictionary objectForKey:@"gender"];
  NSDictionary *interestsDictionary = [childrenDictionary objectForKey:@"interests"];
  
  self.birthdayMessage = (NSString *)[[birthdayDictionary objectForKey:@"errors"] firstObject];
  self.emailMessage = (NSString *)[[emailDictionary objectForKey:@"errors"] firstObject];
  self.fullNameMessage = (NSString *)[[fullNameDictionary objectForKey:@"errors"] firstObject];
  self.genderMessage = (NSString *)[[genderDictionary objectForKey:@"errors"] firstObject];
  self.interestsMessage = (NSString *)[[interestsDictionary objectForKey:@"errors"] firstObject];
}

@end

