import { MeowColors, MeowEffects, MeowRadius, MeowSpacing } from '../theme/theme'

@Component
export struct GlassCard {
  @Prop paddingValue: number = MeowSpacing.cardPadding
  @Prop radiusValue: number = MeowRadius.large
  @BuilderParam content: () => void

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .padding(this.paddingValue)
    .borderRadius(this.radiusValue)
    .backgroundColor(MeowColors.glassPanel)
    .border({ width: 1, color: MeowColors.borderStrong })
    .backdropBlur(MeowEffects.backdropBlur)
    .shadow({
      radius: 22,
      color: MeowColors.shadowPanel,
      offsetX: 0,
      offsetY: 8
    })
  }
}
