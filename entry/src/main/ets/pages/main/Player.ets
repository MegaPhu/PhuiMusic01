import router from '@ohos.router'
import { LyricsCard } from '../../components/LyricsCard'
import { DEFAULT_TRACK, MUSIC_TRACKS, Track } from '../../model/MusicData'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowEffects, MeowRadius, MeowSpacing } from '../../theme/theme'

interface LyricLine {
  index: number
  text: string
}

@Entry
@Component
struct Player {
  @StorageLink('currentTrack') currentTrack: Track = DEFAULT_TRACK
  @StorageLink('isPlaying') isPlaying: boolean = false
  @StorageLink('likedTrackIds') likedTrackIds: string = ''
  @StorageLink('currentTimeSeconds') elapsedSeconds: number = 0
  @State private lyricsExpanded: boolean = false
  private playTimer: number = -1

  aboutToAppear(): void {
    this.elapsedSeconds = Math.max(0, Math.min(this.elapsedSeconds, this.currentTrack.duration))
    this.startTimer()
  }

  aboutToDisappear(): void {
    this.stopTimer()
  }

  private startTimer(): void {
    if (this.playTimer !== -1) {
      return
    }
    this.playTimer = setInterval(() => {
      if (this.isPlaying) {
        const nextSecond = this.elapsedSeconds + 1
        this.elapsedSeconds = nextSecond > this.currentTrack.duration ? 0 : nextSecond
      }
    }, 1000)
  }

  private stopTimer(): void {
    if (this.playTimer !== -1) {
      clearInterval(this.playTimer)
      this.playTimer = -1
    }
  }

  private activeLyricIndexFor(seconds: number): number {
    if (this.currentTrack.lyrics.length === 0 || this.currentTrack.timestamps.length === 0) {
      return -1
    }
    let activeIndex = 0
    const elapsedMs = seconds * 1000
    for (let i = 0; i < this.currentTrack.timestamps.length; i++) {
      if (elapsedMs >= this.currentTrack.timestamps[i]) {
        activeIndex = i
      }
    }
    return Math.min(activeIndex, this.currentTrack.lyrics.length - 1)
  }

  private resetPlaybackPosition(): void {
    this.elapsedSeconds = 0
  }

  private activeLyricIndex(): number {
    return this.activeLyricIndexFor(this.elapsedSeconds)
  }

  private artistListeners(): string {
    const artist = this.currentTrack.artist
    if (artist === 'Yung Kai') {
      return '10.8M monthly listeners'
    }
    if (artist === 'DJ Asul') {
      return '4.2M monthly listeners'
    }
    if (artist === 'Lady Gaga, Bruno Mars') {
      return '118.5M monthly listeners'
    }
    if (artist === 'Fujii Kaze') {
      return '8.7M monthly listeners'
    }
    if (artist === 'imase') {
      return '6.1M monthly listeners'
    }
    if (artist === 'Escape Plan') {
      return '3.4M monthly listeners'
    }
    if (artist === '承桓') {
      return '2.9M monthly listeners'
    }
    if (artist === 'WanYai') {
      return '1.8M monthly listeners'
    }
    if (artist === 'GUNGUN') {
      return '1.2M monthly listeners'
    }
    if (artist === 'Tiger') {
      return '860K monthly listeners'
    }
    if (artist === 'EMIN feat.JONY') {
      return '5.6M monthly listeners'
    }
    return '1.0M monthly listeners'
  }

  private allLyrics(): LyricLine[] {
    const lines: LyricLine[] = []
    for (let i = 0; i < this.currentTrack.lyrics.length; i++) {
      lines.push({ index: i, text: this.currentTrack.lyrics[i] })
    }
    return lines
  }

  private progressPercent(): string {
    if (this.currentTrack.duration <= 0) {
      return '0%'
    }
    const percent = Math.min(100, Math.max(0, Math.floor((this.elapsedSeconds / this.currentTrack.duration) * 100)))
    return `${percent}%`
  }

  private elapsedLabel(): string {
    const minutes = Math.floor(this.elapsedSeconds / 60)
    const seconds = this.elapsedSeconds % 60
    return `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`
  }

  private togglePlay(): void {
    PlayerManager.togglePlay(this.isPlaying)
    console.log(`[PlayerPage] toggle ${this.currentTrack.title}`)
  }

  private previousTrack(): void {
    PlayerManager.playPrevious(this.currentTrack, this.isPlaying)
    this.resetPlaybackPosition()
    this.lyricsExpanded = false
    console.log('[PlayerPage] previous track')
  }

  private nextTrack(): void {
    PlayerManager.playNext(this.currentTrack, this.isPlaying)
    this.resetPlaybackPosition()
    this.lyricsExpanded = false
    console.log('[PlayerPage] next track')
  }

  private toggleLike(): void {
    PlayerManager.toggleLikedInStorage(this.currentTrack, this.likedTrackIds)
    console.log(`[PlayerPage] add to library ${this.currentTrack.title}`)
  }

  private async openArtistSongs(): Promise<void> {
    console.log(`[PlayerPage] explore artist ${this.currentTrack.artist}`)
    await router.pushUrl({ url: 'pages/main/ArtistSongs' })
  }

  private closePlayer(): void {
    console.log('[PlayerPage] close player')
    router.back()
  }

  @Builder
  private TopIcon(label: string, action: () => void) {
    Text(label)
      .fontSize(label === '⋮' ? 24 : 28)
      .fontWeight(FontWeight.Bold)
      .fontColor(MeowColors.textPrimary)
      .width(42)
      .height(42)
      .textAlign(TextAlign.Center)
      .borderRadius(21)
      .backgroundColor('rgba(255,255,255,0.04)')
      .border({ width: 1, color: 'rgba(255,255,255,0.06)' })
      .onClick(action)
  }

  @Builder
  private TopBar() {
    Row() {
      this.TopIcon('⌄', () => {
        this.closePlayer()
      })
      Column({ space: 2 }) {
        Text(`Playing from ${this.currentTrack.album}`)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(MeowColors.textTertiary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.currentTrack.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      this.TopIcon('⋮', () => {
        console.log('[PlayerPage] menu tapped')
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private CoverStage() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width('100%')
        .aspectRatio(1)
        .borderRadius(MeowRadius.large)
        .backgroundColor('rgba(255,255,255,0.035)')
        .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

      Image(this.currentTrack.artwork)
        .width('100%')
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .borderRadius(MeowRadius.large)
        .clip(true)
    }
    .width('100%')
    .aspectRatio(1)
    .borderRadius(MeowRadius.large)
    .shadow({
      radius: 28,
      color: this.currentTrack.accentSoft,
      offsetX: 0,
      offsetY: 10
    })
    .scale({
      x: this.isPlaying ? 1 : 0.94,
      y: this.isPlaying ? 1 : 0.94
    })
    .animation({ duration: 500, curve: Curve.EaseInOut })
    .parallelGesture(
      PanGesture({ direction: PanDirection.Horizontal, distance: 36 })
        .onActionEnd((event: GestureEvent) => {
          if (event.offsetX <= -48) {
            this.nextTrack()
          } else if (event.offsetX >= 48) {
            this.previousTrack()
          }
        })
    )
  }

  @Builder
  private AddLibraryIcon(active: boolean) {
    Stack({ alignContent: Alignment.Center }) {
      Circle()
        .width(42)
        .height(42)
        .fill(active ? this.currentTrack.accentSoft : 'rgba(255,255,255,0.045)')
        .stroke(active ? this.currentTrack.accent : 'rgba(255,255,255,0.26)')
        .strokeWidth(1.6)

      Row()
        .width(18)
        .height(2.4)
        .borderRadius(1.2)
        .backgroundColor(active ? this.currentTrack.accent : MeowColors.textPrimary)

      Row()
        .width(2.4)
        .height(18)
        .borderRadius(1.2)
        .backgroundColor(active ? this.currentTrack.accent : MeowColors.textPrimary)
    }
    .width(44)
    .height(44)
  }

  @Builder
  private SongInfoRow() {
    Row({ space: 14 }) {
      Column({ space: 5 }) {
        Text(this.currentTrack.title)
          .fontSize(21)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.currentTrack.artist)
          .fontSize(14)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Stack() {
        this.AddLibraryIcon(PlayerManager.isLiked(this.currentTrack, this.likedTrackIds))
      }
      .width(44)
      .height(44)
        .onClick(() => {
          this.toggleLike()
        })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private Progress() {
    Column({ space: 8 }) {
      Stack({ alignContent: Alignment.Start }) {
        Row()
          .width('100%')
          .height(4)
          .borderRadius(2)
          .backgroundColor('rgba(255,255,255,0.18)')
        Row()
          .width(this.progressPercent())
          .height(4)
          .borderRadius(2)
          .backgroundColor(this.currentTrack.accent)
          .animation({ duration: 500, curve: Curve.EaseInOut })
        Row() {
          Blank()
          Circle()
            .width(12)
            .height(12)
            .fill(this.currentTrack.accent)
        }
        .width(this.progressPercent())
        .height(12)
        .translate({ x: 6, y: -4 })
      }
      .width('100%')
      .height(12)

      Row() {
        Text(this.elapsedLabel())
          .fontSize(11)
          .fontColor(MeowColors.textSecondary)
        Blank()
        Text(this.currentTrack.durationLabel)
          .fontSize(11)
          .fontColor(MeowColors.textSecondary)
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private ControlIcon(label: string, active: boolean, action: () => void) {
    Text(label)
      .fontSize(25)
      .fontWeight(FontWeight.Bold)
      .fontColor(active ? this.currentTrack.accent : MeowColors.textSecondary)
      .width(46)
      .height(46)
      .textAlign(TextAlign.Center)
      .opacity(active ? 1 : 0.84)
      .onClick(action)
  }

  @Builder
  private PlayPauseButton() {
    Stack({ alignContent: Alignment.Center }) {
      Text(this.isPlaying ? 'Ⅱ' : '▶')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#000000')
    }
    .width(60)
    .height(60)
    .borderRadius(30)
    .backgroundColor(MeowColors.textPrimary)
    .shadow({
      radius: this.isPlaying ? MeowEffects.glowBlur : 0,
      color: this.isPlaying ? this.currentTrack.accentSoft : 'rgba(0,0,0,0)',
      offsetX: 0,
      offsetY: 0
    })
    .animation({ duration: 500, curve: Curve.EaseInOut })
    .onClick(() => {
      this.togglePlay()
    })
  }

  @Builder
  private Controls() {
    Row() {
      this.ControlIcon('⇄', true, () => {
        console.log('[PlayerPage] shuffle tapped')
      })
      this.ControlIcon('‹', false, () => {
        this.previousTrack()
      })
      this.PlayPauseButton()
      this.ControlIcon('›', false, () => {
        this.nextTrack()
      })
      this.ControlIcon('↻', false, () => {
        console.log('[PlayerPage] repeat tapped')
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  private ShareActionIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(18)
        .height(2)
        .borderRadius(1)
        .backgroundColor(MeowColors.textSecondary)
        .rotate({ angle: -32 })
        .translate({ x: 0, y: -2 })
      Row()
        .width(18)
        .height(2)
        .borderRadius(1)
        .backgroundColor(MeowColors.textSecondary)
        .rotate({ angle: 28 })
        .translate({ x: 0, y: 5 })
      Circle()
        .width(6)
        .height(6)
        .fill(MeowColors.textSecondary)
        .translate({ x: -9, y: 7 })
      Circle()
        .width(6)
        .height(6)
        .fill(MeowColors.textSecondary)
        .translate({ x: 8, y: -8 })
      Circle()
        .width(6)
        .height(6)
        .fill(MeowColors.textSecondary)
        .translate({ x: 10, y: 9 })
    }
    .width(28)
    .height(28)
  }

  @Builder
  private QueueActionIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(22)
        .height(2.4)
        .borderRadius(1.2)
        .backgroundColor(MeowColors.textSecondary)
        .translate({ x: 0, y: -7 })
      Row()
        .width(22)
        .height(2.4)
        .borderRadius(1.2)
        .backgroundColor(MeowColors.textSecondary)
      Row()
        .width(22)
        .height(2.4)
        .borderRadius(1.2)
        .backgroundColor(MeowColors.textSecondary)
        .translate({ x: 0, y: 7 })
    }
    .width(28)
    .height(28)
  }

  @Builder
  private BottomAction(label: string, action: () => void) {
    Column({ space: 3 }) {
      if (label === 'Connect') {
        this.DeviceActionIcon()
      } else if (label === 'Share') {
        this.ShareActionIcon()
      } else {
        this.QueueActionIcon()
      }

      Text(label)
        .fontSize(10)
        .fontColor(MeowColors.textTertiary)
    }
    .width(72)
    .height(44)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(action)
  }

  @Builder
  private BottomActions() {
    Row() {
      this.BottomAction('Connect', () => {
        console.log('[PlayerPage] connect device tapped')
      })
      this.BottomAction('Share', () => {
        console.log('[PlayerPage] share tapped')
      })
      this.BottomAction('Queue', () => {
        console.log('[PlayerPage] queue tapped')
      })
    }
    .width('100%')
    .height(46)
    .padding({ left: 8, right: 8 })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  private DeviceActionIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(16)
        .height(22)
        .borderRadius(4)
        .border({ width: 2, color: MeowColors.textSecondary })
      Row()
        .width(5)
        .height(5)
        .borderRadius(3)
        .backgroundColor(MeowColors.textSecondary)
        .translate({ x: 0, y: 7 })
      Row()
        .width(12)
        .height(16)
        .borderRadius(3)
        .border({ width: 2, color: MeowColors.textSecondary })
        .translate({ x: -11, y: 4 })
    }
    .width(28)
    .height(28)
  }

  @Builder
  private ExpandedLyrics() {
    Column({ space: 16 }) {
      Row() {
        Text('Lyrics')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Blank()
        Text('Hide')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.currentTrack.accent)
          .onClick(() => {
            this.lyricsExpanded = false
          })
      }
      .width('100%')

      Column({ space: 13 }) {
        ForEach(this.allLyrics(), (line: LyricLine) => {
          Text(line.text.length > 0 ? line.text : ' ')
            .fontSize(line.index === this.activeLyricIndex() ? 20 : 16)
            .fontWeight(line.index === this.activeLyricIndex() ? FontWeight.Bold : FontWeight.Medium)
            .fontColor(line.index === this.activeLyricIndex() ? MeowColors.textPrimary : MeowColors.textTertiary)
            .width('100%')
            .opacity(line.index === this.activeLyricIndex() ? 1 : 0.56)
            .animation({ duration: 500, curve: Curve.EaseInOut })
      }, (line: LyricLine) => `${line.index}`)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(18)
    .borderRadius(MeowRadius.large)
    .backgroundColor('rgba(28,28,58,0.90)')
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
  }

  @Builder
  private ExploreCard(label: string, artwork: Resource, opensArtistSongs: boolean) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(artwork)
        .width(140)
        .height(140)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)
        .clip(true)
      Row()
        .width(140)
        .height(70)
        .linearGradient({
          angle: 180,
          colors: [
            ['rgba(9,10,28,0)', 0.0],
            ['rgba(9,10,28,0.84)', 1.0]
          ]
        })
      Text(label)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(140)
        .padding({ left: 10, right: 10, bottom: 10 })
    }
    .width(140)
    .height(140)
    .borderRadius(12)
    .clip(true)
    .onClick(() => {
      if (opensArtistSongs) {
        this.openArtistSongs()
      } else {
        console.log(`[PlayerPage] explore ${label}`)
      }
    })
  }

  @Builder
  private ArtistInfoCard() {
    Row({ space: 16 }) {
      Column({ space: 5 }) {
        Text(this.currentTrack.artist)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.artistListeners())
          .fontSize(13)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('Follow')
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .borderRadius(20)
        .border({ width: 1, color: 'rgba(255,255,255,0.72)' })
        .onClick(() => {
          console.log(`[PlayerPage] follow ${this.currentTrack.artist}`)
        })
    }
    .width('100%')
    .padding(20)
    .borderRadius(MeowRadius.card)
    .backgroundColor('rgba(28,28,58,0.92)')
    .border({ width: 1, color: 'rgba(255,255,255,0.075)' })
    .shadow({
      radius: 22,
      color: 'rgba(0,0,0,0.22)',
      offsetX: 0,
      offsetY: 8
    })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  private ExploreArtist() {
    Column({ space: 14 }) {
      Text(`Explore ${this.currentTrack.artist}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .width('100%')
      Scroll() {
        Row({ space: 12 }) {
          this.ExploreCard(`${this.currentTrack.artist}'s Songs`, this.currentTrack.artwork, true)
          this.ExploreCard('Similar Artists', MUSIC_TRACKS[1].artwork, false)
          this.ExploreCard(`Similar to ${this.currentTrack.title}`, MUSIC_TRACKS[2].artwork, false)
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            [this.currentTrack.accentSoft, 0.0],
            ['#000000', 1.0]
          ]
        })
        .animation({ duration: 500, curve: Curve.EaseInOut })

      Scroll() {
        Column({ space: 18 }) {
          this.TopBar()
          this.CoverStage()
          this.SongInfoRow()
          this.Progress()
          this.Controls()
          this.BottomActions()
          LyricsCard({
            track: this.currentTrack,
            elapsedSeconds: this.elapsedSeconds,
            action: () => {
              this.lyricsExpanded = !this.lyricsExpanded
            }
          })
          if (this.lyricsExpanded) {
            this.ExpandedLyrics()
          }
          this.ArtistInfoCard()
          this.ExploreArtist()
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 34, bottom: MeowSpacing.playerContentBottomPadding })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
