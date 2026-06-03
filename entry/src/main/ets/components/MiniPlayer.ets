import router from '@ohos.router'
import { DEFAULT_TRACK, Track } from '../model/MusicData'
import { PlayerManager } from '../model/PlayerManager'
import { MeowColors, MeowEffects } from '../theme/theme'

@Component
export struct MiniPlayer {
  @StorageLink('currentTrack') currentTrack: Track = DEFAULT_TRACK
  @StorageLink('isPlaying') isPlaying: boolean = false
  @StorageLink('likedTrackIds') likedTrackIds: string = ''

  private async openPlayer(): Promise<void> {
    console.log('[MiniPlayer] open player')
    await router.pushUrl({ url: 'pages/main/Player' })
  }

  private togglePlay(): void {
    console.log('[MiniPlayer] toggle play')
    PlayerManager.togglePlay(this.isPlaying)
  }

  private toggleLike(): void {
    console.log(`[MiniPlayer] add to library ${this.currentTrack.title}`)
    PlayerManager.toggleLikedInStorage(this.currentTrack, this.likedTrackIds)
  }

  @Builder
  private Cover() {
    Image(this.currentTrack.artwork)
      .width(72)
      .height(72)
      .objectFit(ImageFit.Cover)
      .clip(true)
      .backgroundColor(MeowColors.solidSurface)
  }

  @Builder
  private ActionIcon(label: string, sizeValue: number, action: () => void = () => {}) {
    Text(label)
      .fontSize(sizeValue)
      .fontWeight(FontWeight.Bold)
      .fontColor(MeowColors.textPrimary)
      .opacity(0.94)
      .width(30)
      .height(44)
      .textAlign(TextAlign.Center)
      .onClick(() => {
        action()
      })
  }

  @Builder
  private DeviceActionIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(16)
        .height(22)
        .borderRadius(4)
        .border({ width: 2, color: MeowColors.textPrimary })
      Row()
        .width(5)
        .height(5)
        .borderRadius(3)
        .backgroundColor(MeowColors.textPrimary)
        .translate({ x: 0, y: 7 })
      Row()
        .width(12)
        .height(16)
        .borderRadius(3)
        .border({ width: 2, color: MeowColors.textPrimary })
        .translate({ x: -11, y: 4 })
    }
    .width(30)
    .height(44)
    .opacity(0.94)
    .onClick(() => {
      console.log('[MiniPlayer] connect tapped')
    })
  }

  @Builder
  private AddLibraryIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Circle()
        .width(30)
        .height(30)
        .fill(PlayerManager.isLiked(this.currentTrack, this.likedTrackIds) ? this.currentTrack.accentSoft : 'rgba(0,0,0,0)')
        .stroke(PlayerManager.isLiked(this.currentTrack, this.likedTrackIds) ? this.currentTrack.accent : MeowColors.textPrimary)
        .strokeWidth(2)

      Row()
        .width(14)
        .height(2.2)
        .borderRadius(1.1)
        .backgroundColor(PlayerManager.isLiked(this.currentTrack, this.likedTrackIds) ? this.currentTrack.accent : MeowColors.textPrimary)

      Row()
        .width(2.2)
        .height(14)
        .borderRadius(1.1)
        .backgroundColor(PlayerManager.isLiked(this.currentTrack, this.likedTrackIds) ? this.currentTrack.accent : MeowColors.textPrimary)
    }
    .width(30)
    .height(44)
    .opacity(0.94)
    .onClick(() => {
      this.toggleLike()
    })
  }

  @Builder
  private PlayButton() {
    this.ActionIcon(this.isPlaying ? 'Ⅱ' : '▶', 28, () => {
      this.togglePlay()
    })
  }

  build() {
    Row({ space: 14 }) {
      Row() {
        this.Cover()
      }
      .width(72)
      .height(72)
      .onClick(() => {
        this.openPlayer()
      })

      Column({ space: 5 }) {
        Text(this.currentTrack.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.currentTrack.artist)
          .fontSize(13)
          .fontColor('rgba(255,255,255,0.75)')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.openPlayer()
      })

      Row({ space: 20 }) {
        this.DeviceActionIcon()
        this.AddLibraryIcon()
        this.PlayButton()
      }
      .padding({ right: 16 })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(72)
    .padding({ left: 0, right: 0, top: 0, bottom: 0 })
    .backgroundColor('rgba(12,13,31,0.92)')
    .border({ width: 1, color: 'rgba(255,255,255,0.09)' })
    .borderRadius(16)
    .clip(true)
    .backdropBlur(MeowEffects.backdropBlur)
    .shadow({
      radius: 22,
      color: 'rgba(0,0,0,0.38)',
      offsetX: 0,
      offsetY: 8
    })
  }
}
