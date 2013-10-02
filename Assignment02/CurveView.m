//
//  CurveView.m
//  Assignment02
//
//  Created by Khaled Alyousefi on 9/13/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import "CurveView.h"

@implementation CurveView
{
    int touchCounter;
    UISlider *slider;
    UILabel *stepsLabel;
    CurveType currentCurveType;
    NSString *currentCurveTypeText;
    UIColor *lineColor;
}
@synthesize pointsTouchedArray,curveLine,reset;
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        pointsTouchedArray = [[NSMutableArray alloc] init];
        [self prepareView];
    }
    return self;
}

#pragma mark Genrate Assignment02 png Files

// &&&&&&&&&& CREATE 2 IMAGES: HERMITE CURVE & BEZIER CURVE &&&&&&&&&&
- (void) genrateAssignment02Files
{
    // make Assignment02 Hermite.png Curve
    [self drawCurvePoints:HermiteType NumberOfSteps:0.001
                   Point0:[CIVector vectorWithX:128.0 Y:495.0 Z:0.0]
                   Point1:[CIVector vectorWithX:313.0 Y:493.0 Z:0.0]
                   Point2:[CIVector vectorWithX:12.0  Y:120.0 Z:0.0]
                   Point3:[CIVector vectorWithX:474.0 Y:124.0 Z:0.0]];
    [self createImageWithFileName:@"Assignment02_Hermite.png" Points:curveLine.pointsInBetween];
    
    
    [pointsTouchedArray removeAllObjects];
    
    // make Assignment02 Beizer.png Curve
    [self drawCurvePoints:BezierType NumberOfSteps:0.001
                   Point0:[CIVector vectorWithX:93.0  Y:239.0 Z:0.0]
                   Point1:[CIVector vectorWithX:339.0 Y:249.0 Z:0.0]
                   Point2:[CIVector vectorWithX:207.0 Y:150.0 Z:0.0]
                   Point3:[CIVector vectorWithX:207.0 Y:350.0 Z:0.0]];
    [self createImageWithFileName:@"Assignment02_Bezier.png" Points:curveLine.pointsInBetween];
}

// &&&&&&&&&& CREATE POINTS ARRAY &&&&&&&&&&
- (void) drawCurvePoints:(CurveType) curvetype NumberOfSteps:(double) steps
                  Point0:(CIVector*) point0 Point1: (CIVector*) point1 Point2: (CIVector*)point2 Point3:(CIVector*) point3
{
    if (curvetype == HermiteType) {
        lineColor = [UIColor blueColor];
        currentCurveTypeText = @"Hermite";
        NSLog(@"Hermite");
    }
    else if (curvetype == BezierType)
    {
        lineColor = [UIColor redColor];
        currentCurveTypeText = @"Bezier";
        NSLog(@"Bezier");
    }
    
    [pointsTouchedArray insertObject:point0 atIndex:0];
    [pointsTouchedArray insertObject:point1 atIndex:1];
    [pointsTouchedArray insertObject:point2 atIndex:2];
    [pointsTouchedArray insertObject:point3 atIndex:3];
    
    curveLine = [[Curve alloc]
                 initWithCurveLineBetweenPoint0:[pointsTouchedArray objectAtIndex:0]
                 Point1:[pointsTouchedArray objectAtIndex:1]
                 Point2:[pointsTouchedArray objectAtIndex:2]
                 Point3:[pointsTouchedArray objectAtIndex:3]
                 CurveType: curvetype
                 NumberOfSteps:steps];
    
}

#pragma mark Create png Files

// &&&&&&&&&& DRAWING & CREATING AN IMAGE TO PNG FILE &&&&&&&&&&
- (void)createImageWithFileName:(NSString *) filename Points:(NSMutableArray*)pointsToDrawArray
{
    CIVector *currentVectorPoint;
    
    CGFloat max_x=0;
    CGFloat max_y=0;
    
    // Find Max x & Max y From the points array
    for (int i=0; i<[pointsToDrawArray count]-1; i++) {
        currentVectorPoint = [pointsToDrawArray objectAtIndex:i];
        if (currentVectorPoint.X > max_x) {
            max_x = currentVectorPoint.X;
        }
        if (currentVectorPoint.Y > max_y) {
            max_y = currentVectorPoint.Y;
        }
    }
    
    // Set Width & Height to be equal to (Max x + 10) & (Max y + 10)
    // We can be sure now of taking the best Width & Height for cuuent points array
    CGFloat width  = max_x + 10;
    CGFloat height = max_y + 10;
    CGSize    size = CGSizeMake(width, height);
    
    // Creating image
    NSString *targetPath = [NSString stringWithFormat:@"/Users/khaledalyousefi/Documents/%@",filename];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Write text:(image.info) on the image
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    CGRect rect = CGRectMake(2, 2, width-4, 200);
    [[UIColor blackColor] set];
    CIVector *p0 = [pointsTouchedArray objectAtIndex:0];
    CIVector *p1 = [pointsTouchedArray objectAtIndex:1];
    CIVector *p2 = [pointsTouchedArray objectAtIndex:2];
    CIVector *p3 = [pointsTouchedArray objectAtIndex:3];
    NSString *info = [NSString stringWithFormat:@"%@ info: \n"
                      "Width X Height: %.0f X %.0f\n"
                      "CurveType: %@ \n"
                      "P0= (%.0f,%.0f) \n"
                      "P1= (%.0f,%.0f) \n"
                      "P2= (%.0f,%.0f) \n"
                      "P3= (%.0f,%.0f) \n",
                      filename,width,height,currentCurveTypeText,p0.X,p0.Y,p1.X,p1.Y,p2.X,p2.Y,p3.X,p3.Y];
    
    [info drawInRect:CGRectIntegral(rect) withFont:font];
    
    // Draw the Curve
    [lineColor set];
    for (int i=0; i<[pointsToDrawArray count]-1; i++) {
        currentVectorPoint = [pointsToDrawArray objectAtIndex:i];
        if (((currentVectorPoint.X >= 0) && (currentVectorPoint.X < width) && (currentVectorPoint.Y >= 0) && (currentVectorPoint.Y < height))) {
            CGContextFillRect(context, CGRectMake(currentVectorPoint.X, currentVectorPoint.Y, 3.0, 3.0));
        }
    }
    
    // Write context to uiimage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Write the image to the file
    [UIImagePNGRepresentation(image) writeToFile:targetPath atomically:YES];
}

#pragma mark Prepare the user touch interface

// &&&&&&&&&& PREPARE INTERACTIVE TOUCH SCREEN &&&&&&&&&&
-(void) prepareView
{
    currentCurveType = HermiteType;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(resetArea) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Reset" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 50, 100.0, 50.0);
    [self addSubview:button];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-300, self.frame.size.height-50, 600.0, 10.0)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.001;
    slider.maximumValue = 1.0;
    slider.continuous = YES;
    slider.value = 0.01;
    [self addSubview:slider];
    
    stepsLabel = [[UILabel alloc ] initWithFrame:CGRectMake(250, 57, 200.0, 30.0) ];
    stepsLabel.textColor = [UIColor darkGrayColor];
    stepsLabel.font = [UIFont boldSystemFontOfSize:30];
    [self addSubview:stepsLabel];
    stepsLabel.text = [NSString stringWithFormat: @"u= %.03f", slider.value];
    
    NSArray *curveTypesArray = [NSArray arrayWithObjects: @"Hermite", @"Bezier", nil];
    UISegmentedControl *selectedCurveType = [[UISegmentedControl alloc] initWithItems:curveTypesArray];
    selectedCurveType.frame = CGRectMake(self.bounds.size.width - 270, 50, 250, 50);
    selectedCurveType.segmentedControlStyle = UISegmentedControlStylePlain;
    [selectedCurveType addTarget:self action:@selector(changeCurveType:) forControlEvents:UIControlEventValueChanged];
    selectedCurveType.selectedSegmentIndex = currentCurveType;
    [self addSubview:selectedCurveType];
    
    [self genrateAssignment02Files];
    
    currentCurveType = HermiteType;
}

#pragma mark Touch To Make a point

// &&&&&&&&&& HANDLE TOUCHES &&&&&&&&&&
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // Handle the first four touch by record thier poistions [touch locationInView:self]
    if      (touchCounter == 0)
        [pointsTouchedArray insertObject:[NSValue valueWithCGPoint:[touch locationInView:self]] atIndex:0];
    else if (touchCounter == 1)
        [pointsTouchedArray insertObject:[NSValue valueWithCGPoint:[touch locationInView:self]] atIndex:1];
    else if (touchCounter == 2)
        [pointsTouchedArray insertObject:[NSValue valueWithCGPoint:[touch locationInView:self]] atIndex:2];
    else if (touchCounter == 3)
        [pointsTouchedArray insertObject:[NSValue valueWithCGPoint:[touch locationInView:self]] atIndex:3];
    
    
    if (touchCounter >= 0 && touchCounter <= 3) {
        [pointsTouchedArray addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
        [self setNeedsDisplay];
        touchCounter++;
    }
}

// &&&&&&&&&& DRAW POINT ON SCREEN &&&&&&&&&&
// Make point on the screen when the user touch a place on the screen
- (void) makePoint:(CGPoint)point Label:(NSString *) label
{
    UIButton *PointButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"first.png"];
    [PointButton setBackgroundImage:image forState:UIControlStateNormal];
    [PointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [PointButton setTitle:label forState:UIControlStateNormal];
    [PointButton addTarget:self action:@selector(pointMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    // Print position: (x,y)
    UILabel *coordinatesLabel = [[UILabel alloc ] initWithFrame:CGRectMake(PointButton.frame.origin.x-17, PointButton.frame.origin.y-10, 100.0, 90.0) ];
    coordinatesLabel.textColor = [UIColor blackColor];
    coordinatesLabel.backgroundColor = [UIColor clearColor];
    coordinatesLabel.text = [NSString stringWithFormat: @"(%.0f,%.0f)",point.x,point.y];
    coordinatesLabel.tag = 0;
    
    [PointButton addSubview:coordinatesLabel];
    PointButton.frame = CGRectMake(point.x-10, point.y-10, image.size.width, image.size.height);
    [self addSubview:PointButton];
    
}

#pragma mark Draw Curve
// &&&&&&&&&& CREATE & UPDATE CURVE'S POINTS ARRAY &&&&&&&&&&
- (void)drawRect:(CGRect)rect
{
    if (touchCounter > 0 && touchCounter <= 4) {
        CGPoint point;
        point = [[pointsTouchedArray objectAtIndex:touchCounter-1] CGPointValue];
        [self makePoint: point Label:[NSString stringWithFormat:@"P%d",touchCounter-1]];
        if (touchCounter == 4) {
            touchCounter++;
        }
    }
    if (touchCounter > 4){
        // NSLog(@"Hermite");
        curveLine = [[Curve alloc]
                     initWithCurveLineBetweenPoint0:[CIVector vectorWithCGPoint:[[pointsTouchedArray objectAtIndex:0] CGPointValue]]
                     Point1:[CIVector vectorWithCGPoint:[[pointsTouchedArray objectAtIndex:1] CGPointValue]]
                     Point2:[CIVector vectorWithCGPoint:[[pointsTouchedArray objectAtIndex:2] CGPointValue]]
                     Point3:[CIVector vectorWithCGPoint:[[pointsTouchedArray objectAtIndex:3] CGPointValue]]
                     CurveType: currentCurveType
                     NumberOfSteps:slider.value];
        if (currentCurveType == HermiteType) lineColor = [UIColor blueColor];
        else                                 lineColor = [UIColor redColor];
        
        [self drawCurveLineWithColor:lineColor WithSize:3 PointsInBetween:curveLine.pointsInBetween];
    }
}

// &&&&&&&&&& DRAW CURVE ON SCREEN &&&&&&&&&&
// Draw the curve from the Points Array
- (void) drawCurveLineWithColor: (UIColor *) color WithSize:(int)size PointsInBetween: (NSMutableArray *) points
{
    CGPoint currentPoint;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    for (int i=0; i< points.count; i++) {
        currentPoint = [[points objectAtIndex:i] CGPointValue];
        if (((currentPoint.x >= 0) && (currentPoint.x < self.frame.size.width) && (currentPoint.y >= 0) && (currentPoint.y < self.frame.size.height))) {
            
            CGContextFillEllipseInRect(context, CGRectMake(currentPoint.x, currentPoint.y, size, size));
            
        }
    }
}

#pragma mark Response To User Actions
// &&&&&&&&&& HANDLE USER CHANGES &&&&&&&&&&
- (void) pointMoved:(id) sender withEvent:(UIEvent *) event
{
    UIButton *buttonMoved = sender;
    UILabel *label = [[sender subviews] lastObject];
    UITouch *t = [[event allTouches] anyObject];
    CGPoint currentPosition  = [t locationInView:self];
    
    // Change the point position and print the new poistion
    if      ([buttonMoved.currentTitle isEqual:@"P0"])
        [pointsTouchedArray replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:currentPosition]];
    else if ([buttonMoved.currentTitle isEqual:@"P1"])
        [pointsTouchedArray replaceObjectAtIndex:1 withObject:[NSValue valueWithCGPoint:currentPosition]];
    else if ([buttonMoved.currentTitle isEqual:@"P2"])
        [pointsTouchedArray replaceObjectAtIndex:2 withObject:[NSValue valueWithCGPoint:currentPosition]];
    else if ([buttonMoved.currentTitle isEqual:@"P3"])
        [pointsTouchedArray replaceObjectAtIndex:3 withObject:[NSValue valueWithCGPoint:currentPosition]];
    label.text = [NSString stringWithFormat:@"(%.0f,%.0f)",currentPosition.x,currentPosition.y];
    
    // Center the point
    UIControl *control = sender;
    CGPoint center = control.center;
    CGPoint perviousPosition = [t previousLocationInView:self];
    center.x += currentPosition.x - perviousPosition.x;
    center.y += currentPosition.y - perviousPosition.y;
    control.center = center;
    
    if (touchCounter > 4) {
        [self setNeedsDisplay];
    }
}

-(void) sliderAction:(id) sender
{
    stepsLabel.text = [NSString stringWithFormat:@"u= %.03f",slider.value];
    if (touchCounter > 4) {
        [self setNeedsDisplay];
    }
}

-(void) changeCurveType:(id) segment
{
    UISegmentedControl *aa = segment ;
    currentCurveType = aa.selectedSegmentIndex;
    if (touchCounter > 4) {
        [self setNeedsDisplay];
    }
}

-(void) resetArea
{
    touchCounter = 0;
    [curveLine.pointsInBetween removeAllObjects];
    [self setNeedsDisplay];
    [pointsTouchedArray removeAllObjects];
    
    for(id view in self.subviews ){
        UIButton *button = view;
        if ([view isKindOfClass:[UIButton class]] && ![button.titleLabel.text isEqual:@"Reset"]) {
            [view removeFromSuperview];
        }
    }
}

@end
