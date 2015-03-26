#import "WMMeetingMediaAttachment+Telegraph.h"

@implementation WMMeetingMediaAttachment (Telegraph)

- (id)initWithTelegraphMeetingDesc:(TLMessageMedia$messageMediaMeeting *)desc;
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        
        self.descriptionString = desc.meetingDescription;
        self.dateString = desc.date;
        self.timeString = desc.time;
        self.locationString = desc.location;
    }
    return self;
}

@end
