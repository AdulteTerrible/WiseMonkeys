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
    CALayer *_stripeLayer;
    UIEdgeInsets _insets;
    //NSArray *_buttons;
    //NSArray *_buttonActions;
    
    UIFont* _smallFont;
    UIFont* _bigFont;
    
    UIButton *_dateButton;
    UILabel*  _dateLabel;
    
    UIButton *_timeButton;
    UILabel*  _timeLabel;
    
    UIButton *_locationButton;
    UILabel*  _locationLabel;
    
    UIButton *_moreButton;
    
    UILabel*  _descriptionLabel;
    
    UIView *_backgroundView;
    
    float _margin;
}

@end

@implementation WMModernConversationGenericMeetingPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAX(70.0f, frame.size.height))];
    if (self)
    {
        //_backgroundView = [TGBackdropView viewWithLightNavigationBarStyle];
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = UIColorRGBA(0xfafafa, 0.98f);
        //_backgroundView.frame = frame;
        [self addSubview:_backgroundView];
        
        _stripeLayer = [[CALayer alloc] init];
        _stripeLayer.backgroundColor = UIColorRGB(0xb2b2b2).CGColor;
        [self.layer addSublayer:_stripeLayer];
        
        _smallFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _bigFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        _margin = 8.0f;
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = _bigFont;
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
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
    
    _stripeLayer.frame = CGRectMake(0.0f, self.frame.size.height - TGRetinaPixel, self.frame.size.width, TGRetinaPixel);
    
    float maxWidth = (self.frame.size.width-4*_margin)/3;
    
    if (_dateButton) {
        _dateButton.frame = CGRectMake(_margin,
                                       40.0f,
                                       MIN(_dateButton.frame.size.width, maxWidth),
                                       _dateButton.frame.size.height);
    }
    if (_dateLabel){
        _dateLabel.frame = CGRectMake(_margin,
                                      40.0f,
                                      MIN(maxWidth, _dateLabel.frame.size.width),
                                      _dateLabel.frame.size.height);
    }
    if (_timeButton) {
        _timeButton.frame = CGRectMake((self.frame.size.width - MIN(_timeButton.frame.size.width, maxWidth))/2,
                                       40.0f,
                                       MIN(_timeButton.frame.size.width, maxWidth),
                                       _timeButton.frame.size.height);
    }
    if (_timeLabel) {
        _timeLabel.frame = CGRectMake((self.frame.size.width - MIN(maxWidth, _timeLabel.frame.size.width))/2,
                                       40.0f,
                                       MIN(maxWidth, _timeLabel.frame.size.width),
                                       _timeLabel.frame.size.height);
    }
    if (_locationButton) {
        _locationButton.frame = CGRectMake(self.frame.size.width - MIN(maxWidth, _locationButton.frame.size.width) - _margin,
                                           40.0f,
                                           MIN(maxWidth, _locationButton.frame.size.width),
                                           _locationButton.frame.size.height);
    }
    if (_locationLabel) {
        _locationLabel.frame = CGRectMake(self.frame.size.width - MIN(maxWidth, _locationLabel.frame.size.width) - _margin,
                                           40.0f,
                                           MIN(maxWidth, _locationLabel.frame.size.width),
                                           _locationLabel.frame.size.height);
    }
    _moreButton.frame = CGRectMake(self.frame.size.width - _moreButton.frame.size.width - _margin,
                                   0.0f,
                                   _moreButton.frame.size.width,
                                   _moreButton.frame.size.height);
    
    _descriptionLabel.frame = CGRectMake(_margin,
                                         0.0f,
                                         self.frame.size.width - _moreButton.frame.size.width - 2*_margin,
                                         _moreButton.frame.size.height);
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
    [_locationLabel sizeToFit];
    
    if (_meeting.dateIsToBeDiscussed) {
        _dateButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
        _dateButton.titleLabel.font = _smallFont;
        [_dateButton setTitle:@"📅 Suggest" forState:UIControlStateNormal];
        [_dateButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_dateButton addTarget:self action:@selector(dateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_dateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
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
        _timeButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
        _timeButton.titleLabel.font = _smallFont;
        [_timeButton setTitle:@"🕑 Suggest" forState:UIControlStateNormal];
        [_timeButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(timeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_timeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
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
        _locationButton = [[TGModernButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
        _locationButton.titleLabel.font = _smallFont;
        [_locationButton setTitle:@"📍 Suggest" forState:UIControlStateNormal];
        [_locationButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20.0f)];
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
    //id<TGModernConversationEditingPanelDelegate> delegate = (id<TGModernConversationEditingPanelDelegate>)self.delegate;
    //if ([delegate respondsToSelector:@selector(editingPanelRequestedForwardMessages:)])
    //    [delegate editingPanelRequestedForwardMessages:self];
}


@end
