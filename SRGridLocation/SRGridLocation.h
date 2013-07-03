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