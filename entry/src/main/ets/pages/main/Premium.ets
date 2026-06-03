import { BottomNavBar } from '../../components/BottomNavBar'
import { GoldGradientText } from '../../components/GoldGradientText'
import { MiniPlayer } from '../../components/MiniPlayer'
import { PrimaryButton } from '../../components/PrimaryButton'
import { SecondaryButton } from '../../components/SecondaryButton'
import { SolidCard } from '../../components/SolidCard'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

@Entry
@Component
struct Premium {
  @Builder
  private BenefitRow(icon: string, label: string, detail: string) {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .width(42)
          .height(42)
          .borderRadius(21)
          .backgroundColor('rgba(255,255,255,0.07)')
          .border({ width: 1, color: 'rgba(255,255,255,0.10)' })
        Text(icon)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.goldSoft)
      }
      .width(42)
      .height(42)

      Column({ space: 4 }) {
        Text(label)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
        Text(detail)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textSecondary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            [MeowColors.navyTop, 0.0],
            [MeowColors.navyMid, 0.52],
            [MeowColors.navyBottom, 1.0]
          ]
        })

      Circle()
        .width(320)
        .height(320)
        .fill('rgba(212,175,55,0.09)')
        .blur(84)
        .translate({ x: 124, y: -252 })

      Scroll() {
        Column({ space: MeowSpacing.sectionGap }) {
          Text('Premium')
            .fontSize(MeowTypography.headingSize)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .width('100%')

          SolidCard({ paddingValue: 24, radiusValue: 24, elevated: true }) {
            Column({ space: 18 }) {
              Text('PhuiSic Gold')
                .fontSize(MeowTypography.captionSize)
                .fontWeight(FontWeight.Bold)
                .fontColor(MeowColors.goldBright)

              Column({ space: 8 }) {
                GoldGradientText({ text: 'Listen without the noise', textSize: 28, maxLines: 2 })
                Text('A quieter upgrade for focused sessions, offline queues, and cleaner playback.')
                  .fontSize(MeowTypography.bodySize)
                  .fontColor(MeowColors.textSecondary)
                  .lineHeight(21)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)

              Row({ space: 8 }) {
                Text('$4.99')
                  .fontSize(30)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.textPrimary)
                Text('/ month')
                  .fontSize(MeowTypography.bodySize)
                  .fontColor(MeowColors.textSecondary)
              }
              .width('100%')
              .alignItems(VerticalAlign.Bottom)

              PrimaryButton({
                label: 'Start Gold',
                action: () => {
                  console.log('[PremiumPage] start gold')
                }
              })

              SecondaryButton({
                label: 'Maybe Later',
                ghost: true,
                action: () => {
                  console.log('[PremiumPage] maybe later')
                }
              })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }

          Column({ space: 2 }) {
            this.BenefitRow('↓', 'Offline listening', 'Keep albums ready for flights and late-night commutes.')
            this.BenefitRow('HQ', 'Higher quality', 'A cleaner stream for headphones and quiet rooms.')
            this.BenefitRow('✓', 'No interruptions', 'Stay inside the mix with fewer breaks.')
            this.BenefitRow('Q', 'Gold queue tools', 'Save handpicked sessions for repeat listening.')
          }
          .width('100%')
          .padding(18)
          .borderRadius(MeowRadius.large)
          .backgroundColor(MeowColors.solidSurface)
          .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 64, bottom: MeowSpacing.mainContentBottomPadding })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      Column() {
        MiniPlayer()
          .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
        BottomNavBar({ activeTab: 'Premium' })
      }
      .width('100%')
      .zIndex(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
