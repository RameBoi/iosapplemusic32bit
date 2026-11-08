#import "NowPlayingViewController.h"
#import "Theme.h"
#import "Player.h"

@implementation MCNowPlayingViewController {
    UIButton *_done;
    UIImageView *_art;
    UILabel *_title, *_artist, *_elapsed, *_remaining;
    UISlider *_slider;
    UIButton *_prev, *_play, *_next;
    MPVolumeView *_volume;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _done = [UIButton buttonWithType:UIButtonTypeSystem];
    [_done setTitle:@"Done" forState:UIControlStateNormal];
    _done.titleLabel.font = [UIFont systemFontOfSize:18];
    [_done addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_done];

    _art = [[UIImageView alloc] init];
    _art.layer.cornerRadius = 10;
    _art.layer.masksToBounds = YES;
    [self.view addSubview:_art];

    _title = [[UILabel alloc] init];
    _title.font = [UIFont boldSystemFontOfSize:22];
    _title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_title];

    _artist = [[UILabel alloc] init];
    _artist.font = [UIFont systemFontOfSize:19];
    _artist.textColor = [MCTheme accent];
    _artist.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_artist];

    _slider = [[UISlider alloc] init];
    _slider.continuous = NO;
    _slider.minimumTrackTintColor = [UIColor colorWithWhite:0.35 alpha:1];
    _slider.thumbTintColor = [UIColor colorWithWhite:0.35 alpha:1];
    [_slider addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];

    _elapsed = [[UILabel alloc] init];
    _elapsed.font = [UIFont systemFontOfSize:12];
    _elapsed.textColor = [MCTheme secondaryText];
    [self.view addSubview:_elapsed];

    _remaining = [[UILabel alloc] init];
    _remaining.font = [UIFont systemFontOfSize:12];
    _remaining.textColor = [MCTheme secondaryText];
    _remaining.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_remaining];

    UIColor *dark = [UIColor colorWithWhite:0.1 alpha:1];
    _prev = [UIButton buttonWithType:UIButtonTypeCustom];
    [_prev setImage:[MCTheme glyph:MCGlyphPrev size:36 color:dark] forState:UIControlStateNormal];
    [_prev addTarget:self action:@selector(prevTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_prev];

    _play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_play addTarget:self action:@selector(playTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_play];

    _next = [UIButton buttonWithType:UIButtonTypeCustom];
    [_next setImage:[MCTheme glyph:MCGlyphNext size:36 color:dark] forState:UIControlStateNormal];
    [_next addTarget:self action:@selector(nextTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_next];

    _volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    [self.view addSubview:_volume];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:MCPlayerStateChanged object:nil];
    [self refresh];
}

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat w = self.view.bounds.size.width, h = self.view.bounds.size.height;
    _done.frame = CGRectMake(14, 12, 70, 34);
    CGFloat side = MIN(w - 120, 330);
    _art.frame = CGRectMake((w - side) / 2, 56, side, side);
    CGFloat y = CGRectGetMaxY(_art.frame) + 22;
    _title.frame = CGRectMake(30, y, w - 60, 28);
    _artist.frame = CGRectMake(30, y + 30, w - 60, 26);
    _slider.frame = CGRectMake(40, y + 72, w - 80, 30);
    _elapsed.frame = CGRectMake(42, y + 100, 80, 16);
    _remaining.frame = CGRectMake(w - 122, y + 100, 80, 16);
    CGFloat cy = y + 150;
    _prev.frame = CGRectMake(w / 2 - 120, cy, 60, 60);
    _play.frame = CGRectMake(w / 2 - 30, cy, 60, 60);
    _next.frame = CGRectMake(w / 2 + 60, cy, 60, 60);
    _volume.frame = CGRectMake(40, h - 56, w - 80, 30);
}

- (void)refresh {
    MPMediaItem *item = [MCPlayer shared].currentItem;
    if (item) {
        _title.text = [item valueForProperty:MPMediaItemPropertyTitle];
        _artist.text = [item valueForProperty:MPMediaItemPropertyArtist];
        _art.image = [MCTheme artworkForItem:item size:330];
    } else {
        _title.text = @"Not Playing";
        _artist.text = @"";
        _art.image = [MCTheme gradientArtForSeed:@"idle" size:330];
    }
    MCGlyph g = [MCPlayer shared].isPlaying ? MCGlyphPause : MCGlyphPlay;
    [_play setImage:[MCTheme glyph:g size:44 color:[UIColor colorWithWhite:0.1 alpha:1]] forState:UIControlStateNormal];
}

- (void)tick {
    MPMediaItem *item = [MCPlayer shared].currentItem;
    NSTimeInterval dur = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    NSTimeInterval cur = [MCPlayer shared].player.currentPlaybackTime;
    if (dur <= 0) {
        _elapsed.text = @"0:00";
        _remaining.text = @"-0:00";
        if (!_slider.tracking) _slider.value = 0;
        return;
    }
    if (!_slider.tracking) _slider.value = (float)(cur / dur);
    _elapsed.text = [MCTheme timeString:cur];
    _remaining.text = [@"-" stringByAppendingString:[MCTheme timeString:dur - cur]];
}

- (void)seek:(UISlider *)s {
    MPMediaItem *item = [MCPlayer shared].currentItem;
    NSTimeInterval dur = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    if (dur > 0) [MCPlayer shared].player.currentPlaybackTime = s.value * dur;
}

- (void)dismiss { [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)playTapped { [[MCPlayer shared] togglePlayPause]; }
- (void)nextTapped { [[MCPlayer shared] next]; }
- (void)prevTapped { [[MCPlayer shared] previous]; }

@end
