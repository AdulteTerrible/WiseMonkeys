//
//  WMTextCollectionItemView.h
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import "TGCollectionItemView.h"

@interface WMTextCollectionItemView : TGCollectionItemView

@property (nonatomic, copy) void (^textChanged)(NSString *);

@property (nonatomic) CGFloat   alpha;
@property (nonatomic) NSString  *text;

- (void) makeTextFieldFirstResponder;
- (void) setPlaceholder:(NSString*)text;
- (void) setLabel: (NSString*)text;

@end
