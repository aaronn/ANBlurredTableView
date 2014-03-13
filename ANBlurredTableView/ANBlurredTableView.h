//
//  ANBlurredTableView.h
//  Persona
//
//  Created by Aaron Ng (@aaronykng) on 2/22/14.
//  Copyright (c) 2014 Delve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANBlurredTableView : UITableView


/**
 backgroundImage is our base image.
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 backgroundImageView inserts itself into the tableView's backgroundView.
 backgroundImageView changes its' image on scroll to show the blur.
 */
@property (strong) UIImageView *backgroundImageView;

/**
 Our array of blurred frames.
 */
@property (strong) NSMutableArray *frames;


/**
 Our default number of frames. Make larger with a higher rounding value to make the scroll last longer.
 Defaults to 20.
 */
@property (assign) NSInteger framesCount;

/**
 Our default compression quality. Set to higher if it's negatively impacting your background quality.
 Defaults to 0.001f
 */
@property (assign) CGFloat compressionQuality;

/**
 Our default rounding value. Make larger to make the scroll last longer. Needs an adequate # of frames.
 Defaults to 8.0 (Magic number!)
 */
@property (assign) CGFloat roundingValue;

/**
 Our tint color. If one isn't specified, it'll default to clear. We call this blurTintColor to avoid collisions with iOS's own tintColor.
 */
@property (strong) UIColor *blurTintColor;

/**
 Animates the tint opacity from the startOpacity to endOpacity.
 Hijacks the existing alpha on the tintColor.
 Does not currently support HSL colors.
 
 HIGHLY EXPERIMENTAL.
 */
@property (assign) BOOL animateTintAlpha;

/**
 Only is used if animateOpacity is True
 The opacity to start animating at.
 Defaults to 0;
 */
@property (assign) CGFloat startTintAlpha;

/**
 Only used if animateOpacity is True
 The opacity to end animating at.
 Defaults to 0.5f
 */
@property (assign) CGFloat endTintAlpha;

/**
 A boolean value for checking whether or not our frames are done processing.
 */
@property (assign) BOOL rendering;

/**
 Set this to yes if you'd like the blur amount to be animated in once the frames finish rendering. Set to NO to prevent this.
 Defaults to YES. Set to NO to disable the blur-in animation.
 */
@property (assign) BOOL animateOnLoad;


/**
 A CGFloat of how many seconds total it should take to animate our blur in, if animateOnLoad is YES.
 Default is 0.25.
 */
@property (assign) CGFloat animationDuration;


@end
