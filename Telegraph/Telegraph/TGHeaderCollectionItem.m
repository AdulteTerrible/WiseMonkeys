/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGHeaderCollectionItem.h"

#import "TGHeaderCollectionItemView.h"

@interface TGHeaderCollectionItem ()
{
    NSString *_title;
    BOOL     _isHighlighted;
}

@end

@implementation TGHeaderCollectionItem

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self != nil)
    {
        self.transparent = true;
        self.highlightable = false;
        self.selectable = false;
        
        _title = title;
        _isHighlighted = false;
    }
    return self;
}

- (instancetype)initWithHighlightedTitle:(NSString *)title
{
    self = [super init];
    if (self != nil)
    {
        self.transparent = true;
        self.highlightable = false;
        self.selectable = false;
        
        _title = title;
        _isHighlighted = true;
    }
    return self;
}

- (Class)itemViewClass
{
    return [TGHeaderCollectionItemView class];
}

- (CGSize)itemSizeForContainerSize:(CGSize)containerSize
{
    return CGSizeMake(containerSize.width, 22.0f);
}

- (void)bindView:(TGHeaderCollectionItemView *)view
{
    [super bindView:view];
    
    if (_isHighlighted)
        [view setHighlightedTitle:_title];
    else
        [view setTitle:_title];
}

- (void)setTitle:(NSString *)title
{
    if (!TGStringCompare(_title, title))
    {
        _title = title;
        _isHighlighted = false;
        
        [((TGHeaderCollectionItemView *)[self boundView]) setTitle:_title];
    }
}

- (void)setHighlightedTitle:(NSString *)title
{
    if (!TGStringCompare(_title, title))
    {
        _title = title;
        _isHighlighted = true;
        
        [((TGHeaderCollectionItemView *)[self boundView]) setHighlightedTitle:_title];
    }
}

@end
