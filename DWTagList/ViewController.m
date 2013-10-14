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

- (IBAction)addNewTag:(id)sender {
    NSString *text = self.tagField.text;
    if (text.length) {
        [self.xibList addTag:text];
    }
    self.tagField.text = @"";
    [self removeKeyboard:nil];
}

- (void)selectedTag:(NSString *)tagName{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:[NSString stringWithFormat:@"You tapped tag %@", tagName]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
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
    
    [self.xibList setTags:@[@"Add",
                            @"a",
                            @"scrollView",
                            @"and",
                            @"change class",
                            @"as",
                            @"DWTagList",
                            @"Add tags in code"
                            ]];
    
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

@end
