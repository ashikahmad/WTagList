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

@end

@implementation ViewController

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
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 200.0f, 50.0f)];
    NSArray *array = @[@"Foo",
                       @"Tag Label 1",
                       @"Tag Label 2",
                       @"Tag Label 3",
                       @"Tag Label 4",
                       @"Long long long long long long Tag"];
    [tagList setTags:array];
    tagList.automaticResize = YES;
    tagList.layoutType = DWTagLayoutHorizontal;
    [tagList setTagDelegate:self];
    [self.view addSubview:tagList];
    
    // debug
    tagList.layer.borderWidth = 1;
    tagList.layer.borderColor = [UIColor redColor].CGColor;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Horizontal" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSLog(@"%@", NSStringFromCGSize([WTagTheme defaultTheme].textShadowOffset));
}

-(void) changeLayout:(id) sender {
    if (tagList.layoutType == DWTagLayoutFlow) {
        tagList.layoutType = DWTagLayoutHorizontal;
        [btn setTitle:@"Horizontal" forState:UIControlStateNormal];
    } else if (tagList.layoutType == DWTagLayoutHorizontal) {
        tagList.layoutType = DWTagLayoutVertical;
        [btn setTitle:@"Vertical" forState:UIControlStateNormal];
    } else if (tagList.layoutType == DWTagLayoutVertical) {
        tagList.layoutType = DWTagLayoutFlow;
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
