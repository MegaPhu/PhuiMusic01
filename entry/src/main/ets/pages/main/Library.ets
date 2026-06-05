import router from '@ohos.router'
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

  private async openTrack(track: Track): Promise<void> {
    console.log(`[LibraryPage] open ${track.title}`)
    PlayerManager.playTrack(track)
    await router.pushUrl({ url: 'pages/main/Player' })
  }

  private likedTracks(): Track[] {
    return MUSIC_TRACKS.filter((track: Track): boolean => PlayerManager.isLiked(track, this.likedTrackIds))
  }

  private likedPreviewTracks(): Track[] {
    return this.likedTracks().slice(0, 4)
  }

  private savedSongsLabel(count: number): string {
    return count === 1 ? '1 saved song' : `${count} saved songs`
  }

  private likedSongSummary(): string {
    const count = this.likedTracks().length
    return `${this.savedSongsLabel(count)} · Phu`
  }

  private contentBottomPadding(): number {
    return MeowSpacing.mainContentBottomPadding + 24
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
  private SectionHeader(title: string, subtitle: string = '') {
    Column({ space: 3 }) {
      Text(title)
        .fontSize(MeowTypography.subheadingSize)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .width('100%')
      if (subtitle.length > 0) {
        Text(subtitle)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textTertiary)
          .width('100%')
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
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
        if (this.likedPreviewTracks().length === 0) {
          Text('♥')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
        } else {
          Grid() {
            ForEach(this.likedPreviewTracks(), (track: Track) => {
              GridItem() {
                Image(track.artwork)
                  .width(32)
                  .height(32)
                  .objectFit(ImageFit.Cover)
                  .clip(true)
              }
            }, (track: Track) => track.id)
          }
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(2)
          .rowsGap(2)
          .width(66)
          .height(66)
          .borderRadius(MeowRadius.card)
          .clip(true)
        }
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

      Column({ space: 3 }) {
        Text('Pinned')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.goldBright)
        Text('♥')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.likedTracks().length > 0 ? MeowColors.goldBright : MeowColors.textTertiary)
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(16)
    .borderRadius(MeowRadius.large)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.09)' })
    .shadow({
      radius: 16,
      color: MeowColors.shadowNavy,
      offsetX: 0,
      offsetY: 6
    })
  }

  @Builder
  private CollectionCard(title: string, subtitle: string, marker: string, accent: string) {
    Row({ space: 13 }) {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .width(54)
          .height(54)
          .borderRadius(14)
          .backgroundColor(accent)
          .opacity(0.82)
        Text(marker)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
      }
      .width(54)
      .height(54)

      Column({ space: 4 }) {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(subtitle)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .layoutWeight(1)
    .height(82)
    .padding({ left: 12, right: 12 })
    .borderRadius(MeowRadius.card)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.075)' })
  }

  @Builder
  private CollectionGrid() {
    Column({ space: 12 }) {
      this.SectionHeader('Your Collection', 'Saved music organized for quick listening')
      Row({ space: 12 }) {
        this.CollectionCard('Liked Songs', this.likedSongSummary(), '♥', '#5B5EEB')
        this.CollectionCard('Daily Rotation', '4 playlists · updated', '♪', '#1B7D66')
      }
      .width('100%')
      Row({ space: 12 }) {
        this.CollectionCard('Albums', `${MUSIC_TRACKS.length} releases`, '▤', '#6B4FB8')
        this.CollectionCard('Artists', '3 followed artists', '◉', '#9B3F58')
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private PlaylistCard(track: Track, label: string) {
    Row({ space: 14 }) {
      Image(track.artwork)
        .width(74)
        .height(74)
        .borderRadius(14)
        .objectFit(ImageFit.Cover)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

      Column({ space: 5 }) {
        Text(label)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${track.kind} · ${track.artist}`)
          .fontSize(MeowTypography.bodySize)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('›')
        .fontSize(28)
        .fontColor(MeowColors.textTertiary)
    }
    .width('100%')
    .padding(12)
    .borderRadius(MeowRadius.card)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
  }

  @Builder
  private LibraryAlbumTile(track: Track) {
    Column({ space: 7 }) {
      Image(track.artwork)
        .width('100%')
        .aspectRatio(1)
        .borderRadius(MeowRadius.card)
        .objectFit(ImageFit.Cover)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

      Text(track.title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')

      Text(track.artist)
        .fontSize(12)
        .fontColor(MeowColors.textSecondary)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.openTrack(track)
    })
  }

  @Builder
  private AlbumGrid() {
    Column({ space: 18 }) {
      Row({ space: 14 }) {
        this.LibraryAlbumTile(MUSIC_TRACKS[0])
        this.LibraryAlbumTile(MUSIC_TRACKS[1])
      }
      .width('100%')
      Row({ space: 14 }) {
        this.LibraryAlbumTile(MUSIC_TRACKS[2])
        this.LibraryAlbumTile(MUSIC_TRACKS[3])
      }
      .width('100%')
      Row({ space: 14 }) {
        this.LibraryAlbumTile(MUSIC_TRACKS[4])
        this.LibraryAlbumTile(MUSIC_TRACKS[5])
      }
      .width('100%')
    }
    .width('100%')
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

  @Builder
  private PlaylistContent() {
    Column({ space: 16 }) {
      this.LikedSongs()
      if (this.likedTracks().length === 0) {
        Text('Your favorite tracks will gather here.')
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
      this.CollectionGrid()
      Column({ space: 12 }) {
        this.SectionHeader('Playlists', 'Made from your recent listening')
        this.PlaylistCard(MUSIC_TRACKS[0], 'PhuiSic Favorites')
        this.PlaylistCard(MUSIC_TRACKS[3], 'Late Night Focus')
        this.PlaylistCard(MUSIC_TRACKS[5], 'Soft Waves')
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private AlbumContent() {
    Column({ space: 16 }) {
      this.SectionHeader('Albums', 'Full releases and saved singles')
      this.AlbumGrid()

      Column({ space: 12 }) {
        this.SectionHeader('Recently Saved', 'Albums and singles with full details')
        ForEach(MUSIC_TRACKS.slice(6, 10), (track: Track) => {
          SongCard({ track: track })
        }, (track: Track) => `${track.id}`)
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private ArtistContent() {
    Column({ space: 14 }) {
      this.SectionHeader('Artists', 'People behind your saved music')
      Column({ space: 2 }) {
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
    }
    .width('100%')
  }

  @Builder
  private LibraryHeader() {
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
  }

  @Builder
  private TabBar() {
    Row({ space: 10 }) {
      this.LibraryTab('Playlist')
      this.LibraryTab('Album')
      this.LibraryTab('Artist')
    }
    .width('100%')
  }

  @Builder
  private ActiveTabContent() {
    if (this.activeTab === 'Playlist') {
      this.PlaylistContent()
    } else if (this.activeTab === 'Album') {
      this.AlbumContent()
    } else {
      this.ArtistContent()
    }
  }

  @Builder
  private BottomChrome() {
    Column() {
      MiniPlayer()
        .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
      BottomNavBar({ activeTab: 'Library' })
    }
    .width('100%')
    .zIndex(10)
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
          this.LibraryHeader()
          this.TabBar()
          this.ActiveTabContent()
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 64, bottom: MeowSpacing.mainContentBottomPadding + 24 })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      this.BottomChrome()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
