# MusicClone

Apple Music (iPadOS 18 look) for 32-bit iOS 8 / iPad 4. Objective-C + UIKit, built with Theos on GitHub Actions.

## What it is
- Sidebar (Search, Home, New, Radio, Playlists, Artists, Albums, Songs), album grid, floating mini player, Now Playing sheet
- Plays the music already on the iPad (MediaPlayer framework). With an empty library, Home/Albums show sample albums
- Radio and New are visual placeholders only (no streaming)

## Build
1. Push this folder to a GitHub repo (keep the hidden `.github` folder).
2. Actions tab -> "Build MusicClone IPA" -> Run workflow (it also runs on every push).
3. Download the `MusicClone` artifact: `MusicClone.ipa` and a `.deb`.

## Install on the jailbroken iPad
- .deb: copy to the iPad, install with Filza / `dpkg -i`, then respring (or `uicache`).
- .ipa: needs AppSync Unified (fake-signed), install with iFile/Filza/ipainstaller.
