import router from '@ohos.router'

export class MainNavigation {
  static readonly HOME: string = 'Home'
  static readonly SEARCH: string = 'Search'
  static readonly LIBRARY: string = 'Library'
  static readonly PREMIUM: string = 'Premium'
  static readonly PROFILE: string = 'Profile'
  static readonly SWIPE_THRESHOLD: number = 90

  static routeFor(tab: string): string {
    if (tab === MainNavigation.SEARCH) {
      return 'pages/main/Search'
    }
    if (tab === MainNavigation.LIBRARY) {
      return 'pages/main/Library'
    }
    if (tab === MainNavigation.PREMIUM) {
      return 'pages/main/Premium'
    }
    if (tab === MainNavigation.PROFILE) {
      return 'pages/main/Profile'
    }
    return 'pages/main/Home'
  }

  static async navigateTo(tab: string, currentTab: string = ''): Promise<void> {
    if (tab === currentTab) {
      return
    }
    console.log(`[MainNavigation] navigate ${tab}`)
    await router.replaceUrl({ url: MainNavigation.routeFor(tab) })
  }

  static async swipeFrom(currentTab: string, offsetX: number): Promise<void> {
    if (offsetX <= -MainNavigation.SWIPE_THRESHOLD) {
      await MainNavigation.navigateTo(MainNavigation.nextTab(currentTab), currentTab)
    } else if (offsetX >= MainNavigation.SWIPE_THRESHOLD) {
      await MainNavigation.navigateTo(MainNavigation.previousTab(currentTab), currentTab)
    }
  }

  private static nextTab(tab: string): string {
    if (tab === MainNavigation.HOME) {
      return MainNavigation.SEARCH
    }
    if (tab === MainNavigation.SEARCH) {
      return MainNavigation.LIBRARY
    }
    if (tab === MainNavigation.LIBRARY) {
      return MainNavigation.PREMIUM
    }
    if (tab === MainNavigation.PREMIUM) {
      return MainNavigation.PROFILE
    }
    return MainNavigation.HOME
  }

  private static previousTab(tab: string): string {
    if (tab === MainNavigation.HOME) {
      return MainNavigation.PROFILE
    }
    if (tab === MainNavigation.SEARCH) {
      return MainNavigation.HOME
    }
    if (tab === MainNavigation.LIBRARY) {
      return MainNavigation.SEARCH
    }
    if (tab === MainNavigation.PREMIUM) {
      return MainNavigation.LIBRARY
    }
    return MainNavigation.PREMIUM
  }
}
