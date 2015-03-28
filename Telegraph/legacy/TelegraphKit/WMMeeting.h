//
//  WMMeeting.h
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import <Foundation/Foundation.h>

@interface WMMeeting : NSObject

//@property (nonatomic) int uid;
@property (nonatomic) BOOL              isActive;
@property (nonatomic, strong) NSString *meetingDescription;
@property (nonatomic) BOOL              dateIsToBeDiscussed;
@property (nonatomic, strong) NSString  *date;
@property (nonatomic) BOOL              timeIsToBeDiscussed;
@property (nonatomic, strong) NSString  *time;
@property (nonatomic) BOOL              locationIsToBeDiscussed;
@property (nonatomic, strong) NSString *location;

//@property (nonatomic, strong) NSDictionary *customProperties;

//- (id)copyWithZone:(NSZone *)zone;
//- (bool)isEqualToMeeting:(WMMeeting *)anotherMeeting;

@end
