/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGModernConversationCompanion.h"

#import "WMMeeting.h"

@interface TGGenericModernConversationCompanion : TGModernConversationCompanion
{
    int64_t _conversationId;
    
    bool _everyMessageNeedsAuthor;
    
    WMMeeting *_meeting;
}

- (instancetype)initWithConversationId:(int64_t)conversationId mayHaveUnreadMessages:(bool)mayHaveUnreadMessages;

- (void)setOthersUnreadCount:(int)unreadCount;
- (void)setPreferredInitialMessagePositioning:(int32_t)messageId;
- (void)setInitialMessagePayloadWithForwardMessages:(NSArray *)initialForwardMessagePayload sendMessages:(NSArray *)initialSendMessagePayload sendFiles:(NSArray *)initialSendFilePayload;

- (int64_t)conversationId;
- (bool)_shouldCacheRemoteAssetUris;
- (bool)_shouldDisplayProcessUnreadCount;
+ (CGSize)preferredInlineThumbnailSize;
- (int)messageLifetime;
- (NSUInteger)layer;
- (void)setLayer:(NSUInteger)layer;

- (NSString *)_conversationIdPathComponent;
- (NSString *)_sendMessagePathForMessageId:(int32_t)mid;
- (NSString *)_sendMessagePathPrefix;
- (NSDictionary *)_optionsForMessageActions;
- (bool)_messagesNeedRandomId;

- (void)standaloneForwardMessages:(NSArray *)messages;
- (void)standaloneSendMessages:(NSArray *)messages;
- (void)standaloneSendFiles:(NSArray *)files;
- (void)shareVCard;

- (void)controllerWantsToSendMeetingWithDescription:(NSString*)text date:(NSString*)d time:(NSString*)t location:(NSString*)l;
- (void)loadControllerMeetingTitlePanel;
- (void)controllerWantsToChangeMeetingProfileFrom:(WMMeetingProfile)oldProfile To:(WMMeetingProfile)newProfile;
- (void)controllerWantsToChangeLikeTo:(bool)like ForMessageId:(int32_t)mid AndText:(NSString*)text;

@end
