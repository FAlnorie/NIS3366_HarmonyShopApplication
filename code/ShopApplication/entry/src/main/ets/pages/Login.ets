import { router } from '@kit.ArkUI'
import { AuthStore } from '../data/AuthStore'

@Entry
@Component
struct Login {
  @State username: string = ''
  @State password: string = ''
  @State errorText: string = ''

  aboutToAppear() {
    // 已登录用户不需要重复登录，直接进入首页。
    if (AuthStore.isLoggedIn()) {
      router.replaceUrl({ url: 'pages/Index' })
    }
  }

  private doLogin(): void {
    if (this.username.trim().length === 0 || this.password.length === 0) {
      this.errorText = '请输入用户名和密码'
      return
    }
    const ok = AuthStore.login(this.username, this.password)
    if (!ok) {
      this.errorText = '用户名或密码错误'
      return
    }
    this.errorText = ''
    // 登录成功后替换当前路由，避免返回键回到登录页。
    router.replaceUrl({ url: 'pages/Index' })
  }

  build() {
    Column() {
      Column({ space: 12 }) {
        Text('欢迎登录')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')

        Text('登录后即可访问商城应用')
          .fontSize(14)
          .fontColor('#6B7280')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ top: 24, bottom: 18 })

      Column({ space: 12 }) {
        TextInput({ placeholder: '用户名', text: this.username })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .onChange((value: string) => {
            this.username = value
          })

        TextInput({ placeholder: '密码', text: this.password })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value
          })

        if (this.errorText.length > 0) {
          Text(this.errorText)
            .width('100%')
            .fontSize(13)
            .fontColor('#D93025')
        }

        Button('登录')
          .width('100%')
          .height(46)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#0C63C5')
          .margin({ top: 6 })
          .onClick(() => {
            this.doLogin()
          })
      }
      .width('100%')
      .padding(14)
      .backgroundColor('#F4F7FB')
      .borderRadius(16)

      Row() {
        Text('还没有账号？')
          .fontSize(14)
          .fontColor('#6B7280')
        Text('去注册')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#0C63C5')
          .onClick(() => {
            router.pushUrl({ url: 'pages/Register' })
          })
      }
      .margin({ top: 14 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20, top: 36 })
    .backgroundColor('#EDF2F8')
  }
}
