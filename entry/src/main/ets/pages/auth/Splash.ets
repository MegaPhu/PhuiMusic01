import router from '@ohos.router'
import { GoldGradientText } from '../../components/GoldGradientText'
import { MeowColors, MeowTheme, MeowTypography } from '../../theme/theme'

@Entry
@Component
struct Splash {
  private routeTimer: number = -1

  aboutToAppear(): void {
    this.routeTimer = setTimeout(() => {
      console.log('[SplashPage] auto navigate login')
      router.replaceUrl({ url: 'pages/auth/Login' })
    }, 2400)
  }

  aboutToDisappear(): void {
    if (this.routeTimer !== -1) {
      clearTimeout(this.routeTimer)
      this.routeTimer = -1
    }
  }

  build() {
    Stack() {
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
        .fill('rgba(212,175,55,0.13)')
        .blur(84)
        .translate({ x: -124, y: -236 })

      Circle()
        .width(300)
        .height(300)
        .fill('rgba(74,70,156,0.26)')
        .blur(86)
        .translate({ x: 138, y: 258 })

      Scroll() {
        Column({ space: 24 }) {
        Image($r('app.media.meowsic_app_icon'))
          .width(286)
          .height(286)
          .objectFit(ImageFit.Contain)
          .borderRadius(32)
          .shadow({
            radius: 28,
            color: 'rgba(212,175,55,0.24)',
            offsetX: 0,
            offsetY: 10
          })

        Column({ space: 8 }) {
          GoldGradientText({ text: MeowTheme.appName, textSize: MeowTypography.brandSize })
          Text(MeowTheme.tagline)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(MeowColors.textSecondary)
            .textAlign(TextAlign.Center)
            .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')

        Image($r('app.media.meowsic_paw_icon'))
          .width(44)
          .height(44)
          .objectFit(ImageFit.Contain)
          .opacity(0.92)
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 72, bottom: 72 })
      .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
