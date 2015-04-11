//
//  WMMeeting.h
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    WMMeetingProfileNone,
    WMMeetingProfileNegotiator,
    WMMeetingProfileIndependent,
    WMMeetingProfileCommitted,
    WMMeetingProfileNotAvailable
} WMMeetingProfile;

typedef enum {
    WMTextTypePlain =0,
    WMTextTypeDate =1,
    WMTextTypeTime =2,
    WMTextTypeLocation =4
} WMTextType;

@interface WMMeeting : NSObject

+(WMTextType)findTextType:(NSString*)text;

@property (nonatomic, copy) void (^profileChanged)(WMMeetingProfile oldProfile, WMMeetingProfile newProfile);

@property (nonatomic) BOOL                          isActive;
@property (nonatomic) BOOL                          wasCreatedByLocalUser;

@property (nonatomic, strong) NSString              *meetingDescription;

@property (nonatomic) BOOL                          dateIsToBeDiscussed;
@property (nonatomic, strong) NSString              *date;
@property (nonatomic, strong) NSMutableDictionary   *dateOptions;

@property (nonatomic) BOOL                          timeIsToBeDiscussed;
@property (nonatomic, strong) NSString              *time;
@property (nonatomic, strong) NSMutableDictionary   *timeOptions;

@property (nonatomic) BOOL                          locationIsToBeDiscussed;
@property (nonatomic, strong) NSString              *location;
@property (nonatomic, strong) NSMutableDictionary   *locationOptions;

@property (nonatomic) WMMeetingProfile              profile;

- (id)initWithConversationId:(int64_t)conversationId;
- (bool)loadFromPList;
- (void)saveAsPList;
- (void)reset;

- (void)updateLikesFromIncomingMessage:(NSString*)text WithLike:(bool)like;
- (void)updateLikesFromLocalInteractionWithMessage:(NSString*)text ofId:(int32_t)mid AndLike:(bool)like;
- (bool)messagesReceivedLikes;
- (bool)findLikeStatusOfMessageWithId:(int32_t)mid;


@end
