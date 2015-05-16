#import "MGLUserLocationAnnotationView.h"

#import "MGLUserLocation.h"
#import "MGLUserLocation_Private.h"
#import "MGLAnnotation.h"
#import "MGLMapView.h"

const CGFloat MGLTrackingDotRingWidth = 24.0;

@interface MGLUserLocationAnnotationView ()

@property (nonatomic, readwrite) CALayer *haloLayer;

@end

#pragma mark -

@implementation MGLUserLocationAnnotationView
{
    CALayer *_accuracyRingLayer;
    CALayer *_dotBorderLayer;
    CALayer *_dotLayer;
}

- (instancetype)initInMapView:(MGLMapView *)mapView
{
    if (self = [super initWithFrame:CGRectMake(0, 0, MGLTrackingDotRingWidth, MGLTrackingDotRingWidth)])
    {
        self.annotation = [[MGLUserLocation alloc] init];
        self.annotation.mapView = mapView;
        _mapView = mapView;
        [self setupLayers];
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;
    }
    return self;
}

- (NSString *)accessibilityLabel
{
    return self.annotation.title;
}

- (NSString *)accessibilityValue
{
    if (self.annotation.subtitle)
    {
        return self.annotation.subtitle;
    }
    
    CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
    CLLocationDegrees latDeg = fabs(centerCoordinate.latitude);
    NSString *latDir = centerCoordinate.latitude > 0 ? @"north" : @"south";
    CLLocationDegrees lonDeg = fabs(centerCoordinate.longitude);
    NSString *lonDir = centerCoordinate.longitude > 0 ? @"east" : @"west";
    
    if (self.mapView.zoomLevel > 8) {
        // Each arcsecond is about 30 m, too small for even high zoom levels.
        CLLocationDegrees latMin = round(fmod(latDeg, 1) * 60);
        CLLocationDegrees lonMin = round(fmod(lonDeg, 1) * 60);
        return [NSString stringWithFormat:
                @"%i degree%@ %i minute%@ %@, and %i degree%@ %i minute%@ %@",
                (int)latDeg, latDeg == 1 ? @"" : @"s",
                (int)latMin, latMin == 1 ? @"" : @"s", latDir,
                (int)lonDeg, lonDeg == 1 ? @"" : @"s",
                (int)lonMin, lonMin == 1 ? @"" : @"s", lonDir];
    } else {
        // Each arcminute is about 1 nmi, too small for low zoom levels.
        latDeg = round(latDeg);
        lonDeg = round(lonDeg);
        return [NSString stringWithFormat:@"%i degree%@ %@ and %i degree%@ %@",
                (int)latDeg, latDeg == 1 ? @"" : @"s", latDir,
                (int)lonDeg, lonDeg == 1 ? @"" : @"s", lonDir];
    }
}

- (CGRect)accessibilityFrame
{
    return CGRectInset(self.frame, -15, -15);
}

- (UIBezierPath *)accessibilityPath
{
    return [UIBezierPath bezierPathWithOvalInRect:self.frame];
}

- (void)setTintColor:(UIColor *)tintColor
{
    UIImage *trackingDotHaloImage = [self trackingDotHaloImage];
    _haloLayer.bounds = CGRectMake(0, 0, trackingDotHaloImage.size.width, trackingDotHaloImage.size.height);
    _haloLayer.contents = (__bridge id)[trackingDotHaloImage CGImage];
    
    UIImage *dotImage = [self dotImage];
    _dotLayer.bounds = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
    _dotLayer.contents = (__bridge id)[dotImage CGImage];
}

- (void)setupLayers
{
    if (CLLocationCoordinate2DIsValid(self.annotation.coordinate))
    {
        if ( ! _accuracyRingLayer && self.annotation.location.horizontalAccuracy)
        {
            UIImage *accuracyRingImage = [self accuracyRingImage];
            _accuracyRingLayer = [CALayer layer];
            _haloLayer.bounds = CGRectMake(0, 0, accuracyRingImage.size.width, accuracyRingImage.size.height);
            _haloLayer.contents = (__bridge id)[accuracyRingImage CGImage];
            _haloLayer.position = CGPointMake(super.layer.bounds.size.width / 2.0, super.layer.bounds.size.height / 2.0);
            
            [self.layer addSublayer:_accuracyRingLayer];
        }
        
        if ( ! _haloLayer)
        {
            UIImage *haloImage = [self trackingDotHaloImage];
            _haloLayer = [CALayer layer];
            _haloLayer.bounds = CGRectMake(0, 0, haloImage.size.width, haloImage.size.height);
            _haloLayer.contents = (__bridge id)[haloImage CGImage];
            _haloLayer.position = CGPointMake(super.layer.bounds.size.width / 2.0, super.layer.bounds.size.height / 2.0);
            
            [CATransaction begin];
            
            [CATransaction setAnimationDuration:3.5];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
            // scale out radially
            //
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            boundsAnimation.repeatCount = MAXFLOAT;
            boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
            boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)];
            boundsAnimation.removedOnCompletion = NO;
            
            [_haloLayer addAnimation:boundsAnimation forKey:@"animateScale"];
            
            // go transparent as scaled out
            //
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.repeatCount = MAXFLOAT;
            opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            opacityAnimation.toValue   = [NSNumber numberWithFloat:-1.0];
            opacityAnimation.removedOnCompletion = NO;
            
            [_haloLayer addAnimation:opacityAnimation forKey:@"animateOpacity"];
            
            [CATransaction commit];
            
            [self.layer addSublayer:_haloLayer];
        }
        
        // white dot background with shadow
        //
        if ( ! _dotBorderLayer)
        {
            CGRect rect = CGRectMake(0, 0, MGLTrackingDotRingWidth * 1.5, MGLTrackingDotRingWidth * 1.5);
            
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetShadow(context, CGSizeMake(0, 0), MGLTrackingDotRingWidth / 4.0);
            
            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
            CGContextFillEllipseInRect(context, CGRectMake((rect.size.width - MGLTrackingDotRingWidth) / 2.0, (rect.size.height - MGLTrackingDotRingWidth) / 2.0, MGLTrackingDotRingWidth, MGLTrackingDotRingWidth));
            
            UIImage *whiteBackground = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            _dotBorderLayer = [CALayer layer];
            _dotBorderLayer.bounds = CGRectMake(0, 0, whiteBackground.size.width, whiteBackground.size.height);
            _dotBorderLayer.contents = (__bridge id)[whiteBackground CGImage];
            _dotBorderLayer.position = CGPointMake(super.layer.bounds.size.width / 2.0, super.layer.bounds.size.height / 2.0);
            [self.layer addSublayer:_dotBorderLayer];
        }

        // pulsing, tinted dot sublayer
        //
        if ( ! _dotLayer)
        {
            UIImage *dotImage = [self dotImage];
            _dotLayer = [CALayer layer];
            _dotLayer.bounds = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
            _dotLayer.contents = (__bridge id)[dotImage CGImage];
            _dotLayer.position = CGPointMake(super.layer.bounds.size.width / 2.0, super.layer.bounds.size.height / 2.0);
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.repeatCount = MAXFLOAT;
            animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
            animation.removedOnCompletion = NO;
            animation.autoreverses = YES;
            animation.duration = 1.5;
            animation.beginTime = CACurrentMediaTime() + 1.0;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            
            [_dotLayer addAnimation:animation forKey:@"animateTransform"];
            
            [self.layer addSublayer:_dotLayer];
        }
    }
}

- (UIImage *)accuracyRingImage
{
    CGFloat latRadians = self.annotation.coordinate.latitude * M_PI / 180.0f;
    CGFloat pixelRadius = self.annotation.location.horizontalAccuracy / cos(latRadians) / [self.mapView metersPerPixelAtLatitude:self.annotation.coordinate.latitude];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixelRadius * 2, pixelRadius * 2), NO, [[UIScreen mainScreen] scale]);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor colorWithRed:0.378 green:0.552 blue:0.827 alpha:0.7] CGColor]);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor colorWithRed:0.378 green:0.552 blue:0.827 alpha:0.15] CGColor]);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, pixelRadius * 2, pixelRadius * 2));
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

- (UIImage *)trackingDotHaloImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, [[UIScreen mainScreen] scale]);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[_mapView.tintColor colorWithAlphaComponent:0.75] CGColor]);
    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 100, 100));
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (UIImage *)dotImage
{
    CGFloat tintedWidth = MGLTrackingDotRingWidth * 0.7;
    
    CGRect rect = CGRectMake(0, 0, tintedWidth, tintedWidth);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [_mapView.tintColor CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake((rect.size.width - tintedWidth) / 2.0, (rect.size.height - tintedWidth) / 2.0, tintedWidth, tintedWidth));
    
    UIImage *tintedForeground = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedForeground;
}

@end
