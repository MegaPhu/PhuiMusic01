import { MeowColors, MeowTypography } from '../theme/theme'

@Component
export struct GoldGradientText {
  @Prop text: string = MeowThemeText.defaultBrand
  @Prop textSize: number = MeowTypography.brandSize
  @Prop weight: FontWeight = MeowTypography.brandWeight
  @Prop maxLines: number = 1
  @Prop glow: boolean = false

  build() {
    Text(this.text)
      .fontSize(this.textSize)
      .fontWeight(this.weight)
      .fontColor(MeowColors.goldSoft)
      .letterSpacing(0)
      .maxLines(this.maxLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .shadow({
        radius: this.glow ? 10 : 2,
        color: this.glow ? MeowColors.glowGold : MeowColors.shadowText,
        offsetX: 0,
        offsetY: this.glow ? 0 : 1
      })
  }
}

class MeowThemeText {
  static readonly defaultBrand: string = 'PhuiSic'
}
