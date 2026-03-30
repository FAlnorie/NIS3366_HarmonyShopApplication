import { router } from '@kit.ArkUI'
import { AuthStore } from '../data/AuthStore'

@Entry
@Component
struct Register {
  @State username: string = ''
  @State nickname: string = ''
  @State password: string = ''
  @State confirmPassword: string = ''
  @State errorText: string = ''
  @State successText: string = ''

  private doRegister(): void {
    this.errorText = ''
    this.successText = ''

    if (this.password !== this.confirmPassword) {
      this.errorText = '两次密码不一致'
      return
    }

    const message = AuthStore.register(this.username, this.password, this.nickname)
    if (message.length > 0) {
      this.errorText = message
      return
    }

    this.successText = '注册成功，正在返回登录页'
    setTimeout(() => {
      router.replaceUrl({ url: 'pages/Login' })
    }, 700)
  }

  build() {
    Column() {
      Row() {
        Text('< 返回')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#0C63C5')
          .onClick(() => {
            router.back()
          })
        Blank()
      }
      .width('100%')
      .padding({ top: 16, bottom: 8 })

      Text('创建账号')
        .width('100%')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .margin({ bottom: 16 })

      Column({ space: 12 }) {
        TextInput({ placeholder: '用户名（至少 3 位）', text: this.username })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .onChange((value: string) => {
            this.username = value
          })

        TextInput({ placeholder: '昵称（可选）', text: this.nickname })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .onChange((value: string) => {
            this.nickname = value
          })

        TextInput({ placeholder: '密码（至少 6 位）', text: this.password })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value
          })

        TextInput({ placeholder: '确认密码', text: this.confirmPassword })
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .type(InputType.Password)
          .onChange((value: string) => {
            this.confirmPassword = value
          })

        if (this.errorText.length > 0) {
          Text(this.errorText)
            .width('100%')
            .fontSize(13)
            .fontColor('#D93025')
        }

        if (this.successText.length > 0) {
          Text(this.successText)
            .width('100%')
            .fontSize(13)
            .fontColor('#16A34A')
        }

        Button('注册')
          .width('100%')
          .height(46)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#0C63C5')
          .margin({ top: 4 })
          .onClick(() => {
            this.doRegister()
          })
      }
      .width('100%')
      .padding(14)
      .backgroundColor('#F4F7FB')
      .borderRadius(16)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20 })
    .backgroundColor('#EDF2F8')
  }
}

