DWTagList
=========

Create a list of tags from an NSArray to be show in a view with customisable fonts, colors etc.

![preview](http://f.cl.ly/items/1k3K1i0w2b1d1M0O1w1G/DWTagList.png "Preview")

## Installation

Simple copy over `DWTagList.h` and `DWTagList.m` into your project and make sure you have linked the framework `QuartzCore.framework`.

You may then add tags to your view by the following lines of code:

    // Initalise and set the frame of the tag list
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 280.0f, 300.0f)];
    
    // Add the items to the array
    NSArray *array = [[NSArray alloc] initWithObjects:@"Foo", @"Tag Label 1", @"Tag Label 2", @"Tag Label 3", @"Tag Label 4", @"Tag Label 5", nil];
    [tagList setTags:array];
    
    // Add the taglist to your UIView
    [self.view addSubview:tagList];

## Customisation

In `DWTagList.m` there are a number of customisable options to change the layout and the aesthetics of the tags:

    #define CORNER_RADIUS 10.0f
    #define LABEL_MARGIN 5.0f
    #define BOTTOM_MARGIN 5.0f
    #define FONT_SIZE 13.0f
    #define HORIZONTAL_PADDING 7.0f
    #define VERTICAL_PADDING 3.0f
    #define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
    #define TEXT_COLOR [UIColor blackColor]
    #define TEXT_SHADOW_COLOR [UIColor whiteColor]
    #define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
    #define BORDER_COLOR [UIColor lightGrayColor].CGColor
    #define BORDER_WIDTH 1.0f
    #define DEFAULT_AUTOMATIC_RESIZE NO

NOTE: In the future, these will be added as methods that can be used to customise the tags after initialisation.

## License

I have included the license in the `LICENSE` file. I've got it as the MIT license, mainly because I want people to do what they want with this library.

If you do something cool, or find any problems, please create a pull request and I will look at including any of your changes into this project.
