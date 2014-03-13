# ANBlurredTableView

ANBlurredTableView is a simple UITableView subclass for blurring and tinting a background image on scroll.

**Supports:** 
- Blur-out on scroll down, blur-in on scroll up.
- Custom tint color.
- Animating between two different alphas (as seen in gif).
- Variable lengths for scrolling.

![Example Image](https://github.com/aaronn/ANBlurredTableView/blob/master/Images/scroll.gif?raw=true)

**Follow me on Twitter at [@aaronykng](http://www.twitter.com/aaronykng) for more cocoa classes, apps and more!**

## Installation

### Manual Installation
**Add QuartzCore.framework and Accelerate.framework to your project.** Drag the following files into your project:

    ANBlurredTableView.h
    ANBlurredTableView.m
    UIImage+BoxBlur.h
    UIImage+BoxBlur.m

## Usage
Tweak the following properties to customize your ANBlurredTableView.

    // Our tint color. If one isn't specified, it'll default to clear. We call this blurTintColor to avoid collisions with iOS's own tintColor.
    @property (strong) UIColor *blurTintColor;
    
    // Animates the tint opacity from the startOpacity to endOpacity.
    @property (assign) BOOL animateTintAlpha;
    
    // The opacity to start animating at. Only is used if animateOpacity is True.
    @property (assign) CGFloat startTintAlpha;
    
    //The opacity to end animating at. Only used if animateOpacity is True
    @property (assign) CGFloat endTintAlpha;
    
    // A CGFloat of how many seconds total it should take to animate our blur in, if animateOnLoad is YES.
    @property (assign) CGFloat animationDuration;
    
    // Our default number of frames. Make larger with a higher rounding value to make the scroll last longer.
     // Defaults to 20.
    @property (assign) NSInteger framesCount;
    
     //Our default rounding value. Make larger to make the scroll last longer. Needs an adequate # of frames.
     //Defaults to 8.0 (Magic number!)
    @property (assign) CGFloat roundingValue;

    //Our default compression quality. Set to higher if it's negatively impacting your background quality.
    @property (assign) CGFloat compressionQuality;

Check out the header files for a more detailed look at each property.

After setting each property, simply set the background image:

    [_tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"];
    
ANBlurredTableView will take care of the rest in the background once the image has been set. 

On slower devices, ANBlurredTableView will blur-in once everything is finished rendering.
    
## Demo
The demo shows an ANBlurredTableView that blurs-in and out from a dark grey with an alpha of 0.35 to an alpha of 0.75 as you scroll down. If you're on a slower device, you may see the blur animate-in to your current contentOffset when rendering completes.

Consider setting animateTintAlpha to NO, or changing the blurTintColor to test out various features in ANBlurredTableView.

## To Do
- Cocoapods
- Considering a method for changing the background image after one has already loaded. Should pre-render in the background before swapping out.
- Shrink the gif to <4MB.

## Credits
The image box blur algorithm is from [IndieAmbitions Blog](http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29). UIImage category is modified from [ios-relatimeblur](https://github.com/alexdrone/ios-realtimeblur). 

**Follow me on Twitter at [@aaronykng](http://www.twitter.com/aaronykng).**

## License
Do whatever you’d like. I’d really appreciate it if you mentioned me and link back if you use this in a project though!
