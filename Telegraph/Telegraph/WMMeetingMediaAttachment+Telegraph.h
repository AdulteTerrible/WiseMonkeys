//
//  WMMeetingMediaAttachment+Telegram.h
//  Telegraph
//
//  Created by Sébastien on 25-3-15.
//
//

#import "WMMeetingMediaAttachment.h"

#import "tl/TLMetaScheme.h"

@interface WMMeetingMediaAttachment (Telegraph)

- (id)initWithTelegraphMeetingDesc:(TLMessageMedia$messageMediaMeeting *)desc;

@end
