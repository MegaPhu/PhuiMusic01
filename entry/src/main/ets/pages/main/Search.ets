import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { SongCard } from '../../components/SongCard'
import { MUSIC_TRACKS, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

interface BrowseCategory {
  id: number
  title: string
  subtitle: string
  start: string
  end: string
}

const BROWSE_CATEGORIES: BrowseCategory[] = [
  { id: 1, title: 'Music', subtitle: 'Songs and albums', start: '#2B4D88', end: '#6C8BD8' },
  { id: 2, title: 'Podcast', subtitle: 'Stories and talk', start: '#176F5C', end: '#4FB091' },
  { id: 3, title: 'Audiobooks', subtitle: 'Long listening', start: '#5E3D8E', end: '#A983D8' },
  { id: 4, title: 'Live Events', subtitle: 'Sessions nearby', start: '#843F52', end: '#D27D8F' }
]

@Entry
@Component
struct SearchPage {
  @State private query: string = ''

  private matches(track: Track): boolean {
    if (this.query.length === 0) {
      return true
    }
    const text = `${track.title} ${track.artist} ${track.album}`.toLowerCase()
    return text.includes(this.query.toLowerCase())
  }

  private resultCount(): number {
    let count = 0
    for (let i = 0; i < MUSIC_TRACKS.length; i++) {
      if (this.matches(MUSIC_TRACKS[i])) {
        count++
      }
    }
    return count
  }

  @Builder
  private SearchGlyph() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(17)
        .height(17)
        .borderRadius(9)
        .border({ width: 2, color: MeowColors.textSecondary })
        .translate({ x: -2, y: -2 })
      Row()
        .width(9)
        .height(2)
        .borderRadius(1)
        .backgroundColor(MeowColors.textSecondary)
        .rotate({ angle: 45 })
        .translate({ x: 7, y: 8 })
    }
    .width(28)
    .height(28)
  }

  @Builder
  private SearchBar() {
    Row({ space: 12 }) {
      this.SearchGlyph()

      TextInput({ placeholder: 'What do you want to listen to?', text: this.query })
        .height(50)
        .fontSize(16)
        .fontColor(MeowColors.textPrimary)
        .placeholderColor(MeowColors.textTertiary)
        .caretColor(MeowColors.goldBright)
        .backgroundColor('rgba(0,0,0,0)')
        .layoutWeight(1)
        .onChange((value: string) => {
          console.log('[SearchPage] query changed')
          this.query = value
        })
    }
    .height(56)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .borderRadius(MeowRadius.control)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.10)' })
  }

  @Builder
  private CategoryCard(category: BrowseCategory) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Row()
        .width('100%')
        .height(116)
        .borderRadius(MeowRadius.card)
        .linearGradient({
          angle: 135,
          colors: [
            [category.start, 0.0],
            [category.end, 0.58],
            [MeowColors.solidSurface, 1.0]
          ]
        })

      Column({ space: 6 }) {
        Text(category.title)
          .fontSize(MeowTypography.subheadingSize)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Text(category.subtitle)
          .fontSize(MeowTypography.captionSize)
          .fontColor('rgba(255,255,255,0.70)')
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16, bottom: 16 })

    }
    .layoutWeight(1)
    .height(116)
    .borderRadius(MeowRadius.card)
    .clip(true)
    .onClick(() => {
      console.log(`[SearchPage] category ${category.title}`)
    })
  }

  @Builder
  private EmptyResults() {
    Column({ space: 8 }) {
      Text('No results found')
        .fontSize(MeowTypography.subheadingSize)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
      Text('Try a song, artist, or album name.')
        .fontSize(MeowTypography.bodySize)
        .fontColor(MeowColors.textSecondary)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 28, bottom: 28 })
    .borderRadius(MeowRadius.card)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private DiscoverCard(track: Track) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(track.artwork)
        .width(156)
        .height(192)
        .borderRadius(MeowRadius.large)
        .objectFit(ImageFit.Cover)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)

      Row()
        .width(156)
        .height(104)
        .borderRadius(MeowRadius.large)
        .linearGradient({
          angle: 180,
          colors: [
            ['rgba(9,10,28,0)', 0.0],
            ['rgba(9,10,28,0.62)', 0.42],
            ['rgba(9,10,28,0.92)', 1.0]
          ]
        })

      Column({ space: 6 }) {
        Text(track.kind)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(MeowColors.textTertiary)
        Text(track.title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(156)
      .padding({ left: 14, right: 14, bottom: 14 })
      .alignItems(HorizontalAlign.Start)
    }
    .width(156)
    .height(192)
    .onClick(async () => {
      PlayerManager.playTrack(track)
      await router.pushUrl({ url: 'pages/main/Player' })
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
          Row() {
            Text('Search')
              .fontSize(MeowTypography.headingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
            Blank()
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          this.SearchBar()

          Column({ space: 14 }) {
            Text('Browse')
              .fontSize(MeowTypography.headingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            Row({ space: 14 }) {
              this.CategoryCard(BROWSE_CATEGORIES[0])
              this.CategoryCard(BROWSE_CATEGORIES[1])
            }
            .width('100%')
            Row({ space: 14 }) {
              this.CategoryCard(BROWSE_CATEGORIES[2])
              this.CategoryCard(BROWSE_CATEGORIES[3])
            }
            .width('100%')
          }
          .width('100%')

          Column({ space: 14 }) {
            Text('Discover')
              .fontSize(MeowTypography.headingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            Scroll() {
              Row({ space: 16 }) {
                ForEach(MUSIC_TRACKS, (track: Track) => {
                  this.DiscoverCard(track)
                }, (track: Track) => `${track.id}`)
              }
              .padding({ right: 24 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }
          .width('100%')

          Column({ space: 12 }) {
            Text(this.query.length > 0 ? 'Results' : 'Recommended Searches')
              .fontSize(MeowTypography.subheadingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            if (this.resultCount() === 0) {
              this.EmptyResults()
            } else {
              ForEach(MUSIC_TRACKS.filter((track: Track) => this.matches(track)).slice(0, 4), (track: Track) => {
                SongCard({ track: track })
              }, (track: Track) => `${track.id}`)
            }
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
        BottomNavBar({ activeTab: 'Search' })
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
