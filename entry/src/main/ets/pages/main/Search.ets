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
  { id: 1, title: 'Music', subtitle: 'Songs and albums', start: '#253E73', end: '#5E7FD0' },
  { id: 2, title: 'Podcast', subtitle: 'Stories and talk', start: '#12614F', end: '#43A184' },
  { id: 3, title: 'Audiobooks', subtitle: 'Long listening', start: '#56357F', end: '#9370C8' },
  { id: 4, title: 'Live Events', subtitle: 'Sessions nearby', start: '#773649', end: '#BE6D82' }
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
    return this.filteredTracks().length
  }

  private filteredTracks(): Track[] {
    const results: Track[] = []
    for (let i = 0; i < MUSIC_TRACKS.length; i++) {
      if (this.matches(MUSIC_TRACKS[i])) {
        results.push(MUSIC_TRACKS[i])
      }
    }
    return results
  }

  private visibleResults(): Track[] {
    const results = this.filteredTracks()
    if (this.query.length > 0) {
      return results
    }
    return results.slice(0, 4)
  }

  private resultSummary(): string {
    if (this.query.length === 0) {
      return 'Songs you may want next'
    }
    const count = this.resultCount()
    if (count === 1) {
      return '1 match'
    }
    return `${count} matches`
  }

  private contentBottomPadding(): number {
    return MeowSpacing.mainContentBottomPadding + 24
  }

  private clearQuery(): void {
    console.log('[SearchPage] clear query')
    this.query = ''
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

      if (this.query.length > 0) {
        Text('×')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textSecondary)
          .width(34)
          .height(34)
          .textAlign(TextAlign.Center)
          .borderRadius(17)
          .backgroundColor('rgba(255,255,255,0.06)')
          .onClick(() => {
            this.clearQuery()
          })
      }
    }
    .height(56)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .borderRadius(MeowRadius.control)
    .backgroundColor('rgba(28,28,58,0.88)')
    .border({ width: 1, color: this.query.length > 0 ? 'rgba(212,175,55,0.42)' : 'rgba(255,255,255,0.10)' })
    .shadow({
      radius: this.query.length > 0 ? 16 : 0,
      color: this.query.length > 0 ? 'rgba(212,175,55,0.14)' : 'rgba(0,0,0,0)',
      offsetX: 0,
      offsetY: 6
    })
    .animation({ duration: 180, curve: Curve.EaseOut })
  }

  @Builder
  private CategoryCard(category: BrowseCategory) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Row()
        .width('100%')
        .height(124)
        .borderRadius(MeowRadius.card)
        .linearGradient({
          angle: 135,
          colors: [
            [category.start, 0.0],
            [category.end, 0.66],
            ['rgba(28,28,58,0.92)', 1.0]
          ]
        })

      Column({ space: 6 }) {
        Text(category.title)
          .fontSize(MeowTypography.subheadingSize)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(category.subtitle)
          .fontSize(MeowTypography.captionSize)
          .fontColor('rgba(255,255,255,0.70)')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16, bottom: 18 })

    }
    .layoutWeight(1)
    .height(124)
    .borderRadius(MeowRadius.card)
    .border({ width: 1, color: 'rgba(255,255,255,0.10)' })
    .clip(true)
    .shadow({
      radius: 10,
      color: 'rgba(4,5,20,0.32)',
      offsetX: 0,
      offsetY: 5
    })
    .onClick(() => {
      console.log(`[SearchPage] category ${category.title}`)
    })
  }

  @Builder
  private EmptyResults() {
    Column({ space: 10 }) {
      this.SearchGlyph()
      Text('No results found')
        .fontSize(MeowTypography.subheadingSize)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
      Text(this.query.length > 0 ? `No matches for "${this.query}"` : 'Try a song, artist, or album name.')
        .fontSize(MeowTypography.bodySize)
        .fontColor(MeowColors.textSecondary)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ left: 18, right: 18, top: 28, bottom: 28 })
    .borderRadius(MeowRadius.card)
    .backgroundColor('rgba(28,28,58,0.72)')
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private DiscoverCard(track: Track) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(track.artwork)
        .width(160)
        .height(196)
        .borderRadius(18)
        .objectFit(ImageFit.Cover)
        .clip(true)
        .backgroundColor(MeowColors.solidSurface)
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

      Row()
        .width(160)
        .height(104)
        .borderRadius(18)
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
        Text(track.artist)
          .fontSize(12)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(160)
      .padding({ left: 14, right: 14, bottom: 14 })
      .alignItems(HorizontalAlign.Start)
    }
    .width(160)
    .height(196)
    .shadow({
      radius: 16,
      color: MeowColors.shadowNavy,
      offsetX: 0,
      offsetY: 7
    })
    .onClick(async () => {
      PlayerManager.playTrack(track)
      await router.pushUrl({ url: 'pages/main/Player' })
    })
  }

  @Builder
  private ResultsHeader() {
    Row() {
      Column({ space: 3 }) {
        Text(this.query.length > 0 ? 'Results' : 'Recommended Searches')
          .fontSize(MeowTypography.subheadingSize)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Text(this.resultSummary())
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textTertiary)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private BrowseContent() {
    Column({ space: MeowSpacing.sectionGap }) {
      Column({ space: 16 }) {
        Text('Browse All')
          .fontSize(22)
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
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .width('100%')
        Scroll() {
          Row({ space: 16 }) {
            ForEach(MUSIC_TRACKS, (track: Track) => {
              this.DiscoverCard(track)
            }, (track: Track) => `${track.id}`)
          }
          .padding({ right: 40 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private ResultsContent() {
    Column({ space: 12 }) {
      this.ResultsHeader()
      if (this.resultCount() === 0) {
        this.EmptyResults()
      } else {
        ForEach(this.visibleResults(), (track: Track) => {
          SongCard({ track: track })
        }, (track: Track) => `${track.id}`)
      }
    }
    .width('100%')
  }

  @Builder
  private BottomChrome() {
    Column() {
      MiniPlayer()
        .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
      BottomNavBar({ activeTab: 'Search' })
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

          if (this.query.length === 0) {
            this.BrowseContent()
          }

          this.ResultsContent()
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
