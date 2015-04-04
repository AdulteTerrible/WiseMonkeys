//
//  WMModernConversationGenericMeetingPanel.m
//  Telegraph
//
//  Created by Sébastien on 26-3-15.
//
//

#import "WMModernConversationGenericMeetingPanel.h"

#import "TGModernLabelViewModel.h"
#import "TGModernLetteredAvatarViewModel.h"
#import "TGModernColorViewModel.h"
#import "TGDoubleTapGestureRecognizer.h"

#import "TGImageUtils.h"
#import "TGFont.h"

#import "TGBackdropView.h"
#import "TGViewController.h"

#import "TGModernButton.h"

#import "ASHandle.h"

@interface WMModernConversationGenericMeetingPanel ()
{
    CALayer         *_stripeLayer;
    UIEdgeInsets     _insets;
    //NSArray *_buttons;
    //NSArray *_buttonActions;
    
    UIFont          *_smallFont;
    UIFont          *_bigFont;
    UIFont          *_bigBoldFont;
    
    UIButton        *_dateButton;
    UILabel         *_dateLabel;
    
    UIButton        *_timeButton;
    UILabel         *_timeLabel;
    
    UIButton        *_locationButton;
    UILabel         *_locationLabel;
    
    UIButton        *_moreButton;
    
    UILabel         *_descriptionLabel;
    
    UIView          *_backgroundView;
    
    float           _margin; // space between date/time/location views
}

@property (nonatomic, strong) UIView        *unreadBadgeContainer;
@property (nonatomic, strong) UIImageView   *unreadBadgeBackground;
@property (nonatomic, strong) UILabel       *unreadBadgeLabel;

@end

@implementation WMModernConversationGenericMeetingPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAX(70.0f, frame.size.height))];
    if (self)
    {
        _backgroundView = [TGBackdropView viewWithLightNavigationBarStyle];
        _backgroundView.frame = frame;
        
        //_backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = UIColorRGBA(0xfafafa, 0.98f);
        
        [self addSubview:_backgroundView];
        
        _stripeLayer = [[CALayer alloc] init];
        _stripeLayer.backgroundColor = UIColorRGB(0xb2b2b2).CGColor;
        [self.layer addSublayer:_stripeLayer];
        
        _smallFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        _bigFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        _bigBoldFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
        _margin = 8.0f;
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = _bigBoldFont;
        [self addSubview:_descriptionLabel];

        _moreButton = [[TGModernButton alloc] init];
        _moreButton.backgroundColor = [UIColor clearColor];
        _moreButton.titleLabel.font = _bigFont;
        [_moreButton setTitle:@"More" forState:UIControlStateNormal];
        [_moreButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_moreButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
        [_moreButton sizeToFit];
        CGSize buttonSize = _moreButton.frame.size;
        _moreButton.frame = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height + 20.0f);
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ModernTourButtonRightArrow.png"]];
        CGSize arrowSize = arrowView.frame.size;
        arrowView.frame = CGRectMake(_moreButton.frame.size.width - arrowSize.width, CGFloor((_moreButton.frame.size.height - arrowView.frame.size.height) / 2.0f) + 1.0f + TGRetinaPixel, arrowSize.width, arrowSize.height);
        
        [_moreButton addSubview:arrowView];
        [_moreButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
        
        [self setUnreadCount:1];
    }
    return self;
}

- (void)loadUnreadBadgeView
{
    if (_unreadBadgeContainer != nil)
        return;
    
    _unreadBadgeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _unreadBadgeContainer.hidden = true;
    _unreadBadgeContainer.userInteractionEnabled = false;
    _unreadBadgeContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:_unreadBadgeContainer];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(18.0f, 18.0f), false, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColorRGB(0xff3b30).CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0.0f, 0.0f, 18.0f, 18.0f));
    UIImage *badgeImage = [UIGraphicsGetImageFromCurrentImageContext() stretchableImageWithLeftCapWidth:9.0f topCapHeight:0.0f];
    UIGraphicsEndImageContext();
    
    _unreadBadgeBackground = [[UIImageView alloc] initWithImage:badgeImage];
    [_unreadBadgeContainer addSubview:_unreadBadgeBackground];
    
    _unreadBadgeLabel = [[UILabel alloc] init];
    _unreadBadgeLabel.text = @"1";
    [_unreadBadgeLabel sizeToFit];
    _unreadBadgeLabel.text = nil;
    _unreadBadgeLabel.backgroundColor = [UIColor clearColor];
    _unreadBadgeLabel.textColor = [UIColor whiteColor];
    _unreadBadgeLabel.font = TGSystemFontOfSize(13);
    [_unreadBadgeContainer addSubview:_unreadBadgeLabel];
    
    [self setNeedsLayout];
}

- (void)setUnreadCount:(int)unreadCount
{
    if (unreadCount <= 0 && _unreadBadgeLabel == nil)
        return;
    
    [self loadUnreadBadgeView];
    
    if (unreadCount <= 0)
        _unreadBadgeContainer.hidden = true;
    else
    {
        NSString *text = nil;
        
        //if (TGIsLocaleArabic())
        //    text = [TGStringUtils stringWithLocalizedNumber:unreadCount];
        //else
        //{
            if (unreadCount < 1000)
                text = [[NSString alloc] initWithFormat:@"%d", unreadCount];
            else if (unreadCount < 1000000)
                text = [[NSString alloc] initWithFormat:@"%dK", unreadCount / 1000];
            else
                text = [[NSString alloc] initWithFormat:@"%dM", unreadCount / 1000000];
        //}
        
        _unreadBadgeLabel.text = text;
        [_unreadBadgeLabel sizeToFit];
        _unreadBadgeContainer.hidden = false;
        
        CGRect frame = _unreadBadgeBackground.frame;
        CGFloat textWidth = _unreadBadgeLabel.frame.size.width;
        frame.size.width = MAX(18.0f, textWidth + 10.0f + TGRetinaPixel * 2.0f);
        frame.origin.x = _unreadBadgeBackground.superview.frame.size.width - frame.size.width;
        _unreadBadgeBackground.frame = frame;
        
        CGRect labelFrame = _unreadBadgeLabel.frame;
        labelFrame.origin.x = 5.0f + TGRetinaPixel + frame.origin.x;
        labelFrame.origin.y = 1;
        _unreadBadgeLabel.frame = labelFrame;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
    
    _stripeLayer.frame = CGRectMake(0.0f, self.frame.size.height - TGRetinaPixel, self.frame.size.width, TGRetinaPixel);

    // Heights for 1st and 2nd lines of controls
    float firstLineY    = 0.0f;
    float secondLineY   = 40.0f;
    
    _moreButton.frame = CGRectMake(self.frame.size.width - _moreButton.frame.size.width - _margin,
                                   firstLineY,
                                   _moreButton.frame.size.width,
                                   _moreButton.frame.size.height);
    
    // Set badge with unread message count on "More >" button
    if (_unreadBadgeContainer != nil)
    {
        CGRect unreadBadgeContainerFrame = _unreadBadgeContainer.frame;
        unreadBadgeContainerFrame.origin.x = _moreButton.frame.origin.x + _moreButton.frame.size.width - 25;
        unreadBadgeContainerFrame.origin.y = 2;
        _unreadBadgeContainer.frame = unreadBadgeContainerFrame;
    }
    
    _descriptionLabel.frame = CGRectMake(_margin,
                                         firstLineY,
                                         self.frame.size.width - _moreButton.frame.size.width - 2*_margin,
                                         _moreButton.frame.size.height);
    
    // width for each 3 parameters
    float maxWidth = (self.frame.size.width - 4*_margin)/3;
    float minWidth = 0; // to bound each control to max allowable width
    
    // starting with center: "time" parameter, likely to be smaller
    if (_timeButton) {
        minWidth = MIN(_timeButton.frame.size.width, maxWidth);
        _timeButton.frame = CGRectMake((self.frame.size.width - minWidth)/2,
                                       secondLineY - 6.0f,
                                       minWidth,
                                       _timeButton.frame.size.height);
    }
    else if (_timeLabel) {
        minWidth = MIN(_timeLabel.frame.size.width, maxWidth);
        _timeLabel.frame = CGRectMake((self.frame.size.width - minWidth)/2,
                                      secondLineY,
                                      minWidth,
                                      _timeLabel.frame.size.height);
    }

    // use the rest of total width for the 2 other fields
    float remainingWidth = (self.frame.size.width - minWidth - 2*_margin)/2;
    
    if (_dateButton) {
        minWidth = MIN(_dateButton.frame.size.width, remainingWidth);
        _dateButton.frame = CGRectMake(_margin,
                                       secondLineY - 6.0f,
                                       minWidth,
                                       _dateButton.frame.size.height);
    }
    else if (_dateLabel){
        minWidth = MIN(_dateLabel.frame.size.width, remainingWidth);
        _dateLabel.frame = CGRectMake(_margin,
                                      secondLineY,
                                       minWidth,
                                      _dateLabel.frame.size.height);
    }
    
    if (_locationButton) {
        minWidth = MIN(_locationButton.frame.size.width, remainingWidth);
        _locationButton.frame = CGRectMake(self.frame.size.width - minWidth - _margin,
                                           secondLineY - 6.0f,
                                           minWidth,
                                           _locationButton.frame.size.height);
    }
    else if (_locationLabel) {
        minWidth = MIN(_locationLabel.frame.size.width, remainingWidth);
        _locationLabel.frame = CGRectMake(self.frame.size.width - minWidth - _margin,
                                           secondLineY,
                                           minWidth,
                                           _locationLabel.frame.size.height);
    }
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
}

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    [self setNeedsLayout];
}

- (void) setMeeting:(WMMeeting *)meeting
{
    _meeting = meeting;
    
    _descriptionLabel.text = [[NSString alloc] initWithFormat:@"💭 %@", _meeting.meetingDescription];
    [_descriptionLabel sizeToFit];
    
    if (_meeting.dateIsToBeDiscussed) {
        _dateButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        _dateButton.titleLabel.font = _smallFont;
//        if ([_meeting.dateOptions count]>0) {
//            [_dateButton setTitle:[[NSString alloc] initWithFormat:@"📅(%d) Suggest", [_meeting.dateOptions count]] forState:UIControlStateNormal];
//        }
//        else
            [_dateButton setTitle:@"📅 Suggest" forState:UIControlStateNormal];
        [_dateButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_dateButton addTarget:self action:@selector(dateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        //[_dateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
        [_dateButton sizeToFit];
        _dateButton.enabled = true;
        [self addSubview:_dateButton];
    }
    else {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = _smallFont;
        _dateLabel.text = [[NSString alloc] initWithFormat:@"📅 %@", _meeting.date];
        [_dateLabel sizeToFit];
        [self addSubview:_dateLabel];
    }
    
    if (_meeting.timeIsToBeDiscussed) {
        _timeButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        _timeButton.titleLabel.font = _smallFont;
//        if ([_meeting.timeOptions count]>0) {
//            [_timeButton setTitle:[[NSString alloc] initWithFormat:@"🕑(%d) Suggest", [_meeting.timeOptions count]] forState:UIControlStateNormal];
//        }
//        else
            [_timeButton setTitle:@"🕑 Suggest" forState:UIControlStateNormal];
        [_timeButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(timeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        //[_timeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
        [_timeButton sizeToFit];
        _timeButton.enabled = true;
        [self addSubview:_timeButton];
    }
    else {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = _smallFont;
        _timeLabel.text = [[NSString alloc] initWithFormat:@"🕑 %@", _meeting.time];
        [_timeLabel sizeToFit];
        [self addSubview:_timeLabel];
    }

    if (_meeting.locationIsToBeDiscussed) {
        _locationButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        _locationButton.titleLabel.font = _smallFont;
//        if ([_meeting.locationOptions count]>0) {
//            [_locationButton setTitle:[[NSString alloc] initWithFormat:@"📍(%d) Suggest", [_meeting.locationOptions count]] forState:UIControlStateNormal];
//        }
//        else
            [_locationButton setTitle:@"📍Suggest" forState:UIControlStateNormal];
        [_locationButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        //[_locationButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
        [_locationButton sizeToFit];
        _locationButton.enabled = true;
        [self addSubview:_locationButton];
    }
    else {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = _smallFont;
        _locationLabel.text = [[NSString alloc] initWithFormat:@"📍 %@", _meeting.location];
        [_locationLabel sizeToFit];
        [self addSubview:_locationLabel];
    }
    
    [self setNeedsLayout];
}

- (void)dateButtonPressed
{
    [_companionHandle requestAction:@"insertTextInInputPanel" options:@{@"text": @"📅"}];
}

- (void)timeButtonPressed
{
    [_companionHandle requestAction:@"insertTextInInputPanel" options:@{@"text": @"🕑"}];
}

- (void)locationButtonPressed
{
    [_companionHandle requestAction:@"insertTextInInputPanel" options:@{@"text": @"📍"}];
}

- (void)moreButtonPressed
{
    [_companionHandle requestAction:@"showMeetingScreen" options:@{@"text": @"📍"}];
}


@end
