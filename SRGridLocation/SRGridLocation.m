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

#import "SRGridLocation.h"

// Projection parameters
typedef struct {
	double axis;            // Semi-major axis of the ellipsoid
	double flattening;      // Flattening of the ellipsoid
	double centralMeridian; // Central meridian for the projection
	double scale;           // Scale on central meridian
	double falseNorthing;   // Offset for origo
	double falseEasting;    // Offset for origo
} SRGridLocationProjectionParameters;

// Forward declarations
SRGridLocationProjectionParameters SRGridLocationProjectionParametersForProjection(SRGridLocationProjection projection);
SRGridLocationProjectionParameters SRGridLocationProjectionParametersMake(double axis, double flattening, double centralMeridian, double scale, double falseNorthing, double falseEasting);

// GRS 80 ellipsoid
#define SRGridLocationProjectionParametersGRS80 \
  SRGridLocationProjectionParametersMake(6378137.0, 1.0 / 298.257222101, 0, 0, 0, 0)

// Bessel 1841 ellipsoid
#define SRGridLocationProjectionParametersBessel \
  SRGridLocationProjectionParametersMake(6377397.155, 1.0 / 299.1528128, DBL_MIN, 1.0, 0.0, 1500000.0)

// SWEREF99 ellipsoid
#define SRGridLocationProjectionParametersSWEREF99 \
  SRGridLocationProjectionParametersMake(6378137.0, 1.0 / 298.257222101, DBL_MIN, 1.0, 0.0, 150000.0)

#pragma mark - Public

SRGridLocationCoordinate SRGridLocationCoordinateMake(SRGridLocationPosition x, SRGridLocationPosition y, SRGridLocationProjection projection) {
	SRGridLocationCoordinate coordinates = {x,y, projection};
	return coordinates;
}

SRGridLocationCoordinate SRGridLocationCoordinateFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate, SRGridLocationProjection projection) {
	SRGridLocationProjectionParameters params = SRGridLocationProjectionParametersForProjection(projection);
	
	// Define variables
	double e2 = params.flattening * (2.0 - params.flattening);
	double n = params.flattening / (2.0 - params.flattening);
	double a_roof = params.axis / (1.0 + n) * (1.0 + n * n / 4.0 + n * n * n * n / 64.0);
	double A = e2;
	double B = (5.0 * e2 * e2 - e2 * e2 * e2) / 6.0;
	double C = (104.0 * e2 * e2 * e2 - 45.0 * e2 * e2 * e2 * e2) / 120.0;
	double D = (1237.0 * e2 * e2 * e2 * e2) / 1260.0;
	double beta1 = n / 2.0 - 2.0 * n * n / 3.0 + 5.0 * n * n * n / 16.0 + 41.0 * n * n * n * n / 180.0;
	double beta2 = 13.0 * n * n / 48.0 - 3.0 * n * n * n / 5.0 + 557.0 * n * n * n * n / 1440.0;
	double beta3 = 61.0 * n * n * n / 240.0 - 103.0 * n * n * n * n / 140.0;
	double beta4 = 49561.0 * n * n * n * n / 161280.0;
	
	// Convert
	double deg_to_rad = M_PI / 180.0;
	double phi = coordinate.latitude * deg_to_rad;
	double lambda = coordinate.longitude * deg_to_rad;
	double lambda_zero = params.centralMeridian * deg_to_rad;
	
	double phi_star = phi - sin(phi) * cos(phi) * (A +
                                                 B * pow(sin(phi), 2) +
                                                 C * pow(sin(phi), 4) +
                                                 D * pow(sin(phi), 6));
	double delta_lambda = lambda - lambda_zero;
	double xi_prim = atan(tan(phi_star) / cos(delta_lambda));
	double eta_prim = atanh((cos(phi_star) * sin(delta_lambda)));
	SRGridLocationPosition x = params.scale * a_roof * (xi_prim +
                                                      beta1 * sin(2.0 * xi_prim) * cosh(2.0 * eta_prim) +
                                                      beta2 * sin(4.0 * xi_prim) * cosh(4.0 * eta_prim) +
                                                      beta3 * sin(6.0 * xi_prim) * cosh(6.0 * eta_prim) +
                                                      beta4 * sin(8.0 * xi_prim) * cosh(8.0 * eta_prim)) +
  params.falseNorthing;
	SRGridLocationPosition y = params.scale * a_roof * (eta_prim +
                                                      beta1 * cos(2.0 * xi_prim) * sinh(2.0 * eta_prim) +
                                                      beta2 * cos(4.0 * xi_prim) * sinh(4.0 * eta_prim) +
                                                      beta3 * cos(6.0 * xi_prim) * sinh(6.0 * eta_prim) +
                                                      beta4 * cos(8.0 * xi_prim) * sinh(8.0 * eta_prim)) + 
  params.falseEasting;
	x = round(x * 1000.0) / 1000.0;
	y = round(y * 1000.0) / 1000.0;
	
	return SRGridLocationCoordinateMake(x, y, projection);
}

CLLocationCoordinate2D CLLocationCoordinate2DFromSRGridLocationCoordinate(SRGridLocationCoordinate coordinate) {
	SRGridLocationProjectionParameters params = SRGridLocationProjectionParametersForProjection(coordinate.projection);
  
	// Define variables
	double e2 = params.flattening * (2.0 - params.flattening);
	double n = params.flattening / (2.0 - params.flattening);
	double a_roof = params.axis / (1.0 + n) * (1.0 + n * n / 4.0 + n * n * n * n / 64.0);
	double delta1 = n / 2.0 - 2.0 * n * n / 3.0 + 37.0 * n * n * n / 96.0 - n * n * n * n / 360.0;
	double delta2 = n * n / 48.0 + n * n * n / 15.0 - 437.0 * n * n * n * n / 1440.0;
	double delta3 = 17.0 * n * n * n / 480.0 - 37 * n * n * n * n / 840.0;
	double delta4 = 4397.0 * n * n * n * n / 161280.0;
	
	double Astar = e2 + e2 * e2 + e2 * e2 * e2 + e2 * e2 * e2 * e2;
	double Bstar = -(7.0 * e2 * e2 + 17.0 * e2 * e2 * e2 + 30.0 * e2 * e2 * e2 * e2) / 6.0;
	double Cstar = (224.0 * e2 * e2 * e2 + 889.0 * e2 * e2 * e2 * e2) / 120.0;
	double Dstar = -(4279.0 * e2 * e2 * e2 * e2) / 1260.0;
	
	// Convert
	double deg_to_rad = M_PI / 180;
	double lambda_zero = params.centralMeridian * deg_to_rad;
	double xi = (coordinate.x - params.falseNorthing) / (params.scale * a_roof);
	double eta = (coordinate.y - params.falseEasting) / (params.scale * a_roof);
	double xi_prim = xi -
  delta1 * sin(2.0 * xi) * cosh(2.0 * eta) -
  delta2 * sin(4.0 * xi) * cosh(4.0 * eta) -
  delta3 * sin(6.0 * xi) * cosh(6.0 * eta) -
  delta4 * sin(8.0 * xi) * cosh(8.0 * eta);
	double eta_prim = eta -
  delta1 * cos(2.0 * xi) * sinh(2.0 * eta) -
  delta2 * cos(4.0 * xi) * sinh(4.0 * eta) -
  delta3 * cos(6.0 * xi) * sinh(6.0 * eta) -
  delta4 * cos(8.0 * xi) * sinh(8.0 * eta);
	
	double phi_star = asin(sin(xi_prim) / cosh(eta_prim));
	double delta_lambda = atan(sinh(eta_prim) / cos(xi_prim));
	double lon_radian = lambda_zero + delta_lambda;
	double lat_radian = phi_star + sin(phi_star) * cos(phi_star) *
  (Astar +
   Bstar * pow(sin(phi_star), 2) +
   Cstar * pow(sin(phi_star), 4) +
   Dstar * pow(sin(phi_star), 6));
	
	CLLocationDegrees lat = lat_radian * 180.0 / M_PI;
	CLLocationDegrees lon = lon_radian * 180.0 / M_PI;
	
	return CLLocationCoordinate2DMake(lat, lon);
}

#pragma mark - Private

SRGridLocationProjectionParameters SRGridLocationProjectionParametersForProjection(SRGridLocationProjection projection) {
  SRGridLocationProjectionParameters params;
  
	if (projection == SRGridLocationProjection_RT90_7_5_gon_v) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 11.0 + 18.375 / 60.0;
		params.scale = 1.000006000000;
		params.falseNorthing = -667.282;
		params.falseEasting = 1500025.141;
	}
	else if (projection == SRGridLocationProjection_RT90_5_0_gon_v) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 13.0 + 33.376 / 60.0;
		params.scale = 1.000005800000;
		params.falseNorthing = -667.130;
		params.falseEasting = 1500044.695;
	}
	else if (projection == SRGridLocationProjection_RT90_2_5_gon_v) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 15.0 + 48.0 / 60.0 + 22.624306 / 3600.0;
		params.scale = 1.00000561024;
		params.falseNorthing = -667.711;
		params.falseEasting = 1500064.274;
	}
	else if (projection == SRGridLocationProjection_RT90_0_0_gon_v) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 18.0 + 3.378 / 60.0;
		params.scale = 1.000005400000;
		params.falseNorthing = -668.844;
		params.falseEasting = 1500083.521;
	}
	else if (projection == SRGridLocationProjection_RT90_2_5_gon_o) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 20.0 + 18.379 / 60.0;
		params.scale = 1.000005200000;
		params.falseNorthing = -670.706;
		params.falseEasting = 1500102.765;
	}
	else if (projection == SRGridLocationProjection_RT90_5_0_gon_o) {
		params = SRGridLocationProjectionParametersGRS80;
		params.centralMeridian = 22.0 + 33.380 / 60.0;
		params.scale = 1.000004900000;
		params.falseNorthing = -672.557;
		params.falseEasting = 1500121.846;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_7_5_gon_v) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 11.0 + 18.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_5_0_gon_v) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 13.0 + 33.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_2_5_gon_v) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 15.0 + 48.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_0_0_gon_v) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 18.0 + 3.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_2_5_gon_o) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 20.0 + 18.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_Bessel_RT90_5_0_gon_o) {
		params = SRGridLocationProjectionParametersBessel;
		params.centralMeridian = 22.0 + 33.0 / 60.0 + 29.8 / 3600.0;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_tm) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 15.00;
		params.scale = 0.9996;
		params.falseNorthing = 0.0;
		params.falseEasting = 500000.0;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1200) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 12.00;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1330) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 13.50;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1500) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 15.00;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1630) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 16.50;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1800) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 18.00;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1415) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 14.25;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1545) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 15.75;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1715) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 17.25;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_1845) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 18.75;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_2015) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 20.25;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_2145) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 21.75;
	}
	else if (projection == SRGridLocationProjection_SWEREF_99_2315) {
		params = SRGridLocationProjectionParametersSWEREF99;
		params.centralMeridian = 23.25;
	}
	
	return params;
}

SRGridLocationProjectionParameters SRGridLocationProjectionParametersMake(double axis, double flattening, double centralMeridian, double scale, double falseNorthing, double falseEasting) {
	SRGridLocationProjectionParameters params = {axis, flattening, centralMeridian, scale, falseNorthing, falseEasting};
	return params;
}
