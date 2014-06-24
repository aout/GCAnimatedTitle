//
//  ViewController.m
//  AnimatedTitle
//
//  Created by Guillaume CASTELLANA on 19/6/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.titleBar createLabelsFromTitles: @[@"Intercom", @"Inbox", @"Important", @"Upcoming"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didChangeSliderValue:(UISlider*)sender
{
    [self.titleBar scrollTo:sender.value];
}

@end
