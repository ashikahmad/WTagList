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
    tagList.alwaysBounceVertical = YES;
    [tagList setAutomaticResize:YES];
    NSArray *array = @[@"Foo",
                       @"Tag Label 1",
                       @"Tag Label 2",
                       @"Tag Label 3",
                       @"Tag Label 4",
                       @"Long long long long long long Tag"];
    [tagList setTags:array];
    [tagList setTagDelegate:self];
    [self.view addSubview:tagList];
    
    // debug
    tagList.layer.borderWidth = 1;
    tagList.layer.borderColor = [UIColor redColor].CGColor;
    
    NSLog(@"%@", NSStringFromCGSize([WTagTheme defaultTheme].textShadowOffset));
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
