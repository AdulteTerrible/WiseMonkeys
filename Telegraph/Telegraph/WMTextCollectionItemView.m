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
        _textField.delegate = self;
        _textField.font = TGSystemFontOfSize(18.0f);
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = [UIColor blackColor];
        //_textField.autocorrectionType = UITextAutocorrectionTypeNo;
        //_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //_textField.spellCheckingType = UITextSpellCheckingTypeNo;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDefault;
        
        
        [self addSubview:_textField];
        
        //[self setLabel:@"Test"];
    }
    return self;
}

- (void)setAlpha:(CGFloat)value
{
    if (value == 1.0f)                         // Textfield appears
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_textChanged) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _textChanged(text);
    }
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)__unused textField
{
    return false;
}

@end
