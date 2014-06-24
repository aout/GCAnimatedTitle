//
//  ViewController.h
//  AnimatedTitle
//
//  Created by Guillaume CASTELLANA on 19/6/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCAnimatedTitle.h"

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet GCAnimatedTitle* titleBar;
@property (nonatomic, weak) IBOutlet UISlider* progressSlider;

@end
