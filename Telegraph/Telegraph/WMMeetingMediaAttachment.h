//
//  WMMeetingMediaAttachment.h
//  Telegraph
//
//  Created by Sébastien on 24-3-15.
//
//

#import "TGMediaAttachment.h"

#define TGMeetingMediaAttachmentType 0xAC9ED06E // chosen randomly, following TGLocationMediaAttachmentType and others

typedef enum {
    WMMeetingMessageKindNone = 0,
    WMMeetingMessageKindInvitation = 1,
    WMMeetingMessageKindDateProposal = 2,
    WMMeetingMessageKindTimeProposal = 3,
    WMMeetingMessageKindLocationProposal = 4
} WMMeetingMessageKind;

@interface WMMeetingMediaAttachment : TGMediaAttachment <TGMediaAttachmentParser>

//@property (nonatomic) BOOL              isActive;
@property (nonatomic) WMMeetingMessageKind    kind;
@property (nonatomic) NSString                *descriptionString;
@property (nonatomic) BOOL                    dateIsToBeDiscussed;
@property (nonatomic) NSString                *dateString;
@property (nonatomic) BOOL                    timeIsToBeDiscussed;
@property (nonatomic) NSString                *timeString;
@property (nonatomic) BOOL                    locationIsToBeDiscussed;
@property (nonatomic) NSString                *locationString;

- (id)initWithDescription:(NSString*)text date:(NSString*)d time:(NSString*)t location:(NSString*)l;

@end
