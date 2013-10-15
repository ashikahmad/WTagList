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
@property (weak, nonatomic) IBOutlet DWTagList *xibList;
@property (weak, nonatomic) IBOutlet UITextField *tagField;
@end

@implementation ViewController

- (IBAction)sortPrefChanged:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        self.xibList.autoSort = [(UISwitch *)sender isOn];
        [self.xibList setNeedsLayout];
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
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 270.0f, 200.0f, 50.0f)];
    NSArray *array = @[@"Foo",
                       @"Tag Label 1",
                       @"Tag Label 2",
                       @"Tag Label 3",
                       @"Tag Label 4",
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
                            @"DWTagList",
                            @"and",
                            @"Add tags in code"
                            ]];
    
// xibList have set attributes in XIB keyPath
    
    // debug
    tagList.layer.borderWidth = 1;
    tagList.layer.borderColor = [UIColor redColor].CGColor;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 210, 280, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Flow" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSLog(@"%@", NSStringFromCGSize([WTagTheme defaultTheme].textShadowOffset));
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void) removeKeyboard:(id) sender {
    [self.view endEditing:NO];
}

-(void) changeLayout:(id) sender {
    if (tagList.layoutType == DWTagLayoutFlow) {
        tagList.layoutType = DWTagLayoutHorizontal;
        self.xibList.layoutType = DWTagLayoutHorizontal;
        [btn setTitle:@"Horizontal" forState:UIControlStateNormal];
    } else if (tagList.layoutType == DWTagLayoutHorizontal) {
        tagList.layoutType = DWTagLayoutVertical;
        self.xibList.layoutType = DWTagLayoutVertical;
        [btn setTitle:@"Vertical" forState:UIControlStateNormal];
    } else if (tagList.layoutType == DWTagLayoutVertical) {
        tagList.layoutType = DWTagLayoutFlow;
        self.xibList.layoutType = DWTagLayoutFlow;
        [btn setTitle:@"Flow" forState:UIControlStateNormal];
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

-(void)tagList:(DWTagList *)list selectedTag:(DWTagView *)tagView {
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

-(void)tagListPreparedAllTags:(DWTagList *)list {
    if (list == self.xibList) {
        DWTagView *tag = [self.xibList tagWithText:@"and"];
        tag.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        tag.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
        tag.borderColor = [UIColor redColor].CGColor;
    }
}

@end
