import { router } from '@kit.ArkUI'
import { AuthStore, UserAccount } from '../data/AuthStore'
import { CartStore } from '../data/CartStore'

@Entry
@Component
struct UserCenter {
  @State nickname: string = ''
  @State username: string = ''
  @State cartCount: number = 0
  @State cartTotalText: string = 'CNY 0.00'

  aboutToAppear() {
    if (!this.ensureLogin()) {
      return
    }
    this.refreshView()
  }

  onPageShow() {
    if (!this.ensureLogin()) {
      return
    }
    this.refreshView()
  }

  private ensureLogin(): boolean {
    if (AuthStore.isLoggedIn()) {
      return true
    }
    router.replaceUrl({ url: 'pages/Login' })
    return false
  }

  private refreshView(): void {
    const user: UserAccount | undefined = AuthStore.getCurrentUser()
    if (user) {
      this.nickname = user.nickname
      this.username = user.username
    } else {
      this.nickname = '未登录'
      this.username = ''
    }
    this.cartCount = CartStore.getTotalCount()
    this.cartTotalText = `CNY ${CartStore.getTotalPrice().toFixed(2)}`
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Blank()
      }
      .width('100%')
      .height(260)
      .linearGradient({
        angle: 130,
        colors: [['#0B3E91', 0], ['#0C63C5', 0.55], ['#22A6F2', 1]]
      })

      Column() {
        Row() {
          Text('< 返回')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .onClick(() => {
              router.back()
            })
          Blank()
          Text('用户中心')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
          Blank()
          Text(' ')
            .width(44)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 14 })

        Row({ space: 12 }) {
          Text('U')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0C63C5')
            .width(54)
            .height(54)
            .textAlign(TextAlign.Center)
            .backgroundColor('#FFFFFF')
            .borderRadius(27)

          Column({ space: 4 }) {
            Text(this.nickname)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text(`账号：${this.username}`)
              .fontSize(13)
              .fontColor('rgba(255,255,255,0.88)')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding({ left: 18, right: 18, top: 20, bottom: 22 })
        .backgroundColor('rgba(255,255,255,0.12)')
        .borderRadius(22)
        .margin({ left: 12, right: 12 })

        Row({ space: 10 }) {
          Column({ space: 4 }) {
            Text('购物车商品')
              .fontSize(12)
              .fontColor('#64748B')
            Text(`${this.cartCount} 件`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#0F172A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)

          Column({ space: 4 }) {
            Text('购物车总额')
              .fontSize(12)
              .fontColor('#64748B')
            Text(this.cartTotalText)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#0F172A')
              .maxLines(1)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 14 })

        Column({ space: 12 }) {
          Button('查看购物车')
            .width('100%')
            .height(46)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#0C63C5')
            .onClick(() => {
              router.pushUrl({ url: 'pages/Cart' })
            })

          Button('清空购物车')
            .width('100%')
            .height(46)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#0C63C5')
            .backgroundColor('#E8F1FD')
            .onClick(() => {
              CartStore.clear()
              this.refreshView()
            })

          Button('退出登录')
            .width('100%')
            .height(46)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#D93025')
            .onClick(() => {
              AuthStore.logout()
              router.replaceUrl({ url: 'pages/Login' })
            })
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 18 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EDF2F8')
  }
}
