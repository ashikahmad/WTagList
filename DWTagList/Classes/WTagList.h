//
//  WTagList.h
//  DWTagList
//
//  Created by Ashik Ahmad on 10/13/13.
//  Copyright (c) 2013 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTagView;
@class WTagTheme;
@class WTagList;

//-------------------------------------------
/// Layout Types : How to layout tags in list
//-------------------------------------------

typedef enum {
    WTagLayoutFlow,
    WTagLayoutVertical,
    WTagLayoutHorizontal,
    WTagLayoutDefault = WTagLayoutFlow
} WTagLayout;

//-------------------------------------------------------------
/// List Delegate : Use if needed actions based on interactions
//-------------------------------------------------------------

@protocol WTagListDelegate <NSObject>
@required
-tagList:(WTagList *) tagList selectedTag:(WTagView *) selectedTag;
@end

static NSString *const kWThemeBackgroundColor = @"backgroundColor";
static NSString *const kWThemeBorderColor = @"borderColor";
static NSString *const kWThemeTextColor = @"textColor";
static NSString *const kWThemeTextShadowColor = @"textShadowColor";
static NSString *const kWThemeTextShadowOffset = @"textShadowOffset";

static NSString *const kWThemeHighlightedBackgroundColor = @"highlightedBackgroundColor";
static NSString *const kWThemeHighlightedBorderColor = @"highlightedborderColor";
static NSString *const kWThemeHighlightedTextColor = @"highlightedTextColor";
static NSString *const kWThemeHighlightedTextShadowColor = @"highlightedTextShadowColor";
static NSString *const kWThemeHighlightedTextShadowOffset = @"highlightedTextShadowOffset";

//-------------------------------------
/// Tag Theme : Style tags, as you want
//-------------------------------------

@interface WTagTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textShadowColor;
@property (nonatomic, assign) CGSize textShadowOffset;

@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBorderColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *highlightedTextShadowColor;
@property (nonatomic, assign) CGSize highlightedTextShadowOffset;

-(id)initWithInfo:(NSDictionary *) themeInfo;
+(WTagTheme *)themeWithInfo:(NSDictionary *) themeInfo;
-(void)modifyWithInfo:(NSDictionary *) themeInfo;

+(WTagTheme *) defaultTheme;

@end

//------------------------------------------
/// Tag View : Basic tag element in the list
//------------------------------------------

@interface WTagView : UIView
/// Readonly. But can be modified using modifyWithInfo: @see modifyWithInfo: (WTagTheme)
@property (weak, nonatomic, readonly) WTagTheme *theme;
@property (weak, nonatomic, readwrite) NSString *text;
@property (weak, nonatomic, readonly) WTagList *parentList;
@property (nonatomic, strong) id userData;

-(void) removeFromList;

@end

//----------------------------------------------------------------
/// Tag List : UIControl subclass. Use like other control-elements
//----------------------------------------------------------------

@interface WTagList : UIControl

@property (nonatomic) BOOL viewOnly;
@property (nonatomic) BOOL automaticResize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat labelMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat minimumWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) WTagLayout tagLayout;

/// If no theme is assigned to any TagView, this theme is applied.
@property (nonatomic, strong) WTagTheme *defaultTheme;

@property (nonatomic, strong) NSObject<WTagListDelegate> *listDelegate;

/// @param tagTexts - array of texts for tags
-(void) setTags:(NSArray *) tagTexts;
/// @param tagText - text for tag
-(void) addTag:(NSString *) tagText;

/// @return TagView at tagIndex, nil otherwise
-(WTagView *)tagAtIndex:(NSUInteger) index;
/// @return TagViews found with tagText, nil otherwise
-(NSArray *)tagsWithText:(NSString *)tagText;
/// @return first tagView found with tagText, nil otherwise
-(WTagView *)tagWithText:(NSString *)tagText;

@end
