import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { SecondaryButton } from '../../components/SecondaryButton'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowEffects, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

interface ProfileMenuItem {
  id: number
  icon: string
  title: string
  hint: string
  badge: string
}

const PROFILE_MENU: ProfileMenuItem[] = [
  { id: 1, icon: '+', title: 'Add Account', hint: 'Switch or add another listener', badge: '' },
  { id: 2, icon: '▥', title: 'Listening Stats', hint: 'Weekly taste and listening time', badge: 'New' },
  { id: 3, icon: '↺', title: 'Recently Played', hint: 'Return to your latest queue', badge: '' },
  { id: 4, icon: '•', title: 'Updates', hint: 'Release notes and product news', badge: 'New' },
  { id: 5, icon: '⚙', title: 'Settings and Privacy', hint: 'Account, playback, and Privacy', badge: '' }
]

@Entry
@Component
struct Profile {
  @StorageLink('mockUsername') mockUsername: string = 'Phu'

  private handleMenu(item: ProfileMenuItem): void {
    console.log(`[ProfilePage] menu ${item.title}`)
  }

  private async logout(): Promise<void> {
    console.log('[ProfilePage] logout')
    AppStorage.SetOrCreate<boolean>('isLoggedIn', false)
    AppStorage.SetOrCreate<string>('mockUsername', 'Phu')
    PlayerManager.reset()
    await router.replaceUrl({ url: 'pages/auth/Login' })
  }

  @Builder
  private Avatar(sizeValue: number) {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(sizeValue)
        .height(sizeValue)
        .borderRadius(sizeValue * 0.28)
        .linearGradient({
          angle: 135,
          colors: [
            [MeowColors.goldDark, 0.0],
            [MeowColors.goldBright, 0.36],
            [MeowColors.goldSoft, 0.72],
            [MeowColors.goldDeep, 1.0]
          ]
        })
        .shadow({
          radius: MeowEffects.glowBlur,
          color: MeowColors.glowGold,
          offsetX: 0,
          offsetY: 0
        })

      Row()
        .width(sizeValue - 8)
        .height(sizeValue - 8)
        .borderRadius((sizeValue - 8) * 0.26)
        .backgroundColor(MeowColors.solidSurface)

      Image($r('app.media.meowsic_app_icon'))
        .width(sizeValue - 8)
        .height(sizeValue - 8)
        .objectFit(ImageFit.Contain)
        .borderRadius((sizeValue - 8) * 0.26)
        .clip(true)
    }
    .width(sizeValue)
    .height(sizeValue)
  }

  @Builder
  private Stat(value: string, label: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
      Text(label)
        .fontSize(MeowTypography.captionSize)
        .fontColor(MeowColors.textTertiary)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private MenuRow(item: ProfileMenuItem) {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .width(44)
          .height(44)
          .borderRadius(22)
          .backgroundColor('rgba(255,255,255,0.08)')
          .border({ width: 1, color: 'rgba(255,255,255,0.10)' })
        Text(item.icon)
          .fontSize(item.icon === '+' ? 24 : 20)
          .fontWeight(FontWeight.Bold)
          .fontColor(MeowColors.textPrimary)
      }
      .width(44)
      .height(44)

      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(item.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (item.badge.length > 0) {
            Text(item.badge)
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.goldBright)
          }
        }
        .width('100%')

        Text(item.hint)
          .fontSize(MeowTypography.captionSize)
          .fontColor(MeowColors.textSecondary)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('>')
        .fontSize(18)
        .fontColor(MeowColors.textTertiary)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .onClick(() => {
      this.handleMenu(item)
    })
  }

  @Builder
  private ProfileHeader() {
    Column({ space: 18 }) {
      Row({ space: 16 }) {
        this.Avatar(78)

        Column({ space: 6 }) {
          Text(this.mockUsername.length > 0 ? this.mockUsername : 'Phu')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('PhuiSic Gold Listener')
            .fontSize(MeowTypography.bodySize)
            .fontColor(MeowColors.textSecondary)
          Text('View profile')
            .fontSize(MeowTypography.captionSize)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.goldBright)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Row() {
        this.Stat('42h', 'This month')
        this.Stat('18', 'Playlists')
        this.Stat('Gold', 'Plan')
      }
      .width('100%')
      .padding({ top: 16 })
      .border({ width: { top: 1 }, color: 'rgba(255,255,255,0.10)' })
    }
    .width('100%')
    .padding(22)
    .borderRadius(MeowRadius.large)
    .backgroundColor(MeowColors.solidSurface)
    .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
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
        .fill('rgba(212,175,55,0.055)')
        .blur(78)
        .translate({ x: 128, y: -250 })

      Scroll() {
        Column({ space: MeowSpacing.sectionGap }) {
          Text('Profile')
            .fontSize(MeowTypography.headingSize)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .width('100%')

          this.ProfileHeader()

          Column({ space: 0 }) {
            ForEach(PROFILE_MENU, (item: ProfileMenuItem) => {
              this.MenuRow(item)
            }, (item: ProfileMenuItem) => `${item.id}`)
          }
          .width('100%')
          .padding({ left: 18, right: 18, top: 6, bottom: 6 })
          .borderRadius(MeowRadius.large)
          .backgroundColor(MeowColors.solidSurface)
          .border({ width: 1, color: 'rgba(255,255,255,0.08)' })

          Column({ space: 12 }) {
            Text('Session')
              .fontSize(MeowTypography.subheadingSize)
              .fontWeight(FontWeight.Bold)
              .fontColor(MeowColors.textPrimary)
              .width('100%')
            Text('Take a quiet pause from this listening space.')
              .fontSize(MeowTypography.bodySize)
              .fontColor(MeowColors.textSecondary)
              .lineHeight(20)
              .width('100%')
            SecondaryButton({
              label: 'Log Out',
              ghost: true,
              action: () => {
                this.logout()
              }
            })
          }
          .width('100%')
          .padding(22)
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
        BottomNavBar({ activeTab: 'Profile' })
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
