#import "Player.h"

NSString * const MCPlayerStateChanged = @"MCPlayerStateChanged";

@implementation MCPlayer

+ (instancetype)shared {
    static MCPlayer *inst;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ inst = [[MCPlayer alloc] init]; });
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _player = [MPMusicPlayerController applicationMusicPlayer];
        [_player beginGeneratingPlaybackNotifications];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(changed:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_player];
        [nc addObserver:self selector:@selector(changed:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_player];
    }
    return self;
}

- (void)changed:(NSNotification *)n {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MCPlayerStateChanged object:self];
    });
}

- (MPMediaItem *)currentItem { return self.player.nowPlayingItem; }
- (BOOL)isPlaying { return self.player.playbackState == MPMusicPlaybackStatePlaying; }

- (void)playItems:(NSArray *)items startIndex:(NSUInteger)index {
    if (items.count == 0 || index >= items.count) return;
    MPMediaItemCollection *col = [MPMediaItemCollection collectionWithItems:items];
    [self.player setQueueWithItemCollection:col];
    self.player.nowPlayingItem = items[index];
    [self.player play];
}

- (void)togglePlayPause {
    if (!self.player.nowPlayingItem) return;
    if (self.isPlaying) [self.player pause]; else [self.player play];
}

- (void)next { [self.player skipToNextItem]; }

- (void)previous {
    if (self.player.currentPlaybackTime > 3.0) [self.player skipToBeginning];
    else [self.player skipToPreviousItem];
}

@end
