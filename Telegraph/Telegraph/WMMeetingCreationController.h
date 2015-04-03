//
//  WMMeetingCreationController.h
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

//#import "TGViewController.h"
#import "TGCollectionMenuController.h"

#import "ActionStage.h"
#import "ASWatcher.h"

//#import "TGUser.h"

@interface WMMeetingCreationController : TGCollectionMenuController <ASWatcher> //TGViewController <ASWatcher>

@property (nonatomic, strong) ASHandle *watcher;
@property (nonatomic, strong) ASHandle *actionHandle;

@property (nonatomic, strong) id message;

@property (nonatomic, strong) id activityHolder;

- (id)init;

@end
