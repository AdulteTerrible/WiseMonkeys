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
        self.locationOptions = [[NSMutableDictionary alloc] init];
        
        self.profile = WMMeetingProfileNone;
    }
    return self;
}

@end
