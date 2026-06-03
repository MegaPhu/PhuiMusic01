import { MeowColors, MeowEffects, MeowRadius, MeowSpacing } from '../theme/theme'

@Component
export struct SolidCard {
  @Prop paddingValue: number = MeowSpacing.cardPaddingSmall
  @Prop radiusValue: number = MeowRadius.card
  @Prop elevated: boolean = false
  @BuilderParam content: () => void

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .padding(this.paddingValue)
    .borderRadius(this.radiusValue)
    .backgroundColor(this.elevated ? MeowColors.solidSurfaceRaised : 'rgba(28,28,58,0.88)')
    .border({ width: 1, color: this.elevated ? 'rgba(255,255,255,0.10)' : 'rgba(255,255,255,0.075)' })
    .shadow({
      radius: this.elevated ? 24 : 10,
      color: this.elevated ? MeowColors.shadowNavy : 'rgba(4,5,20,0.18)',
      offsetX: 0,
      offsetY: this.elevated ? 10 : 4
    })
  }
}
