//
//  CLWaveAnimationView.m
//  AnimationSample
//
//  Created by chao luo on 3/11/19.
//  Copyright © 2019 chao luo. All rights reserved.
//

#import "CLWaveAnimationView.h"
#import "CLWeakProxy.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface CLWaveAnimationView ()

@property (assign, nonatomic) CGFloat step;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UILabel *backLabel;
@property (strong, nonatomic) UILabel *frontLabel;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (nonatomic) CGFloat radius;

@end

@implementation CLWaveAnimationView

- (void)dealloc {
    // 这里使用了CLWeakProxy 不会造成循环引用
    [_displayLink invalidate];
    _displayLink = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _circleBorderColor = RGB(238, 238, 242);
        _normalColor = [UIColor whiteColor];
        _highlightColor = RGB(65, 148, 229);
        
        _backLabel = [[UILabel alloc] init];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.textColor = self.highlightColor;
        _backLabel.frame = self.bounds;
        [self addSubview:_backLabel];
        
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.fillColor = [UIColor greenColor].CGColor; // Any color but clear will be OK
        _maskLayer.fillRule = kCAFillRuleNonZero; // 填充看边框
        
        _frontLabel = [[UILabel alloc] init];
        _frontLabel.backgroundColor = self.highlightColor;
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        _frontLabel.textColor = self.normalColor;
        _frontLabel.layer.mask = _maskLayer;
        _frontLabel.frame = self.bounds;
        [self addSubview:_frontLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _backLabel.text = self.title;
    _frontLabel.text = self.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect centerRect = [self centerRect:self.frame];
    _radius = centerRect.size.width / 2;

    _backLabel.frame = centerRect;
    _frontLabel.frame = centerRect;
    _maskLayer.frame = self.backLabel.bounds;
    
    _backLabel.font = [UIFont systemFontOfSize:centerRect.size.width * 0.6];
    _frontLabel.font = self.backLabel.font;
    
    self.frontLabel.layer.cornerRadius = self.radius;
    self.frontLabel.layer.masksToBounds = YES;
}

- (CGRect)centerRect:(CGRect)rect {
    CGFloat min = MIN(rect.size.width, rect.size.height);
    return CGRectMake((rect.size.width-min)/2, (rect.size.height-min)/2, min, min);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing circle path
    CGRect centerRect = [self centerRect:rect];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPathRef circlePathRef = CGPathCreateWithRoundedRect(centerRect, self.radius, self.radius, NULL);
    CGContextAddPath(contextRef, circlePathRef);
    CGPathRelease(circlePathRef);
    CGContextSetLineWidth(contextRef, 1);
    CGContextSetStrokeColorWithColor(contextRef, self.circleBorderColor.CGColor);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (void)startAnimation {
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:[CLWeakProxy proxyWithTarget:self] selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)update {
    CGRect rect = self.maskLayer.bounds;
    CGFloat y = rect.size.height/2;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, y);
    // M_PI = 3.1415 sin(PI/2) = 1
    for (float x = 0.0f; x <=  rect.size.width ; x++) {
        CGFloat radianUnit = (2 * M_PI) / rect.size.width; // (2*M_PI)为正弦波的一个波动周期 rect.size.width则是屏幕上一个波显示的宽度， 从而计算出一个逻辑像素点表示的弧度大小
        y = 30 * sin(1 * radianUnit * x + self.step) + rect.size.height * 0.5;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path, NULL, 0, rect.size.height);
    CGPathCloseSubpath(path);
    self.maskLayer.path = path;
    CGPathRelease(path);
    self.step = self.step + 0.04;
}

@end
