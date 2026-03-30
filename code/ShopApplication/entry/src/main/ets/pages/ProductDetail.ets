import { router } from '@kit.ArkUI'
import { findProductById } from '../data/ProductData'
import { Product } from '../model/ProductModel'
import { CartStore } from '../data/CartStore'
import { AuthStore } from '../data/AuthStore'

@Entry
@Component
struct ProductDetail {
  @State product?: Product = undefined

  aboutToAppear() {
    if (!this.ensureLogin()) {
      return
    }
    // 详情页通过路由参数 productId 查询对应商品。
    const params = router.getParams() as Record<string, Object>
    const productId = Number(params['productId'] ?? -1)
    this.product = findProductById(productId)
  }

  private getHighlights(category: string): string[] {
    if (category === '手机') {
      return ['鸿蒙互联', '超清影像', '官方质保']
    }
    if (category === '电脑') {
      return ['轻薄机身', '高刷屏幕', '长效续航']
    }
    if (category === '配件') {
      return ['原装正品', '极速发货', '7 天无忧']
    }
    return ['新品推荐', '官方直营', '品质保障']
  }

  private getPriceText(price: number): string {
    return `CNY ${price.toFixed(2)}`
  }

  private ensureLogin(): boolean {
    if (AuthStore.isLoggedIn()) {
      return true
    }
    // 防止未登录用户直接通过路由访问详情页。
    router.replaceUrl({ url: 'pages/Login' })
    return false
  }

  build() {
    Column() {
      if (this.product) {
        Scroll() {
          Column() {
            Stack({ alignContent: Alignment.TopStart }) {
              Column() {
                Blank()
              }
              .width('100%')
              .height(320)
              .borderRadius(24)
              .linearGradient({
                angle: 135,
                colors: [['#0A223F', 0], ['#0F4C81', 0.55], ['#1A76D2', 1]]
              })
              Row(){
                Image(this.product.image)
                  .width(200)
                  .height(200)
                  .margin({top: 70})
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)

              Row() {
                Text('< 返回')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#FFFFFF')
                  .onClick(() => {
                    router.back()
                  })
                Blank()
              }
              .width('100%')
              .padding({ top: 18, left: 16, right: 16 })
            }

            Column({ space: 12 }) {
              Text(this.product.category)
                .fontSize(12)
                .fontColor('#1A76D2')
                .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                .backgroundColor('#E9F2FD')
                .borderRadius(12)

              Text(this.product.name)
                .width('100%')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111111')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(this.getPriceText(this.product.price))
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0C63C5')

              Text('官方自营 · 现货速发 · 支持 7 天无理由退换')
                .fontSize(13)
                .fontColor('#6B7280')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#FFFFFF')
            .borderRadius(20)
            .padding(16)
            .margin({ top: 14 })

            Column({ space: 10 }) {
              Text('产品亮点')
                .width('100%')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#111111')

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                ForEach(this.getHighlights(this.product.category), (item: string) => {
                  Text(item)
                    .fontSize(13)
                    .fontColor('#1F2937')
                    .padding({ left: 10, right: 10, top: 7, bottom: 7 })
                    .backgroundColor('#F3F6FA')
                    .borderRadius(14)
                    .margin({ right: 8, bottom: 8 })
                }, (item: string) => item)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#FFFFFF')
            .borderRadius(20)
            .padding(16)
            .margin({ top: 12 })

            Blank()
              .height(110)
          }
          .padding({ left: 14, right: 14, top: 12 })
        }
        .width('100%')
        .layoutWeight(1)

        Row() {
          Column() {
            Text('到手价')
              .fontSize(12)
              .fontColor('#6B7280')
            Text(this.getPriceText(this.product.price))
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
          }
          .alignItems(HorizontalAlign.Start)

          Blank()

          Button('加入购物车')
            .width(124)
            .height(46)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#0C63C5')
            .backgroundColor('#E8F1FD')
            .onClick(() => {
              if (this.product) {
                CartStore.addItem(this.product, 1)
              }
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 16 })
        .backgroundColor('#FFFFFF')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .shadow({
          radius: 18,
          color: 'rgba(10,34,63,0.12)',
          offsetX: 0,
          offsetY: -6
        })
      } else {
        Column() {
          Text('未找到商品')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111111')

          Text('该商品可能已下架或参数异常')
            .fontSize(14)
            .fontColor('#6B7280')
            .margin({ top: 8, bottom: 16 })

          Button('返回列表')
            .backgroundColor('#0C63C5')
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding(20)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EDF2F8')
  }
}
