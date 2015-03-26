//
//  WMPreparedMeetingMessage.h
//  Telegraph
//
//  Created by Sébastien on 24-3-15.
//
//

#import "TGPreparedMessage.h"
#import "WMMeetingMediaAttachment.h"

@interface WMPreparedMeetingMessage : TGPreparedMessage

@property (nonatomic) WMMeetingMessageKind    kind;
@property (nonatomic) NSString                *descriptionString;
@property (nonatomic) NSString                *dateString;
@property (nonatomic) NSString                *timeString;
@property (nonatomic) NSString                *locationString;

- (instancetype)initWithDescription:(NSString*)text date:(NSString*)d time:(NSString*)t location:(NSString*)l;

@end
