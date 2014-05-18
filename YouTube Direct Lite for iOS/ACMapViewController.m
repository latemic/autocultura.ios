//
//  ACMapViewController.m
//  autocultura
//
//  Created by Denys Nikolayenko on 5/18/14.
//  Copyright (c) 2014 ___AUTOCULTURA___. All rights reserved.
//

#import "ACMapViewController.h"
#import "INTULocationManager.h"
#import "ACDetailsViewController.h"

@interface ACMapViewController ()
{
    MKPointAnnotation *_annotation;
    NSInteger _locationRequestID;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ACMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D kyivCoordinate;
	kyivCoordinate.latitude = 50.45;
    kyivCoordinate.longitude = 30.52;
    
    _annotation = [MKPointAnnotation alloc];
    _annotation.title = @"Местоположение";
    _annotation.coordinate = kyivCoordinate;
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    _locationRequestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                                                timeout:15.0f
                                                   delayUntilAuthorized:YES
                                                                  block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                                      if (status == INTULocationStatusSuccess) {
                                                                          // Set pin with the current   location on the map
                                                                          [_annotation setCoordinate:currentLocation.coordinate];
                                                                          MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800.0, 800.0);
                                                                          [self.mapView setRegion:userLocation animated:YES];
                                                                      }
                                                                      
                                                                      [self.mapView addAnnotation:_annotation];
                                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	_annotation.subtitle = [NSString	stringWithFormat:@"%f %f", _annotation.coordinate.latitude, _annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		MKPointAnnotation *annotation = (MKPointAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
	}
	
	static NSString * const kPinAnnotationIdentifier = @"loc";
	MKPinAnnotationView *draggablePinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
        draggablePinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
        draggablePinView.pinColor = MKPinAnnotationColorPurple;
        draggablePinView.draggable = TRUE;
        draggablePinView.canShowCallout = TRUE;
	}
	
	return draggablePinView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"pushDetailsViewControllerSegue"]) {
        ((ACDetailsViewController *)segue.destinationViewController).videoURL = self.videoURL;
        ((ACDetailsViewController *)segue.destinationViewController).youtubeService = self.youtubeService;
    }
}


@end
