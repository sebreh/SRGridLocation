//
//  CLLocation+SRGridLocation.h
//  Transit
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SRGridLocation.h"


@interface CLLocation (SRGridLocation)

- (id)sr_locationWithX:(SRGridLocationPosition)x y:(SRGridLocationPosition)y projection:(SRGridLocationProjection)projection;

@end
