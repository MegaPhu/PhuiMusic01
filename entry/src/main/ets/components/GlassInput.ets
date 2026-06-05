import { MeowColors, MeowEffects, MeowRadius } from '../theme/theme'

@Component
export struct GlassInput {
  @Link value: string
  @Prop placeholder: string = ''
  @Prop icon: string = ''
  @Prop iconResource: Resource = $r('app.media.ic_gmail')
  @Prop useIconImage: boolean = false
  @Prop isPassword: boolean = false
  @Prop showPasswordToggle: boolean = false
  @State private focused: boolean = false
  @State private passwordVisible: boolean = false

  private inputType(): InputType {
    if (!this.isPassword) {
      return InputType.Normal
    }
    return this.passwordVisible ? InputType.Normal : InputType.Password
  }

  build() {
    Row({ space: 10 }) {
      if (this.useIconImage) {
        Image(this.iconResource)
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
      } else if (this.icon.length > 0) {
        Text(this.icon)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.goldBright)
          .width(22)
          .textAlign(TextAlign.Center)
      }

      TextInput({ placeholder: this.placeholder, text: this.value })
        .type(this.inputType())
        .height(54)
        .fontSize(14)
        .fontColor(MeowColors.textPrimary)
        .placeholderColor(MeowColors.textTertiary)
        .caretColor(MeowColors.goldBright)
        .backgroundColor(MeowColors.transparent)
        .layoutWeight(1)
        .onFocus(() => {
          this.focused = true
        })
        .onBlur(() => {
          this.focused = false
        })
        .onChange((text: string) => {
          this.value = text
        })

      if (this.isPassword && this.showPasswordToggle) {
        Text(this.passwordVisible ? 'Hide' : 'Show')
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.goldBright)
          .padding({ left: 6, right: 4 })
          .onClick(() => {
            this.passwordVisible = !this.passwordVisible
          })
      }
    }
    .height(56)
    .width('100%')
    .padding({ left: 18, right: 16 })
    .borderRadius(28)
    .backgroundColor(MeowColors.glassInputBg)
    .border({
      width: this.focused ? 1.8 : 1.5,
      color: this.focused ? MeowColors.goldBright : MeowColors.glassStroke
    })
    .backdropBlur(MeowEffects.backdropBlur)
    .shadow({
      radius: this.focused ? 18 : 0,
      color: this.focused ? MeowColors.glowGold : MeowColors.transparent,
      offsetX: 0,
      offsetY: 0
    })
    .animation({ duration: 180, curve: Curve.EaseOut })
  }
}
