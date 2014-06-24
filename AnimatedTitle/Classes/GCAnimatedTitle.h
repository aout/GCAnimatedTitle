//
//  GCAnimatedTitle.h
//  GCAnimatedTitle
//
//  Created by Guillaume CASTELLANA on 19/6/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAnimatedTitle : UIView

- (void) createLabelsFromTitles:(NSArray*)titles;

- (void) scrollTo:(float)progress;

@end
