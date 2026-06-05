import router from '@ohos.router'
import { BottomNavBar } from '../../components/BottomNavBar'
import { MiniPlayer } from '../../components/MiniPlayer'
import { SecondaryButton } from '../../components/SecondaryButton'
import { PlayerManager } from '../../model/PlayerManager'
import { MeowColors, MeowRadius, MeowSpacing, MeowTypography } from '../../theme/theme'

interface ProfileMenuItem {
  id: number
  iconType: string
  title: string
  hint: string
  badge: string
  accent: string
}

const PROFILE_MENU: ProfileMenuItem[] = [
  { id: 1, iconType: 'account', title: 'Add Account', hint: 'Switch or add another listener', badge: '', accent: '#2FA7D6' },
  { id: 2, iconType: 'stats', title: 'Listening Stats', hint: 'Weekly taste and listening time', badge: 'New', accent: '#F5D84A' },
  { id: 3, iconType: 'history', title: 'Recently Played', hint: 'Return to your latest queue', badge: '', accent: '#2AB7A9' },
  { id: 4, iconType: 'updates', title: 'Updates', hint: 'Release notes and product news', badge: 'New', accent: '#D65ACF' },
  { id: 5, iconType: 'privacy', title: 'Settings and Privacy', hint: 'Account, playback, and privacy', badge: '', accent: '#A3ADB8' }
]

@Entry
@Component
struct Profile {
  @StorageLink('mockUsername') mockUsername: string = 'Phu'

  private handleMenu(item: ProfileMenuItem): void {
    console.log(`[ProfilePage] menu ${item.title}`)
  }

  private menuSymbol(iconType: string): string {
    if (iconType === 'account') {
      return '+'
    }
    if (iconType === 'stats') {
      return '⌁'
    }
    if (iconType === 'history') {
      return '↺'
    }
    if (iconType === 'updates') {
      return '↗'
    }
    return '⚙'
  }

  private menuSymbolSize(iconType: string): number {
    return iconType === 'account' ? 24 : 19
  }

  private async logout(): Promise<void> {
    console.log('[ProfilePage] logout')
    AppStorage.SetOrCreate<boolean>('isLoggedIn', false)
    AppStorage.SetOrCreate<string>('mockUsername', 'Phu')
    AppStorage.SetOrCreate<string>('likedTrackIds', '')
    PlayerManager.reset()
    await router.replaceUrl({ url: 'pages/auth/Login' })
  }

  @Builder
  private Avatar(sizeValue: number) {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(sizeValue)
        .height(sizeValue)
        .borderRadius(sizeValue / 2)
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
          radius: 14,
          color: 'rgba(212,175,55,0.26)',
          offsetX: 0,
          offsetY: 0
        })

      Row()
        .width(sizeValue - 8)
        .height(sizeValue - 8)
        .borderRadius((sizeValue - 8) / 2)
        .backgroundColor(MeowColors.solidSurface)

      Image($r('app.media.meowsic_app_icon'))
        .width(sizeValue - 8)
        .height(sizeValue - 8)
        .objectFit(ImageFit.Contain)
        .borderRadius((sizeValue - 8) / 2)
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
  private StatusPill(label: string, tone: string) {
    Text(label)
      .fontSize(11)
      .fontWeight(FontWeight.Bold)
      .fontColor(tone)
      .padding({ left: 10, right: 10, top: 5, bottom: 5 })
      .borderRadius(12)
      .backgroundColor('rgba(255,255,255,0.055)')
      .border({ width: 1, color: 'rgba(255,255,255,0.08)' })
  }

  @Builder
  private MenuIcon(item: ProfileMenuItem) {
    Stack({ alignContent: Alignment.Center }) {
      Row()
        .width(44)
        .height(44)
        .borderRadius(22)
        .backgroundColor('rgba(255,255,255,0.055)')
        .border({ width: 1, color: 'rgba(255,255,255,0.10)' })
      Circle()
        .width(24)
        .height(24)
        .fill(item.accent)
        .opacity(0.18)
      Text(this.menuSymbol(item.iconType))
        .fontSize(this.menuSymbolSize(item.iconType))
        .fontWeight(FontWeight.Bold)
        .fontColor(item.accent)
    }
    .width(44)
    .height(44)
  }

  @Builder
  private MenuRow(item: ProfileMenuItem) {
    Row({ space: 14 }) {
      this.MenuIcon(item)

      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(item.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (item.badge.length > 0) {
            this.StatusPill(item.badge, MeowColors.goldBright)
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

      Text('›')
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
        this.Avatar(82)

        Column({ space: 8 }) {
          Row({ space: 8 }) {
            this.StatusPill('Gold', MeowColors.goldBright)
            this.StatusPill('Private', MeowColors.textSecondary)
          }
          .width('100%')

          Text(this.mockUsername.length > 0 ? this.mockUsername : 'Phu')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('PhuiSic Gold Listener')
            .fontSize(MeowTypography.bodySize)
            .fontColor(MeowColors.textSecondary)
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
    .shadow({
      radius: 16,
      color: MeowColors.shadowNavy,
      offsetX: 0,
      offsetY: 6
    })
  }

  @Builder
  private MenuPanel() {
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
  }

  @Builder
  private LogoutPanel() {
    Column({ space: 12 }) {
      Text('Session')
        .fontSize(MeowTypography.subheadingSize)
        .fontWeight(FontWeight.Bold)
        .fontColor(MeowColors.textPrimary)
        .width('100%')
      Text('Logging out returns to the sign-in screen and resets the demo session.')
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

  @Builder
  private BottomChrome() {
    Column() {
      MiniPlayer()
        .margin({ left: 14, right: 14, bottom: MeowSpacing.miniPlayerBottomMargin })
      BottomNavBar({ activeTab: 'Profile' })
    }
    .width('100%')
    .zIndex(10)
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

      Scroll() {
        Column({ space: MeowSpacing.sectionGap }) {
          Text('Profile')
            .fontSize(MeowTypography.headingSize)
            .fontWeight(FontWeight.Bold)
            .fontColor(MeowColors.textPrimary)
            .width('100%')

          this.ProfileHeader()
          this.MenuPanel()
          this.LogoutPanel()
        }
        .width('100%')
        .padding({ left: MeowSpacing.pagePadding, right: MeowSpacing.pagePadding, top: 64, bottom: MeowSpacing.mainContentBottomPadding + 24 })
      }
      .width('100%')
      .height('100%')
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .zIndex(1)

      this.BottomChrome()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(MeowColors.navyDeep)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}
