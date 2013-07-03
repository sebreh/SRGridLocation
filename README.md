# SRGridLocation

SRGridLocation provides a convenient way to convert between Swedish grid and GPS location coordinates.

## Usage

### CocoaPods

Add the following line to your Podfile:

	pod 'SRGridLocation'

And run:

	pod install

### Manual

Manually copy the source files in the SRGridLocation directory into your project.

### Usage

You can include SRGridLocation anywhere by adding the following line at the top of your source file:

	#import <SRGridLocation/SRGridLocation.h>

Then, use the following methods to convert between coordinate types:

	SRGridLocationCoordinate SRGridLocationCoordinateMake(SRGridLocationPosition x, SRGridLocationPosition y, SRGridLocationProjection projection)

	SRGridLocationCoordinate SRGridLocationCoordinateFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate, SRGridLocationProjection projection)

	CLLocationCoordinate2D CLLocationCoordinate2DFromSRGridLocationCoordinate(SRGridLocationCoordinate coordinate)

There is also a convenience category for CLLocation to create one based on a grid coordinate. To include it:

	#import <SRGridLocation/CLLocation+SRGridLocation.h>

Then use it like:

	CLLocation *location = [CLLocation sr_locationWithX:6167342 y:1323289];