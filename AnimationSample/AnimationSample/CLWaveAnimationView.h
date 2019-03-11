//
//  CLWaveAnimationView.h
//  AnimationSample
//
//  Created by chao luo on 3/11/19.
//  Copyright © 2019 chao luo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLWaveAnimationView : UIView

@property(nonatomic) NSString *title;

@property(nonatomic) UIColor *circleBorderColor;
@property(nonatomic) UIColor *normalColor;
@property(nonatomic) UIColor *highlightColor;

- (void)startAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
