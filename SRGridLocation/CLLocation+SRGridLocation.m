//
//  CLLocationGrid is based on the original Javascript code by Arnold Andreasson,
//  available at
//  http://mellifica.se/geodesi/gausskruger.js
//
//  and the SwedishGrid project by ICE House, available at
//  http://github.com/icehouse/swedishgrid
//
//  Copyright (c) 2013 Sebastian Rehnby
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CLLocation+SRGridLocation.h"

@implementation CLLocation (SRGridLocation)

- (id)sr_locationWithX:(SRGridLocationPosition)x y:(SRGridLocationPosition)y projection:(SRGridLocationProjection)projection {
	SRGridLocationCoordinate coordinate = SRGridLocationCoordinateMake(x, y, projection);
	CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DFromSRGridLocationCoordinate(coordinate);
	
	return [self initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
};

@end
