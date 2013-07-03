//
//  SRBasicAnnotation.m
//  DemoApp
//
//  Created by Sebastian Rehnby on 7/3/13.
//  Copyright (c) 2013 Sebastian Rehnby. All rights reserved.
//

#import "SRBasicAnnotation.h"

@implementation SRBasicAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
  self = [super init];
  if (self) {
    _coordinate = coordinate;
  }
  return self;
}

@end
