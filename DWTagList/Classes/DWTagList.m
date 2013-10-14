//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 13.0f
#define HORIZONTAL_PADDING_DEFAULT 7.0f
#define VERTICAL_PADDING_DEFAULT 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f
//#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
#define DEFAULT_AUTOMATIC_RESIZE NO

@interface DWTagList()

@property (nonatomic, assign) CGFloat maxTagWidth;

//- (void)touchedTag:(id)sender;

@end

@interface DWTagView ()

@property (nonatomic, strong) DWTagList *parentList;
@property (nonatomic, strong) UIButton  *button;
@property (nonatomic, strong) UILabel   *label;

-(void) applyParentTheme;

@end

@implementation DWTagList

@synthesize textArray;
@synthesize tagDelegate = _tagDelegate, automaticResize = _automaticResize;

-(void) basicInit {
    [self setClipsToBounds:YES];
    self.automaticResize = DEFAULT_AUTOMATIC_RESIZE;
//    self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
    self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
    self.labelMargin = LABEL_MARGIN_DEFAULT;
    self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
    self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
    self.verticalPadding = VERTICAL_PADDING_DEFAULT;
    
    self.defaultTextColor = TEXT_COLOR;
    self.defaultTextShadowColor = TEXT_SHADOW_COLOR;
    self.defaultTextShadowOffset = TEXT_SHADOW_OFFSET;
    self.defaultCornerRadius = CORNER_RADIUS;
    self.defaultBorderColor = [UIColor colorWithCGColor:BORDER_COLOR];
    self.defaultBorderWidth = BORDER_WIDTH;
    
    self.layoutType = DWTagLayoutDefault;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self basicInit];
    }
    return self;
}

-(void)applyDefaultTheme {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[DWTagView class]]) {
            [(DWTagView *)v applyParentTheme];
        }
    }
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    
    [self setNeedsLayout];
}

- (void)addTag:(NSString *)tagText
{
    if(textArray){
        NSMutableArray *arr = [textArray mutableCopy];
        [arr addObject:tagText];
        textArray = arr;
    } else
        textArray = @[tagText];
    
    [self setNeedsLayout];
}

-(DWTagView *)tagWithText:(NSString *)tagText {
    int index = [self.textArray indexOfObject:tagText];
    if (index != NSNotFound
        && index < self.subviews.count) {
        UIView *v = [self.subviews objectAtIndex:index];
        // Reassure
        if ([v isKindOfClass:[DWTagView class]]
            && [((DWTagView *)v).text isEqualToString:tagText]) {
            return (DWTagView *)v;
        }
    }
    return nil;
}

- (void)removeTagWithText:(NSString *)tagText {
    DWTagView *tag = [self tagWithText:tagText];
    [self removeTag:tag];
}

-(void)removeTag:(DWTagView *)tag {
    if (tag) {
        [tag removeFromSuperview];
        
        NSMutableArray *arr = [self.textArray mutableCopy];
        [arr removeObject:tag.text];
        self.textArray = arr;
        
        [self setNeedsDisplay];
    }
}

//- (void)setTagBackgroundColor:(UIColor *)color
//{
//    lblBackgroundColor = color;
//    [self setNeedsLayout];
//}

//- (void)setTagHighlightColor:(UIColor *)color
//{
//    self.highlightedBackgroundColor = color;
//    [self setNeedsLayout];
//}

- (void)setViewOnly:(BOOL)viewOnly
{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self setNeedsLayout];
    }
}

-(void)setLayoutType:(DWTagLayout)layoutType {
    _layoutType = layoutType;
    [self display];
}

-(void)setAutomaticResize:(BOOL)automaticResize {
    _automaticResize = automaticResize;
    if(automaticResize)
        [self sizeToFit];
}

//- (void)touchedTag:(id)sender
//{
//    UITapGestureRecognizer *t = (UITapGestureRecognizer *)sender;
//    DWTagView *tagView = (DWTagView *)t.view;
//    if(tagView && self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(selectedTag:)])
//        [self.tagDelegate selectedTag:tagView.label.text];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self display];
}

- (void)display
{
    BOOL firstSetUp = (self.subviews.count==0 && self.textArray.count>1);
    self.maxTagWidth = MAXFLOAT;
    if (self.layoutType != DWTagLayoutHorizontal) {
        self.maxTagWidth = self.frame.size.width - self.labelMargin;
    }
    
    NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[DWTagView class]]) {
            DWTagView *tagView = (DWTagView*)subview;

            [tagView.button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            
            [tagViews addObject:subview];
        }
        [subview removeFromSuperview];
    }

    CGRect previousFrame = CGRectZero;
    CGFloat maxWidth = 0;
    BOOL lineStart = YES;
    
    for (NSString *text in textArray) {
        DWTagView *tagView = nil;
        if (tagViews.count > 0) {
            NSArray *arr = [tagViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"text=%@", text]];
            if(arr && arr.count)
                tagView = arr[0];
            [tagViews removeObject:tagView];
        }
        if(!tagView) {
            tagView = [[DWTagView alloc] initForList:self];
            tagView.text = text;
        }
        
        if (self.layoutType == DWTagLayoutVertical
            ||
            (self.layoutType == DWTagLayoutFlow
            && !lineStart
            && previousFrame.origin.x + previousFrame.size.width + tagView.frame.size.width + self.labelMargin > self.frame.size.width))
            lineStart = YES;
        
        CGRect newRect = CGRectZero;
        if (lineStart)
            newRect.origin = CGPointMake(self.labelMargin,
                                         (previousFrame.origin.y?(previousFrame.origin.y + tagView.frame.size.height):0) + self.bottomMargin);
        else
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + self.labelMargin, previousFrame.origin.y);
        
        newRect.size = tagView.frame.size;
        [tagView setFrame:newRect];

        previousFrame = tagView.frame;
        lineStart = NO;
        if (self.layoutType != DWTagLayoutFlow) {
            maxWidth = MAX(maxWidth, CGRectGetMaxX(tagView.frame)+self.labelMargin);
        }
        
        [self addSubview:tagView];

        if (!_viewOnly) {
            [tagView.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    if (self.layoutType == DWTagLayoutFlow) {
        sizeFit = CGSizeMake(self.frame.size.width, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
    } else {
        sizeFit = CGSizeMake(maxWidth, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
        
    }
    self.contentSize = sizeFit;
    
    if (self.automaticResize) {
        [self sizeToFit];
    }
    
    if (firstSetUp
        &&self.tagDelegate
        && [self.tagDelegate respondsToSelector:@selector(tagListPreparedAllTags:)]) {
        [self.tagDelegate tagListPreparedAllTags:self];
    }
}

-(void)sizeToFit {
    if (self.subviews.count) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, MIN(sizeFit.width, self.frame.size.width), sizeFit.height);
    }
}

- (CGSize)fittedSize
{
    return sizeFit;
}

- (void)touchUpInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if(button
       && [button.superview isKindOfClass:[DWTagView class]]
       && self.tagDelegate)
        [self.tagDelegate tagList:self selectedTag:(DWTagView *)button.superview];
}

//- (UIColor *)getBackgroundColor
//{
//     if (!lblBackgroundColor) {
//         return BACKGROUND_COLOR;
//     } else {
//         return lblBackgroundColor;
//     }
//}

- (void)dealloc
{
//    lblBackgroundColor = nil;
}

@end

@implementation DWTagView

- (id)initForList:(DWTagList *)parentList {
    self = [super init];
    if (self) {
        self.parentList = parentList;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_button setFrame:self.frame];
        [self addSubview:_button];
        
        [self.layer setMasksToBounds:YES];
        
        [self applyParentTheme];
    }
    return self;
}

-(void)applyParentTheme {
    self.backgroundColor = self.parentList.defaultBackgroundColor;
    
    self.textColor = self.parentList.defaultTextColor;
    self.textShadowColor = self.parentList.defaultTextShadowColor;
    self.textShadowOffset = self.parentList.defaultTextShadowOffset;
    
    self.cornerRadius = self.parentList.defaultCornerRadius;
    self.borderColor = self.parentList.defaultBorderColor.CGColor;
    self.borderWidth = self.parentList.defaultBorderWidth;
}

-(void)setText:(NSString *)text {
    self.label.text = text;
    self.label.font = self.parentList.font;
    
    float maxTextWidth = self.parentList.maxTagWidth - self.parentList.horizontalPadding*2;
    float minimumTextWidth = self.parentList.minimumWidth - self.parentList.horizontalPadding*2;
    CGSize textSize = [text sizeWithFont:self.label.font forWidth:maxTextWidth lineBreakMode:NSLineBreakByTruncatingTail];
    
    textSize.width = MAX(textSize.width, minimumTextWidth);
    textSize.height += self.parentList.verticalPadding*2;
    
    self.frame = CGRectMake(0, 0, textSize.width+self.parentList.horizontalPadding*2, textSize.height);
    self.label.frame = CGRectMake(self.parentList.horizontalPadding, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    
    [_button setAccessibilityLabel:self.label.text];
}

-(NSString *)text { return self.label.text; }

-(void)setTextColor:(UIColor *)textColor
{ self.label.textColor = textColor; }
-(void)setTextShadowColor:(UIColor *)textShadowColor
{ self.label.shadowColor = textShadowColor; }
-(void)setTextShadowOffset:(CGSize)textShadowOffset
{ self.label.shadowOffset = textShadowOffset; }
-(void)setCornerRadius:(CGFloat)cornerRadius
{ self.layer.cornerRadius = cornerRadius; }
-(void)setBorderColor:(CGColorRef)borderColor
{ self.layer.borderColor = borderColor; }
-(void)setBorderWidth:(CGFloat)borderWidth
{ self.layer.borderWidth = borderWidth; }

-(UIColor *)textColor { return self.label.textColor; }
-(UIColor *)textShadowColor { return self.label.shadowColor; }
-(CGSize)textShadowOffset { return self.label.shadowOffset; }
-(CGFloat)cornerRadius { return self.layer.cornerRadius; }
-(CGColorRef)borderColor { return self.layer.borderColor; }
-(CGFloat)borderWidth { return self.layer.borderWidth; }

@end
