//
//  Curve.h
//  Assignment02
//
//  Created by Khaled Alyousefi on 9/15/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, CurveType) {
    HermiteType,
    BezierType
};

@interface Curve : NSObject
@property (nonatomic) NSMutableArray *pointsInBetween;

- (id)initWithCurveLineBetweenPoint0:(CIVector*) point0 Point1: (CIVector*) point1 Point2: (CIVector*)point2 Point3:(CIVector*) point3 CurveType:(CurveType) curvetype NumberOfSteps:(double) steps;
@end
