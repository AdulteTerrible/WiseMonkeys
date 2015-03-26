//
//  WMTextCollectionItem.m
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import "WMTextCollectionItem.h"

#import "WMTextCollectionItemView.h"

@implementation WMTextCollectionItem

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _hidden = false;
        _alpha = 1.0f;
        self.selectable = false;
        self.highlightable = false;
    }
    return self;
}

- (Class)itemViewClass
{
    return [WMTextCollectionItemView class];
}

- (CGSize)itemSizeForContainerSize:(CGSize)containerSize
{
    if (_hidden)
        return CGSizeMake(containerSize.width, 1.0f);

    return CGSizeMake(containerSize.width, 45.0f);
}

- (void)bindView:(WMTextCollectionItemView *)view
{
    [super bindView:view];
    
    view.textChanged = _textChanged;
}

- (void)unbindView
{
    ((WMTextCollectionItemView *)self.boundView).textChanged = nil;
    
    [super unbindView];
}

- (void)becomeFirstResponder
{
    if ([self boundView] != nil)
    [((WMTextCollectionItemView *) [self boundView]) makeTextFieldFirstResponder];
}

- (void) setPlaceholder: (NSString*)text
{
    if ([self boundView] != nil)
        [((WMTextCollectionItemView *) [self boundView]) setPlaceholder:text];
}

- (void) setLabel: (NSString*)text
{
    if ([self boundView] != nil)
        [((WMTextCollectionItemView *) [self boundView]) setLabel:text];
}

- (void)setAlpha:(CGFloat)value
{
    _alpha = value;
    
    [((WMTextCollectionItemView *)[self boundView]) setAlpha:_alpha];
}

- (NSString*) text
{
    return [((WMTextCollectionItemView *)[self boundView]) text];
}

@end
