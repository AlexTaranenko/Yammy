

#import <Foundation/Foundation.h>

// ErrorString Mapping

@interface ErrorString : NSObject

@property (nonatomic, strong) NSString *text;

+ (RKObjectMapping *)objectMapping;

@end

// Main Mapping

@interface ResponseStatusModel : NSObject

@property (nonatomic, strong) NSString *errorMessage;
@property (strong, nonatomic) NSNumber *dataSuccess;
@property (strong, nonatomic) NSNumber *code;
@property (strong, nonatomic) NSNumber *status;
@property (nonatomic, strong) NSString *localized;

@property (nonatomic, strong) NSString *birthdayMessage;
@property (nonatomic, strong) NSString *emailMessage;
@property (nonatomic, strong) NSString *fullNameMessage;
@property (nonatomic, strong) NSString *genderMessage;
@property (nonatomic, strong) NSString *interestsMessage;

+ (RKObjectMapping *)objectMapping;

- (void)setupRegisterErrorsByResponse:(NSData *)responseData;

@end

