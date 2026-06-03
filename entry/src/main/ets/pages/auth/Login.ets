import router from '@ohos.router'
import { FloatingNotes } from '../../components/FloatingNotes'
import { GlassCard } from '../../components/GlassCard'
import { GlassInput } from '../../components/GlassInput'
import { GoldGradientText } from '../../components/GoldGradientText'
import { PrimaryButton } from '../../components/PrimaryButton'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

@Entry
@Component
struct Login {
  @State private email: string = ''
  @State private password: string = ''

  private async login(): Promise<void> {
    console.log('[LoginPage] demo login')
    AppStorage.SetOrCreate<boolean>('isLoggedIn', true)
    await router.replaceUrl({ url: 'pages/Index' })
  }

  private async navigateToSignUp(): Promise<void> {
    console.log('[LoginPage] navigate sign up')
    await router.pushUrl({ url: 'pages/auth/SignUp' })
  }

  private async navigateToReset(): Promise<void> {
    console.log('[LoginPage] navigate reset password')
    await router.pushUrl({ url: 'pages/auth/ResetPassword' })
  }

  @Builder
  private SocialButton(label: string, icon: string) {
    Row({ space: 8 }) {
      Text(icon)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
      Text(label)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
    }
    .height(46)
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .borderRadius(MeowRadius.pill)
    .backgroundColor('rgba(255,255,255,0.10)')
    .border({ width: 1, color: 'rgba(255,255,255,0.18)' })
  }

  @Builder
  private Divider() {
    Row({ space: 12 }) {
      Row().height(1).layoutWeight(1).backgroundColor('rgba(255,255,255,0.16)')
      Text('OR')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textTertiary)
      Row().height(1).layoutWeight(1).backgroundColor('rgba(255,255,255,0.16)')
    }
    .width('100%')
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

      Circle().width(300).height(300).fill('rgba(212,175,55,0.12)').blur(80).translate({ x: -118, y: -248 })
      Circle().width(260).height(260).fill('rgba(74,70,156,0.26)').blur(72).translate({ x: 130, y: 252 })
      FloatingNotes({ compact: true })

      Scroll() {
        Column({ space: MeowSpacing.sectionGap }) {
          Row({ space: 10 }) {
            Image($r('app.media.meowsic_logo'))
              .width(50)
              .height(50)
              .objectFit(ImageFit.Contain)
              .borderRadius(14)
              .clip(true)
            GoldGradientText({ text: 'PhuiSic', textSize: 28 })
            Blank()
            Text('♪')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor('#c9a84c')
              .opacity(0.86)
          }
          .justifyContent(FlexAlign.Start)
          .width('100%')
          .padding({ top: 4 })

          GlassCard({ paddingValue: 26, radiusValue: 26 }) {
            Column({ space: MeowSpacing.fieldGap }) {
              Column({ space: 6 }) {
                Text('Welcome Back')
                  .fontSize(MeowTypography.headingSize)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.textPrimary)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text('Log in to continue')
                  .fontSize(MeowTypography.bodySize)
                  .fontColor(MeowColors.textSecondary)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 4 })

              GlassInput({
                value: $email,
                placeholder: 'Email / Username',
                iconResource: $r('app.media.ic_gmail'),
                useIconImage: true
              })
              GlassInput({
                value: $password,
                placeholder: 'Password',
                iconResource: $r('app.media.ic_password'),
                useIconImage: true,
                isPassword: true,
                showPasswordToggle: true
              })

              Text('Forgot Password?')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(MeowColors.goldBright)
                .width('100%')
                .textAlign(TextAlign.End)
                .onClick(() => {
                  this.navigateToReset()
                })

              PrimaryButton({
                label: 'Log In',
                action: () => {
                  this.login()
                }
              })

              Row() {
                Text('Don\'t have an account? ')
                  .fontSize(13)
                  .fontColor(MeowColors.textSecondary)
                Text('Sign Up')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.goldBright)
                  .onClick(() => {
                    this.navigateToSignUp()
                  })
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')

              this.Divider()

              Row({ space: 12 }) {
                this.SocialButton('Apple', 'A')
                this.SocialButton('Google', 'G')
              }
              .width('100%')
            }
          }
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 48, bottom: 56 })
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
