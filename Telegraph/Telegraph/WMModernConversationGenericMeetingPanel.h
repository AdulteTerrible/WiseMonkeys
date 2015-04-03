//
//  WMModernConversationGenericMeetingPanel.h
//  Telegraph
//
//  Created by Sébastien on 26-3-15.
//
//

#import "TGModernConversationTitlePanel.h"
#import "WMMeeting.h"

@class ASHandle;

@interface WMModernConversationGenericMeetingPanel : TGModernConversationTitlePanel

@property (nonatomic) ASHandle *companionHandle;
@property (nonatomic) WMMeeting *meeting;

//- (void)setButtonsWithTitlesAndActions:(NSArray *)buttonsDesc;

@end
