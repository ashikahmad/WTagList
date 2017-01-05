//
//  WTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "WTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 2.0f
#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 13.0f
#define HORIZONTAL_PADDING_DEFAULT 7.0f
#define VERTICAL_PADDING_DEFAULT 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:161/255.0 green:170/255.0 blue:201/255.0 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 0.0f
//#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
#define DEFAULT_AUTOMATIC_RESIZE NO

#define IMG_WIDTH_HEIGHT 18
#define IMGNAME @"img_delete.png"

@interface WTagList()

@property (nonatomic, assign) BOOL isTagsSettingUp;
@property (nonatomic, assign) CGFloat maxTagWidth;

//- (void)touchedTag:(id)sender;
- (void)display:(BOOL)animated;

@end

@interface WTagView ()

@property (nonatomic, strong) WTagList *parentList;
@property (nonatomic, strong) UIButton  *button;
@property (nonatomic, strong) UILabel   *label;

-(void) applyParentTheme;

@end

@implementation WTagList

@synthesize tagDelegate = _tagDelegate, automaticResize = _automaticResize;

-(void) basicInit {
    self.isTagsSettingUp = NO;
    self.autoSort = NO;
    
    [self setClipsToBounds:YES];
    self.animateChanges = NO;
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
    
    self.layoutType = WTagLayoutDefault;
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
        if ([v isKindOfClass:[WTagView class]]) {
            [(WTagView *)v applyParentTheme];
        }
    }
}

-(void) sortTags {
    self.textArray = [self.textArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    [self setNeedsLayout];
}

- (void)setTags:(NSArray *)array
{
    self.isTagsSettingUp = YES;
    
    self.textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    
//    if(self.autoSort)
//        [self sortTags];
//    else
        [self setNeedsLayout];
}

- (void)addTag:(NSString *)tagText
{
    if(self.textArray){
        self.textArray = [self.textArray arrayByAddingObject:tagText];
    } else
        self.textArray = @[tagText];
    
//    if(self.autoSort)
//        [self sortTags];
//    else
        [self setNeedsLayout];
}

-(WTagView *)tagWithText:(NSString *)tagText {
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[WTagView class]]
            && [((WTagView *)v).text isEqualToString:tagText]) {
            return (WTagView *) v;
        }
    }
    
    return nil;
}

-(NSArray *)tagsWithText:(NSString *)tagText {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[WTagView class]]
            && [((WTagView *)v).text isEqualToString:tagText]) {
            [arr addObject:v];
        }
    }
    
    if(arr.count) return arr;
    else return nil;
}

- (void)removeTagWithText:(NSString *)tagText {
    NSMutableArray *arr = [self.textArray mutableCopy];
    int count = arr.count;
    [arr removeObject:tagText];
    self.textArray = arr;
    
    // if any change made really
    if(count != arr.count)
        [self display:self.animateChanges];
}

-(void)removeTag:(WTagView *)tag {
    if (tag) {
        [self removeTagWithText:tag.text];
    }
}

- (void)setViewOnly:(BOOL)viewOnly
{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self setNeedsLayout];
    }
}

-(void)setLayoutType:(WTagLayout)layoutType {
    _layoutType = layoutType;
    [self display:self.animateChanges];
}

-(void)setAutomaticResize:(BOOL)automaticResize {
    _automaticResize = automaticResize;
    if(automaticResize)
        [self sizeToFit];
}

-(void)setAutoSort:(BOOL)autoSort {
    _autoSort = autoSort;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self display:self.animateChanges];
}

-(void)display:(BOOL) animated {
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self _display];
                         }];
    } else {
        [self _display];
    }
}

- (void)_display
{
    BOOL firstSetUp = (self.isTagsSettingUp && self.textArray.count>1);
    self.maxTagWidth = MAXFLOAT;
    if (self.layoutType != WTagLayoutHorizontal) {
        self.maxTagWidth = self.frame.size.width - self.labelMargin;
    }
    
    NSMutableArray *oldTagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[WTagView class]]) {
            WTagView *tagView = (WTagView*)subview;

            [tagView.button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            
            [oldTagViews addObject:subview];
        }
    }

    CGRect previousFrame = CGRectZero;
    CGFloat maxWidth = 0;
    BOOL lineStart = YES;
    
    NSMutableArray *newTagViews = [NSMutableArray array];
    NSArray *texts = self.autoSort?[self.textArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)]:self.textArray;
    for (NSString *text in texts) {
        WTagView *tagView = nil;
        if (oldTagViews.count > 0) {
            NSArray *arr = [oldTagViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"text=%@", text]];
            if(arr && arr.count)
                tagView = arr[0];
            [oldTagViews removeObject:tagView];
        }
        if(!tagView) {
            tagView = [[WTagView alloc] initForList:self];
            tagView.text = text;
            [self addSubview:tagView];
            [newTagViews addObject:tagView];
        }
        
        if (self.layoutType == WTagLayoutVertical
            ||
            (self.layoutType == WTagLayoutFlow
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
        if (self.layoutType != WTagLayoutFlow) {
            maxWidth = MAX(maxWidth, CGRectGetMaxX(tagView.frame)+self.labelMargin);
        }
        
//        [self addSubview:tagView];

        if (!_viewOnly) {
            [tagView.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    if (oldTagViews.count) {
        [oldTagViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        if (self.tagDelegate
            && [self.tagDelegate respondsToSelector:@selector(tagList:removedTags:)]) {
            [self.tagDelegate tagList:self removedTags:oldTagViews];
        }
    }
    
    if (newTagViews.count
        && self.tagDelegate
        && [self.tagDelegate respondsToSelector:@selector(tagList:addedTags:)]) {
        [self.tagDelegate tagList:self addedTags:newTagViews];
    }
    
    if (self.layoutType == WTagLayoutFlow) {
        sizeFit = CGSizeMake(self.frame.size.width, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
    } else {
        sizeFit = CGSizeMake(maxWidth, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
        
    }
    self.contentSize = sizeFit;
    
    if (self.automaticResize) {
        [self sizeToFit];
    }
    
    if (firstSetUp){
        if (self.tagDelegate
            && [self.tagDelegate respondsToSelector:@selector(tagListPreparedAllTags:)]) {
            [self.tagDelegate tagListPreparedAllTags:self];
        }
        self.isTagsSettingUp = NO;
    }
}

-(void)sizeToFit {
    if (self.subviews.count) {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
//                                MIN(sizeFit.width, self.frame.size.width),
                                self.frame.size.width,
                                sizeFit.height);
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
       && [button.superview isKindOfClass:[WTagView class]]
       && self.tagDelegate)
        [self.tagDelegate tagList:self selectedTag:(WTagView *)button.superview];
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

@implementation WTagView

- (id)initForList:(WTagList *)parentList {
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

-(void)removeFromList {
    if (self.parentList) {
        [self.parentList removeTag:self];
    }
}

-(void)applyParentTheme {
    self.backgroundColor = self.parentList.defaultBackgroundColor;
    
    self.textColor = self.parentList.defaultTextColor;
    //self.textShadowColor = self.parentList.defaultTextShadowColor;
    //self.textShadowOffset = self.parentList.defaultTextShadowOffset;
    
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
    
    self.frame = CGRectMake(0, 0, textSize.width+self.parentList.horizontalPadding*2 + IMG_WIDTH_HEIGHT+2.0, textSize.height);
    self.label.frame = CGRectMake(self.parentList.horizontalPadding, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMGNAME]];
    imgView.frame = CGRectMake(textSize.width+self.parentList.horizontalPadding, (textSize.height - IMG_WIDTH_HEIGHT)*0.5, IMG_WIDTH_HEIGHT, IMG_WIDTH_HEIGHT);
    [_label addSubview:imgView];
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
