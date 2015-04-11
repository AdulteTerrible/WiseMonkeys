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
    int64_t                 _conversationId;
    NSMutableDictionary*    _localLikes;      // stores messageID of messages liked by local user
}

@end

@implementation WMMeeting

+(WMTextType)findTextType:(NSString*)text
{
    NSRange r;
    r = [text rangeOfString:@"📅"];
    if (r.location != NSNotFound) {
        return WMTextTypeDate;
    }
    else {
        r = [text rangeOfString:@"🕑"];
        if (r.location != NSNotFound) {
            return WMTextTypeTime;
        }
        else {
            r = [text rangeOfString:@"📍"];
            if (r.location != NSNotFound) {
                return WMTextTypeLocation;
            }
        }
    }
    
    return WMTextTypePlain;
}

- (id) initWithConversationId:(int64_t)conversationId
{
    if (self = [super init]) {
        _conversationId = conversationId;
        
        _localLikes = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        self.isActive = false;
        // DEBUG, to be set back to false
        self.wasCreatedByLocalUser = true;
        
        self.meetingDescription = @"";
        
        self.date = @"";
        self.dateIsToBeDiscussed = true;
        self.dateOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        self.time = @"";
        self.timeIsToBeDiscussed = true;
        self.timeOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        self.location = @"";
        self.locationIsToBeDiscussed = true;
        self.locationOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        _profile = WMMeetingProfileNone;
    }
    return self;
}

- (bool)loadFromPList
{
    self.isActive = false;
    
    if (_conversationId == 0)
        return false;
    
    NSString *filename = [[NSString alloc]initWithFormat:@"%lld.plist", _conversationId];
        
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    if (![fileManager fileExistsAtPath: path]) {
        path = [documentsDirectory stringByAppendingPathComponent:filename];
    }
        
    NSMutableDictionary *data;
    if (![fileManager fileExistsAtPath: path])
        return false;
    
    data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //TGLog(@"WMMeeting, loadFromPList: %@", data);
    
    self.isActive = [[data objectForKey:@"isActive"] boolValue];
    self.meetingDescription = [data objectForKey:@"meetingDescription"];
            
    self.date = [data objectForKey:@"date"];
    self.dateIsToBeDiscussed = [[data objectForKey:@"dateIsToBeDiscussed"] boolValue];
    self.dateOptions = [data objectForKey:@"dateOptions"];
            
    self.time = [data objectForKey:@"time"];
    self.timeIsToBeDiscussed = [[data objectForKey:@"timeIsToBeDiscussed"] boolValue];
    self.timeOptions = [data objectForKey:@"timeOptions"];
            
    self.location = [data objectForKey:@"location"];
    self.locationIsToBeDiscussed = [[data objectForKey:@"locationIsToBeDiscussed"] boolValue];
    self.locationOptions = [data objectForKey:@"locationOptions"];
            
    _profile = (WMMeetingProfile)[[data objectForKey:@"profile"] intValue];
    _localLikes = [data objectForKey:@"localLikes"];
    
    self.wasCreatedByLocalUser = [[data objectForKey:@"wasCreatedByLocalUser"] boolValue];
    
    return true;
}

-(void)setProfile:(WMMeetingProfile)profile
{
    WMMeetingProfile old = _profile;
    _profile = profile;
    
    if (self.profileChanged) {
        self.profileChanged(old, _profile);
    }
}

-(void)saveAsPList
{
    if (_conversationId == 0)
        return;
    
    if (!_isActive)
        return;
    
    NSString *filename = [[NSString alloc]initWithFormat:@"%lld.plist", _conversationId];
    
    //Get the documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        path = [documentsDirectory stringByAppendingPathComponent:filename];
    }
    
    NSMutableDictionary *data;
    if ([fileManager fileExistsAtPath: path])
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    else // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] initWithCapacity:13];
    
    [data setObject:[NSNumber numberWithBool:self.isActive] forKey:@"isActive"];
    [data setObject:self.meetingDescription forKey:@"meetingDescription"];
    
    [data setObject:self.date forKey:@"date"];
    [data setObject:[NSNumber numberWithBool:self.dateIsToBeDiscussed] forKey:@"dateIsToBeDiscussed"];
    [data setObject:self.dateOptions forKey:@"dateOptions"];
    
    [data setObject:self.time forKey:@"time"];
    [data setObject:[NSNumber numberWithBool:self.timeIsToBeDiscussed] forKey:@"timeIsToBeDiscussed"];
    [data setObject:self.timeOptions forKey:@"timeOptions"];
    
    [data setObject:self.location forKey:@"location"];
    [data setObject:[NSNumber numberWithBool:self.locationIsToBeDiscussed] forKey:@"locationIsToBeDiscussed"];
    [data setObject:self.locationOptions forKey:@"locationOptions"];
    
    [data setObject:_localLikes forKey:@"localLikes"];
    [data setObject:[NSNumber numberWithBool:self.wasCreatedByLocalUser] forKey:@"wasCreatedByLocalUser"];
    //TGLog(@"WMMeeting, about to saveAsPList: %@", data);
    
    [data setObject:[NSNumber numberWithInt:_profile] forKey:@"profile"];
    
    //To insert the data into the plist
    if (![data writeToFile:path atomically:YES])
        TGLog(@"Couldn't save meeting data in pList");
}

-(void)reset
{
    // reset values
    self.isActive = false;
    self.wasCreatedByLocalUser = false;
    
    _localLikes = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.meetingDescription = @"";
    
    self.date = @"";
    self.dateIsToBeDiscussed = true;
    self.dateOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.time = @"";
    self.timeIsToBeDiscussed = true;
    self.timeOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.location = @"";
    self.locationIsToBeDiscussed = true;
    self.locationOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    _profile = WMMeetingProfileNone;
    
    // delete pList
    NSString *filename = [[NSString alloc]initWithFormat:@"%lld.plist", _conversationId];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        //TODO: Handle/Log error
    }
}

-(void)updateLikesFromIncomingMessage:(NSString*)text WithLike:(bool)like
{
    WMTextType type = [WMMeeting findTextType:text];
    
    switch (type) {
        case WMTextTypeDate: {
            NSString* string = (NSString*)[_dateOptions objectForKey:text];
            if (string == nil)
                [_dateOptions setObject:@"1" forKey:text];
            else {
                int i = [string intValue];
                [_dateOptions setObject:[NSString stringWithFormat:@"%d",like?++i:--i] forKey:text];
            }
            break;
        }
        case WMTextTypeTime: {
            NSString* string = (NSString*)[_timeOptions objectForKey:text];
            if (string == nil)
                [_timeOptions setObject:@"1" forKey:text];
            else {
                int i = [string intValue];
                [_timeOptions setObject:[NSString stringWithFormat:@"%d",like?++i:--i] forKey:text];
            }
            break;
        }
        case WMTextTypeLocation: {
            NSString* string = (NSString*)[_locationOptions objectForKey:text];
            if (string == nil)
                [_locationOptions setObject:@"1" forKey:text];
            else {
                int i = [string intValue];
                [_locationOptions setObject:[NSString stringWithFormat:@"%d",like?++i:--i] forKey:text];
            }
            break;
        }
        default:
            //NSAssert(false, @"Shouldn't reach this case");
            break;
    }
}

-(void)updateLikesFromLocalInteractionWithMessage:(NSString*)text ofId:(int32_t)mid AndLike:(bool)like
{
    [_localLikes setObject:[NSNumber numberWithBool:like] forKey:[[NSString alloc] initWithFormat:@"%d", mid]]; // to be able to save it in a pList, keys MUST be NSString
    
    [self updateLikesFromIncomingMessage:text WithLike:like]; // local likes should be accounted for in total sum
}

-(bool)findLikeStatusOfMessageWithId:(int32_t)mid
{
    id object = [_localLikes objectForKey:[[NSString alloc] initWithFormat:@"%d", mid]];
    
    if (object == nil)
        return false;
    
    return [object boolValue];
}

-(bool)messagesReceivedLikes
{
    if (_localLikes == nil)
        return false;
    
    return (_localLikes.count > 0);
}

-(void)dealloc {
    TGLog(@"Deallocating meeting!");
}

@end
