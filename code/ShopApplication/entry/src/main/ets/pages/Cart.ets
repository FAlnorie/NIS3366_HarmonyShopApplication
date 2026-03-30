import { router } from '@kit.ArkUI'
import { CartItem, CartStore } from '../data/CartStore'
import { AuthStore } from '../data/AuthStore'

@Entry
@Component
struct Cart {
  @State cartItems: CartItem[] = []
  @State accountsText: string = `NULL`
  aboutToAppear() {
    if (!this.ensureLogin()) {
      return
    }
    this.reloadCart()
  }

  onPageShow() {
    if (!this.ensureLogin()) {
      return
    }
    this.reloadCart()
  }

  private reloadCart(): void {
    // 每次刷新都重读 store，确保数量/金额与其它页面操作保持一致。
    this.cartItems = CartStore.getItems()
    this.getTotalPriceText()
  }

  private getTotalPriceText(): void {
    this.accountsText = `CNY ${CartStore.getTotalPrice().toFixed(2)}`
  }

  private ensureLogin(): boolean {
    if (AuthStore.isLoggedIn()) {
      return true
    }
    // 购物车属于登录态页面，未登录直接重定向。
    router.replaceUrl({ url: 'pages/Login' })
    return false
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

        Text('购物车')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')

        Blank()

        Text('清空')
          .fontSize(14)
          .fontColor('#E53935')
          .opacity(this.cartItems.length > 0 ? 1 : 0.4)
          .onClick(() => {
            if (this.cartItems.length === 0) {
              return
            }
            CartStore.clear()
            this.reloadCart()
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      if (this.cartItems.length === 0) {
        Column() {
          Text('购物车还是空的')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111111')
            .margin({ bottom: 8 })

          Text('去首页挑选你喜欢的商品吧')
            .fontSize(14)
            .fontColor('#6B7280')
            .margin({ bottom: 20 })

          Button('继续逛逛')
            .fontSize(15)
            .backgroundColor('#0C63C5')
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ForEach(this.cartItems, (item: CartItem) => {
            ListItem() {
              Row({ space: 12 }) {
                Image(item.product.image)
                  .width(88)
                  .height(88)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(12)

                Column({ space: 8 }) {
                  Text(item.product.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#111111')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`单价 ${item.product.price.toFixed(2)}`)
                    .fontSize(13)
                    .fontColor('#6B7280')

                  Row({ space: 10 }) {
                    Text('-')
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#111111')
                      .width(28)
                      .height(28)
                      .textAlign(TextAlign.Center)
                      .backgroundColor('#EEF2F7')
                      .borderRadius(14)
                      .onClick(() => {
                        CartStore.updateQuantity(item.product.id, item.quantity - 1)
                        this.reloadCart()
                      })

                    Text(`${item.quantity}`)
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#111111')

                    Text('+')
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#111111')
                      .width(28)
                      .height(28)
                      .textAlign(TextAlign.Center)
                      .backgroundColor('#EEF2F7')
                      .borderRadius(14)
                      .onClick(() => {
                        CartStore.updateQuantity(item.product.id, item.quantity + 1)
                        this.reloadCart()
                      })

                    Blank()

                    Text('删除')
                      .fontSize(13)
                      .fontColor('#E53935')
                      .onClick(() => {
                        CartStore.removeItem(item.product.id)
                        this.reloadCart()
                      })
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Center)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
            }
            .margin({ bottom: 10 })
          }, (item: CartItem) => `${item.product.id}-${item.quantity}`)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 12, right: 12 })

        Row() {
          Column() {
            Text('合计')
              .fontSize(12)
              .fontColor('#6B7280')
            Text(this.accountsText)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
          }
          .alignItems(HorizontalAlign.Start)

          Blank()

          Button('去结算')
            .width(132)
            .height(44)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#0C63C5')
            .onClick(() => {
              router.pushUrl({ url: 'pages/Checkout' })
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 16 })
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 18, topRight: 18 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EDF2F8')
  }
}
