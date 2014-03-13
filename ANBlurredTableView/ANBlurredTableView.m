//
//  ANBlurredTableView.m
//  Persona
//
//  Created by Aaron Ng (@aaronykng) on 2/22/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import "ANBlurredTableView.h"
#import "UIImage+BoxBlur.h"

#define DEFAULT_COMPRESSION_QUALITY 0.001
#define DEFAULT_FRAMES_COUNT 20
#define DEFAULT_ROUNDING_VALUE 8.0
#define DEFAULT_TINT_COLOR [UIColor clearColor]
#define DEFAULT_TINT_ALPHA_START 0.0
#define DEFAULT_TINT_ALPHA_END 0.5
#define DEFAULT_ANIMATION_DURATION 0.25


@implementation ANBlurredTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        // Initialization code
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    // Default of 20 total frames for blurring.
    if (!_framesCount)
    {_framesCount = DEFAULT_FRAMES_COUNT;}
    
    // Default tint color if one doesn't exist.
    if (!_blurTintColor)
    {_blurTintColor = DEFAULT_TINT_COLOR;}
    
    // Default rounding value of 8
    if (!_roundingValue)
    {_roundingValue = DEFAULT_ROUNDING_VALUE;}
    
    // Revert to a default compression quality of 0.001f for performance reasons.
    if (!_compressionQuality)
    {_compressionQuality = DEFAULT_COMPRESSION_QUALITY;}
    
    // If we have animateOnLoad as YES, default animation duration is 0.25s
    if (!_animationDuration)
    {_animationDuration = DEFAULT_ANIMATION_DURATION;}
    
    // Process our opacity if animateOpacity is on.
    if (_animateTintAlpha)
    {
        // Only allow numbers between 0 and 1. Defaults to 0 if broken.
        if (_startTintAlpha < 0.0 || _startTintAlpha > 1.0)
        {_startTintAlpha = 0.0;}
        
        // Only allow numbers between 0 and 1. Defaults to 1 if broken.
        else if (_endTintAlpha < 0.0 || _endTintAlpha > 1.0)
        {_endTintAlpha = 1.0;}
    }
    
    // Blur in our background if the user has called the tableView before the frames have finished processing.
    _animateOnLoad = YES;
    
}


-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    // Prepare layout sets the correct backgroundImageView and prepares the view to be manipulated.
    [self prepareLayout];
}


#pragma mark -
#pragma mark Helper Methods

-(UIImage*)downsampleImage:(UIImage*)image
{
    // Downsample our image.
    NSData *imageData = UIImageJPEGRepresentation(image, _compressionQuality);
    UIImage *downSampledImage = [UIImage imageWithData:imageData];
    return downSampledImage;
}


-(void)prepareLayout
{
    // Make sure the background color of the tableView itself is clear so that the image is visible.
    [self setBackgroundColor:[UIColor clearColor]];
    
    // Set the tableView's backgroundView as a UIImageView that is the size of the frame.
    _backgroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.backgroundView = _backgroundImageView;

    // set the background color to the tableView's default background color.
    // We do this instead of setting the backgroundColor for the user by default to allow for flexibility if the user decides to layer transparent views, etc.
    [_backgroundImageView setBackgroundColor:self.backgroundColor];
    
    // Set up our defaults.
    // Clear our our array.
    _frames = [[NSMutableArray alloc]init];
    
    // Generate blur frames if a background is available.
    if (_backgroundImage)
    {
        UIColor *processedTint = _blurTintColor;
        // Start with startTint instead of the tintColor's alpha if animateTint is active.
        if(_animateTintAlpha)
        {processedTint = [_blurTintColor colorWithAlphaComponent:_startTintAlpha];}
        
        // Generate our first frame.
        UIImage *firstFrame = [_backgroundImage drn_boxblurImageWithBlur:0.0 withTintColor:processedTint];
        // Add our first frame to the array.
        [_frames addObject:firstFrame];
        [_backgroundImageView setImage:firstFrame];
        
        // Disable scroll blurring while rendering frames.
        _rendering = YES;
        [self renderBlurFramesWithCompletion:^{
            
            // Animate in on completion.
            if (_animateOnLoad){
                CGFloat currentOffset = self.contentOffset.y;
                for (int i = 0; i < (int)currentOffset; i++)
                {
                    // This slows down our loop.
                    [NSThread sleepForTimeInterval:_animationDuration/currentOffset];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        {[self updateBackgroundBlurWithVerticalContentOffset:i];
                        }
                    });
                }
            }
            // Done rendering. Re-enable scroll bluring.
            _rendering = NO;
        }];
    }
}

#pragma mark -
#pragma mark Generate Animations
-(void)renderBlurFramesWithCompletion:(void(^)())completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Generate our frames in the background-- since our frames aren't generated immediately you'll want to use this to customize how the background comes in.
        [self renderBlurFrames];
        completion();
    });
}

//  You probably don't want to call this by itself.

-(void)renderBlurFrames
{

    // Generate a downsampled image to process.
    UIImage *downsampledImage = [self downsampleImage:_backgroundImage];
    
    // Used to step our alpha up if animating tintAlpha.
    CGFloat i = _startTintAlpha;
    CGFloat difference = _endTintAlpha - _startTintAlpha;
    
    // If animating tintAlpha, step up alpha by the difference over the framesCount.
    CGFloat incrementBy = difference / (CGFloat)_framesCount;
    
    // Generate our frames based on the number of frames allowed.
    // We set our first frame earlier to preserve image fidelity. This is 1 and up.
    for(int frame = 1; frame < _framesCount; frame++)
    {
        // The color we'll use to tint with, changing if animate is on.
        UIColor *processColor = _blurTintColor;
        
        // If animating our tintAlpha, set the processColor's alpha to the startAlpha.
        if (_animateTintAlpha){
            // Increment by our incrementBy.
            i = i + incrementBy;
            processColor = [_blurTintColor colorWithAlphaComponent:i];
        }
        
            // Blur with specified tint color.
            UIImage *image = [downsampledImage drn_boxblurImageWithBlur:((CGFloat)frame/(_framesCount-1)) withTintColor:processColor];
            
            // add to our frames array.
            [_frames addObject:image];
    }
}

#pragma mark -
#pragma mark Observers

-(void)setContentOffset:(CGPoint)contentOffset
{
    // Watch the contentOffset to determine the image to show in the background.
    [super setContentOffset:contentOffset];
    // Update our backgroundBlur on scroll.
    if (!_rendering)
    {[self updateBackgroundBlurWithVerticalContentOffset:contentOffset.y];}
}

#pragma mark -
#pragma mark UI Code

-(void)updateBackgroundBlurWithVerticalContentOffset:(CGFloat)contentOffset
{
    
    // Our current frame is based on our offset being lowered by a rounding value.
    NSInteger frame = (int)(contentOffset/_roundingValue);
    
    // If that value is lower than 0 or over the maximum, ignore it.
    if (frame < 0)
    {frame = 0;}
    else if (frame >= _framesCount)
    {frame = _framesCount - 1;}
    
    // Calculate blur based on the contentOffset.y. The more frames we have and the larger the rounding value, the further the blur lasts.
    //UIImage *image = [_frames objectAtIndex:frame];
    [_backgroundImageView setImage:[_frames objectAtIndex:frame]];
}


@end
