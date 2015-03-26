//
//  WMMeetingMediaAttachment.m
//  Telegraph
//
//  Created by Sébastien on 24-3-15.
//
//

#import "WMMeetingMediaAttachment.h"

@implementation WMMeetingMediaAttachment

@synthesize kind = _kind;
@synthesize descriptionString = _descriptionString;
@synthesize dateIsToBeDiscussed = _dateIsToBeDiscussed;
@synthesize dateString = _dateString;
@synthesize timeIsToBeDiscussed = _timeIsToBeDiscussed;
@synthesize timeString = _timeString;
@synthesize locationIsToBeDiscussed = _locationIsToBeDiscussed;
@synthesize locationString = _locationString;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        _kind = WMMeetingMessageKindNone;
    }
    return self;
}

- (id)initWithDescription:(NSString*)text date:(NSString*)d time:(NSString*)t location:(NSString*)l
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        _kind = WMMeetingMessageKindInvitation;
        _descriptionString = text;
        _dateIsToBeDiscussed = ([d isEqual:[NSNull null]]);
        _dateString = d;
        _timeIsToBeDiscussed = ([t isEqual:[NSNull null]]);
        _timeString = t;
        _locationIsToBeDiscussed = ([l isEqual:[NSNull null]]);
        _locationString = l;
    }
    return self;
}

- (id)initWithDate:(NSString*)d
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        _kind = WMMeetingMessageKindDateProposal;
        _dateString = d;
    }
    return self;
}

- (id)initWithTime:(NSString*)t
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        _kind = WMMeetingMessageKindTimeProposal;
        _timeString = t;
    }
    return self;
}


- (id)initWithLocation:(NSString*)l
{
    self = [super init];
    if (self != nil)
    {
        self.type = TGMeetingMediaAttachmentType;
        _kind = WMMeetingMessageKindLocationProposal;
        _locationString = l;
    }
    return self;
}

- (void)serialize:(NSMutableData *)data
{
    int dataLengthPtr = data.length;
    int zero = 0;
    [data appendBytes:&zero length:4];
    
    int kind = _kind;
    [data appendBytes:&kind length:4];
    
    switch (_kind) {
        case WMMeetingMessageKindInvitation: {
            NSData *descriptionData = [_descriptionString dataUsingEncoding:NSUTF8StringEncoding];
            int length = descriptionData.length;
            [data appendBytes:&length length:4];
            [data appendData:descriptionData];
            
            [data appendBytes:&_dateIsToBeDiscussed length:1];
            [data appendBytes:&_timeIsToBeDiscussed length:1];
            [data appendBytes:&_locationIsToBeDiscussed length:1];
            
            if (!_dateIsToBeDiscussed) {
                NSData *dateData = [_dateString dataUsingEncoding:NSUTF8StringEncoding];
                length = dateData.length;
                [data appendBytes:&length length:4];
                [data appendData:dateData];
            }
            
            if (!_timeIsToBeDiscussed) {
                NSData *timeData = [_timeString dataUsingEncoding:NSUTF8StringEncoding];
                length = timeData.length;
                [data appendBytes:&length length:4];
                [data appendData:timeData];
            }
            
            if (!_locationIsToBeDiscussed) {
                NSData *locationData = [_locationString dataUsingEncoding:NSUTF8StringEncoding];
                length = locationData.length;
                [data appendBytes:&length length:4];
                [data appendData:locationData];
            }
            
            break;
        }
        case WMMeetingMessageKindDateProposal:
            break;
        case WMMeetingMessageKindTimeProposal:
            break;
        case WMMeetingMessageKindLocationProposal:
            break;
        default:
            break;
    }
    
    int dataLength = data.length - dataLengthPtr - 4;
    [data replaceBytesInRange:NSMakeRange(dataLengthPtr, 4) withBytes:&dataLength];
}

- (TGMediaAttachment *)parseMediaAttachment:(NSInputStream *)is
{
    int dataLength = 0;
    [is read:(uint8_t *)&dataLength maxLength:4];
    
    WMMeetingMediaAttachment *meetingAttachment = [[WMMeetingMediaAttachment alloc] init];
    
    int kind = 0;
    [is read:(uint8_t *)&kind maxLength:4];
    meetingAttachment.kind = (WMMeetingMessageKind)kind;
    
    switch (meetingAttachment.kind) {
        case WMMeetingMessageKindInvitation: {
            
            int length = 0;
            [is read:(uint8_t *)&length maxLength:4];
            uint8_t *descBytes = malloc(length);
            [is read:descBytes maxLength:length];
            meetingAttachment.descriptionString = [[NSString alloc] initWithBytesNoCopy:descBytes length:length encoding:NSUTF8StringEncoding freeWhenDone:true];
            
            int dateIsToBeDiscussed = 0;
            [is read:(uint8_t *)&dateIsToBeDiscussed maxLength:1];
            meetingAttachment.dateIsToBeDiscussed = (BOOL)dateIsToBeDiscussed;
            
            int timeIsToBeDiscussed = 0;
            [is read:(uint8_t *)&timeIsToBeDiscussed maxLength:1];
            meetingAttachment.timeIsToBeDiscussed = (BOOL)timeIsToBeDiscussed;
            
            int locationIsToBeDiscussed = 0;
            [is read:(uint8_t *)&locationIsToBeDiscussed maxLength:1];
            meetingAttachment.locationIsToBeDiscussed = (BOOL)locationIsToBeDiscussed;
            
            if (dateIsToBeDiscussed == 0) {
                length = 0;
                [is read:(uint8_t *)&length maxLength:4];
                uint8_t *dateBytes = malloc(length);
                [is read:dateBytes maxLength:length];
                meetingAttachment.dateString = [[NSString alloc] initWithBytesNoCopy:dateBytes length:length encoding:NSUTF8StringEncoding freeWhenDone:true];
            }
            
            if (timeIsToBeDiscussed == 0) {
                length = 0;
                [is read:(uint8_t *)&length maxLength:4];
                uint8_t *timeBytes = malloc(length);
                [is read:timeBytes maxLength:length];
                meetingAttachment.timeString = [[NSString alloc] initWithBytesNoCopy:timeBytes length:length encoding:NSUTF8StringEncoding freeWhenDone:true];
            }
            
            if (locationIsToBeDiscussed == 0) {
                length = 0;
                [is read:(uint8_t *)&length maxLength:4];
                uint8_t *locationBytes = malloc(length);
                [is read:locationBytes maxLength:length];
                meetingAttachment.locationString = [[NSString alloc] initWithBytesNoCopy:locationBytes length:length encoding:NSUTF8StringEncoding freeWhenDone:true];
            }
            break;
        }
        default:
            break;
    }
    
    return meetingAttachment;
}

@end
