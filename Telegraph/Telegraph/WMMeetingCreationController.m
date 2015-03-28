//
//  WMMeetingCreationController.m
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import "WMMeetingCreationController.h"

#import "ActionStage.h"
#import "SGraphObjectNode.h"

#import "TGAppDelegate.h"
#import "TGTelegraph.h"

#import "TGHeaderCollectionItem.h"
#import "TGSwitchCollectionItem.h"
#import "TGVariantCollectionItem.h"
#import "TGButtonCollectionItem.h"
#import "TGCommentCollectionItem.h"
#import "WMTextCollectionItem.h"

#import "TGUsernameController.h"

#import "TGActionSheet.h"

#import "TGAlertSoundController.h"

#pragma mark -

@interface WMMeetingCreationController () <TGAlertSoundControllerDelegate>
{
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
}

//@property (nonatomic, strong) TGUser *user;

@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation WMMeetingCreationController

- (id)init
{
    //self = [super initWithNibName:nil bundle:nil];
    self = [super init];
    if (self)
    {
        _actionHandle = [[ASHandle alloc] initWithDelegate:self releaseOnMainThread:true];
        
        [self setTitleText:TGLocalized(@"Meeting.Title")];
        [self setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:TGLocalized(@"Common.Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)]];
        [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:TGLocalized(@"Meeting.Send") style:UIBarButtonItemStyleDone target:self action:@selector(sendButtonPressed)]];
        
        self.navigationItem.rightBarButtonItem.enabled = false;
        
        //// Description
        _descriptionItem = [[WMTextCollectionItem alloc] init];
        __weak WMMeetingCreationController *weakSelf = self;
        // creating the callback to enable the "send" button
        _descriptionItem.textChanged = ^(NSString *text)
        {
            __strong WMMeetingCreationController *strongSelf = weakSelf;
            if (strongSelf != nil)
            {
                strongSelf->_descriptionString = text;
                strongSelf.navigationItem.rightBarButtonItem.enabled = (_descriptionString.length != 0);
            }
        };
        //[_descriptionItem becomeFirstResponder];
        TGCollectionMenuSection *descriptionSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                       [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.Description")],
                                                                                                       _descriptionItem
                                                                                                       ]];
        UIEdgeInsets topSectionInsets = descriptionSection.insets;
        topSectionInsets.top = 32.0f;
        descriptionSection.insets = topSectionInsets;
        [self.menuSections addSection:descriptionSection];

        //// Date
        _dateIsToBeDiscussed = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.isToBeDiscussed") isOn:true];
        _dateIsToBeDiscussed.interfaceHandle = _actionHandle;
        _dateItem = [[WMTextCollectionItem alloc] init];
        _dateItem.hidden = true;
        _dateItem.alpha = 0.0f;
        TGCollectionMenuSection *dateSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.Date")],
                                                                                                _dateIsToBeDiscussed,
                                                                                                _dateItem
                                                                                                //,[[TGCommentCollectionItem alloc] initWithText:TGLocalized(@"Notifications.MessageNotificationsHelp")]
                                                                                                ]];
        [self.menuSections addSection:dateSection];
        
        //// Time
        _timeItem = [[WMTextCollectionItem alloc] init];
        _timeItem.hidden = true;
        _timeItem.alpha = 0.0f;
        _timeIsToBeDiscussed = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.isToBeDiscussed") isOn:true];
        _timeIsToBeDiscussed.interfaceHandle = _actionHandle;
        
        TGCollectionMenuSection *timeSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.Time")],
                                                                                                _timeIsToBeDiscussed,
                                                                                                _timeItem
                                                                                                //,[[TGCommentCollectionItem alloc] initWithText:TGLocalized(@"Notifications.MessageNotificationsHelp")]
                                                                                                ]];
        //timeSection.insets = topSectionInsets;
        [self.menuSections addSection:timeSection];
        
        //// Location
        _locationIsToBeDiscussed = [[TGSwitchCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.isToBeDiscussed") isOn:true];
        _locationIsToBeDiscussed.interfaceHandle = _actionHandle;
        _locationItem = [[WMTextCollectionItem alloc] init];
        _locationItem.hidden = true;
        _locationItem.alpha = 0.0f;
        TGCollectionMenuSection *locationSection = [[TGCollectionMenuSection alloc] initWithItems:@[
                                                                                                [[TGHeaderCollectionItem alloc] initWithTitle:TGLocalized(@"Meeting.Location")],
                                                                                                _locationIsToBeDiscussed,
                                                                                                _locationItem,
                                                                                                //,[[TGCommentCollectionItem alloc] initWithText:TGLocalized(@"Notifications.MessageNotificationsHelp")]
                                                                                                ]];
        //locationSection.insets = topSectionInsets;
        [self.menuSections addSection:locationSection];
    }
    return self;
}

- (void)dealloc
{
    [_actionHandle reset];
    [ActionStageInstance() removeWatcher:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // setting the label and default texts before displaying the view
    // (pretty ugly to do it here, but if these methods are called in init, they are *not* executed)
    [_descriptionItem setPlaceholder:TGLocalized(@"ChangeDescription.DescriptionPlaceholder")];
    //[_descriptionItem becomeFirstResponder];
    
    [_dateItem setPlaceholder:TGLocalized(@"ChangeDate.DatePlaceholder")];
    //[_dateItem becomeFirstResponder];
    
    [_timeItem setPlaceholder:TGLocalized(@"ChangeTime.TimePlaceholder")];
    //[_timeItem becomeFirstResponder];

    [_locationItem setPlaceholder:TGLocalized(@"ChangeLocation.LocationPlaceholder")];
    //[_locationItem becomeFirstResponder];
    
    [self.collectionView layoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    //[_descriptionItem becomeFirstResponder];
    //[_dateItem becomeFirstResponder];
    //[_timeItem becomeFirstResponder];
    //[_locationItem becomeFirstResponder];
    
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([self respondsToSelector:@selector(presentedViewController)])
    {
        if ([self presentedViewController] != nil)
            return false;
    }
    else
    {
        if ([self modalViewController] != nil)
            return false;
    }
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - Actions


- (void)dismissButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)cancelButtonPressed
{
    id<ASWatcher> watcherDelegate = _watcher == nil ? nil : _watcher.delegate;
    if (watcherDelegate != nil && [watcherDelegate respondsToSelector:@selector(actionStageActionRequested:options:)])
    {
        [watcherDelegate actionStageActionRequested:@"meetingCreationViewFinished" options:nil];
    }
}

- (void)sendButtonPressed
{
    id<ASWatcher> watcherDelegate = _watcher == nil ? nil : _watcher.delegate;
    if (watcherDelegate != nil && [watcherDelegate respondsToSelector:@selector(actionStageActionRequested:options:)])
    {
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        // description
        [options setObject:_descriptionString forKey:@"description"];
        
        // date
        if ([_dateIsToBeDiscussed isOn])
            [options setObject:@"" forKey:@"date"];
        else
            [options setObject:[_dateItem text] forKey:@"date"];

        // time
        if ([_timeIsToBeDiscussed isOn])
            [options setObject:@"" forKey:@"time"];
        else
            [options setObject:[_timeItem text] forKey:@"time"];
        
        // location
        if ([_locationIsToBeDiscussed isOn])
            [options setObject:@"" forKey:@"location"];
        else
            [options setObject:[_locationItem text] forKey:@"location"];
        
         //TGLog(@"Meeting creation: sendButtonPressed with: %@", options);
        
        [watcherDelegate actionStageActionRequested:@"meetingCreationViewFinished" options:options];
    }
}

#pragma mark -

- (void)actionStageActionRequested:(NSString *)action options:(id)options
{
    if ([action isEqualToString:@"switchItemChanged"])
    {
        TGSwitchCollectionItem *switchItem = options[@"item"];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             if (switchItem == _dateIsToBeDiscussed)
             {
                 _dateItem.hidden = !_dateItem.hidden;
                 _dateItem.alpha = 1.0f - _dateItem.alpha;

             }
             else if (switchItem == _timeIsToBeDiscussed)
             {
                 _timeItem.hidden = !_timeItem.hidden;
                 _timeItem.alpha = 1.0f - _timeItem.alpha;
             }
             else if (switchItem == _locationIsToBeDiscussed)
             {
                 _locationItem.hidden = !_locationItem.hidden;
                 _locationItem.alpha = 1.0f - _locationItem.alpha;
             }
             [self.collectionLayout invalidateLayout];
             [self.collectionView layoutSubviews];
         } completion:nil];
    }
}

@end


