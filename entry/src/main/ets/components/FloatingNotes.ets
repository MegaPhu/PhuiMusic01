import { MeowColors, MeowEffects } from '../theme/theme'

@Component
export struct FloatingNotes {
  @Prop compact: boolean = false
  @State private drift: number = 0
  private timerId: number = -1

  aboutToAppear(): void {
    this.timerId = setInterval(() => {
      this.drift = this.drift === 0 ? 1 : 0
    }, 1400)
  }

  aboutToDisappear(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
  }

  @Builder
  private Note(label: string, x: number, y: number, sizeValue: number, opacityValue: number) {
    Text(label)
      .fontSize(sizeValue)
      .fontWeight(FontWeight.Bold)
      .fontColor(MeowColors.goldBright)
      .opacity(opacityValue)
      .translate({
        x: x + (this.drift === 1 ? 5 : -3),
        y: y + (this.drift === 1 ? -8 : 4)
      })
      .shadow({
        radius: MeowEffects.glowBlur,
        color: MeowColors.glowGold,
        offsetX: 0,
        offsetY: 0
      })
      .animation({ duration: 1200, curve: Curve.EaseInOut })
  }

  build() {
    Stack() {
      this.Note('♪', -112, -82, this.compact ? 15 : 20, 0.42)
      this.Note('♫', 112, 74, this.compact ? 16 : 21, 0.36)
    }
    .width('100%')
    .height(this.compact ? 220 : 320)
    .hitTestBehavior(HitTestMode.None)
  }
}
