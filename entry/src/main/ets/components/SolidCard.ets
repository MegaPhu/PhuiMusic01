import { MeowColors, MeowRadius, MeowSpacing } from '../theme/theme'

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
    .backgroundColor(this.elevated ? MeowColors.solidSurfaceRaised : MeowColors.solidSurface)
    .border({ width: 1, color: this.elevated ? MeowColors.borderStrong : MeowColors.borderSubtle })
    .shadow({
      radius: this.elevated ? 22 : 8,
      color: this.elevated ? MeowColors.shadowNavy : MeowColors.shadowSubtle,
      offsetX: 0,
      offsetY: this.elevated ? 8 : 3
    })
  }
}
