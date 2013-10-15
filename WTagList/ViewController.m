//
//  ViewController.m
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "ViewController.h"
#import "WTagList.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WTagList *xibList;
@property (weak, nonatomic) IBOutlet UITextField *tagField;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation ViewController

- (IBAction)sortPrefChanged:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        self.xibList.autoSort = tagList.autoSort = [(UISwitch *)sender isOn];
//        [self.xibList setNeedsLayout];
//        [tagList setNeedsLayout];
    }
}

- (IBAction)addNewTag:(id)sender {
    NSString *text = self.tagField.text;
    if (text.length) {
        [self.xibList addTag:text];
    }
    self.tagField.text = @"";
    
    if([sender isKindOfClass:[UIButton class]])
        [self removeKeyboard:nil];
    else
        [self.tagField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect f = self.btn.frame;
    f.origin.y += f.size.height + 20;
    f.size.height += 50.0f;
    tagList = [[WTagList alloc] initWithFrame:f];
    NSArray *array = @[@"Foo",
                       @"Tag Label 1",
                       @"Tag Label 2",
                       @"Tag Label 3",
                       @"Tag Label 11",
                       @"Long long long long long long Tag"];
    [tagList setTags:array];
    tagList.automaticResize = YES;
    [tagList setTagDelegate:self];
    [self.view addSubview:tagList];
    
    self.xibList.tagDelegate = self;
    [self.xibList setTags:@[@"Add",
                            @"a",
                            @"scrollView",
                            @"and",
                            @"change class",
                            @"as",
                            @"WTagList",
                            @"and",
                            @"Add tags in code"
                            ]];
    
// xibList have set attributes in XIB keyPath
    
    // debug
    tagList.layer.borderWidth = 1;
    tagList.layer.borderColor = [UIColor redColor].CGColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void) removeKeyboard:(id) sender {
    [self.view endEditing:NO];
}

-(IBAction) changeLayout:(id) sender {
    if (tagList.layoutType == WTagLayoutFlow) {
        tagList.layoutType = WTagLayoutHorizontal;
        self.xibList.layoutType = WTagLayoutHorizontal;
        [self.btn setTitle:@"Layout: Horizontal" forState:UIControlStateNormal];
    } else if (tagList.layoutType == WTagLayoutHorizontal) {
        tagList.layoutType = WTagLayoutVertical;
        self.xibList.layoutType = WTagLayoutVertical;
        [self.btn setTitle:@"Layout: Vertical" forState:UIControlStateNormal];
    } else if (tagList.layoutType == WTagLayoutVertical) {
        tagList.layoutType = WTagLayoutFlow;
        self.xibList.layoutType = WTagLayoutFlow;
        [self.btn setTitle:@"Layout: Flow" forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - TagList Delegate

-(void)tagList:(WTagList *)list selectedTag:(WTagView *)tagView {
    if (list == self.xibList) {
        [list removeTag:tagView];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:[NSString stringWithFormat:@"You tapped tag %@", tagView.text]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)tagListPreparedAllTags:(WTagList *)list {
    if (list == self.xibList) {
        WTagView *tag = [self.xibList tagWithText:@"WTagList"];
        tag.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        tag.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
        tag.borderColor = [UIColor redColor].CGColor;
    }
}

@end
