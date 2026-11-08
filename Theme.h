#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, MCGlyph) {
    MCGlyphSearch, MCGlyphHome, MCGlyphNew, MCGlyphRadio,
    MCGlyphPlaylists, MCGlyphArtists, MCGlyphAlbums, MCGlyphSongs,
    MCGlyphPlay, MCGlyphPause, MCGlyphNext, MCGlyphPrev
};

@interface MCTheme : NSObject
+ (UIColor *)accent;
+ (UIColor *)secondaryText;
+ (UIImage *)glyph:(MCGlyph)glyph size:(CGFloat)size color:(UIColor *)color;
+ (UIImage *)gradientArtForSeed:(NSString *)seed size:(CGFloat)size;
+ (UIImage *)artworkForItem:(MPMediaItem *)item size:(CGFloat)size;
+ (NSString *)timeString:(NSTimeInterval)t;
+ (UIView *)bigTitleHeader:(NSString *)text width:(CGFloat)width;
@end
