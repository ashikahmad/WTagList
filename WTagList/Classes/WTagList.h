//
//  WTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

//-------------------------------------------
/// Layout Types : How to layout tags in list
//-------------------------------------------

typedef enum {
    WTagLayoutFlow,
    WTagLayoutVertical,
    WTagLayoutHorizontal,
    WTagLayoutDefault = WTagLayoutFlow
} WTagLayout;

@class WTagList, WTagView;

@protocol WTagListDelegate <NSObject>

@optional
- (void)tagList:(WTagList *) list removedTags:(NSArray *) tags;
- (void)tagList:(WTagList *) list addedTags:(NSArray *) tags;
- (void)tagListPreparedAllTags:(WTagList *) list;

@required
- (void)tagList:(WTagList *) list selectedTag:(WTagView *)tagView;

@end

@interface WTagList : UIScrollView
{
    CGSize sizeFit;
}

@property (nonatomic, assign) BOOL animateChanges;
@property (nonatomic) BOOL viewOnly;
@property (nonatomic, assign) BOOL autoSort;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, weak) id<WTagListDelegate> tagDelegate;
//@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic) BOOL automaticResize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat labelMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat minimumWidth;

@property (nonatomic, strong) UIColor *defaultBackgroundColor;
@property (nonatomic, strong) UIColor *defaultTextColor;
@property (nonatomic, strong) UIColor *defaultTextShadowColor;
@property (nonatomic, assign) CGSize defaultTextShadowOffset;
@property (nonatomic, assign) CGFloat defaultCornerRadius;
@property (nonatomic, strong) UIColor *defaultBorderColor;
@property (nonatomic, assign) CGFloat defaultBorderWidth;


@property (nonatomic, assign) WTagLayout layoutType;


/// any properties starting with default* will not be applied autometically. Invoke this method to force.
-(void) applyDefaultTheme;

// add/set
- (void)setTags:(NSArray *)array;
- (void)addTag:(NSString *)tagText;
- (void) sortTags;

// find
-(WTagView *) tagWithText:(NSString *) tagText;
-(NSArray *) tagsWithText:(NSString *) tagText;

/**
 removes tags with same test as tagText.
 @warning all tags matching will be removed (same will happen in removeTag: also)
 */
- (void)removeTagWithText:(NSString *) tagText;
/**
 @warning all tags with same text will be removed as they are identified by text.
 @see removeTagWithText:
 */
- (void)removeTag:(WTagView *) tag;

- (CGSize)fittedSize;

@end

@interface WTagView : UIView

@property (nonatomic, readwrite) NSString *text;
@property (nonatomic, readwrite) UIColor *textColor;
@property (nonatomic, readwrite) UIColor *textShadowColor;
@property (nonatomic, readwrite) CGSize textShadowOffset;
@property (nonatomic, readwrite) CGFloat cornerRadius;
@property (nonatomic, readwrite) CGColorRef borderColor;
@property (nonatomic, readwrite) CGFloat borderWidth;

- (id) initForList:(WTagList *) parentList;
- (void) removeFromList;

@end
