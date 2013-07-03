//
//  SRViewController.m
//  DemoApp
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import "SRViewController.h"
#import "SRGridLocation.h"
#import "SRBasicAnnotation.h"

@interface SRViewController () <MKMapViewDelegate>

@end

@implementation SRViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Create a grid coordinate
  SRGridLocationPosition x = 6167342.71;
  SRGridLocationPosition y = 1323289.675;
  SRGridLocationProjection projection = SRGridLocationProjection_RT90_2_5_gon_v;
  SRGridLocationCoordinate gridCoordinate = SRGridLocationCoordinateMake(x, y, projection);
  
  // Convert to GPS coordinate
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DFromSRGridLocationCoordinate(gridCoordinate);
  
  SRBasicAnnotation *annotation = [[SRBasicAnnotation alloc] initWithCoordinate:coordinate];
  [self.mapView addAnnotation:annotation];
  
  self.mapView.region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01));
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  return [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
}

@end
