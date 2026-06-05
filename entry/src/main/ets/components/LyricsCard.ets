import { DEFAULT_TRACK, Track } from '../model/MusicData'
import { MeowColors, MeowRadius } from '../theme/theme'

interface VisibleLyric {
  index: number
  text: string
}

@Component
export struct LyricsCard {
  @Prop track: Track = DEFAULT_TRACK
  @Prop elapsedSeconds: number = 0
  action: () => void = () => {}

  private activeLyricIndex(): number {
    let activeIndex = 0
    const elapsedMs = this.elapsedSeconds * 1000
    for (let i = 0; i < this.track.timestamps.length; i++) {
      if (elapsedMs >= this.track.timestamps[i]) {
        activeIndex = i
      }
    }
    return Math.min(activeIndex, this.track.lyrics.length - 1)
  }

  private visibleLyrics(): VisibleLyric[] {
    const activeIndex = this.activeLyricIndex()
    const lines: VisibleLyric[] = []
    const startIndex = Math.max(0, activeIndex - 1)
    const endIndex = Math.min(this.track.lyrics.length - 1, activeIndex + 2)
    for (let i = startIndex; i <= endIndex; i++) {
      lines.push({ index: i, text: this.track.lyrics[i] })
    }
    return lines
  }

  private lineOpacity(index: number): number {
    const distance = Math.abs(index - this.activeLyricIndex())
    if (distance === 0) {
      return 1
    }
    if (distance === 1) {
      return 0.52
    }
    return 0.32
  }

  build() {
    Column({ space: 14 }) {
      Row() {
        Text('Lyrics Preview')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Blank()
        Text('Show')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.track.accent)
      }
      .width('100%')

      Column({ space: 9 }) {
        ForEach(this.visibleLyrics(), (line: VisibleLyric) => {
          Text(line.text.length > 0 ? line.text : ' ')
            .fontSize(line.index === this.activeLyricIndex() ? 19 : 14)
            .fontWeight(line.index === this.activeLyricIndex() ? FontWeight.Bold : FontWeight.Regular)
            .fontColor(line.index === this.activeLyricIndex() ? MeowColors.textPrimary : MeowColors.textSecondary)
            .opacity(this.lineOpacity(line.index))
            .maxLines(line.index === this.activeLyricIndex() ? 2 : 1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .translate({ x: 0, y: line.index === this.activeLyricIndex() ? 0 : 2 })
            .animation({ duration: 180, curve: Curve.EaseOut })
        }, (line: VisibleLyric) => `${line.index}`)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(20)
    .borderRadius(MeowRadius.large)
    .backgroundColor(MeowColors.surfaceOverlay)
    .border({ width: 1, color: MeowColors.borderSoft })
    .shadow({
      radius: 20,
      color: MeowColors.shadowNavy,
      offsetX: 0,
      offsetY: 10
    })
    .animation({ duration: 500, curve: Curve.EaseInOut })
    .onClick(() => {
      this.action()
    })
  }
}
