//
//  WMMeetingScreenController.h
//  Telegraph
//
//  Created by Sébastien on 29-3-15.
//
//

#import "TGCollectionMenuController.h"

#import "ASWatcher.h"

#import "WMMeeting.h"

typedef enum {
    WMMeetingProfileNegotiator,
    WMMeetingProfileIndependent,
    WMMeetingProfileCommitted,
    WMMeetingProfileNotAvailable
} WMMeetingProfile;

@interface WMMeetingScreenController : TGCollectionMenuController <ASWatcher>

@property (nonatomic, strong) ASHandle *actionHandle;

- (id)initWithMeeting:(WMMeeting*)meeting;

@end
