//
//  ServerManager.h
//  Yammy
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterMapping.h"
#import "ResponseStatusModel.h"
#import "UserCircleMapping.h"
#import "ImageMapping.h"
#import "GiftMapping.h"
#import "LanguageMapping.h"
#import "MessageMapping.h"
#import "ChatMapping.h"
#import "InterestsMapping.h"
#import "PrivateProfileMapping.h"
#import "PreferencesMapping.h"
#import "DictionaryMapping.h"
#import "ProfileMapping.h"
#import "ContactMapping.h"
#import "LikeMapping.h"
#import "MatchMapping.h"
#import "ActivityLineMapping.h"
#import "LocationMapping.h"
#import "ActivityLineStatsMapping.h"
#import "HelpMapping.h"
#import "UserSettingsMapping.h"
#import "PeoplesMapping.h"
#import "VerifyMapping.h"

typedef enum : NSUInteger {
  IsNoAvatar = 0,
  IsAvatar,
} EnumPhotoAvatar;

typedef enum : NSUInteger {
  DefaultType = 0,
  CoinsType,
  ServiceType,
} GiftType;

typedef void(^RegisterUserBlock)(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel);
typedef void(^LoginUserBlock)(RegisterMapping *registerMapping, NSString *errorMessage);
typedef void(^SubscribeNotificationsBlock)(BOOL status, NSString *errorMessage);
typedef void(^SearchDefaultBlock)(NSArray *peoplesArray, NSString *errorMessage);
typedef void(^UploadPhotoBlock)(BOOL status, NSString *errorMessage);
typedef void(^DeletePhotoBlock)(BOOL status, NSString *errorMessage);
typedef void(^AvatarPhotoBlock)(BOOL status, NSString *errorMessage);
typedef void(^MovePhotoBlock)(BOOL status, NSString *errorMessage);
typedef void(^InterestsBlock)(NSArray *interestsArray, NSString *errorMessage);
typedef void(^GiftsBlock)(NSArray *giftsArray, NSString *errorMessage);
typedef void(^MessagesBlock)(NSArray *messagesArray, NSString *errorMessage);
typedef void(^ChatsBlock)(NSArray *chatsArray, NSString *errorMessage);
typedef void(^PrivateProfileBlock)(PrivateProfileMapping *privateProfileMapping, NSString *errorMessage);
typedef void(^PreferencesBlock)(NSArray *preferencesArray, NSString *errorMessage);
typedef void(^UpdatePrivateProfileBlock)(BOOL status, NSString *errorMessage);
typedef void(^DictionaryBlock)(NSArray *dictionaryListArray, NSString *errorMessage);
typedef void(^ProfileBlock)(ProfileMapping *profileMapping, NSString *errorMessage);
typedef void(^LanguageListBlock)(NSArray *languageArray, NSString *errorMessage);
typedef void(^UpdateProfileBlock)(BOOL status, NSString *errorMessage);
typedef void(^ContactsBlock)(NSArray *contactsArray, NSString *errorMessage);
typedef void(^ContactBlock)(BOOL status, NSString *errorMessage);
typedef void(^LikesListBlock)(NSArray *likesArray, NSString *errorMessage);
typedef void(^LikesSendBlock)(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage);
typedef void(^MatchesListBlock)(NSArray *matchesArray, NSString *errorMessage);
typedef void(^ActivityLinesListBlock)(NSArray *activityLinesArray, NSString *errorMessage);
typedef void(^SendGiftBlock)(BOOL status, NSString *errorMessage);
typedef void(^MessagesListBlock)(NSArray *messagesArray, NSString *errorMessage);
typedef void(^SendMessageBlock)(BOOL status, NSString *errorMessage);
typedef void(^LocationListBlock)(NSArray *locationArray, NSString *errorMessage);
typedef void(^HotPageListBlock)(PeoplesMapping *peoplesMapping, NSString *errorMessage);
typedef void(^ActivityLineStatsBlock)(ActivityLineStatsMapping *activityLineStatsMapping, NSString *errorMessage);
typedef void(^CleanBlock)(BOOL status, NSString *errorMessage);
typedef void(^ServicesListBlock)(NSArray *servicesArray, NSString *errorMessage);
typedef void(^ServicesEnableBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^BlockUserBlock)(BOOL status, NSString *errorMessage);
typedef void(^ConfirmProfileBlock)(ResponseStatusModel *responseStatusModel, BOOL status, NSString *errorMessage);
typedef void(^RecoverProfileBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^ChangePasswordBlock)(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel);
typedef void(^ReportBlock)(BOOL status, NSString *errorMessage);
typedef void(^RequestPrivateProfileBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^ReplyRequestBlock)(BOOL status, NSString *errorMessage);
typedef void(^ProfileAvailableBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^SendStickerBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^SignOutBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^BlockedProfilesBlock)(NSArray *blockedProfiles, NSString *errorMessage);
typedef void(^UnBlockUserBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^HelpTopicsBlock)(NSArray *topicsArray, NSString *errorMessage);
typedef void(^HelpArticlesBlock)(NSArray *articlesArray, NSString *errorMessage);
typedef void(^GroupStickersBlock)(NSArray *groupStickersArray, NSString *errorMessage);
typedef void(^StickersBlock)(NSArray *stickersArray, NSString *errorMessage);
typedef void(^UserSettingsBlock)(UserSettingsMapping *userSettingsMapping, NSString *errorMessage);
typedef void(^SetUserSettingsBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^ClearBlock)(ResponseStatusModel *responseStatusModel, NSString *errorMessage);
typedef void(^UserLanguagesBlock)(NSArray *languages, NSString *errorMessage);
typedef void(^UserLanguageBlock)(BOOL success, NSString *errorMessage);
typedef void(^UserDeleteBlock)(BOOL success, NSString *errorMessage);
typedef void(^AdminSupportBlock)(NSNumber *userId, NSString *errorMessage);
typedef void(^VerifyBlock)(VerifyMapping *verifyMapping, NSString *errorMessage);
typedef void(^VerifyPhotoBlock)(BOOL success, NSString *errorMessage);

typedef void(^ForbiddenBlock)(NSString *errorMessage);
typedef void(^ChatMotivationBlock)(NSNumber *statusCode);

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

@property (strong, nonatomic) ProfileMapping *myProfileMapping;

@property (nonatomic) ForbiddenBlock forbiddenBlock;
@property (nonatomic) ChatMotivationBlock chatMotivationBlock;

// Register user
- (void)registerUserWithParams:(NSDictionary *)params withFileData:(NSData *)fileData withCompletion:(RegisterUserBlock)completion;

// Login user
- (void)loginUserWithParams:(NSDictionary *)params withCompletion:(LoginUserBlock)completion;

// Subscribe Notifications
- (void)subscribeNotificationsWithParams:(NSDictionary *)params withCompletion:(SubscribeNotificationsBlock)completion;

// Get dictionary of list
- (void)getDictionaryOfListByPath:(NSString *)path withCompletion:(DictionaryBlock)completion;

// Get Gender List
- (void)getGenderListForInterestedIn:(BOOL)forInterestedIn withCompletion:(DictionaryBlock)completion;

// Get profile
- (void)getProfileById:(NSNumber *)idProfile withCompletion:(ProfileBlock)completion;

// Get private profile
- (void)getPrivateProfileById:(NSNumber *)idProfile wirhCompletion:(PrivateProfileBlock)completion;

// Update private profile
- (void)updatePrivateProfileWithParams:(NSDictionary *)params withCompletion:(UpdatePrivateProfileBlock)completion;

// Upload photo
- (void)uploadImageToServerByData:(NSData *)fileData withPath:(NSString *)path withCompletion:(UploadPhotoBlock)completion;

// Get language list
- (void)getLanguageListWithCompletion:(LanguageListBlock)completion;

// Update profile
- (void)updateProfileWithParams:(NSDictionary *)params withCompletion:(UpdateProfileBlock)completion;

// Get interests
- (void)getInterestsWithCompletion:(InterestsBlock)completion;

// Avatar photo
- (void)setupAvatarPhotoWithParams:(NSDictionary *)params withCompletion:(AvatarPhotoBlock)completion;

// Delete photo
- (void)deletePhotoWithParams:(NSDictionary *)params withCompletion:(DeletePhotoBlock)completion;

// Move photo
- (void)movePhotoToProfileWithParams:(NSDictionary *)params andPath:(NSString *)path withCompletion:(MovePhotoBlock)completion;

// Get my gifts
- (void)getMyGiftsWithParams:(NSDictionary *)params withCompletion:(GiftsBlock)completion;

// Get contacts
- (void)getContactsWitchCompletion:(ContactsBlock)completion;

// User circles
- (void)searchDefaultWithCompletion:(SearchDefaultBlock)completion;

// Add contact
- (void)addContactToBookmarkByUserId:(NSNumber *)userId withCompletion:(ContactBlock)completion;

// Remove contact
- (void)removeContactWithParams:(NSDictionary *)params withCompletion:(ContactBlock)completion;

// Update contact
- (void)updateContactWithParams:(NSDictionary *)params withCompletion:(ContactBlock)completion;

// Get preferences
- (void)getPreferenceswithCompletion:(PreferencesBlock)completion;

// Get likes
- (void)getLikesListWithParams:(NSDictionary *)params withCompletion:(LikesListBlock)completion;

// Send Like
- (void)sendLikeWithParams:(NSDictionary *)params withCompletion:(LikesSendBlock)completion;

// Matches list
- (void)getMatchesWithParams:(NSDictionary *)params wihCompletion:(MatchesListBlock)completion;

// Get activity lines
- (void)getActivityLinesWithParams:(NSDictionary *)params withCompletion:(ActivityLinesListBlock)completion;

// Get all gifts
- (void)getAllGiftsWithType:(GiftType)giftType WithCompletion:(GiftsBlock)completion;

// Send Gift
- (void)sendGiftWithParams:(NSDictionary *)params withCompletion:(SendGiftBlock)completion;

// Search General
- (void)searchGeneralWithParams:(NSDictionary *)params withCompletion:(SearchDefaultBlock)completion;

// Search Preferences
- (void)searchPreferencesWithParams:(NSDictionary *)params withCompletion:(SearchDefaultBlock)completion;

// Get locations list
- (void)getLocationListWithCompletion:(LocationListBlock)completion;

// Get Hot Page list
- (void)getHotPageListWithCompletion:(HotPageListBlock)completion;

// Get Activity stats
- (void)getActivityLineStatsWithCompletion:(ActivityLineStatsBlock)completion;

// Get services
- (void)getServicesWithCompletion:(ServicesListBlock)completion;

// Get user services
- (void)getUserServicesWithCompletion:(ServicesListBlock)completion;

// Enable services
- (void)enableServicesByServiceId:(NSNumber *)serviceId withCompletion:(ServicesEnableBlock)completion;

// Disable services
- (void)disableServicesByServiceId:(NSNumber *)serviceId withCompletion:(ServicesEnableBlock)completion;

// Block user
- (void)blockUserByUserId:(NSNumber *)userId withCompletion:(BlockUserBlock)completion;

// Confirm profile
- (void)confirmProfileWithParams:(NSDictionary *)params withCompletion:(ConfirmProfileBlock)completion;

// Recover profile
- (void)recoverProfileWithParams:(NSDictionary *)params withCompletion:(RecoverProfileBlock)completion;

// Change password
- (void)changePasswordWithParams:(NSDictionary *)params withCompletion:(ChangePasswordBlock)completion;

// Send report
- (void)sendReportWithParams:(NSDictionary *)params withCompletion:(ReportBlock)completion;

// Request private profile
- (void)requestPrivateProfileWithParams:(NSDictionary *)params withCompletion:(RequestPrivateProfileBlock)completion;

// Reply request
- (void)replyRequestWithParams:(NSDictionary *)params withCompletin:(ReplyRequestBlock)completion;

// Profile available
- (void)checkAvailableProfileWithParams:(NSDictionary *)params withCompletion:(ProfileAvailableBlock)completion;

// Profile recover allowed
- (void)recoverAllowedProfileWithParams:(NSDictionary *)params withCompletion:(RecoverProfileBlock)completion;

// Sign Out
- (void)signOutByIsEveryWhere:(BOOL)everyWhere withCompletion:(SignOutBlock)completion;

// Blocked profiles
- (void)getBlockedProfilesWithCompletion:(BlockedProfilesBlock)completion;

// Unblock user
- (void)unblockUserByIdUser:(NSNumber *)userId withCompletion:(UnBlockUserBlock)completion;

// Help topics
- (void)getHelpTopicsWithCompletion:(HelpTopicsBlock)completion;

// Help articles
- (void)getHelpArticlesByIdTopic:(NSNumber *)idTopic withCompletion:(HelpArticlesBlock)completion;

// Group Stickers
- (void)getGroupStickersWithCompletion:(GroupStickersBlock)completion;

// Stickers
- (void)getStickersByDictionary:(DictionaryMapping *)dictionaryMapping withCompletion:(StickersBlock)completion;

// User settings
- (void)getUserSettingsWithCompletion:(UserSettingsBlock)completion;

// Set user settings
- (void)setUserSettingsWithParams:(NSDictionary *)params withCompletion:(SetUserSettingsBlock)completion;

// Clear profile data
- (void)clearProfileDataWithCompletion:(ClearBlock)completion;

// User settings verifications
- (void)userSettingsVerifications;

// User languages list
- (void)userLanguageListWithCompletion:(UserLanguagesBlock)completion;

// User language add
- (void)addUserLanguageWithParams:(NSDictionary *)params withCompletion:(UserLanguageBlock)completion;

// User language delete
- (void)deleteUserLanguageWithParams:(NSDictionary *)params withCompletion:(UserLanguageBlock)completion;

// Delete User
- (void)deleteUserWithCompletion:(UserDeleteBlock)completion;

// UnDelete User
- (void)unDeleteUserWithCompletion:(UserDeleteBlock)completion;

// Get Request Verifications
- (void)getRequestVerificationsWithCompletion:(VerifyBlock)completion;

// Verify Photo
- (void)verifyPhotoByImage:(UIImage *)image withMapping:(VerifyMapping *)verifyMapping withCompletion:(VerifyPhotoBlock)completion;

/* Chat Block */

// Get chats
- (void)getChatsListWithCompletion:(ChatsBlock)completion;

// Get Messages
- (void)getMessagesWithParams:(NSDictionary *)params witnCompletion:(MessagesListBlock)completion;

// Send message
- (void)sendMessageWithParams:(NSDictionary *)params withCompletion:(SendMessageBlock)completion;

// Send image message
- (void)sendImageMessageWithParams:(NSDictionary *)params byImageData:(NSData *)imageData withCompletion:(SendMessageBlock)completion;

// Send gift message
- (void)sendGiftMessageWithParams:(NSDictionary *)params withCompletion:(SendMessageBlock)completion;

// Send audio message
- (void)sendAudioMessageWithParams:(NSDictionary *)params byFileData:(NSData *)fileData withCompletion:(SendMessageBlock)completion;

// Clean chat
- (void)cleanChatByUserId:(NSNumber *)userId withCompletion:(CleanBlock)completion;

// Send Sticker
- (void)sendStickerWithParams:(NSDictionary *)params withCompletion:(SendStickerBlock)completion;

// Admin Chat Support
- (void)getUserAdminSupportWithCompletion:(AdminSupportBlock)completion;

/* Chat Block */

@end

