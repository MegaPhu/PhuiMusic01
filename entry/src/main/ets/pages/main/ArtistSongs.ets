import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { DEFAULT_TRACK, MUSIC_TRACKS, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing } from '../../theme/theme'

@Entry
@Component
struct ArtistSongs {
  @StorageLink('currentTrack') currentTrack: Track = DEFAULT_TRACK
  @StorageLink('isPlaying') isPlaying: boolean = false
  @State private activeTab: string = 'Music'

  private closePage(): void {
    console.log('[ArtistSongsPage] back')
    router.back()
  }

  private playTrack(track: Track): void {
    console.log(`[ArtistSongsPage] play ${track.title}`)
    PlayerManager.playTrack(track)
  }

  private togglePlay(): void {
    console.log('[ArtistSongsPage] toggle play')
    PlayerManager.togglePlay(this.isPlaying)
  }

  @Builder
  private BackButton() {
    Text('‹')
      .fontSize(42)
      .fontWeight(FontWeight.Bold)
      .fontColor(MeowColors.textPrimary)
      .width(54)
      .height(54)
      .textAlign(TextAlign.Center)
      .borderRadius(27)
      .backgroundColor('rgba(9,10,28,0.52)')
      .onClick(() => {
        this.closePage()
      })
  }

  @Builder
  private Header() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(this.currentTrack.artwork)
        .width('100%')
        .height(260)
        .objectFit(ImageFit.Cover)
        .opacity(0.84)
      Column()
        .width('100%')
        .height(160)
        .linearGradient({
          angle: 180,
          colors: [
            ['rgba(9,10,28,0)', 0.0],
            [MeowColors.navyDeep, 1.0]
          ]
        })
      Column({ space: 7 }) {
        Text(this.currentTrack.artist)
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text('10.8M monthly listeners')
          .fontSize(14)
          .fontColor(MeowColors.textSecondary)
      }
      .width('100%')
      .padding({ left: 24, right: 24, bottom: 22 })
      .alignItems(HorizontalAlign.Start)

      Row() {
        this.BackButton()
      }
      .width('100%')
      .height(92)
      .alignItems(VerticalAlign.Top)
      .padding({ left: 18, top: 34 })
    }
    .width('100%')
    .height(260)
  }

  @Builder
  private FollowButton() {
    Text('Follow')
      .fontSize(13)
      .fontWeight(FontWeight.Bold)
      .fontColor(MeowColors.textPrimary)
      .padding({ left: 20, right: 20, top: 7, bottom: 7 })
      .borderRadius(20)
      .border({ width: 1, color: 'rgba(255,255,255,0.72)' })
  }

  @Builder
  private ControlsRow() {
    Row({ space: 14 }) {
      Image(this.currentTrack.artwork)
        .width(40)
        .height(40)
        .borderRadius(10)
        .objectFit(ImageFit.Cover)
        .clip(true)
      this.FollowButton()
      Text('⋮')
        .fontSize(24)
        .fontColor(MeowColors.textSecondary)
      Blank()
      Text('⇄')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.goldBright)
      Stack({ alignContent: Alignment.Center }) {
        Text(this.isPlaying ? 'Ⅱ' : '▶')
          .fontSize(27)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.navyDeep)
      }
      .width(56)
      .height(56)
      .borderRadius(28)
      .linearGradient({
        angle: 135,
        colors: [
          [MeowColors.goldDark, 0.0],
          [MeowColors.goldBright, 0.42],
          [MeowColors.goldSoft, 1.0]
        ]
      })
      .onClick(() => {
        this.togglePlay()
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 10 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private ReleaseBanner() {
    Row({ space: 12 }) {
      Image(this.currentTrack.artwork)
        .width(42)
        .height(42)
        .borderRadius(6)
        .objectFit(ImageFit.Cover)
        .clip(true)
      Text('Listen to new releases')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .layoutWeight(1)
      Text('›')
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textSecondary)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .borderRadius(8)
    .backgroundColor('rgba(28,28,58,0.78)')
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
    .onClick(() => {
      this.playTrack(this.currentTrack)
    })
  }

  @Builder
  private TabItem(label: string) {
    Column({ space: 8 }) {
      Text(label)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.activeTab === label ? MeowColors.textPrimary : MeowColors.textSecondary)
      Row()
        .width(this.activeTab === label ? 36 : 0)
        .height(2)
        .borderRadius(1)
        .backgroundColor(this.activeTab === label ? MeowColors.goldBright : 'rgba(0,0,0,0)')
    }
    .height(38)
    .onClick(() => {
      console.log(`[ArtistSongsPage] tab ${label}`)
      this.activeTab = label
    })
  }

  @Builder
  private Tabs() {
    Row({ space: 36 }) {
      this.TabItem('Music')
      this.TabItem('Clips')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10 })
  }

  @Builder
  private PopularRow(track: Track, index: number) {
    Row({ space: 12 }) {
      Text(`${index + 1}`)
        .fontSize(14)
        .fontColor(MeowColors.textSecondary)
        .width(24)
      Image(track.artwork)
        .width(44)
        .height(44)
        .borderRadius(6)
        .objectFit(ImageFit.Cover)
        .clip(true)
      Column({ space: 4 }) {
        Row({ space: 6 }) {
          Text(track.title)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
          if (index === 3) {
            Text('E')
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.navyDeep)
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(4)
              .backgroundColor(MeowColors.textSecondary)
          }
        }
        .width('100%')
        Text(`${49 + index * 9}.${index + 2}M plays`)
          .fontSize(12)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      Text('⋮')
        .fontSize(22)
        .fontColor(MeowColors.textSecondary)
    }
    .width('100%')
    .height(58)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.playTrack(track)
    })
  }

  @Builder
  private PopularList() {
    Column({ space: 8 }) {
      Text('Popular')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .width('100%')
        .padding({ left: 16, right: 16 })
      ForEach(MUSIC_TRACKS, (track: Track, index: number) => {
        this.PopularRow(track, index)
      }, (track: Track) => track.id)
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
            [MeowColors.navyMid, 0.44],
            [MeowColors.navyBottom, 1.0]
          ]
        })

      Scroll() {
        Column({ space: 4 }) {
          this.Header()
          this.ControlsRow()
          Column({ space: 14 }) {
            this.ReleaseBanner()
            this.Tabs()
            this.PopularList()
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
        .width('100%')
        .padding({ bottom: MeowSpacing.mainContentBottomPadding })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      Column() {
        MiniPlayer()
          .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
        BottomNavBar({ activeTab: 'Home', trailingTab: 'Create' })
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
