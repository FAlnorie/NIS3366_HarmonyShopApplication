import { router } from '@kit.ArkUI'
import { CartItem, CartStore } from '../data/CartStore'
import { AuthStore } from '../data/AuthStore'

@Entry
@Component
struct Checkout {
  @State cartItems: CartItem[] = []
  @State addressText: string = '上海市 闵行区 上海交通大学闵行校区'
  @State receiverText: string = '池松泽  150****0000'
  @State selectedPayMethod: number = 0
  @State selectedDelivery: number = 0
  @State isSubmitting: boolean = false
  @State isSubmitSuccess: boolean = false

  private paymentMethods: string[] = ['微信支付', '支付宝','银行卡']
  private deliveryMethods: string[] = ['标准配送', '次日达', '门店自提']

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
    this.cartItems = CartStore.getItems()
  }

  private getItemTotalPrice(): number {
    return CartStore.getTotalPrice()
  }

  private getDiscountPrice(): number {
    if (this.cartItems.length === 0) {
      return 0
    }
    return 20
  }

  private getDeliveryPrice(): number {
    if (this.selectedDelivery === 0) {
      return 8
    }
    if (this.selectedDelivery === 1) {
      return 15
    }
    return 0
  }

  private getFinalPrice(): number {
    if (this.cartItems.length === 0) {
      return 0
    }
    return this.getItemTotalPrice() - this.getDiscountPrice() + this.getDeliveryPrice()
  }

  private getPriceText(price: number): string {
    return `CNY ${price.toFixed(2)}`
  }

  private ensureLogin(): boolean {
    if (AuthStore.isLoggedIn()) {
      return true
    }
    router.replaceUrl({ url: 'pages/Login' })
    return false
  }

  private submitOrder(): void {
    if (this.cartItems.length === 0 || this.isSubmitting) {
      return
    }
    this.isSubmitting = true
    this.isSubmitSuccess = false
    setTimeout(() => {
      this.isSubmitting = false
      this.isSubmitSuccess = true
      CartStore.clear()
      this.reloadCart()
    }, 1200)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
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

          Text('确认订单')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111111')

          Blank()

          Text(' ')
            .width(44)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 10 })

        if (this.cartItems.length === 0 && !this.isSubmitSuccess) {
          Column() {
            Text('当前没有可结算商品')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#111111')
              .margin({ bottom: 10 })

            Button('返回购物车')
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
          Scroll() {
            Column({ space: 12 }) {
              Column({ space: 8 }) {
                Text('收货信息')
                  .width('100%')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#111111')
                Text(this.receiverText)
                  .width('100%')
                  .fontSize(14)
                  .fontColor('#374151')
                Text(this.addressText)
                  .width('100%')
                  .fontSize(13)
                  .fontColor('#6B7280')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .padding(14)

              Column({ space: 10 }) {
                Text('商品清单')
                  .width('100%')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#111111')

                ForEach(this.cartItems, (item: CartItem) => {
                  Row({ space: 10 }) {
                    Image(item.product.image)
                      .width(52)
                      .height(52)
                      .borderRadius(10)
                      .objectFit(ImageFit.Cover)

                    Column() {
                      Text(item.product.name)
                        .fontSize(14)
                        .fontColor('#111111')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      Text(`x${item.quantity}`)
                        .fontSize(12)
                        .fontColor('#6B7280')
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)

                    Text(this.getPriceText(item.product.price * item.quantity))
                      .fontSize(13)
                      .fontColor('#111111')
                      .fontWeight(FontWeight.Medium)
                  }
                  .width('100%')
                }, (item: CartItem) => `${item.product.id}-${item.quantity}`)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .padding(14)

              Column({ space: 10 }) {
                Text('支付方式')
                  .width('100%')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#111111')

                ForEach(this.paymentMethods, (method: string, index: number) => {
                  Row() {
                    Text(method)
                      .fontSize(14)
                      .fontColor('#111111')
                    Blank()
                    Text(this.selectedPayMethod === index ? '已选中' : '选择')
                      .fontSize(12)
                      .fontColor(this.selectedPayMethod === index ? '#0C63C5' : '#9CA3AF')
                  }
                  .width('100%')
                  .padding({ top: 8, bottom: 8 })
                  .onClick(() => {
                    this.selectedPayMethod = index
                  })
                }, (method: string) => method)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .padding(14)

              Column({ space: 10 }) {
                Text('配送方式')
                  .width('100%')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#111111')

                ForEach(this.deliveryMethods, (method: string, index: number) => {
                  Row() {
                    Text(method)
                      .fontSize(14)
                      .fontColor('#111111')
                    Blank()
                    Text(this.selectedDelivery === index ? '已选中' : '选择')
                      .fontSize(12)
                      .fontColor(this.selectedDelivery === index ? '#0C63C5' : '#9CA3AF')
                  }
                  .width('100%')
                  .padding({ top: 8, bottom: 8 })
                  .onClick(() => {
                    this.selectedDelivery = index
                  })
                }, (method: string) => method)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .padding(14)

              Column({ space: 8 }) {
                Row() {
                  Text('商品总额')
                    .fontSize(13)
                    .fontColor('#6B7280')
                  Blank()
                  Text(this.getPriceText(this.getItemTotalPrice()))
                    .fontSize(13)
                    .fontColor('#111111')
                }
                .width('100%')

                Row() {
                  Text('优惠')
                    .fontSize(13)
                    .fontColor('#6B7280')
                  Blank()
                  Text(`-${this.getPriceText(this.getDiscountPrice())}`)
                    .fontSize(13)
                    .fontColor('#16A34A')
                }
                .width('100%')

                Row() {
                  Text('运费')
                    .fontSize(13)
                    .fontColor('#6B7280')
                  Blank()
                  Text(this.getPriceText(this.getDeliveryPrice()))
                    .fontSize(13)
                    .fontColor('#111111')
                }
                .width('100%')
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .padding(14)

              Blank()
                .height(110)
            }
            .padding({ left: 12, right: 12, bottom: 10 })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#EDF2F8')

      if (this.cartItems.length > 0 || this.isSubmitSuccess) {
        Row() {
          Column() {
            Text('应付金额')
              .fontSize(12)
              .fontColor('#6B7280')
            Text(this.getPriceText(this.getFinalPrice()))
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
          }
          .alignItems(HorizontalAlign.Start)

          Blank()

          Button(this.isSubmitting ? '订单提交中...' : '提交订单')
            .width(140)
            .height(46)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .enabled(!this.isSubmitting && this.cartItems.length > 0)
            .backgroundColor('#0C63C5')
            .onClick(() => {
              this.submitOrder()
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 16 })
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
      }

      if (this.isSubmitSuccess) {
        Column({ space: 10 }) {
          Text('订单提交成功')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111111')
          Text('已完成前端演示，支付流程未接入')
            .fontSize(13)
            .fontColor('#6B7280')

          Row({ space: 10 }) {
            Button('继续逛逛')
              .fontSize(14)
              .backgroundColor('#0C63C5')
              .onClick(() => {
                router.pushUrl({ url: 'pages/Index' })
              })
            Button('返回购物车')
              .fontSize(14)
              .fontColor('#0C63C5')
              .backgroundColor('#E8F1FD')
              .onClick(() => {
                this.isSubmitSuccess = false
                router.pushUrl({ url: 'pages/Cart' })
              })
          }
        }
        .width('78%')
        .padding({ left: 16, right: 16, top: 20, bottom: 20 })
        .backgroundColor('#FFFFFF')
        .borderRadius(18)
        .shadow({
          radius: 20,
          color: 'rgba(0,0,0,0.15)',
          offsetX: 0,
          offsetY: 10
        })
      }
    }
  }
}
