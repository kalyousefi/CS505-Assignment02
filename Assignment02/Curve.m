//
//  Bezier.m
//  Assignment02
//
//  Created by Khaled Alyousefi on 9/15/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import "Curve.h"

@implementation Curve

@synthesize pointsInBetween;

- (id)initWithCurveLineBetweenPoint0:(CIVector*) point0 Point1:(CIVector*) point1 Point2: (CIVector*)point2 Point3:(CIVector*)  point3 CurveType:(CurveType) curvetype NumberOfSteps:(double) steps
{
    if (self)
    {
        pointsInBetween = [[NSMutableArray alloc]init];
        NSMutableDictionary *coefficients = [self calculateCoefficientsForCurveType:curvetype Point0:point0 Point1:point1 Point2:point2 Point3:point3];
        [self generatePoints:coefficients CurveType:curvetype NumberOfSteps:steps Point1:point1 Point3:point3];
    }
    return self;
}

-(NSMutableDictionary *) calculateCoefficientsForCurveType:(CurveType)curvetype Point0:(CIVector*) point0 Point1:(CIVector*) point1 Point2: (CIVector*)point2 Point3:(CIVector*)  point3
{
    NSMutableDictionary *c_array = [[NSMutableDictionary alloc]init];
    
    if (curvetype == HermiteType) {
        /*
         P0  = point0
         P1  = point1
         P'0 = point2
         P'1 = point3
         
         C0 = P0
         C1 = P'0
         C2 = -3 P0 + 3P1 -2P'0 -P'1
         C3 = 2P0 -2P1 +P'0 + P'1
         */
        
        [c_array setValue:[NSNumber numberWithFloat:point0.X] forKey:@"C0x"];
        [c_array setValue:[NSNumber numberWithFloat:point0.Y] forKey:@"C0y"];
        [c_array setValue:[NSNumber numberWithFloat:point0.Z] forKey:@"C0z"];
        
        [c_array setValue:[NSNumber numberWithFloat:point2.X] forKey:@"C1x"];
        [c_array setValue:[NSNumber numberWithFloat:point2.Y] forKey:@"C1y"];
        [c_array setValue:[NSNumber numberWithFloat:point2.Z] forKey:@"C1z"];
        
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.X + 3 * point1.X -2 * point2.X - point3.X)] forKey:@"C2x"];
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.Y + 3 * point1.Y -2 * point2.Y - point3.Y)] forKey:@"C2y"];
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.Z + 3 * point1.Z -2 * point2.Z - point3.Z)] forKey:@"C2z"];
        
        [c_array setValue:[NSNumber numberWithFloat:(2 * point0.X - 2 * point1.X + point2.X + point3.X)] forKey:@"C3x"];
        [c_array setValue:[NSNumber numberWithFloat:(2 * point0.Y - 2 * point1.Y + point2.Y + point3.Y)] forKey:@"C3y"];
        [c_array setValue:[NSNumber numberWithFloat:(2 * point0.Z - 2 * point1.Z + point2.Z + point3.Z)] forKey:@"C3z"];
    }
    else if (curvetype == BezierType)
    {
        /*
         C0 = P0
         C1 = -3 P0 + 3 P1
         C2 = 3 P0 - 6 P1 + 3 P2
         C3 = -P0 + 3 P1 - 3 P2 + P3
         */
        [c_array setValue:[NSNumber numberWithFloat:point0.X] forKey:@"C0x"];
        [c_array setValue:[NSNumber numberWithFloat:point0.Y] forKey:@"C0y"];
        [c_array setValue:[NSNumber numberWithFloat:point0.Z] forKey:@"C0z"];
        
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.X + 3 * point1.X)] forKey:@"C1x"];
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.Y + 3 * point1.Y)] forKey:@"C1y"];
        [c_array setValue:[NSNumber numberWithFloat:(-3 * point0.Z + 3 * point1.Z)] forKey:@"C1z"];
        
        [c_array setValue:[NSNumber numberWithFloat:(3 * point0.X - 6 * point1.X + 3 * point2.X)] forKey:@"C2x"];
        [c_array setValue:[NSNumber numberWithFloat:(3 * point0.Y - 6 * point1.Y + 3 * point2.Y)] forKey:@"C2y"];
        [c_array setValue:[NSNumber numberWithFloat:(3 * point0.Z - 6 * point1.Z + 3 * point2.Z)] forKey:@"C2z"];
        
        [c_array setValue:[NSNumber numberWithFloat:(- point0.X + 3 * point1.X - 3 * point2.X + point3.X)] forKey:@"C3x"];
        [c_array setValue:[NSNumber numberWithFloat:(- point0.Y + 3 * point1.Y - 3 * point2.Y + point3.Y)] forKey:@"C3y"];
        [c_array setValue:[NSNumber numberWithFloat:(- point0.Z + 3 * point1.Z - 3 * point2.Z + point3.Z)] forKey:@"C3z"];
    }
    return c_array;
}

- (void)BresenhamLine:(CIVector*) point1 To: (CIVector*) point2
{
    
    //I used the algorthim from this source: java-gaming.org/index.php?topic=24497
    
    int x0 = point1.X;
    int y0 = point1.Y;
    int x1 = point2.X;
    int y1 = point2.Y;
    
    BOOL steep = abs(y1 - y0) > abs(x1 - x0);
    if (steep) {
        int tmp = x0;
        x0 = y0;
        y0 = tmp;
        tmp = x1;
        x1 = y1;
        y1 = tmp;
    }
    if (x0 > x1) {
        int tmp = x0;
        x0 = x1;
        x1 = tmp;
        tmp = y0;
        y0 = y1;
        y1 = tmp;
    }
    int deltax = x1 - x0;
    int deltay = abs(y1 - y0);
    int error = deltax / 2;
    int ystep = -1;
    int y = y0;
    if (y0 < y1)
        ystep = 1;
    for (int x = x0; x <= x1; x++) {
        if (steep){
            [pointsInBetween addObject:[CIVector vectorWithX:y Y:x Z:0.0]];
        }else{
            [pointsInBetween addObject:[CIVector vectorWithX:x Y:y Z:0.0]];
        }
        error -= deltay;
        if (error < 0) {
            y += ystep;
            error += deltax;
        }
    }
}

- (void) generatePoints: (NSMutableDictionary *) C_Array  CurveType:(CurveType) curvetype NumberOfSteps:(double) steps  Point1:(CIVector*)point1 Point3:(CIVector*)point3
{
    NSMutableArray *points = [[NSMutableArray alloc]init];
    
    // Generate Curve points
    // x = C0x + C1x * u + C2x * u * u + C3x * u * u * u
    for (double u=0; u<=1; u+=steps) {
        int x = [[C_Array objectForKey:@"C0x"] intValue] + [[C_Array objectForKey:@"C1x"] intValue] * u +
        [[C_Array objectForKey:@"C2x"] intValue] * u * u + [[C_Array objectForKey:@"C3x"] intValue] * u * u * u;
        int y = [[C_Array objectForKey:@"C0y"] intValue] + [[C_Array objectForKey:@"C1y"] intValue] * u +
        [[C_Array objectForKey:@"C2y"] intValue] * u * u + [[C_Array objectForKey:@"C3y"] intValue] * u * u * u;
        int z = [[C_Array objectForKey:@"C0z"] intValue] + [[C_Array objectForKey:@"C1z"] intValue] * u +
        [[C_Array objectForKey:@"C2z"] intValue] * u * u + [[C_Array objectForKey:@"C3z"] intValue] * u * u * u;
        [points addObject:[CIVector vectorWithX:x Y:y Z:z]];
        
    }
    
    // Draw Bresenham Line between all curve points
    for (int i=0; i<[points count]-1; i++) {
        //CIVector *v1 = [points objectAtIndex:i];
        //CIVector *v2 = [points objectAtIndex:i+1];
        [self BresenhamLine:[points objectAtIndex:i] To:[points objectAtIndex:i+1]];
    }
    
    // Draw the last Bresenham Line to curve's end point
    if      (curvetype == HermiteType)
        [self BresenhamLine:[points objectAtIndex:([points count]-1)] To:point1];
    else if (curvetype == BezierType)
        [self BresenhamLine:[points objectAtIndex:([points count]-1)] To:point3];
}

@end
