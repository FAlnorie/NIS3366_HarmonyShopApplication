export class UserAccount {
  username: string
  password: string
  nickname: string

  constructor(username: string, password: string, nickname: string) {
    this.username = username
    this.password = password
    this.nickname = nickname
  }
}

export class AuthStore {
  private static readonly USERS_KEY: string = 'auth_users_json'
  private static readonly CURRENT_KEY: string = 'auth_current_user'
  private static initialized: boolean = false

  private static ensureInitialized(): void {
    if (AuthStore.initialized) {
      return
    }
    PersistentStorage.PersistProp(AuthStore.USERS_KEY, '[]')
    PersistentStorage.PersistProp(AuthStore.CURRENT_KEY, '')
    AuthStore.initialized = true
  }

  private static getUsersJson(): string {
    AuthStore.ensureInitialized()
    const value: string | undefined = AppStorage.Get<string>(AuthStore.USERS_KEY)
    if (value === undefined || value === null) {
      return '[]'
    }
    return String(value)
  }

  private static setUsersJson(jsonText: string): void {
    AuthStore.ensureInitialized()
    AppStorage.Set(AuthStore.USERS_KEY, jsonText)
  }

  private static getCurrentUsernameRaw(): string {
    AuthStore.ensureInitialized()
    const value: string | undefined = AppStorage.Get<string>(AuthStore.CURRENT_KEY)
    if (value === undefined || value === null) {
      return ''
    }
    return String(value)
  }

  private static setCurrentUsernameRaw(username: string): void {
    AuthStore.ensureInitialized()
    AppStorage.Set(AuthStore.CURRENT_KEY, username)
  }

  static getUsers(): UserAccount[] {
    const jsonText = AuthStore.getUsersJson()
    try {
      const parsed = JSON.parse(jsonText) as Array<Record<string, Object>>
      if (!Array.isArray(parsed)) {
        return []
      }
      const users: UserAccount[] = []
      parsed.forEach((item: Record<string, Object>) => {
        const username = String(item['username'] ?? '').trim()
        const password = String(item['password'] ?? '')
        const nickname = String(item['nickname'] ?? '')
        if (username.length > 0 && password.length > 0) {
          users.push(new UserAccount(username, password, nickname))
        }
      })
      return users
    } catch (_err) {
      return []
    }
  }

  private static saveUsers(users: UserAccount[]): void {
    AuthStore.setUsersJson(JSON.stringify(users))
  }

  static register(username: string, password: string, nickname: string): string {
    const cleanUsername = username.trim()
    const cleanNickname = nickname.trim()
    if (cleanUsername.length < 3) {
      return '用户名至少 3 位'
    }
    if (password.length < 6) {
      return '密码至少 6 位'
    }
    const users = AuthStore.getUsers()
    const exists = users.find((item: UserAccount) => item.username === cleanUsername)
    if (exists) {
      return '用户名已存在'
    }
    const nextNickname = cleanNickname.length > 0 ? cleanNickname : cleanUsername
    users.push(new UserAccount(cleanUsername, password, nextNickname))
    AuthStore.saveUsers(users)
    return ''
  }

  static login(username: string, password: string): boolean {
    const cleanUsername = username.trim()
    const users = AuthStore.getUsers()
    const target = users.find((item: UserAccount) => item.username === cleanUsername && item.password === password)
    if (!target) {
      return false
    }
    AuthStore.setCurrentUsernameRaw(target.username)
    return true
  }

  static logout(): void {
    AuthStore.setCurrentUsernameRaw('')
  }

  static isLoggedIn(): boolean {
    return AuthStore.getCurrentUsernameRaw().length > 0
  }

  static getCurrentUser(): UserAccount | undefined {
    const username = AuthStore.getCurrentUsernameRaw()
    if (username.length === 0) {
      return undefined
    }
    const users = AuthStore.getUsers()
    return users.find((item: UserAccount) => item.username === username)
  }
}
