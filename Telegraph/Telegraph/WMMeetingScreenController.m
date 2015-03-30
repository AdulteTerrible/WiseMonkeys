//
//  WMMeetingScreenController.h
//  Telegraph
//
//  Created by Sébastien on 29-3-15.
//
//

#import "WMMeetingScreenController.h"

#import "ActionStage.h"
#import "SGraphObjectNode.h"

#import "TGAppDelegate.h"
#import "TGTelegraph.h"

#import "TGHeaderCollectionItem.h"
#import "TGSwitchCollectionItem.h"
#import "TGVariantCollectionItem.h"
#import "TGButtonCollectionItem.h"
#import "TGCommentCollectionItem.h"

#import "TGCheckCollectionItem.h"

#import "TGActionSheet.h"

#import "WMTextCollectionItem.h"

@interface WMMeetingScreenController () //<TGAlertSoundControllerDelegate>
{
    /*TGSwitchCollectionItem *_privateAlert;
    TGSwitchCollectionItem *_privatePreview;
    TGVariantCollectionItem *_privateSound;
    
    TGSwitchCollectionItem *_groupAlert;
    TGSwitchCollectionItem *_groupPreview;
    TGVariantCollectionItem *_groupSound;
    
    TGSwitchCollectionItem *_inAppSounds;
    TGSwitchCollectionItem *_inAppVibrate;
    TGSwitchCollectionItem *_inAppPreview;
    
    NSMutableDictionary *_privateNotificationSettings;
    NSMutableDictionary *_groupNotificationSettings;
    
    bool _selectingPrivateSound;
    */
    
    // Description
    // *_meetingDescription;
    WMTextCollectionItem   *_descriptionItem;
    NSString               *_descriptionString;
    
    // Date
    TGSwitchCollectionItem *_dateIsToBeDiscussed;
    WMTextCollectionItem   *_dateItem;
    NSString               *_dateString;
    
    // Time
    TGSwitchCollectionItem *_timeIsToBeDiscussed;
    WMTextCollectionItem   *_timeItem;
    NSString               *_timeString;
    
    // Location
    TGSwitchCollectionItem *_locationIsToBeDiscussed;
    WMTextCollectionItem   *_locationItem;
    NSString               *_locationString;
    WMMeeting *_meeting;
}

@end

@implementation WMMeetingScreenController

- (id)initWithMeeting:(WMMeeting*)meeting
{
    self = [super init];
    if (self)
    {
        _meeting = meeting;
        
        _actionHandle = [[ASHandle alloc] initWithDelegate:self releaseOnMainThread:true];
        
        [self setTitleText:@"Get-together"];
        
        //// Description
        //[_descriptionItem becomeFirstResponder];
        NSMutableArray *optionsSectionItems = [[NSMutableArray alloc] init];
        [optionsSectionItems addObject:[[TGHeaderCollectionItem alloc] initWithTitle:_meeting.meetingDescription]];
        if (_meeting.dateOptions.count>0) {
            for(id key in _meeting.dateOptions) {
                id value = [_meeting.dateOptions objectForKey:key];
                TGCheckCollectionItem *cItem = [[TGCheckCollectionItem alloc] initWithTitle:[[NSString alloc]initWithFormat:@"%@♥︎ %@", (NSString*)value, (NSString*)key] action:@selector(profilePressed:)];
                [cItem setIsChecked:false];
                [optionsSectionItems addObject:cItem];
            }
        }
        if (_meeting.timeOptions.count>0) {
            for(id key in _meeting.timeOptions) {
                id value = [_meeting.timeOptions objectForKey:key];
                TGCheckCollectionItem *cItem = [[TGCheckCollectionItem alloc] initWithTitle:[[NSString alloc]initWithFormat:@"%@♥︎ %@", (NSString*)value, (NSString*)key] action:@selector(profilePressed:)];
                [cItem setIsChecked:false];
                [optionsSectionItems addObject:cItem];
            }
        }
        if (_meeting.locationOptions.count>0) {
            for(id key in _meeting.locationOptions) {
                id value = [_meeting.locationOptions objectForKey:key];
                TGCheckCollectionItem *cItem = [[TGCheckCollectionItem alloc] initWithTitle:[[NSString alloc]initWithFormat:@"%@♥︎ %@", (NSString*)value, (NSString*)key] action:@selector(profilePressed:)];
                [cItem setIsChecked:false];
                [optionsSectionItems addObject:cItem];
            }
        }
        TGCollectionMenuSection *optionsSection = [[TGCollectionMenuSection alloc] initWithItems:optionsSectionItems];
        UIEdgeInsets topSectionInsets = optionsSection.insets;
        topSectionInsets.top = 16.0f;
        optionsSection.insets = topSectionInsets;
        [self.menuSections addSection:optionsSection];
        
        NSMutableArray *profileSectionItems = [[NSMutableArray alloc] init];
        [profileSectionItems addObject:[[TGHeaderCollectionItem alloc] initWithTitle:@"PROFILE"]];
        
        TGCheckCollectionItem *checkItem = [[TGCheckCollectionItem alloc] initWithTitle:@"Please choose your profile:" action:@selector(profilePressed:)];
        [checkItem setIsChecked:false];
        checkItem.requiresFullSeparator = true;
        [profileSectionItems addObject:checkItem];
        
        TGCheckCollectionItem *checkItem0 = [[TGCheckCollectionItem alloc] initWithTitle:@"I want to discuss options" action:@selector(profilePressed:)];
        [checkItem0 setIsChecked:true];
        [profileSectionItems addObject:checkItem0];
        
        TGCheckCollectionItem *checkItem2 = [[TGCheckCollectionItem alloc] initWithTitle:@"I don't want to decide now" action:@selector(profilePressed:)];
        [checkItem2 setIsChecked:false];
        [profileSectionItems addObject:checkItem2];
        
        TGCheckCollectionItem *checkItem1 = [[TGCheckCollectionItem alloc] initWithTitle:@"I'll be there" action:@selector(profilePressed:)];
        [checkItem1 setIsChecked:false];
        [profileSectionItems addObject:checkItem1];
        

        TGCheckCollectionItem *checkItem3 = [[TGCheckCollectionItem alloc] initWithTitle:@"I'm not available" action:@selector(profilePressed:)];
        [checkItem3 setIsChecked:false];
        [profileSectionItems addObject:checkItem3];
        
        [profileSectionItems addObject:[[TGCommentCollectionItem alloc] initWithText:@"Your choice will not be communicated to the other members."]];
        
        TGCollectionMenuSection *profileSection = [[TGCollectionMenuSection alloc] initWithItems:profileSectionItems];
        profileSection.insets = topSectionInsets;
        [self.menuSections addSection:profileSection];
        
        /*
        _privateNotificationSettings = [[NSMutableDictionary alloc] initWithDictionary:@{@"muteUntil": @(0), @"soundId": @(1), @"previewText": @(true)}];
        _groupNotificationSettings = [[NSMutableDictionary alloc] initWithDictionary:@{@"muteUntil": @(0), @"soundId": @(1), @"previewText": @(true)}];
        
        
        
        _privateAlert = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.MessageNotificationsAlert") isOn:true];
        _privateAlert.interfaceHandle = _actionHandle;
        _privatePreview = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.MessageNotificationsPreview") isOn:true];
        _privatePreview.interfaceHandle = _actionHandle;
        
        NSString *currentPrivateSound = [TGAppDelegateInstance modernAlertSoundTitles][1];
        NSString *currentGroupSound = [TGAppDelegateInstance modernAlertSoundTitles][1];
        
        _privateSound = [[TGVariantCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.MessageNotificationsSound") variant:currentPrivateSound action:@selector(privateSoundPressed)];
        _privateSound.deselectAutomatically = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        TGCollectionMenuSection *messageNotificationsSection = [[TGCollectionMenuSection alloc] initWithItems:@[
            [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.MessageNotifications")],
            _privateAlert,
            _privatePreview,
            _privateSound,
            [[TGCommentCollectionItem alloc] initWithText:TGLocalized(@"Notifications.MessageNotificationsHelp")]
        ]];
        UIEdgeInsets topSectionInsets = messageNotificationsSection.insets;
        topSectionInsets.top = 32.0f;
        messageNotificationsSection.insets = topSectionInsets;
        [self.menuSections addSection:messageNotificationsSection];
        
        _groupSound = [[TGVariantCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.MessageNotificationsSound") variant:currentGroupSound action:@selector(groupSoundPressed)];
        _groupSound.deselectAutomatically = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        _groupAlert = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.GroupNotificationsAlert") isOn:true];
        _groupAlert.interfaceHandle = _actionHandle;
        _groupPreview = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.GroupNotificationsPreview") isOn:true];
        _groupPreview.interfaceHandle = _actionHandle;
        
        TGCollectionMenuSection *groupNotificationsSection = [[TGCollectionMenuSection alloc] initWithItems:@[
            [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.GroupNotifications")],
            _groupAlert,
            _groupPreview,
            _groupSound,
            [[TGCommentCollectionItem alloc] initWithText:TGLocalized(@"Notifications.GroupNotificationsHelp")]
        ]];
        [self.menuSections addSection:groupNotificationsSection];
        
        _inAppSounds = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.InAppNotificationsSounds") isOn:TGAppDelegateInstance.soundEnabled];
        _inAppSounds.interfaceHandle = _actionHandle;
        _inAppVibrate = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.InAppNotificationsVibrate") isOn:TGAppDelegateInstance.vibrationEnabled];
        _inAppVibrate.interfaceHandle = _actionHandle;
        _inAppPreview = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.InAppNotificationsPreview") isOn:TGAppDelegateInstance.bannerEnabled];
        _inAppPreview.interfaceHandle = _actionHandle;
        
        NSMutableArray *inAppNotificationsSectionItems = [[NSMutableArray alloc] init];
        
        [inAppNotificationsSectionItems addObject:[[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Notifications.InAppNotifications")]];
        [inAppNotificationsSectionItems addObject:_inAppSounds];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [inAppNotificationsSectionItems addObject:_inAppVibrate];
            [inAppNotificationsSectionItems addObject:_inAppPreview];
        }
        
        TGCollectionMenuSection *inAppNotificationsSection = [[TGCollectionMenuSection alloc] initWithItems:inAppNotificationsSectionItems];
        [self.menuSections addSection:inAppNotificationsSection];
        
        [ActionStageInstance() dispatchOnStageQueue:^
        {
            [ActionStageInstance() watchForPaths:@[
                [NSString stringWithFormat:@"/tg/peerSettings/(%d)", INT_MAX - 1],
                [NSString stringWithFormat:@"/tg/peerSettings/(%d)", INT_MAX - 2]
            ] watcher:self];
            
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/peerSettings/(%d,cached)", INT_MAX - 1] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:INT_MAX - 1] forKey:@"peerId"] watcher:self];
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/peerSettings/(%d,cached)", INT_MAX - 2] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:INT_MAX - 2] forKey:@"peerId"] watcher:self];
        }];
         */
        
        TGButtonCollectionItem *resetItem = [[TGButtonCollectionItem alloc] initWithTitle:@"Close discussion" action:@selector(resetAllNotifications)];
        //resetItem.titleColor = TGDestructiveAccentColor();
        resetItem.deselectAutomatically = true;
        TGCollectionMenuSection *resetSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                 resetItem,
                                                                                                 [[TGCommentCollectionItem alloc] initWithText:@"Notify the members the discussion is about to close, and after a grace period, select the most popular options."],
                                                                                                 ]];
        [self.menuSections addSection:resetSection];
    }
    return self;
}

- (void)dealloc
{
    [_actionHandle reset];
    [ActionStageInstance() removeWatcher:self];
}

#pragma mark -

- (void)resetAllNotifications
{
//    [[[TGActionSheet alloc] initWithTitle:TGLocalized(@"Notifications.ResetAllNotificationsHelp") actions:@[
//        [[TGActionSheetAction alloc] initWithTitle:TGLocalized(@"Notifications.Reset") action:@"reset" type:TGActionSheetActionTypeDestructive],
//        [[TGActionSheetAction alloc] initWithTitle:TGLocalized(@"Common.Cancel") action:@"cancel" type:TGActionSheetActionTypeCancel]
//    ] actionBlock:^(WMMeetingScreenController *controller, NSString *action)
//    {
//        if ([action isEqualToString:@"reset"])
//        {
//            [controller _commitResetAllNotitications];
//        }
//    } target:self] showInView:self.view];
}

- (void)_commitResetAllNotitications
{
    /*TGAppDelegateInstance.soundEnabled = true;
    TGAppDelegateInstance.vibrationEnabled = false;
    TGAppDelegateInstance.bannerEnabled = true;
    [TGAppDelegateInstance saveSettings];
    
    _privateNotificationSettings = [[NSMutableDictionary alloc] initWithDictionary:@{@"muteUntil": @(0), @"soundId": @(1), @"previewText": @(true)}];
    _groupNotificationSettings = [[NSMutableDictionary alloc] initWithDictionary:@{@"muteUntil": @(0), @"soundId": @(1), @"previewText": @(true)}];
    
    [self _updateItems:true];
    
    [ActionStageInstance() requestActor:@"/tg/resetPeerSettings" options:nil watcher:TGTelegraphInstance];
     */
}

#pragma mark -

- (void)_updateItems:(bool)animated
{
    /*
    [_privateAlert setIsOn:[[_privateNotificationSettings objectForKey:@"muteUntil"] intValue] == 0 animated:animated];
    [_privatePreview setIsOn:[[_privateNotificationSettings objectForKey:@"previewText"] boolValue] animated:animated];
    
    int privateSoundId = [[_privateNotificationSettings objectForKey:@"soundId"] intValue];
    if (privateSoundId == 1)
        privateSoundId = 100;
    
    //_privateSound.variant = [self soundNameFromId:privateSoundId];
    
    [_groupAlert setIsOn:[[_groupNotificationSettings objectForKey:@"muteUntil"] intValue] == 0 animated:animated];
    [_groupPreview setIsOn:[[_groupNotificationSettings objectForKey:@"previewText"] boolValue] animated:animated];
    
    int groupSoundId = [[_groupNotificationSettings objectForKey:@"soundId"] intValue];
    if (groupSoundId == 1)
        groupSoundId = 100;
    
    //_groupSound.variant = [self soundNameFromId:groupSoundId];
    
    [_inAppSounds setIsOn:TGAppDelegateInstance.soundEnabled animated:animated];
    [_inAppVibrate setIsOn:TGAppDelegateInstance.vibrationEnabled animated:animated];
    [_inAppPreview setIsOn:TGAppDelegateInstance.bannerEnabled animated:animated];
     */
}

#pragma mark -

- (void)actionStageActionRequested:(NSString *)action options:(id)options
{
    if ([action isEqualToString:@"switchItemChanged"])
    {
        TGSwitchCollectionItem *switchItem = options[@"item"];
        /*
        if (switchItem == _privateAlert)
        {
            int muteUntil = switchItem.isOn ? 0 : INT_MAX;
            _privateNotificationSettings[@"muteUntil"] = @(muteUntil);
            
            static int actionId = 0;
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/changePeerSettings/(%d)/(pc%d)", INT_MAX - 1, actionId++] options:@{
                @"peerId": @(INT_MAX - 1),
                @"muteUntil": @(muteUntil)
            } watcher:TGTelegraphInstance];
        }
        else if (switchItem == _privatePreview)
        {
            bool previewText = switchItem.isOn;
            _privateNotificationSettings[@"previewText"] = @(previewText);
            
            static int actionId = 0;
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/changePeerSettings/(%d)/(pc%d)", INT_MAX - 1, actionId++] options:@{
                @"peerId": @(INT_MAX - 1),
                @"previewText": @(previewText)
            } watcher:TGTelegraphInstance];
        }
        else if (switchItem == _groupAlert)
        {
            int muteUntil = switchItem.isOn ? 0 : INT_MAX;
            _groupNotificationSettings[@"muteUntil"] = @(muteUntil);

            static int actionId = 0;
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/changePeerSettings/(%d)/(pc%d)", INT_MAX - 2, actionId++] options:@{
                @"peerId": @(INT_MAX - 2),
                @"muteUntil": @(muteUntil)
            } watcher:TGTelegraphInstance];
        }
        else if (switchItem == _groupPreview)
        {
            bool previewText = switchItem.isOn;
            _groupNotificationSettings[@"previewText"] = @(previewText);

            static int actionId = 0;
            [ActionStageInstance() requestActor:[NSString stringWithFormat:@"/tg/changePeerSettings/(%d)/(pc%d)", INT_MAX - 2, actionId++] options:@{
                @"peerId": @(INT_MAX - 2),
                @"previewText": @(previewText)
            } watcher:TGTelegraphInstance];
        }
        else if (switchItem == _inAppSounds)
        {
            TGAppDelegateInstance.soundEnabled = switchItem.isOn;
            [TGAppDelegateInstance saveSettings];
        }
        else if (switchItem == _inAppVibrate)
        {
            TGAppDelegateInstance.vibrationEnabled = switchItem.isOn;
            [TGAppDelegateInstance saveSettings];
        }
        if (switchItem == _inAppPreview)
        {
            TGAppDelegateInstance.bannerEnabled = switchItem.isOn;
            [TGAppDelegateInstance saveSettings];
        }
         */
    }
}

- (void)profilePressed:(TGCheckCollectionItem *)checkCollectionItem
{
    NSIndexPath *indexPath = [self indexPathForItem:checkCollectionItem];
    if (indexPath != nil)
    {
        [self _selectItem:checkCollectionItem];
        //[self _playSoundWithId:[self soundIdFromItemIndexPath:indexPath]];
    }
}

- (void)_selectItem:(TGCheckCollectionItem *)checkCollectionItem
{
    for (int sectionIndex = 0; sectionIndex < (int)self.menuSections.sections.count-1; sectionIndex++)
    {
        for (id item in ((TGCollectionMenuSection *)self.menuSections.sections[sectionIndex]).items)
        {
            if ([item isKindOfClass:[TGCheckCollectionItem class]])
            {
                if (item == checkCollectionItem)
                    [(TGCheckCollectionItem *)item setIsChecked:true];
                else
                    [(TGCheckCollectionItem *)item setIsChecked:false];
            }
        }
    }
}

@end
