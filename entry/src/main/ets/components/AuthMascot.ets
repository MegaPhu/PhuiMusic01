import { MeowColors, MeowEffects } from '../theme/theme'

@Component
export struct AuthMascot {
  @Prop compact: boolean = false
  @Prop dj: boolean = false
  @Prop variant: string = ''
  @State private breathe: number = 1
  private timerId: number = -1

  aboutToAppear(): void {
    this.timerId = setInterval(() => {
      this.breathe = this.breathe === 1 ? 1.035 : 1
    }, 1300)
  }

  aboutToDisappear(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  private imageSize(): number {
    if (this.variant === 'logo') {
      return 54
    }
    if (this.variant === 'reset') {
      return 176
    }
    if (this.dj) {
      return 286
    }
    return this.compact ? 118 : 190
  }

  @Builder
  private MascotImage(sizeValue: number) {
    Image($r('app.media.meowsic_cat_mascot'))
      .width(sizeValue)
      .height(sizeValue)
      .objectFit(ImageFit.Contain)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Circle()
        .width(this.imageSize() * 0.72)
        .height(this.imageSize() * 0.72)
        .fill(MeowColors.glowGoldHalo)
        .blur(this.compact ? 16 : 28)

      this.MascotImage(this.imageSize())

      if (this.dj) {
        Circle()
          .width(this.imageSize() * 0.72)
          .height(this.imageSize() * 0.72)
          .fill(MeowColors.transparent)
          .border({ width: 2, color: MeowColors.goldRingSoft })
          .opacity(0.36)
      }
    }
    .width(this.imageSize())
    .height(this.imageSize())
    .scale({ x: this.breathe, y: this.breathe })
    .shadow({
      radius: this.dj ? 22 : MeowEffects.glowBlur,
      color: this.dj ? MeowColors.glowGold : MeowColors.glowGoldFaint,
      offsetX: 0,
      offsetY: 0
    })
    .animation({ duration: 950, curve: Curve.EaseInOut })
  }
}
