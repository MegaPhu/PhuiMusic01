import { AlbumCard } from '../../components/AlbumCard'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { SongCard } from '../../components/SongCard'
import { MUSIC_TRACKS, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

@Entry
@Component
struct Library {
  @State private activeTab: string = 'Playlist'
  @StorageLink('likedTrackIds') likedTrackIds: string = ''

  private handleSearch(): void {
    console.log('[LibraryPage] search tapped')
  }

  private handleAdd(): void {
    console.log('[LibraryPage] add tapped')
  }

  private likedTracks(): Track[] {
    return MUSIC_TRACKS.filter((track: Track): boolean => PlayerManager.isLiked(track, this.likedTrackIds))
  }

  private likedSongSummary(): string {
    const count = this.likedTracks().length
    return `${count} saved song${count !== 1 ? 's' : ''} · Phu`
  }

  @Builder
  private SearchGlyph() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(17)
        .height(17)
        .borderRadius(9)
        .border({ width: 2, color: MeowColors.textPrimary })
        .translate({ x: -2, y: -2 })
      Row()
        .width(9)
        .height(2)
        .borderRadius(1)
        .backgroundColor(MeowColors.textPrimary)
        .rotate({ angle: 45 })
        .translate({ x: 7, y: 8 })
    }
    .width(44)
    .height(44)
    .borderRadius(22)
    .backgroundColor('rgba(255,255,255,0.06)')
    .onClick(() => {
      this.handleSearch()
    })
  }

  @Builder
  private HeaderIcon(label: string, actionType: string) {
    Text(label)
      .fontSize(26)
      .fontWeight(FontWeight.Medium)
      .fontColor(MeowColors.textPrimary)
      .width(44)
      .height(44)
      .textAlign(TextAlign.Center)
      .borderRadius(22)
      .backgroundColor('rgba(255,255,255,0.06)')
      .onClick(() => {
        if (actionType === 'search') {
          this.handleSearch()
        } else {
          this.handleAdd()
        }
      })
  }

  @Builder
  private LibraryTab(label: string) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontWeight(this.activeTab === label ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.activeTab === label ? MeowColors.navyDeep : MeowColors.textSecondary)
    }
    .height(38)
    .padding({ left: 16, right: 16 })
    .borderRadius(MeowRadius.chip)
    .backgroundColor(this.activeTab === label ? MeowColors.goldBright : 'rgba(255,255,255,0.07)')
    .linearGradient({
      angle: 135,
      colors: this.activeTab === label ? [
        [MeowColors.goldDark, 0.0],
        [MeowColors.goldBright, 0.36],
        [MeowColors.goldSoft, 0.72],
        [MeowColors.goldDeep, 1.0]
      ] : [
        ['rgba(255,255,255,0.07)', 0.0],
        ['rgba(255,255,255,0.07)', 1.0]
      ]
    })
    .border({ width: 1, color: this.activeTab === label ? 'rgba(255,215,0,0.42)' : 'rgba(255,255,255,0.10)' })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      console.log(`[LibraryPage] tab ${label}`)
      this.activeTab = label
    })
  }

  @Builder
  private LikedSongs() {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .width(70)
          .height(70)
          .borderRadius(MeowRadius.card)
          .linearGradient({
            angle: 135,
            colors: [
              ['#4F46E5', 0.0],
              ['#A78BFA', 0.52],
              ['#9BE7C1', 1.0]
            ]
          })
        Text('♥')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
      }
      .width(70)
      .height(70)

      Column({ space: 5 }) {
        Text('Liked Songs')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Text(this.likedSongSummary())
          .fontSize(MeowTypography.bodySize)
          .fontColor(MeowColors.textSecondary)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('Pinned')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.goldBright)
    }
    .width('100%')
    .padding(14)
    .borderRadius(MeowRadius.card)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
  }

  @Builder
  private ArtistRow(name: string, hint: string, accent: string) {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(62)
          .height(62)
          .fill(accent)
          .opacity(0.82)
        Text(name.substring(0, 1))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
      }
      .width(62)
      .height(62)

      Column({ space: 5 }) {
        Text(name)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Text(hint)
          .fontSize(MeowTypography.bodySize)
          .fontColor(MeowColors.textSecondary)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }

  @Builder
  private AddRow(label: string, rounded: boolean) {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.Center }) {
        if (rounded) {
          Circle().width(62).height(62).fill('rgba(255,255,255,0.08)')
        } else {
          Row().width(62).height(62).borderRadius(MeowRadius.card).backgroundColor('rgba(255,255,255,0.08)')
        }
        Text('+')
          .fontSize(32)
          .fontColor(MeowColors.textSecondary)
      }
      .width(62)
      .height(62)

      Text(label)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor(MeowColors.textPrimary)
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
    .onClick(() => {
      this.handleAdd()
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            [MeowColors.navyTop, 0.0],
            [MeowColors.navyMid, 0.52],
            [MeowColors.navyBottom, 1.0]
          ]
        })

      Scroll() {
        Column({ space: MeowSpacing.sectionGap }) {
          Row({ space: 10 }) {
            Text('Library')
              .fontSize(MeowTypography.headingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .layoutWeight(1)
            this.SearchGlyph()
            this.HeaderIcon('+', 'add')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Row({ space: 10 }) {
            this.LibraryTab('Playlist')
            this.LibraryTab('Album')
            this.LibraryTab('Artist')
          }
          .width('100%')

          Column({ space: 12 }) {
            this.LikedSongs()
            if (this.likedTracks().length === 0) {
              Text('Tap the heart on any song to add it here.')
                .fontSize(MeowTypography.bodySize)
                .fontColor(MeowColors.textTertiary)
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                .borderRadius(MeowRadius.card)
                .backgroundColor('rgba(255,255,255,0.045)')
                .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
            } else {
              ForEach(this.likedTracks(), (track: Track) => {
                SongCard({ track: track })
              }, (track: Track) => track.id)
            }
          }
          .width('100%')

          Column({ space: 14 }) {
            Text('Albums')
              .fontSize(MeowTypography.subheadingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            Scroll() {
              Row({ space: 16 }) {
                ForEach(MUSIC_TRACKS.slice(0, 5), (track: Track) => {
                  AlbumCard({ track: track })
                }, (track: Track) => `${track.id}`)
              }
              .padding({ right: MeowSpacing.pagePadding })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }
          .width('100%')

          Column({ space: 2 }) {
            Text('Artists')
              .fontSize(MeowTypography.subheadingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
              .margin({ bottom: 8 })
            this.ArtistRow('Irokz', 'Artist · 3 saved tracks', '#1FA77B')
            this.ArtistRow('DJ Asul', 'Artist · recently played', '#8F1D2C')
            this.ArtistRow('PhuiSic Studio', 'Artist · mascot mixes', '#7B4AB8')
            this.AddRow('Add Artist', true)
            this.AddRow('Add Podcast', false)
          }
          .width('100%')
          .padding(18)
          .borderRadius(MeowRadius.large)
          .backgroundColor(MeowColors.solidSurface)
          .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

          Column({ space: 12 }) {
            Text('Recently Played')
              .fontSize(MeowTypography.subheadingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            ForEach(MUSIC_TRACKS.slice(3, 6), (track: Track) => {
              SongCard({ track: track })
            }, (track: Track) => `${track.id}`)
          }
          .width('100%')
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 64, bottom: MeowSpacing.mainContentBottomPadding })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      Column() {
        MiniPlayer()
          .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
        BottomNavBar({ activeTab: 'Library' })
      }
      .width('100%')
      .zIndex(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
