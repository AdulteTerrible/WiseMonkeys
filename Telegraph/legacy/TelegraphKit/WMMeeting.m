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
//    bool _contactIdInitialized;
//    bool _formattedPhoneInitialized;
//    
//    TG_SYNCHRONIZED_DEFINE(_cachedValues);
}

@end

@implementation WMMeeting

- (id)copyWithZone:(NSZone *)__unused zone
{
    WMMeeting *meeting = [[WMMeeting alloc] init];
    
    meeting.uid = _uid;
    meeting.isActive = _isActive;
    meeting.meetingDescription = _meetingDescription;
    meeting.dateIsToBeDiscussed = _dateIsToBeDiscussed;
    meeting.startDate = _startDate;
    meeting.timeIsToBeDiscussed = _timeIsToBeDiscussed;
    meeting.startTime = _startTime;
    meeting.locationIsToBeDiscussed = _locationIsToBeDiscussed;
    meeting.location = _location;
    //meeting.photoUrlSmall = _photoUrlSmall;
    //meeting.photoUrlMedium = _photoUrlMedium;
    //meeting.photoUrlBig = _photoUrlBig;
    
    meeting.customProperties = _customProperties;
    
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
        ((anotherMeeting.startDate == nil && _startDate == nil) || [anotherMeeting.startDate isEqualToDate:_startDate]) &&
        anotherMeeting.timeIsToBeDiscussed == _timeIsToBeDiscussed &&
        ((anotherMeeting.startTime == nil && _startTime == nil) || [anotherMeeting.startTime isEqualToDate:_startTime]) &&
        anotherMeeting.locationIsToBeDiscussed == _locationIsToBeDiscussed &&
        ((anotherMeeting.location == nil && _location == nil) || [anotherMeeting.location isEqualToString:_location])
//        &&
//        ((anotherMeeting.photoUrlSmall == nil && _photoUrlSmall == nil) || [anotherMeeting.photoUrlSmall isEqualToString:_photoUrlSmall]) &&
//        ((anotherMeeting.photoUrlMedium == nil && _photoUrlMedium == nil) || [anotherMeeting.photoUrlMedium isEqualToString:_photoUrlMedium]) &&
//        ((anotherMeeting.photoUrlBig == nil && _photoUrlBig == nil) || [anotherMeeting.photoUrlBig isEqualToString:_photoUrlBig])
        )
    {
        return true;
    }
    return false;
}

@end
