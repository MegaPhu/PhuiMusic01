import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { MUSIC_CATEGORIES, MUSIC_TRACKS, MusicCategory, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing } from '../../theme/theme'

@Entry
@Component
struct Home {
  @State private activeCategory: string = 'All'

  private async openTrack(track: Track): Promise<void> {
    console.log(`[HomePage] open ${track.title}`)
    PlayerManager.playTrack(track)
    await router.pushUrl({ url: 'pages/main/Player' })
  }

  private greetingText(): string {
    const hour = new Date().getHours()
    if (hour < 12) {
      return 'Good morning'
    }
    if (hour < 18) {
      return 'Good afternoon'
    }
    return 'Good evening'
  }

  private visibleTracks(): Track[] {
    if (this.activeCategory === 'Podcast') {
      return MUSIC_TRACKS.slice(4, 8)
    }
    if (this.activeCategory === 'Audiobooks') {
      return MUSIC_TRACKS.slice(7, MUSIC_TRACKS.length)
    }
    return MUSIC_TRACKS
  }

  private railTitle(): string {
    if (this.activeCategory === 'All') {
      return 'Today\'s Picks'
    }
    return `${this.activeCategory} Picks`
  }

  private secondaryRailTitle(): string {
    const tracks = this.visibleTracks()
    if (tracks.length === 0) {
      return 'More to Explore'
    }
    return `More Like ${tracks[0].artist}`
  }

  private contentBottomPadding(): number {
    return MeowSpacing.mainContentBottomPadding + 24
  }

  @Builder
  private BrandBadge() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(48)
        .height(48)
        .borderRadius(24)
        .linearGradient({
          angle: 135,
          colors: [
            [MeowColors.goldDark, 0.0],
            [MeowColors.goldBright, 0.36],
            [MeowColors.goldSoft, 0.72],
            [MeowColors.goldDeep, 1.0]
          ]
        })
      Text('P')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.navyDeep)
    }
    .width(48)
    .height(48)
  }

  @Builder
  private Header() {
    Row({ space: 14 }) {
      this.BrandBadge()
      Column({ space: 3 }) {
        Text('PhuiSic')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.greetingText())
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private CategoryChip(category: MusicCategory) {
    Row() {
      Text(category.label)
        .fontSize(14)
        .fontWeight(this.activeCategory === category.label ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.activeCategory === category.label ? MeowColors.navyDeep : MeowColors.textPrimary)
    }
    .height(40)
    .padding({ left: 20, right: 20 })
    .borderRadius(20)
    .linearGradient({
      angle: 135,
      colors: this.activeCategory === category.label ? [
        [MeowColors.goldDark, 0.0],
        [MeowColors.goldBright, 0.36],
        [MeowColors.goldSoft, 0.72],
        [MeowColors.goldDeep, 1.0]
      ] : [
        ['rgba(255,255,255,0.06)', 0.0],
        ['rgba(255,255,255,0.06)', 1.0]
      ]
    })
    .border({ width: 1, color: this.activeCategory === category.label ? 'rgba(255,215,0,0.40)' : 'rgba(255,255,255,0.12)' })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      console.log(`[HomePage] category ${category.label}`)
      this.activeCategory = category.label
    })
  }

  @Builder
  private CategoryTabs() {
    Scroll() {
      Row({ space: 10 }) {
        ForEach(MUSIC_CATEGORIES, (category: MusicCategory) => {
          this.CategoryChip(category)
        }, (category: MusicCategory) => category.id)
      }
      .padding({ right: 40 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
  }

  @Builder
  private SectionHeader(title: string, showAction: boolean = false) {
    Row() {
      Text(title)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .layoutWeight(1)
      if (showAction) {
        Text('Show all')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.goldBright)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private RecentSquareCard(track: Track) {
    Column({ space: 9 }) {
      Image(track.artwork)
        .width(136)
        .height(136)
        .objectFit(ImageFit.Cover)
        .borderRadius(MeowRadius.card)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
        .shadow({
          radius: 14,
          color: MeowColors.shadowNavy,
          offsetX: 0,
          offsetY: 6
        })
      Text(track.title)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
      Text(track.artist)
        .fontSize(11)
        .fontColor(MeowColors.textSecondary)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
    }
    .width(136)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.openTrack(track)
    })
  }

  @Builder
  private RecentGrid(songs: Track[]) {
    Column({ space: 12 }) {
      this.SectionHeader('Recently Played', true)
      Scroll() {
        Row({ space: 14 }) {
          ForEach(songs, (song: Track) => {
            this.RecentSquareCard(song)
          }, (song: Track) => song.id)
        }
        .padding({ right: 40 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private KindBadge(kind: string) {
    Text(kind)
      .fontSize(12)
      .fontWeight(FontWeight.Medium)
      .fontColor(MeowColors.textSecondary)
  }

  @Builder
  private PickCard(track: Track) {
    Column({ space: 10 }) {
      Image(track.artwork)
        .width(164)
        .height(164)
        .objectFit(ImageFit.Cover)
        .borderRadius(MeowRadius.card)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
        .shadow({
          radius: 16,
          color: MeowColors.shadowNavy,
          offsetX: 0,
          offsetY: 7
        })

      Column({ space: 6 }) {
        this.KindBadge(track.kind)
        Text(track.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
        Text(track.artist)
          .fontSize(13)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width(164)
    .onClick(() => {
      this.openTrack(track)
    })
  }

  @Builder
  private HorizontalPicks(title: string, songs: Track[]) {
    Column({ space: 12 }) {
      this.SectionHeader(title)
      Scroll() {
        Row({ space: 18 }) {
          ForEach(songs, (song: Track) => {
            this.PickCard(song)
          }, (song: Track) => song.id)
        }
        .padding({ right: 40 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
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
            [MeowColors.navyMid, 0.50],
            [MeowColors.navyBottom, 1.0]
          ]
        })

      Scroll() {
        Column({ space: 28 }) {
          this.Header()
          this.CategoryTabs()
          this.RecentGrid(this.visibleTracks().slice(0, 6))
          this.HorizontalPicks(this.railTitle(), this.visibleTracks().slice(0, 6))
          this.HorizontalPicks(this.secondaryRailTitle(), this.visibleTracks().slice(1, 7))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 56, bottom: this.contentBottomPadding() })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      Column() {
        MiniPlayer()
          .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
        BottomNavBar({ activeTab: 'Home' })
      }
      .width('100%')
      .zIndex(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
