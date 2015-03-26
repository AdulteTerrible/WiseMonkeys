//
//  WMTextCollectionItem.h
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import "TGCollectionItem.h"

@interface WMTextCollectionItem : TGCollectionItem

@property (nonatomic) NSString  *text;
@property (nonatomic) CGFloat   alpha;
@property (nonatomic) bool      hidden;

@property (nonatomic, copy) void (^textChanged)(NSString *);

- (void)becomeFirstResponder;
- (void) setPlaceholder: (NSString*)text;
- (void) setLabel: (NSString*)text;

@end
