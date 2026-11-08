#import "Theme.h"

static UIBezierPath *MCPoly(CGFloat s, const CGFloat *p, int n) {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < n; i++) {
        CGPoint pt = CGPointMake(p[i * 2] * s, p[i * 2 + 1] * s);
        if (i == 0) [path moveToPoint:pt]; else [path addLineToPoint:pt];
    }
    [path closePath];
    return path;
}

@implementation MCTheme

+ (UIColor *)accent { return [UIColor colorWithRed:0.98 green:0.14 blue:0.24 alpha:1.0]; }
+ (UIColor *)secondaryText { return [UIColor colorWithWhite:0.5 alpha:1.0]; }

+ (UIImage *)glyph:(MCGlyph)glyph size:(CGFloat)s color:(UIColor *)c {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(s, s), NO, 0);
    [c setFill];
    [c setStroke];
    CGFloat lw = MAX(1.5, s * 0.09);

    switch (glyph) {
        case MCGlyphSearch: {
            UIBezierPath *ring = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(s*0.12, s*0.12, s*0.52, s*0.52)];
            ring.lineWidth = lw;
            [ring stroke];
            UIBezierPath *h = [UIBezierPath bezierPath];
            h.lineWidth = lw; h.lineCapStyle = kCGLineCapRound;
            [h moveToPoint:CGPointMake(s*0.58, s*0.58)];
            [h addLineToPoint:CGPointMake(s*0.88, s*0.88)];
            [h stroke];
        } break;
        case MCGlyphHome: {
            const CGFloat pts[] = {0.5,0.10, 0.93,0.48, 0.80,0.48, 0.80,0.90, 0.20,0.90, 0.20,0.48, 0.07,0.48};
            [MCPoly(s, pts, 7) fill];
        } break;
        case MCGlyphNew: {
            CGFloat q = s * 0.34, o1 = s * 0.12, o2 = s * 0.54;
            CGFloat xs[2] = {o1, o2};
            for (int i = 0; i < 2; i++) for (int j = 0; j < 2; j++) {
                [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(xs[i], xs[j], q, q) cornerRadius:s*0.07] fill];
            }
        } break;
        case MCGlyphRadio: {
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(s*0.40, s*0.40, s*0.20, s*0.20)] fill];
            CGFloat radii[2] = {0.24, 0.42};
            for (int i = 0; i < 2; i++) {
                UIBezierPath *r = [UIBezierPath bezierPathWithArcCenter:CGPointMake(s*0.5, s*0.5) radius:s*radii[i] startAngle:-M_PI/4 endAngle:M_PI/4 clockwise:YES];
                r.lineWidth = lw; r.lineCapStyle = kCGLineCapRound; [r stroke];
                UIBezierPath *l = [UIBezierPath bezierPathWithArcCenter:CGPointMake(s*0.5, s*0.5) radius:s*radii[i] startAngle:3*M_PI/4 endAngle:5*M_PI/4 clockwise:YES];
                l.lineWidth = lw; l.lineCapStyle = kCGLineCapRound; [l stroke];
            }
        } break;
        case MCGlyphPlaylists: {
            UIBezierPath *p = [UIBezierPath bezierPath];
            p.lineWidth = lw; p.lineCapStyle = kCGLineCapRound;
            [p moveToPoint:CGPointMake(s*0.12, s*0.26)]; [p addLineToPoint:CGPointMake(s*0.88, s*0.26)];
            [p moveToPoint:CGPointMake(s*0.12, s*0.50)]; [p addLineToPoint:CGPointMake(s*0.88, s*0.50)];
            [p moveToPoint:CGPointMake(s*0.12, s*0.74)]; [p addLineToPoint:CGPointMake(s*0.52, s*0.74)];
            [p stroke];
        } break;
        case MCGlyphArtists: {
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(s*0.33, s*0.10, s*0.34, s*0.34)] fill];
            UIBezierPath *body = [UIBezierPath bezierPathWithArcCenter:CGPointMake(s*0.5, s*0.95) radius:s*0.38 startAngle:M_PI endAngle:2*M_PI clockwise:YES];
            [body closePath];
            [body fill];
        } break;
        case MCGlyphAlbums: {
            UIBezierPath *sq = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(s*0.10, s*0.10, s*0.80, s*0.80) cornerRadius:s*0.14];
            sq.lineWidth = lw; [sq stroke];
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(s*0.34, s*0.34, s*0.32, s*0.32)] fill];
        } break;
        case MCGlyphSongs: {
            [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(s*0.18, s*0.58, s*0.30, s*0.24)] fill];
            UIBezierPath *stem = [UIBezierPath bezierPath];
            stem.lineWidth = lw; stem.lineCapStyle = kCGLineCapRound;
            [stem moveToPoint:CGPointMake(s*0.45, s*0.70)]; [stem addLineToPoint:CGPointMake(s*0.45, s*0.18)];
            [stem addLineToPoint:CGPointMake(s*0.82, s*0.28)];
            [stem stroke];
        } break;
        case MCGlyphPlay: {
            const CGFloat tri[] = {0.25,0.12, 0.90,0.50, 0.25,0.88};
            [MCPoly(s, tri, 3) fill];
        } break;
        case MCGlyphPause: {
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(s*0.18, s*0.12, s*0.24, s*0.76) cornerRadius:s*0.05] fill];
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(s*0.58, s*0.12, s*0.24, s*0.76) cornerRadius:s*0.05] fill];
        } break;
        case MCGlyphNext: {
            const CGFloat tri[] = {0.10,0.18, 0.64,0.50, 0.10,0.82};
            [MCPoly(s, tri, 3) fill];
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(s*0.70, s*0.18, s*0.16, s*0.64) cornerRadius:s*0.04] fill];
        } break;
        case MCGlyphPrev: {
            const CGFloat tri[] = {0.90,0.18, 0.36,0.50, 0.90,0.82};
            [MCPoly(s, tri, 3) fill];
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(s*0.14, s*0.18, s*0.16, s*0.64) cornerRadius:s*0.04] fill];
        } break;
    }

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)gradientArtForSeed:(NSString *)seed size:(CGFloat)size {
    static NSCache *cache;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ cache = [[NSCache alloc] init]; });

    NSString *key = [NSString stringWithFormat:@"%@|%d", seed, (int)size];
    UIImage *hit = [cache objectForKey:key];
    if (hit) return hit;

    NSUInteger h = [seed hash];
    CGFloat hue1 = (h % 360) / 360.0;
    CGFloat hue2 = fmod(hue1 + 0.10 + ((h / 360) % 12) / 100.0, 1.0);
    UIColor *c1 = [UIColor colorWithHue:hue1 saturation:0.60 brightness:0.97 alpha:1];
    UIColor *c2 = [UIColor colorWithHue:hue2 saturation:0.85 brightness:0.72 alpha:1];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSArray *cols = @[(id)c1.CGColor, (id)c2.CGColor];
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad = CGGradientCreateWithColors(cs, (__bridge CFArrayRef)cols, NULL);
    CGContextDrawLinearGradient(ctx, grad, CGPointZero, CGPointMake(size, size), 0);
    CGGradientRelease(grad);
    CGColorSpaceRelease(cs);

    CGFloat ns = size * 0.42;
    UIImage *note = [self glyph:MCGlyphSongs size:ns color:[UIColor colorWithWhite:1 alpha:0.75]];
    [note drawInRect:CGRectMake((size - ns) / 2, (size - ns) / 2, ns, ns)];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [cache setObject:img forKey:key];
    return img;
}

+ (UIImage *)artworkForItem:(MPMediaItem *)item size:(CGFloat)size {
    MPMediaItemArtwork *art = [item valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *img = art ? [art imageWithSize:CGSizeMake(size, size)] : nil;
    if (img) return img;
    NSString *seed = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (!seed) seed = [item valueForProperty:MPMediaItemPropertyTitle];
    if (!seed) seed = @"?";
    return [self gradientArtForSeed:seed size:size];
}

+ (NSString *)timeString:(NSTimeInterval)t {
    int s = (int)(MAX(0, t) + 0.5);
    return [NSString stringWithFormat:@"%d:%02d", s / 60, s % 60];
}

+ (UIView *)bigTitleHeader:(NSString *)text width:(CGFloat)width {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(28, 6, width - 56, 44)];
    l.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    l.font = [UIFont boldSystemFontOfSize:34];
    l.text = text;
    [v addSubview:l];
    return v;
}

@end
