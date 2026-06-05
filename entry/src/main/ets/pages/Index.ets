import router from '@ohos.router'
import { GoldGradientText } from '../components/GoldGradientText'
import { MeowColors, MeowSpacing, MeowTypography } from '../theme/theme'

@Entry
@Component
struct Index {
  @StorageLink('isLoggedIn') isLoggedIn: boolean = false
  private routeTimer: number = -1

  aboutToAppear(): void {
    AppStorage.SetOrCreate<boolean>('isPlaying', false)
    this.routeTimer = setTimeout(() => {
      if (this.isLoggedIn) {
        console.log('[IndexPage] route to home')
        router.replaceUrl({ url: 'pages/main/Home' })
      } else {
        console.log('[IndexPage] route to splash')
        router.replaceUrl({ url: 'pages/auth/Splash' })
      }
    }, 80)
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

      Column({ space: MeowSpacing.fieldGap }) {
        GoldGradientText({ text: 'PhuiSic', textSize: MeowTypography.brandSize })
        Text('Loading')
          .fontSize(MeowTypography.bodySize)
          .fontColor(MeowColors.textSecondary)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
