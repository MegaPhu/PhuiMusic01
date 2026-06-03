import router from '@ohos.router'
import { DEFAULT_TRACK, Track } from '../model/MusicData'
import { PlayerManager } from '../model/PlayerManager'
import { MeowColors, MeowRadius, MeowTypography } from '../theme/theme'

@Component
export struct AlbumCard {
  @Prop track: Track = DEFAULT_TRACK

  private async openPlayer(): Promise<void> {
    console.log(`[AlbumCard] open ${this.track.title}`)
    PlayerManager.playTrack(this.track)
    await router.pushUrl({ url: 'pages/main/Player' })
  }

  @Builder
  private Cover() {
    Image(this.track.artwork)
      .width(152)
      .height(152)
      .borderRadius(14)
      .objectFit(ImageFit.Cover)
      .clip(true)
      .backgroundColor(MeowColors.solidSurface)
      .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
      .shadow({ radius: 18, color: 'rgba(4,5,20,0.34)', offsetX: 0, offsetY: 10 })
    .width(152)
    .height(152)
  }

  build() {
    Column({ space: 9 }) {
      this.Cover()
      Column({ space: 4 }) {
        Text(this.track.kind)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(MeowColors.textTertiary)
          .maxLines(1)
        Text(this.track.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.track.artist)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(152)
      .alignItems(HorizontalAlign.Start)
    }
    .width(152)
    .onClick(() => {
      this.openPlayer()
    })
  }
}
