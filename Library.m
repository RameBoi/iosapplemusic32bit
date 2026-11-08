#import "Library.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MCLibrary

+ (NSArray *)songs {
    NSArray *items = [[MPMediaQuery songsQuery] items];
    return items ? items : @[];
}

+ (NSArray *)albums {
    NSMutableArray *out = [NSMutableArray array];
    for (MPMediaItemCollection *c in [[MPMediaQuery albumsQuery] collections]) {
        MPMediaItem *rep = [c representativeItem];
        if (!rep) continue;
        NSString *t = [rep valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (!t.length) t = @"Unknown Album";
        NSString *a = [rep valueForProperty:MPMediaItemPropertyAlbumArtist];
        if (!a.length) a = [rep valueForProperty:MPMediaItemPropertyArtist];
        if (!a.length) a = @"Unknown Artist";
        [out addObject:@{@"title": t, @"artist": a, @"items": [c items], @"rep": rep}];
    }
    return out;
}

+ (NSArray *)recentAlbums {
    NSArray *sorted = [[self albums] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSDate *da = [a[@"rep"] valueForProperty:MPMediaItemPropertyDateAdded];
        NSDate *db = [b[@"rep"] valueForProperty:MPMediaItemPropertyDateAdded];
        if (!da) da = [NSDate distantPast];
        if (!db) db = [NSDate distantPast];
        return [db compare:da];
    }];
    if (sorted.count > 60) sorted = [sorted subarrayWithRange:NSMakeRange(0, 60)];
    return sorted;
}

+ (NSArray *)demoAlbums {
    NSArray *pairs = @[
        @[@"Midnight Drive", @"Neon Coast"], @[@"Golden Hour", @"Alma Reyes"],
        @[@"Paper Planes", @"The Lanterns"], @[@"Static Bloom", @"Vera Holt"],
        @[@"Low Tide", @"Marlow"], @[@"Afterglow", @"Kite & Key"],
        @[@"Northern Lights", @"Soren Vale"], @[@"Velvet Hours", @"June Aster"],
        @[@"City of Glass", @"Parallel"], @[@"Daydream Club", @"Pale Sunday"],
        @[@"Open Road", @"Hollis Gray"], @[@"Quiet Storm", @"Ines Duarte"]
    ];
    NSMutableArray *out = [NSMutableArray array];
    for (NSArray *p in pairs) [out addObject:@{@"title": p[0], @"artist": p[1], @"items": @[]}];
    return out;
}

+ (NSArray *)artistGroups {
    NSMutableArray *out = [NSMutableArray array];
    for (MPMediaItemCollection *c in [[MPMediaQuery artistsQuery] collections]) {
        MPMediaItem *rep = [c representativeItem];
        if (!rep) continue;
        NSString *name = [rep valueForProperty:MPMediaItemPropertyArtist];
        if (!name.length) name = @"Unknown Artist";
        NSString *sub = [NSString stringWithFormat:@"%lu song%@", (unsigned long)[c count], [c count] == 1 ? @"" : @"s"];
        [out addObject:@{@"title": name, @"subtitle": sub, @"items": [c items], @"rep": rep}];
    }
    return out;
}

+ (NSArray *)playlistGroups {
    NSMutableArray *out = [NSMutableArray array];
    for (MPMediaItemCollection *c in [[MPMediaQuery playlistsQuery] collections]) {
        NSString *name = [(MPMediaPlaylist *)c valueForProperty:MPMediaPlaylistPropertyName];
        if (!name.length) name = @"Playlist";
        NSString *sub = [NSString stringWithFormat:@"%lu song%@", (unsigned long)[c count], [c count] == 1 ? @"" : @"s"];
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"title": name, @"subtitle": sub, @"items": [c items]}];
        MPMediaItem *rep = [c representativeItem];
        if (rep) d[@"rep"] = rep;
        [out addObject:d];
    }
    return out;
}

@end
