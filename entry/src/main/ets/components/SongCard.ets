import router from '@ohos.router'
import { DEFAULT_TRACK, Track } from '../model/MusicData'
import { PlayerManager } from '../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../theme/theme'

@Component
export struct SongCard {
  @Prop track: Track = DEFAULT_TRACK
  @Prop compact: boolean = false
  @StorageLink('likedTrackIds') likedTrackIds: string = ''

  private async openPlayer(): Promise<void> {
    console.log(`[SongCard] open ${this.track.title}`)
    PlayerManager.playTrack(this.track)
    await router.pushUrl({ url: 'pages/main/Player' })
  }

  @Builder
  private Cover(sizeValue: number) {
    Image(this.track.artwork)
      .width(sizeValue)
      .height(sizeValue)
      .borderRadius(this.compact ? 10 : 12)
      .objectFit(ImageFit.Cover)
      .clip(true)
      .backgroundColor(MeowColors.solidSurface)
      .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
    .width(sizeValue)
    .height(sizeValue)
  }

  @Builder
  private LikeButton() {
    Stack({ alignContent: Alignment.Center }) {
      Text(PlayerManager.isLiked(this.track, this.likedTrackIds) ? '♥' : '♡')
        .fontSize(this.compact ? 20 : 22)
        .fontWeight(FontWeight.Bold)
        .fontColor(PlayerManager.isLiked(this.track, this.likedTrackIds) ? this.track.accent : 'rgba(255,255,255,0.68)')
    }
      .width(this.compact ? 32 : 36)
      .height(this.compact ? 34 : 38)
      .borderRadius(this.compact ? 16 : 18)
      .backgroundColor(PlayerManager.isLiked(this.track, this.likedTrackIds) ? this.track.accentSoft : 'rgba(255,255,255,0.035)')
      .onClick(() => {
        console.log(`[SongCard] toggle like ${this.track.title}`)
        PlayerManager.toggleLikedInStorage(this.track, this.likedTrackIds)
      })
  }

  build() {
    Row({ space: 12 }) {
      this.Cover(this.compact ? 54 : 64)

      Column({ space: 5 }) {
        Text(this.track.title)
          .fontSize(this.compact ? 14 : 16)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.track.kind} · ${this.track.artist}`)
          .fontSize(MeowTypography.captionSize)
          .fontColor('rgba(255,255,255,0.58)')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 2 }) {
        this.LikeButton()
        Text(this.track.durationLabel)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textTertiary)
          .width(42)
          .textAlign(TextAlign.Center)
      }
      .alignItems(HorizontalAlign.Center)
    }
    .width(this.compact ? 236 : '100%')
    .height(this.compact ? 78 : 88)
    .padding({ left: 12, right: 14, top: 12, bottom: 12 })
    .borderRadius(this.compact ? 14 : MeowRadius.card)
    .backgroundColor('rgba(28,28,58,0.78)')
    .border({ width: 1, color: 'rgba(255,255,255,0.07)' })
    .onClick(() => {
      this.openPlayer()
    })
  }
}
