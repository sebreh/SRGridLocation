//
//  CLLocation+SRGridLocation.m
//  Transit
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import "CLLocation+SRGridLocation.h"

@implementation CLLocation (SRGridLocation)

- (id)sr_locationWithX:(SRGridLocationPosition)x y:(SRGridLocationPosition)y projection:(SRGridLocationProjection)projection {
	SRGridLocationCoordinate coordinate = SRGridLocationCoordinateMake(x, y, projection);
	CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DFromSRGridLocationCoordinate(coordinate);
	
	return [self initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
};

@end
