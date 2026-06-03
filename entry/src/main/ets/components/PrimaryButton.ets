import { MeowColors, MeowEffects, MeowRadius } from '../theme/theme'

@Component
export struct PrimaryButton {
  @Prop label: string = 'Continue'
  @Prop isEnabled: boolean = true
  action: () => void = () => {}
  @State private pressed: boolean = false

  build() {
    Button(this.label)
      .height(54)
      .width('100%')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.isEnabled ? '#F4D77A' : MeowColors.textTertiary)
      .borderRadius(MeowRadius.pill)
      .linearGradient({
        angle: 135,
        colors: [
          [MeowColors.navyDeep, 0.0],
          ['#17172F', 0.48],
          ['#252545', 1.0]
        ]
      })
      .border({ width: 1.2, color: this.isEnabled ? 'rgba(255,215,0,0.42)' : 'rgba(255,255,255,0.14)' })
      .shadow({
        radius: this.isEnabled ? (this.pressed ? 10 : 14) : 0,
        color: this.isEnabled ? 'rgba(212,175,55,0.24)' : 'rgba(0,0,0,0)',
        offsetX: 0,
        offsetY: this.pressed ? 4 : 7
      })
      .scale({
        x: this.pressed ? MeowEffects.pressScale : 1,
        y: this.pressed ? MeowEffects.pressScale : 1
      })
      .opacity(this.isEnabled ? 1 : 0.55)
      .enabled(this.isEnabled)
      .onTouch((event: TouchEvent) => {
        if (!this.isEnabled) {
          return
        }
        if (event.type === TouchType.Down) {
          this.pressed = true
        } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
          this.pressed = false
        }
      })
      .onClick(() => {
        if (this.isEnabled) {
          this.action()
        }
      })
      .animation({ duration: 140, curve: Curve.EaseOut })
  }
}
