
#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define RGB_MAX 255.0f
#define RGB(r, g, b) [UIColor colorWithRed:(r/RGB_MAX) \
green:(g/RGB_MAX) blue:(b/RGB_MAX) alpha:1]

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/RGB_MAX) \
green:(g/RGB_MAX) blue:(b/RGB_MAX) alpha:a]

#define RGBH(rgb) [UIColor \
colorWithRed:(((rgb >> 16) & 0xff)/RGB_MAX) \
green:(((rgb >> 8) & 0xff)/RGB_MAX) \
blue:((rgb & 0xff)/RGB_MAX) alpha:1]

#define RGBHA(argb) [UIColor \
colorWithRed:(((argb >> 16) & 0xff)/RGB_MAX) \
green:(((argb >> 8) & 0xff)/RGB_MAX) \
blue:((argb & 0xff)/RGB_MAX) \
alpha:(((argb >> 24) & 0xff)/RGB_MAX)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/RGB_MAX green:((float)((rgbValue & 0xFF00) >> 8))/RGB_MAX blue:((float)(rgbValue & 0xFF))/RGB_MAX alpha:1.0]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_X ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f)

// Fonts
#define NOTOSANSDISPLAY_REGULAR @"NotoSansDisplay-Regular"
#define NOTOSANSDISPLAY_BOLD    @"NotoSansDisplay-Bold"
#define NOTOSANSDISPLAY_MEDIUM  @"NotoSansDisplay-Medium"

// API

#define WEB_SOCKET_HOST               @"ws://api.yammydating.com:8080"
#define BASE_URL                      @"http://api.yammydating.com/api/"
#define REGISTER                      @"Profiles/Register"
#define LOGIN                         @"Profiles/SignIn"
#define SUBSCRIBE_NOTIFICATIONS       @"Profiles/SubscribeNotifications"
#define GENDER_LIST                   @"Dictionaries/GetGenderList"
#define GENDER                        @"Dictionaries/GetSexList"
#define ALCOHOL_LIST                  @"Dictionaries/GetAlcoholList"
#define BODY_TYPE_LIST                @"Dictionaries/GetBodyTypeList"
#define LIVE_WITH_LIST                @"Dictionaries/GetLiveWithList"
#define KID_LIST                      @"Dictionaries/GetKidList"
#define SMOKING_LIST                  @"Dictionaries/GetSmokingList"
#define JOB_LIST                      @"Dictionaries/GetJobList"
#define PROFILE_VIEW                  @"Profiles/View"
#define PROFILE_PRIVATE_VIEW          @"Profiles/ViewPrivate"
#define FIRST_SEX_WITH_LIST           @"Dictionaries/GetFirstSexWithList"
#define FIRST_SEX_WHEN_LIST           @"Dictionaries/GetFirstSexWhenList"
#define FIRST_SEX_WHERE_LIST          @"Dictionaries/GetFirstSexWhereList"
#define READY_TO_NEW_SEX_HORIZON_LIST @"Dictionaries/GetReadyToNewSexHorizonList"
#define HAVE_FILMED_HOME_SEX_LIST     @"Dictionaries/GetHaveFilmedHomeSexList"
#define READY_TO_FIRST_SEX_LIST       @"Dictionaries/GetReadyToFirstSexList"
#define SEX_PASSION_LIST              @"Dictionaries/GetSexPassionList"
#define SEX_FREQUENCY_LIST            @"Dictionaries/GetSexFrequencyList"
#define VIRTUAL_SEX_LIST              @"Dictionaries/GetVirtualSexList"
#define UPDATE_PROFILE_PRIVATE_VIEW   @"Profiles/UpdatePrivate"
#define UPDATE_PROFILE_VIEW           @"Profiles/Update"
#define MAIN_URL                      @"http://api.yammydating.com/"
#define RELATIONSHIP_LIST             @"Dictionaries/GetRelationshipList"
#define LANGUAGE_LIST                 @"Dictionaries/GetLanguageList"
#define TRAIT_LIST                    @"Dictionaries/GetTraitList"
#define INTEREST_LIST                 @"Dictionaries/GetInterestList"
#define AVATAR_PHOTO                  @"Profiles/SetMediaPrimaryPhoto"
#define DELETE_PHOTO                  @"Profiles/RemoveMedia"
#define MOVE_PHOTO_TO_PUBLIC          @"Profiles/MoveMediaPublic"
#define MOVE_PHOTO_TO_PRIVATE         @"Profiles/MoveMediaPrivate"
#define MY_GIFTS                      @"Gifts/List"
#define CONTACTS_LIST                 @"Contacts/List"
#define SEARCH_DEFAULT                @"Search/Default"
#define CONTACTS_ADD                  @"Contacts/Add"
#define CONTACTS_REMOVE               @"Contacts/Remove"
#define CONTACTS_UPDATE               @"Contacts/Update"
#define PRIVATE_PREFERENCES_LIST      @"Dictionaries/GetPrivatePreferenceList"
#define LIKES_LIST                    @"Likes/List"
#define LIKES_SEND                    @"Likes/Send"
#define MATCHES_LIST                  @"Matches/List"
#define CHATS_LIST                    @"Chats/List"
#define ACTIVITY_LINE_LIST            @"ActivityLine/List"
#define GIFTS_LIST                    @"Dictionaries/GetGiftList"
#define SEND_GIFT                     @"Gifts/Send"
#define CHAT_ROOM                     @"Chats/Room"
#define CHAT_SEND                     @"Chats/Send"
#define SEARCH_GENERAL                @"Search/General"
#define SEARCH_PREFERENCES            @"Search/Preferences"
#define LOCATIONS_LIST                @"Dictionaries/GetLocationList"
#define HOT_PAGE_LIST                 @"HotPage/List"
#define ACTIVITY_LINE_STATS           @"ActivityLine/Stats"
#define CHATS_CLEAN                   @"Chats/Clean"
#define USER_SERVICES_LIST            @"Services/List"
#define SERVICES_LIST                 @"Dictionaries/GetServiceList"
#define SERVICES_ENABLE               @"Services/Enable"
#define SERVICES_DISABLE              @"Services/Disable"
#define PROFILES_BLOCK                @"Profiles/Block"
#define PROFILES_REPORT               @"Profiles/Report"
#define PROFILES_CONFIRM              @"Profiles/Confirm"
#define PROFILES_RECOVER              @"Profiles/Recover"
#define PROFILES_NEW_PASSWORD         @"Profiles/RecoverChangePassword"
#define REQUEST_PRIVATE_PROFILE       @"Profiles/RequestPrivateProfile"
#define REPLY_REQUEST                 @"ActivityLine/ReplyRequest"
#define PROFILES_AVAILABLE            @"Profiles/Available"
#define PROFILES_RECOVER_ALLOWED      @"Profiles/RecoverAllowed"
#define STICKERS_LIST                 @"Dictionaries/GetStickerList"
#define SIGN_OUT                      @"Services/SignOut"
#define BLOCKED_LIST                  @"Profiles/Blocked"
#define UNBLOCK_USER                  @"Profiles/UnBlock"
#define HELP_TOPICS                   @"Help/Topics"
#define HELP_ARTICLES                 @"Help/Articles"
#define GROUP_STICKERS                @"Dictionaries/GetStickerGroupList"
#define USER_SETTINGS                 @"UserSettings/Get"
#define USER_SETTINGS_SET             @"UserSettings/Set"
#define CLEAR_DATA_PROFILE            @"Profiles/EraseData"
#define USER_SETTINGS_VERIFICATIONS   @"UserSettings/LinkedAccounts"
#define USER_LANGUAGES_LIST           @"UserLanguages/List"
#define USER_LANGUAGES_ADD            @"UserLanguages/Add"
#define USER_LANGUAGES_DELETE         @"UserLanguages/Delete"
#define USER_DELETE                   @"Profiles/Delete"
#define USER_UNDELETE                 @"Profiles/UnDelete"
#define CHAT_SUPPORT                  @"Chats/Support"
#define GET_REQUEST_VERIFICATIONS     @"Profiles/RequestVerification"
#define VERIFY_PHOTO                  @"Profiles/Verify"

// Identifiers View Controllers

// Constants
#define GOOGLE_PLACES_API_KEY @"AIzaSyBoAcJqznFKsyYmUwcC_aBiJtT2jb1vBBs"
#define YANDEX_METRICA_API_KEY @"107522c2-8d40-4798-926a-caddbe70d8ca"


// Storyboards ID

#define TAB_BAR_STORYBOARD_ID               @"TAB_BAR_STORYBOARD_ID"
#define HOME_STORYBOARD_ID                  @"HOME_STORYBOARD_ID"
#define HOT_PAGE_STORYBOARD_ID              @"HOT_PAGE_STORYBOARD_ID"
#define ACTIVITY_LINE_STORYBOARD_ID         @"ACTIVITY_LINE_STORYBOARD_ID"
#define CHAT_STORYBOARD_ID                  @"CHAT_STORYBOARD_ID"
#define PROFILE_STORYBOARD_ID               @"PROFILE_STORYBOARD_ID"
#define LOGIN_STORYBOARD_ID                 @"LOGIN_STORYBOARD_ID"
#define REGISTER_STORYBOARD_ID              @"REGISTER_STORYBOARD_ID"
#define GEO_SEARCH_STORYBOARD_ID            @"GEO_SEARCH_STORYBOARD_ID"
#define CALENDAR_REGISTER_STORYBOARD_ID     @"CALENDAR_REGISTER_STORYBOARD_ID"
#define HAVE_ACCOUNT_STORYBOARD_ID          @"HAVE_ACCOUNT_STORYBOARD_ID"
#define FINISH_REGISTER_STORYBOARD_ID       @"FINISH_REGISTER_STORYBOARD_ID"
#define CODE_REGISTER_STORYBOARD_ID         @"CODE_REGISTER_STORYBOARD_ID"
#define SPLASH_STORYBOARD_ID                @"SPLASH_STORYBOARD_ID"
#define SEARCH_STORYBOARD_ID                @"SEARCH_STORYBOARD_ID"
#define SEARCH_PRIVATE_STORYBOARD_ID        @"SEARCH_PRIVATE_STORYBOARD_ID"
#define SEARCH_PRIVATE_ROUND_STORYBOARD_ID  @"SEARCH_PRIVATE_ROUND_STORYBOARD_ID"
#define EDIT_PROFILE_STORYBOARD_ID          @"EDIT_PROFILE_STORYBOARD_ID"
#define MENU_PHOTO_STORYBOARD_ID            @"MENU_PHOTO_STORYBOARD_ID"
#define ALL_ACTIVITY_STORYBOARD_ID          @"ALL_ACTIVITY_STORYBOARD_ID"
#define LIKES_STORYBOARD_ID                 @"LIKES_STORYBOARD_ID"
#define CONCURRENCES_STORYBOARD_ID          @"CONCURRENCES_STORYBOARD_ID"
#define CONTACT_LIST_STORYBOARD_ID          @"CONTACT_LIST_STORYBOARD_ID"
#define CHAT_LIST_STORYBOARD_ID             @"CHAT_LIST_STORYBOARD_ID"
#define PROFILE_FORM_STORYBOARD_ID          @"PROFILE_FORM_STORYBOARD_ID"
#define MY_GIFTS_STORYBOARD_ID              @"MY_GIFTS_STORYBOARD_ID"
#define SERVICES_STORYBOARD_ID              @"SERVICES_STORYBOARD_ID"
#define GIFTS_STORYBOARD_ID                 @"GIFTS_STORYBOARD_ID"
#define PASSWORD_STORYBOARD_ID              @"PASSWORD_STORYBOARD_ID"
#define RECOVERY_PASSWORD_STORYBOARD_ID     @"RECOVERY_PASSWORD_STORYBOARD_ID"
#define NEW_PASSWORD_STORYBOARD_ID          @"NEW_PASSWORD_STORYBOARD_ID"
#define REPORT_STORYBOARD_ID                @"REPORT_STORYBOARD_ID"
#define LANGUAGES_STORYBOARD_ID             @"LANGUAGES_STORYBOARD_ID"
#define NEW_REGISTER_STORYBOARD_ID          @"NEW_REGISTER_STORYBOARD_ID"
#define SETTINGS_STORYBOARD_ID              @"SETTINGS_STORYBOARD_ID"
#define BLOCKED_STORYBOARD_ID               @"BLOCKED_STORYBOARD_ID"
#define ABOUT_STORYBOARD_ID                 @"ABOUT_STORYBOARD_ID"
#define HELP_STORYBOARD_ID                  @"HELP_STORYBOARD_ID"
#define ACCOUNT_STORYBOARD_ID               @"ACCOUNT_STORYBOARD_ID"
#define SETTINGS_ACCOUNT_STORYBOARD_ID      @"SETTINGS_ACCOUNT_STORYBOARD_ID"
#define DETAIL_SET_ACOUNT_STORYBOARD_ID     @"DETAIL_SET_ACOUNT_STORYBOARD_ID"
#define RIGHT_MENU_STORYBOARD_ID            @"RIGHT_MENU_STORYBOARD_ID"
#define ARTICLE_STORYBOARD_ID               @"ARTICLE_STORYBOARD_ID"
#define TUTORIAL_STORYBOARD_ID              @"TUTORIAL_STORYBOARD_ID"
#define FULL_IMAGE_STORYBOARD_ID            @"FULL_IMAGE_STORYBOARD_ID"
#define PROFILE_FORM_DETAIL_STORYBOARD_ID   @"PROFILE_FORM_DETAIL_STORYBOARD_ID"

// Segue Identifiers

#define PROFILE_CONTAINER_SEGUE             @"PROFILE_CONTAINER_SEGUE"
#define PROFILE_PUBLIC_CONTAINER_SEGUE      @"PROFILE_PUBLIC_CONTAINER_SEGUE"
#define PROFILE_PRIVATE_CONTAINER_SEGUE     @"PROFILE_PRIVATE_CONTAINER_SEGUE"
#define MY_PROFILE_PUBLIC_CONTAINER_SEGUE   @"MY_PROFILE_PUBLIC_CONTAINER_SEGUE"
#define MY_PROFILE_PRIVATE_CONTAINER_SEGUE  @"MY_PROFILE_PRIVATE_CONTAINER_SEGUE"

// Notification Center

#define UPDATE_CHAT_LIST        @"UPDATE_CHAT_LIST"
#define RECEIVE_PUSH            @"RECEIVE_PUSH"
#define UPDATE_PROFILE_MAPPING  @"UPDATE_PROFILE_MAPPING"
#define UPDATE_STATS            @"UPDATE_STATS"

// Const

static NSInteger kCenterButtonTag = 100;
static NSInteger kStatusCodeInvalidRequestProfilesRegisterPhoneAlreadyExists = 508;
static NSInteger kStatusCodeInvalidRequestProfilesRegisterEmailAlreadyExists = 503;

// Enums

typedef enum : NSUInteger {
  PhotosPublicProfileTag = 10,
  GiftsPublicProfileTag,
  VerificationPublicProfileTag,
} PublicProfileCollectionViewTag;

typedef enum : NSUInteger {
  InterestPublicProfileTableViewTag = 10,
  VerificationPublicProfileTableViewTag,
} PublicProfileTableViewTag;

typedef enum : NSUInteger {
  MyServicesPublicMyProfileTag = 10,
  GiftsPublicMyProfileTag
} PublicMyProfileCollectionViewTag;

typedef enum : NSUInteger {
  InterestPublicMyProfileTableViewTag = 10,
  VerificationPublicMyProfileTableViewTag
} PublicMyProfileTableViewTag;

typedef enum : NSUInteger {
  NameRegisterSection = 0,
  SexRegisterSection,
  BirthDayRegisterSection,
  InterestPersonRegisterSection
} RegisterTableSections;

typedef enum : NSUInteger {
  RegisterInterestMale = 1,
  RegisterInterestFemale,
  RegisterInterestLesbian,
  RegisterInterestGay,
  RegisterInterestBisexual,
} RegisterInterests;

typedef enum : NSUInteger {
  InterestPersonSearchSection = 0,
  AgeSearchSection,
  ShowSearchSection,
  LocationSearchSection
} SearchTableSections;

typedef enum : NSUInteger {
  OneStrawberryButtonTag = 10,
  TwoStrawberryButtonTag,
  ThreeStrawberryButtonTag,
  FourStrawberryButtonTag
} StrawberryButtonTag;

typedef enum : NSUInteger {
  AvatarPhotoRow = 0,
  MoveToPrivateProfileRow,
  DeletePhotoRow,
} MenuRowEnum;

typedef enum : NSUInteger {
  BumerangPublicRow = 0,
  GalleryPublicRow,
  CameraPublicRow,
} PublicMenuRow;
