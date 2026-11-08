#import "MiniPlayerView.h"
#import "Theme.h"
#import "Player.h"

@implementation MCMiniPlayerView {
    UIVisualEffectView *_blur;
    UIImageView *_art;
    UILabel *_title, *_subtitle;
    UIButton *_play, *_next;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.20;
        self.layer.shadowRadius = 14;
        self.layer.shadowOffset = CGSizeMake(0, 5);

        _blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        _blur.layer.cornerRadius = 14;
        _blur.layer.masksToBounds = YES;
        [self addSubview:_blur];

        _art = [[UIImageView alloc] init];
        _art.layer.cornerRadius = 6;
        _art.layer.masksToBounds = YES;
        [self addSubview:_art];

        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        _title.textColor = [UIColor blackColor];
        [self addSubview:_title];

        _subtitle = [[UILabel alloc] init];
        _subtitle.font = [UIFont systemFontOfSize:13];
        _subtitle.textColor = [MCTheme secondaryText];
        [self addSubview:_subtitle];

        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play addTarget:self action:@selector(playTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_play];

        _next = [UIButton buttonWithType:UIButtonTypeCustom];
        [_next setImage:[MCTheme glyph:MCGlyphNext size:24 color:[UIColor colorWithWhite:0.15 alpha:1]] forState:UIControlStateNormal];
        [_next addTarget:self action:@selector(nextTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_next];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyTapped)];
        [self addGestureRecognizer:tap];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:MCPlayerStateChanged object:nil];
        [self refresh];
    }
    return self;
}

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    _blur.frame = self.bounds;
    _art.frame = CGRectMake(10, 8, 44, 44);
    _title.frame = CGRectMake(66, 10, w - 66 - 110, 20);
    _subtitle.frame = CGRectMake(66, 31, w - 66 - 110, 18);
    _play.frame = CGRectMake(w - 104, 10, 40, 40);
    _next.frame = CGRectMake(w - 56, 10, 40, 40);
}

- (void)refresh {
    MPMediaItem *item = [MCPlayer shared].currentItem;
    if (item) {
        _title.text = [item valueForProperty:MPMediaItemPropertyTitle];
        _subtitle.text = [item valueForProperty:MPMediaItemPropertyArtist];
        _art.image = [MCTheme artworkForItem:item size:44];
    } else {
        _title.text = @"Not Playing";
        _subtitle.text = @"";
        _art.image = [MCTheme gradientArtForSeed:@"idle" size:44];
    }
    MCGlyph g = [MCPlayer shared].isPlaying ? MCGlyphPause : MCGlyphPlay;
    [_play setImage:[MCTheme glyph:g size:26 color:[UIColor colorWithWhite:0.15 alpha:1]] forState:UIControlStateNormal];
}

- (void)playTapped { [[MCPlayer shared] togglePlayPause]; }
- (void)nextTapped { [[MCPlayer shared] next]; }
- (void)bodyTapped { if (self.onTap) self.onTap(); }

@end
