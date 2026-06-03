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
    .backgroundColor('rgba(12,13,31,0.66)')
    .border({ width: 1, color: 'rgba(255,255,255,0.12)' })
    .backdropBlur(MeowEffects.backdropBlur)
    .shadow({
      radius: 26,
      color: 'rgba(4,5,20,0.42)',
      offsetX: 0,
      offsetY: 12
    })
  }
}
