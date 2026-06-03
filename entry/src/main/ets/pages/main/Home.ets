import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { MUSIC_CATEGORIES, MUSIC_TRACKS, MusicCategory, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowSpacing } from '../../theme/theme'

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
      .padding({ right: 16 })
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
        .width('100%')
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .borderRadius(14)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
        .shadow({
          radius: 16,
          color: 'rgba(0,0,0,0.28)',
          offsetX: 0,
          offsetY: 8
        })
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
  private RecentGrid(songs: Track[]) {
    Column({ space: 12 }) {
      this.SectionHeader('Recently Played', true)
      Row({ space: 12 }) {
        this.RecentSquareCard(songs[0])
        this.RecentSquareCard(songs[1])
      }
      .width('100%')
      Row({ space: 12 }) {
        this.RecentSquareCard(songs[2])
        this.RecentSquareCard(songs[3])
      }
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
        .borderRadius(14)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
        .shadow({
          radius: 18,
          color: 'rgba(0,0,0,0.30)',
          offsetX: 0,
          offsetY: 10
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
        .padding({ right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
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
          this.RecentGrid(MUSIC_TRACKS.slice(0, 4))
          this.HorizontalPicks('Today\'s Picks', MUSIC_TRACKS.slice(0, 6))
          this.HorizontalPicks('More Like DJ Asul', MUSIC_TRACKS.slice(1, 6))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 52, bottom: MeowSpacing.mainContentBottomPadding })
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
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
