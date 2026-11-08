#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

extern NSString * const MCPlayerStateChanged;

@interface MCPlayer : NSObject
+ (instancetype)shared;
@property (nonatomic, readonly) MPMusicPlayerController *player;
@property (nonatomic, readonly) MPMediaItem *currentItem;
@property (nonatomic, readonly) BOOL isPlaying;
- (void)playItems:(NSArray *)items startIndex:(NSUInteger)index;
- (void)togglePlayPause;
- (void)next;
- (void)previous;
@end
