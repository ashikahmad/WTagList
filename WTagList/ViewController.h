//
//  ViewController.h
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTagList.h"

@interface ViewController : UIViewController <WTagListDelegate>
{
    WTagList *tagList;
}

@end
