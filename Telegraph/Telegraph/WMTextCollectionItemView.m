//
//  WMTextCollectionItemView.m
//  Telegraph
//
//  Created by Sébastien on 22-3-15.
//
//

#import "WMTextCollectionItemView.h"

#import "TGTextField.h"
#import "TGFont.h"

@interface WMTextCollectionItemView () <UITextFieldDelegate>
{
    TGTextField *_textField;
    UILabel     *_label;
    BOOL        _hasLabel;
}

@end

@implementation WMTextCollectionItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _hasLabel = false;
        _alpha = 1.0f;
        
        _textField = [[TGTextField alloc] init];
        _textField.font = TGSystemFontOfSize(18.0f);
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = [UIColor blackColor];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate = self;
        
        [self addSubview:_textField];
        
        //[self setLabel:@"Test"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_hasLabel) {
        _label.frame = (CGRect){{14.0f, CGFloor((self.contentView.frame.size.height - _label.frame.size.height) / 2.0f)}, _label.frame.size};
        
        _textField.frame = CGRectMake(CGRectGetMaxX(_label.frame) + 2.0f, 0.0f, self.contentView.frame.size.width - 8.0f - 2.0f - CGRectGetMaxX(_label.frame), self.contentView.frame.size.height);
    }
    else {
        _textField.frame = (CGRect){{15.0f, 0.0f}, {self.frame.size.width, self.frame.size.height}};
    }
}

- (void)setAlpha:(CGFloat)value
{
    if ((_alpha == 0.0f)&&(value == 1.0f))    // Textfield appears
        [self makeTextFieldFirstResponder];   // so we give it the focus
    
    _alpha = value;
    _textField.alpha = _alpha;
    if (_hasLabel)
        _label.alpha = _alpha;
}


- (void)makeTextFieldFirstResponder
{
    [_textField becomeFirstResponder];
}

- (void) setPlaceholder:(NSString*)text
{
    _textField.placeholder = text;
    _textField.placeholderFont = _textField.font;
    _textField.placeholderColor = UIColorRGB(0xbfbfbf);
}

- (void) setLabel:(NSString*)text
{
    _hasLabel = TRUE;
    _label = [[UILabel alloc] init];
    _label.text = text;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
    _label.font = TGSystemFontOfSize(18.0f);
    [_label sizeToFit];
    [self.contentView addSubview:_label];
    
    _textField.leftInset = 20.0f;
    
    //[self layoutSubviews];
}

- (NSString*) text
{
    return [_textField text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_textChanged)
        _textChanged([textField text]);
    
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_textChanged)
        _textChanged([textField text]);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_textChanged)
        _textChanged([textField text]);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_textChanged)
        _textChanged([textField text]);
    
    return true;
}

@end
