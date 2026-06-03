import { MeowColors, MeowEffects, MeowRadius } from '../theme/theme'

@Component
export struct SecondaryButton {
  @Prop label: string = 'Cancel'
  @Prop ghost: boolean = false
  @Prop isEnabled: boolean = true
  action: () => void = () => {}
  @State private pressed: boolean = false

  build() {
    Button(this.label)
      .height(48)
      .width('100%')
      .fontSize(14)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.isEnabled ? MeowColors.textPrimary : MeowColors.textTertiary)
      .borderRadius(MeowRadius.control)
      .backgroundColor(this.ghost ? 'rgba(255,255,255,0.035)' : 'rgba(28,28,58,0.86)')
      .border({ width: 1, color: this.ghost ? 'rgba(255,255,255,0.16)' : 'rgba(255,255,255,0.09)' })
      .shadow({
        radius: this.ghost ? 0 : 10,
        color: this.ghost ? 'rgba(0,0,0,0)' : 'rgba(4,5,20,0.22)',
        offsetX: 0,
        offsetY: this.ghost ? 0 : 4
      })
      .scale({
        x: this.pressed ? MeowEffects.pressScale : 1,
        y: this.pressed ? MeowEffects.pressScale : 1
      })
      .opacity(this.isEnabled ? 1 : 0.5)
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
