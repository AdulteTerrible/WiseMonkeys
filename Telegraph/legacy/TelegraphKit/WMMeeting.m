//
//  WMMeeting.m
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import <Foundation/Foundation.h>

#import "WMMeeting.h"

#import "TGDatabase.h"

@interface WMMeeting ()
{
}

@end

@implementation WMMeeting

- (id) init
{
    if (self = [super init]) {
        self.meetingDescription = @"";
        
        self.date = @"";
        self.dateIsToBeDiscussed = true;
        self.dateOptions = [[NSMutableDictionary alloc] init];
        
        self.time = @"";
        self.timeIsToBeDiscussed = true;
        self.timeOptions = [[NSMutableDictionary alloc] init];
        
        self.location = @"";
        self.locationIsToBeDiscussed = true;
        self.timeOptions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
- (id)copyWithZone:(NSZone *)__unused zone
{
    WMMeeting *meeting = [[WMMeeting alloc] init];
    
    meeting.uid = _uid;
    meeting.isActive = _isActive;
    meeting.meetingDescription = _meetingDescription;
    meeting.dateIsToBeDiscussed = _dateIsToBeDiscussed;
    meeting.date = _date;
    meeting.timeIsToBeDiscussed = _timeIsToBeDiscussed;
    meeting.time = _time;
    meeting.locationIsToBeDiscussed = _locationIsToBeDiscussed;
    meeting.location = _location;
    
    return meeting;
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[WMMeeting class]] && [self isEqualToMeeting:object];
}

- (bool)isEqualToMeeting:(WMMeeting *)anotherMeeting
{
    if (anotherMeeting.uid == _uid &&
        anotherMeeting.isActive == _isActive &&
        ((anotherMeeting.meetingDescription == nil && _meetingDescription == nil) || [anotherMeeting.meetingDescription isEqualToString:_meetingDescription]) &&
        anotherMeeting.dateIsToBeDiscussed == _dateIsToBeDiscussed &&
        ((anotherMeeting.date == nil && _date == nil) || [anotherMeeting.date isEqualToString:_date]) &&
        anotherMeeting.timeIsToBeDiscussed == _timeIsToBeDiscussed &&
        ((anotherMeeting.time == nil && _time == nil) || [anotherMeeting.time isEqualToString:_time]) &&
        anotherMeeting.locationIsToBeDiscussed == _locationIsToBeDiscussed &&
        ((anotherMeeting.location == nil && _location == nil) || [anotherMeeting.location isEqualToString:_location]))
    {
        return true;
    }
    return false;
}
*/
@end
