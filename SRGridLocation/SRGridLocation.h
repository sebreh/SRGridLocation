//
//  SRGridLocation.h
//  Transit
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

// Projections
typedef NS_ENUM(NSUInteger, SRGridLocationProjection) {
	SRGridLocationProjection_RT90_7_5_gon_v = 0,
	SRGridLocationProjection_RT90_5_0_gon_v = 1,
	SRGridLocationProjection_RT90_2_5_gon_v = 2,
	SRGridLocationProjection_RT90_0_0_gon_v = 3,
	SRGridLocationProjection_RT90_2_5_gon_o = 4,
	SRGridLocationProjection_RT90_5_0_gon_o = 5,
	SRGridLocationProjection_Bessel_RT90_7_5_gon_v = 6,
	SRGridLocationProjection_Bessel_RT90_5_0_gon_v = 7,
	SRGridLocationProjection_Bessel_RT90_2_5_gon_v = 8,
	SRGridLocationProjection_Bessel_RT90_0_0_gon_v = 9,
	SRGridLocationProjection_Bessel_RT90_2_5_gon_o = 10,
	SRGridLocationProjection_Bessel_RT90_5_0_gon_o = 11,
	SRGridLocationProjection_SWEREF_99_tm = 12,
	SRGridLocationProjection_SWEREF_99_1200 = 13,
	SRGridLocationProjection_SWEREF_99_1330 = 14,
	SRGridLocationProjection_SWEREF_99_1500 = 15,
	SRGridLocationProjection_SWEREF_99_1630 = 16,
	SRGridLocationProjection_SWEREF_99_1800 = 17,
	SRGridLocationProjection_SWEREF_99_1415 = 18,
	SRGridLocationProjection_SWEREF_99_1545 = 19,
	SRGridLocationProjection_SWEREF_99_1715 = 20,
	SRGridLocationProjection_SWEREF_99_1845 = 21,
	SRGridLocationProjection_SWEREF_99_2015 = 22,
	SRGridLocationProjection_SWEREF_99_2145 = 23,
	SRGridLocationProjection_SWEREF_99_2315 = 24,
};

// An a position on a grid axis
typedef double SRGridLocationPosition;

// A coordinate (x,y) in a grid system
typedef struct {
	SRGridLocationPosition x;
	SRGridLocationPosition y;
  SRGridLocationProjection projection;
} SRGridLocationCoordinate;

SRGridLocationCoordinate SRGridLocationCoordinateMake(SRGridLocationPosition x, SRGridLocationPosition y, SRGridLocationProjection projection);

// Convert
SRGridLocationCoordinate SRGridLocationCoordinateFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate, SRGridLocationProjection projection);
CLLocationCoordinate2D CLLocationCoordinate2DFromSRGridLocationCoordinate(SRGridLocationCoordinate coordinate);