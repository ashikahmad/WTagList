//
//  WTagList.m
//  DWTagList
//
//  Created by Ashik Ahmad on 10/13/13.
//  Copyright (c) 2013 Terracoding LTD. All rights reserved.
//

#import "WTagList.h"

@implementation WTagTheme

-(id)init {
    NSAssert(false, @"Use initWithInfo:/themeWithInfo: instead.");
    return self;
}

-(id)initWithInfo:(NSDictionary *)themeInfo {
    if ((self = [super init])) {
        [self modifyWithInfo:themeInfo];
    }
    return self;
}

+(id)themeWithInfo:(NSDictionary *)themeInfo {
    return [[self alloc] initWithInfo:themeInfo];
}

-(void)modifyWithInfo:(NSDictionary *)themeInfo {
    for (NSString *key in themeInfo) {
        [self setValue:themeInfo[key] forKey:key];
    }
}

+(WTagTheme *)defaultTheme {
    NSDictionary *themeInfo = @{
                                kWThemeBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00],
                                kWThemeBorderColor:[UIColor lightGrayColor],
                                kWThemeTextColor:[UIColor blackColor],
                                kWThemeTextShadowColor:[UIColor whiteColor],
                                kWThemeTextShadowOffset:[NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                kWThemeHighlightedBackgroundColor:[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
                                };
    return [self themeWithInfo:themeInfo];
}

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kWThemeTextShadowOffset]) {
        self.textShadowOffset = (value)?[(NSValue *)value CGSizeValue]:CGSizeZero;
    } else if ([key isEqualToString:kWThemeHighlightedTextShadowOffset]){
        self.highlightedTextShadowOffset = (value)?[(NSValue *)value CGSizeValue]:CGSizeZero;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

#pragma mark - WTagView -

@interface WTagView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

-(void)setTheme:(WTagTheme *)theme;
-(void)setParentList:(WTagList *)parentList;

@end

@implementation WTagView

@synthesize label = _label,
button = _button,
theme = _theme,
parentList = _parentList;

-(void) applyTheme {
    if (self.parentList) {
        _label.textColor = self.theme.textColor?:self.parentList.defaultTheme.textColor;
        _label.shadowColor = self.theme.textShadowColor?:self.parentList.defaultTheme.textShadowColor;
        _label.shadowOffset = self.theme.textShadowOffset;
        
        [self.layer setCornerRadius:self.parentList.cornerRadius];
        [self.layer setBorderColor:[(self.theme.borderColor?:self.parentList.defaultTheme.borderColor) CGColor]];
        [self.layer setBorderWidth: self.parentList.borderWidth];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _theme = nil;
        _parentList = nil;
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_button setFrame:self.frame];
        [self addSubview:_button];
        
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

-(void)setText:(NSString *)text { self.label.text = text; }
-(NSString *)text {return self.label.text; }

-(void)setTheme:(WTagTheme *)theme {
    _theme = theme;
    [self applyTheme];
}

-(void)setParentList:(WTagList *)parentList {
    _parentList = parentList;
    [self applyTheme];
}

@end

@interface WTagList ()
@property (weak) NSMutableArray *tagViews;
@end

@implementation WTagList

#pragma mark - Initialization

-(void) basicInit {
    self.defaultTheme = [WTagTheme defaultTheme];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self basicInit];
    }
    return self;
}

#pragma mark - Overrides

//-(void)sizeToFit {
//    
//}

#pragma mark - Setting up Tags



#pragma mark - Finding Tag

-(WTagView *)tagAtIndex:(NSUInteger) index {
    if (self.tagViews && self.tagViews.count > index)
        return (self.tagViews)[index];
    else return nil;
}

-(NSArray *)tagsWithText:(NSString *)tagText {
    NSMutableArray *arr = [NSMutableArray array];
    
    if(self.tagViews){
        for (WTagView *tag in self.tagViews) {
            if ([tag.text isEqual:tagText]) {
                [arr addObject:tag];
            }
        }
    }
    
    if(arr.count) return arr;
    else return nil;
}

-(WTagView *)tagWithText:(NSString *)tagText {
    NSArray *tags = [self tagsWithText:tagText];
    if (tags && tags.count) {
        return tags[0];
    }
    return nil;
}

@end
