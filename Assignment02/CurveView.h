//
//  CurveView.h
//  Assignment02
//
//  Created by Khaled Alyousefi on 9/15/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Curve.h"

@interface CurveView : UIView
@property (nonatomic) NSMutableArray *pointsTouchedArray;
@property (nonatomic) Curve *curveLine;
@property (strong, nonatomic) UIButton *reset;
@end
