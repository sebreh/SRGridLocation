//
//  SRGridLocationTests.m
//  SRGridLocationTests
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SRGridLocation.h"

static double const kLatLongTolerance = 1.0e-7;
static double const kGridTolerance = 0.001;

static SRGridLocationCoordinate rt90[4];
static SRGridLocationCoordinate sweref99tm[4];
static CLLocationCoordinate2D latLong[4];

@interface SRGridLocationTests : SenTestCase

@end

@implementation SRGridLocationTests

+ (void)setUp {
	// Test coordinates
	rt90[0] = SRGridLocationCoordinateMake(7453389.762, 1727060.905, SRGridLocationProjection_RT90_2_5_gon_v);
	rt90[1] = SRGridLocationCoordinateMake(7047738.415, 1522128.637, SRGridLocationProjection_RT90_2_5_gon_v);
	rt90[2] = SRGridLocationCoordinateMake(6671665.273, 1441843.186, SRGridLocationProjection_RT90_2_5_gon_v);
	rt90[3] = SRGridLocationCoordinateMake(6249111.351, 1380573.079, SRGridLocationProjection_RT90_2_5_gon_v);
  
	sweref99tm[0] = SRGridLocationCoordinateMake(7454204.638, 761811.242, SRGridLocationProjection_SWEREF_99_tm);
	sweref99tm[1] = SRGridLocationCoordinateMake(7046077.605, 562140.337, SRGridLocationProjection_SWEREF_99_tm);
	sweref99tm[2] = SRGridLocationCoordinateMake(6669189.376, 486557.055, SRGridLocationProjection_SWEREF_99_tm);
	sweref99tm[3] = SRGridLocationCoordinateMake(6246136.458, 430374.835, SRGridLocationProjection_SWEREF_99_tm);
  
	latLong[0] = CLLocationCoordinate2DMake(67 +  5/60.0 + 26.452769/3600, 21 +  2/60.0 +  5.101575/3600);
	latLong[1] = CLLocationCoordinate2DMake(63 + 32/60.0 + 14.761735/3600, 16 + 14/60.0 + 59.594626/3600);
	latLong[2] = CLLocationCoordinate2DMake(60 +  9/60.0 + 33.882413/3600, 14 + 45/60.0 + 28.167152/3600);
	latLong[3] = CLLocationCoordinate2DMake(56 + 21/60.0 + 17.199245/3600, 13 + 52/60.0 + 23.754022/3600);
}

- (void)testRT90GridToGeodetic {
	for (int i = 0; i < 3; i++) {
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DFromSRGridLocationCoordinate(rt90[i]);
    
		STAssertTrue(abs(coordinate.latitude - latLong[i].latitude) < kLatLongTolerance,
                 @"RT90 conversion of x to latitude, expected = %.6f, actual = %.6f",
                 latLong[i].latitude, coordinate.latitude);
		STAssertTrue(abs(coordinate.longitude - latLong[i].longitude) < kLatLongTolerance,
                 @"RT90 conversion of y to longitude, expected = %.6f, actual = %.6f",
                 latLong[i].longitude, coordinate.longitude);
	}
}

- (void)testRT90GeodeticToGrid {
	for (int i = 0; i < 3; i++) {
		SRGridLocationCoordinate coordinate = SRGridLocationCoordinateFromCLLocationCoordinate2D(latLong[i], SRGridLocationProjection_RT90_2_5_gon_v);
    
		STAssertTrue(abs(coordinate.x - rt90[i].x) < kGridTolerance,
                 @"RT90 conversion of latitude to x, expected = %.6f, actual = %.6f",
                 rt90[i].x, coordinate.x);
		STAssertTrue(abs(coordinate.y - rt90[i].y) < kGridTolerance,
                 @"RT90 conversion of longitude to y, expected = %.6f, actual = %.6f",
                 rt90[i].y, coordinate.y);
	}
}

- (void)testSWEREF99TMGridToGeodetic {
	for (int i = 0; i < 3; i++) {
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DFromSRGridLocationCoordinate(sweref99tm[i]);
    
		STAssertTrue(abs(coordinate.latitude - latLong[i].latitude) < kLatLongTolerance,
                 @"SWEREF99TM conversion of x to latitude, expected = %.6f, actual = %.6f",
                 latLong[i].latitude, coordinate.latitude);
		STAssertTrue(abs(coordinate.longitude - latLong[i].longitude) < kLatLongTolerance,
                 @"SWEREF99TM conversion of y to longitude, expected = %.6f, actual = %.6f",
                 latLong[i].longitude, coordinate.longitude);
	}
}

- (void)testSWEREF99TMGeodeticToGrid {
	for (int i = 0; i < 3; i++) {
		SRGridLocationCoordinate coordinate = SRGridLocationCoordinateFromCLLocationCoordinate2D(latLong[i], SRGridLocationProjection_SWEREF_99_tm);
    
		STAssertTrue(abs(coordinate.x - sweref99tm[i].x) < kGridTolerance,
                 @"SWEREF99TM conversion of latitude to x, expected = %.6f, actual = %.6f",
                 sweref99tm[i].x, coordinate.x);
		STAssertTrue(abs(coordinate.y - sweref99tm[i].y) < kGridTolerance,
                 @"SWEREF99TM conversion of longitude to y, expected = %.6f, actual = %.6f", 
                 sweref99tm[i].y, coordinate.y);
	}
}

@end
