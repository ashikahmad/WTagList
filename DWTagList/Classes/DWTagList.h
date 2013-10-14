//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//-------------------------------------------
/// Layout Types : How to layout tags in list
//-------------------------------------------

typedef enum {
    DWTagLayoutFlow,
    DWTagLayoutVertical,
    DWTagLayoutHorizontal,
    DWTagLayoutDefault = DWTagLayoutFlow
} DWTagLayout;

@class DWTagList, DWTagView;

@protocol DWTagListDelegate <NSObject>

@required

- (void)tagList:(DWTagList *) list selectedTag:(DWTagView *)tagView;

@end

@interface DWTagList : UIScrollView
{
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic) BOOL viewOnly;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, weak) id<DWTagListDelegate> tagDelegate;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic) BOOL automaticResize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat labelMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat minimumWidth;

@property (nonatomic, assign) DWTagLayout layoutType;

- (void)setTagBackgroundColor:(UIColor *)color;
- (void)setTagHighlightColor:(UIColor *)color;

// add/set
- (void)setTags:(NSArray *)array;
- (void)addTag:(NSString *)tagText;

// find
-(DWTagView *) tagWithText:(NSString *) tagText;

// remove
- (void)removeTagWithText:(NSString *) tagText;
- (void)removeTag:(DWTagView *) tag;

- (void)display;
- (CGSize)fittedSize;

@end

@interface DWTagView : UIView

@property (nonatomic, strong) UIButton      *button;
@property (nonatomic, strong) UILabel       *label;
@property (nonatomic, readwrite) NSString *text;

- (id) initForList:(DWTagList *) parentList;

@end
