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
    WMMeeting *_meeting;
    
    TGCollectionMenuSection *_profileSection;
    TGHeaderCollectionItem  *_profileHeader;
    TGCommentCollectionItem *_profileComment;
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
        
        //// Description
        [self setTitleText:_meeting.meetingDescription];
        
        [self _addSectionFromDictionary:_meeting.dateOptions AndTitle:@"DATE OPTIONS"];
        [self _addSectionFromDictionary:_meeting.timeOptions AndTitle:@"TIME OPTIONS"];
        [self _addSectionFromDictionary:_meeting.locationOptions AndTitle:@"LOCATION OPTIONS"];
        
        NSMutableArray *profileSectionItems = [[NSMutableArray alloc] init];
        if (_meeting.profile == WMMeetingProfileNone)
            _profileHeader = [[TGHeaderCollectionItem alloc] initWithHighlightedTitle:@"PLEASE CHOOSE YOUR PROFILE:"];
        else
            _profileHeader = [[TGHeaderCollectionItem alloc] initWithTitle:@"PROFILE"];
        [profileSectionItems addObject:_profileHeader];
        
        //TGCheckCollectionItem *checkItem = [[TGCheckCollectionItem alloc] initWithTitle:@"Please choose your profile:" action:@selector(profilePressed:)];
        //[checkItem setIsChecked:false];
        //checkItem.requiresFullSeparator = true;
        //[profileSectionItems addObject:checkItem];
        
        NSString* committedLabel = @"🙉 I'll be there in any case.";
        
        if (_meeting.dateIsToBeDiscussed || _meeting.timeIsToBeDiscussed || _meeting.locationIsToBeDiscussed) { // at least 1 parameter is to be discussed
            TGCheckCollectionItem *checkItem0 = [[TGCheckCollectionItem alloc] initWithTitle:@"🙈 I want to discuss options." action:@selector(negotiatorProfilePressed:)];
            [checkItem0 setIsChecked:(_meeting.profile == WMMeetingProfileNegotiator)];
            [profileSectionItems addObject:checkItem0];
        }
        else // no negotiation
            committedLabel = @"🙉 I'll be there!";
        
        TGCheckCollectionItem *checkItem2 = [[TGCheckCollectionItem alloc] initWithTitle:@"🙊 I'll decide later if I attend." action:@selector(independentProfilePressed:)];
        [checkItem2 setIsChecked:(_meeting.profile == WMMeetingProfileIndependent)];
        [profileSectionItems addObject:checkItem2];
        
        TGCheckCollectionItem *checkItem1 = [[TGCheckCollectionItem alloc] initWithTitle:committedLabel action:@selector(committedProfilePressed:)];
        [checkItem1 setIsChecked:(_meeting.profile == WMMeetingProfileCommitted)];
        [profileSectionItems addObject:checkItem1];
        
        TGCheckCollectionItem *checkItem3 = [[TGCheckCollectionItem alloc] initWithTitle:@"❌ I'm not available." action:@selector(notAvailableProfilePressed:)];
        [checkItem3 setIsChecked:(_meeting.profile == WMMeetingProfileNotAvailable)];
        [profileSectionItems addObject:checkItem3];
        
        _profileComment = [[TGCommentCollectionItem alloc] initWithText:@"You can change profile anytime. Your individual choice will not be communicated to the other members."];
        [profileSectionItems addObject:_profileComment];
        
        _profileSection = [[TGCollectionMenuSection alloc] initWithItems:profileSectionItems];
        UIEdgeInsets topSectionInsets = _profileSection.insets;
        topSectionInsets.top = 16.0f;
        _profileSection.insets = topSectionInsets;
        [self.menuSections addSection:_profileSection];
        
        if (_meeting.wasCreatedByLocalUser) {
            TGButtonCollectionItem *resetItem = [[TGButtonCollectionItem alloc] initWithTitle:@"Close discussion" action:@selector(closeDiscussion)];
            //resetItem.titleColor = TGDestructiveAccentColor();
            resetItem.deselectAutomatically = true;
            TGCollectionMenuSection *resetSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                     resetItem,
                                                                                                     [[TGCommentCollectionItem alloc] initWithText:@"Notify the members the discussion is about to close, and after a grace period, select the most popular options."],
                                                                                                     ]];
            [self.menuSections addSection:resetSection];
        }
    }
    return self;
}

- (void)dealloc
{
    [_actionHandle reset];
    [ActionStageInstance() removeWatcher:self];
}

#pragma mark -

- (void)closeDiscussion
{
    [_meeting reset];
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

- (void)negotiatorProfilePressed:(TGCheckCollectionItem *)checkCollectionItem
{
    NSIndexPath *indexPath = [self indexPathForItem:checkCollectionItem];
    if (indexPath != nil)
    {
        [self _selectProfileItem:checkCollectionItem];
        
        _profileComment.text = @"You can negotiate the get-together by sending and receiving options for date/time/location, and liking them.";
        
        if (_meeting.profile == WMMeetingProfileNone) {
            [_profileHeader setTitle:@"PROFILE"];
        }
        _meeting.profile = WMMeetingProfileNegotiator;
    }
}

- (void)independentProfilePressed:(TGCheckCollectionItem *)checkCollectionItem
{
    NSIndexPath *indexPath = [self indexPathForItem:checkCollectionItem];
    if (indexPath != nil)
    {
        [self _selectProfileItem:checkCollectionItem];
        
        _profileComment.text = @"You will be only notified of the get-together once date, time and location are known. You can then decide independently to attend.";
        
        if (_meeting.profile == WMMeetingProfileNone) {
            [_profileHeader setTitle:@"PROFILE"];
        }
        _meeting.profile = WMMeetingProfileIndependent;
    }
}

- (void)committedProfilePressed:(TGCheckCollectionItem *)checkCollectionItem
{
    NSIndexPath *indexPath = [self indexPathForItem:checkCollectionItem];
    if (indexPath != nil)
    {
        [self _selectProfileItem:checkCollectionItem];
        
        _profileComment.text = @"You will be only notified of the get-together once date, time and location are known. Thank you for participating unconditionnaly!";
        if (_meeting.profile == WMMeetingProfileNone) {
            [_profileHeader setTitle:@"PROFILE"];
        }
        _meeting.profile = WMMeetingProfileCommitted;
    }
}

- (void)notAvailableProfilePressed:(TGCheckCollectionItem *)checkCollectionItem
{
    NSIndexPath *indexPath = [self indexPathForItem:checkCollectionItem];
    if (indexPath != nil)
    {
        [self _selectProfileItem:checkCollectionItem];
        
        _profileComment.text = @"You will not receive any notification for this get-together. You can change profile any time.";
        if (_meeting.profile == WMMeetingProfileNone) {
            [_profileHeader setTitle:@"PROFILE"];
        }
        _meeting.profile = WMMeetingProfileNotAvailable;
    }
}

- (void)_selectProfileItem:(TGCheckCollectionItem *)checkCollectionItem
{
        for (id item in _profileSection.items)
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

-(void)_addSectionFromDictionary:(NSMutableDictionary*)dictionary AndTitle:(NSString*)title
{
    if (dictionary.count>0) {
        // sort options by likes
        NSArray *orderedKeys = [dictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return ![obj1 compare:obj2];
        }];
        
        NSMutableArray *optionsSectionItems = [[NSMutableArray alloc] init];
        [optionsSectionItems addObject:[[TGHeaderCollectionItem alloc] initWithTitle:title]];
        for(id key in orderedKeys) {
            TGCheckCollectionItem *cItem = [[TGCheckCollectionItem alloc] initWithTitle:[[NSString alloc]initWithFormat:@"%@♥︎ %@", (NSString*)[dictionary objectForKey:key], (NSString*)key] action:@selector(profilePressed:)];
            [cItem setIsChecked:false];
            [optionsSectionItems addObject:cItem];
        }
        
        TGCollectionMenuSection *optionsSection = [[TGCollectionMenuSection alloc] initWithItems:optionsSectionItems];
        
        UIEdgeInsets topSectionInsets = optionsSection.insets;
        topSectionInsets.top = 16.0f;
        optionsSection.insets = topSectionInsets;
        
        [self.menuSections addSection:optionsSection];
    }
}

@end
