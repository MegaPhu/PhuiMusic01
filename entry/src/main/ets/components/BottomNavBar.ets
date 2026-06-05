import { MainNavigation } from '../model/MainNavigation'
import { MeowColors, MeowEffects, MeowSpacing } from '../theme/theme'

@Component
export struct BottomNavBar {
  @Prop activeTab: string = 'Home'
  @Prop trailingTab: string = 'Profile'
  @State private pressedTab: string = ''

  private async navigate(tab: string): Promise<void> {
    if (tab === this.activeTab) {
      return
    }
    if (tab === 'Create') {
      console.log('[BottomNavBar] create tapped')
      return
    }
    console.log(`[BottomNavBar] navigate ${tab}`)
    await MainNavigation.navigateTo(tab, this.activeTab)
  }

  private iconFor(label: string): string {
    if (label === 'Home') {
      return '⌂'
    }
    if (label === 'Search') {
      return '⌕'
    }
    if (label === 'Library') {
      return '▥'
    }
    if (label === 'Premium') {
      return '♬'
    }
    if (label === 'Create') {
      return '+'
    }
    return '◉'
  }

  @Builder
  private NavIcon(label: string) {
    Text(this.iconFor(label))
      .fontSize(label === 'Create' ? 30 : 24)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.activeTab === label ? MeowColors.textPrimary : MeowColors.textDisabled)
  }

  @Builder
  private NavItem(label: string) {
    Column({ space: 5 }) {
      Stack({ alignContent: Alignment.Center }) {
        this.NavIcon(label)
      }
      .width(56)
      .height(30)

      Text(label)
        .fontSize(11)
        .fontWeight(this.activeTab === label ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.activeTab === label ? MeowColors.textPrimary : MeowColors.textDisabled)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height(68)
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .scale({
      x: this.pressedTab === label ? MeowEffects.pressScale : 1,
      y: this.pressedTab === label ? MeowEffects.pressScale : 1
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.pressedTab = label
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.pressedTab = ''
      }
    })
    .onClick(() => {
      this.navigate(label)
    })
    .animation({ duration: 120, curve: Curve.EaseOut })
  }

  build() {
    Row() {
      this.NavItem('Home')
      this.NavItem('Search')
      this.NavItem('Library')
      this.NavItem('Premium')
      this.NavItem(this.trailingTab)
    }
    .width('100%')
    .height(MeowSpacing.bottomNavHeight)
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
    .backgroundColor(MeowColors.navOverlay)
    .border({ width: { top: 1 }, color: MeowColors.borderStrong })
    .backdropBlur(MeowEffects.backdropBlur)
  }
}
