//
//  WMPreparedMeetingMessage.m
//  Telegraph
//
//  Created by Sébastien on 24-3-15.
//
//

#import "WMPreparedMeetingMessage.h"

#import "TGMessage.h"

@implementation WMPreparedMeetingMessage

- (instancetype)initWithDescription:(NSString*)text date:(NSString*)d time:(NSString*)t location:(NSString*)l
{
    self = [super init];
    if (self != nil)
    {
        _kind = WMMeetingMessageKindInvitation;
        _descriptionString = text;
        //_dateIsToBeDiscussed = (d == nil);
        _dateString = d;
        //_timeIsToBeDiscussed = (t == nil);
        _timeString = t;
        //_locationIsToBeDiscussed = (l == nil);
        _locationString = l;
    }
    return self;
}
- (TGMessage *)message
{
    TGMessage *message = [[TGMessage alloc] init];
    message.mid = self.mid;
    message.date = self.date;
    message.isBroadcast = self.isBroadcast;
    message.messageLifetime = self.messageLifetime;
    
    WMMeetingMediaAttachment *meetingAttachment = [[WMMeetingMediaAttachment alloc] initWithDescription:_descriptionString date:_dateString time:_timeString location:_locationString];
    message.mediaAttachments = @[meetingAttachment];
    
    return message;
}

@end
