import { DEFAULT_TRACK, MUSIC_TRACKS, Track } from './MusicData'

export class PlayerManager {
  private static setCurrentTrack(track: Track, isPlaying: boolean): void {
    AppStorage.SetOrCreate<Track>('currentTrack', track)
    AppStorage.SetOrCreate<string>('currentTrackId', track.id)
    AppStorage.SetOrCreate<boolean>('isPlaying', isPlaying)
  }

  static playTrack(track: Track): void {
    PlayerManager.setCurrentTrack(track, false)
  }

  static togglePlay(isPlaying: boolean): void {
    AppStorage.SetOrCreate<boolean>('isPlaying', !isPlaying)
  }

  static pause(): void {
    AppStorage.SetOrCreate<boolean>('isPlaying', false)
  }

  static reset(): void {
    AppStorage.SetOrCreate<Track>('currentTrack', DEFAULT_TRACK)
    AppStorage.SetOrCreate<boolean>('isPlaying', false)
  }

  static nextTrack(currentTrack: Track): Track {
    const currentIndex = MUSIC_TRACKS.findIndex((item: Track) => item.id === currentTrack.id)
    const safeIndex = currentIndex < 0 ? 0 : currentIndex
    const nextIndex = (safeIndex + 1) % MUSIC_TRACKS.length
    return MUSIC_TRACKS[nextIndex]
  }

  static previousTrack(currentTrack: Track): Track {
    const currentIndex = MUSIC_TRACKS.findIndex((item: Track) => item.id === currentTrack.id)
    const safeIndex = currentIndex < 0 ? 0 : currentIndex
    const previousIndex = (safeIndex - 1 + MUSIC_TRACKS.length) % MUSIC_TRACKS.length
    return MUSIC_TRACKS[previousIndex]
  }

  static playNext(currentTrack: Track, isPlaying: boolean): void {
    PlayerManager.setCurrentTrack(PlayerManager.nextTrack(currentTrack), isPlaying)
  }

  static playPrevious(currentTrack: Track, isPlaying: boolean): void {
    PlayerManager.setCurrentTrack(PlayerManager.previousTrack(currentTrack), isPlaying)
  }

  static isLiked(track: Track, ids: string): boolean {
    const token = '|' + track.id + '|'
    return ids.indexOf(token) > -1
  }

  static toggleLiked(track: Track, ids: string): string {
    const token = '|' + track.id + '|'
    if (ids.indexOf(token) > -1) {
      return ids.replace(token, '')
    }
    return ids + token
  }

  static toggleLikedInStorage(track: Track, ids: string): void {
    AppStorage.SetOrCreate<string>('likedTrackIds', PlayerManager.toggleLiked(track, ids))
  }

}
