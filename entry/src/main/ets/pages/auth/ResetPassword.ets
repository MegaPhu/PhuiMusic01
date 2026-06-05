import router from '@ohos.router'
import { AuthMascot } from '../../components/AuthMascot'
import { FloatingNotes } from '../../components/FloatingNotes'
import { GlassCard } from '../../components/GlassCard'
import { GlassInput } from '../../components/GlassInput'
import { PrimaryButton } from '../../components/PrimaryButton'
import { MeowColors, MeowSpacing, MeowTypography } from '../../theme/theme'

@Entry
@Component
struct ResetPassword {
  @State private email: string = ''
  @State private sent: boolean = false

  private async sendResetLink(): Promise<void> {
    console.log('[ResetPasswordPage] send reset link')
    this.sent = true
  }

  private async navigateToLogin(): Promise<void> {
    console.log('[ResetPasswordPage] back to login')
    await router.replaceUrl({ url: 'pages/auth/Login' })
  }

  private goBack(): void {
    console.log('[ResetPasswordPage] back')
    router.back()
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

      FloatingNotes({ compact: true })

      Scroll() {
        Column({ space: 24 }) {
          Row() {
            Text('<')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width(44)
              .height(44)
              .textAlign(TextAlign.Center)
              .borderRadius(22)
              .backgroundColor('rgba(255,255,255,0.06)')
              .onClick(() => {
                this.goBack()
              })
            Blank()
            Text('♫')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor('#c9a84c')
              .opacity(0.86)
          }
          .width('100%')
          .padding({ top: 28 })

          GlassCard({ paddingValue: 26, radiusValue: 26 }) {
            Column({ space: MeowSpacing.fieldGap }) {
              Column({ space: 6 }) {
                Text('Reset Password')
                  .fontSize(MeowTypography.headingSize)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.textPrimary)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text('Enter your email for reset instructions')
                  .fontSize(MeowTypography.bodySize)
                  .fontColor(MeowColors.textSecondary)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }

              if (this.sent) {
                Stack({ alignContent: Alignment.Center }) {
                  Image($r('app.media.meowsic_envelope_icon'))
                    .width(186)
                    .height(132)
                    .objectFit(ImageFit.Contain)
                }
                .width(204)
                .height(148)
                .alignSelf(ItemAlign.Center)
                .shadow({ radius: 18, color: 'rgba(212,175,55,0.22)', offsetX: 0, offsetY: 8 })
                Text('Check Your Email')
                  .fontSize(MeowTypography.subheadingSize)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.goldSoft)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text('We sent a password reset link to your email address.')
                  .fontSize(MeowTypography.bodySize)
                  .fontColor(MeowColors.textSecondary)
                  .textAlign(TextAlign.Center)
                  .lineHeight(20)
                  .width('100%')
              } else {
                GlassInput({
                  value: $email,
                  placeholder: 'Email Address',
                  iconResource: $r('app.media.ic_gmail'),
                  useIconImage: true
                })

                AuthMascot({ compact: true, dj: false, variant: 'reset' })
              }

              if (this.sent) {
                Text('Reset instructions are ready for this demo account.')
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(MeowColors.goldBright)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }

              PrimaryButton({
                label: 'Send Reset Link',
                action: () => {
                  this.sendResetLink()
                }
              })

              Text('Back to Login')
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor(MeowColors.goldBright)
                .textAlign(TextAlign.Center)
                .width('100%')
                .onClick(() => {
                  this.navigateToLogin()
                })
            }
          }
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 48, bottom: 48 })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
