//
//  ViewController.m
//  AnimationSample
//
//  Created by chao luo on 3/11/19.
//  Copyright © 2019 chao luo. All rights reserved.
//

#import "ViewController.h"
#import "CLWaveAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CLWaveAnimationView *view = [[CLWaveAnimationView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    view.title = @"RD";
    [self.view addSubview:view];
    
    [view startAnimation];
    
    // git log
    NSLog(@"65efe2611742a910ffcd24ffb05aa2a3c56d20e6 [65efe26]");
    
}


@end
