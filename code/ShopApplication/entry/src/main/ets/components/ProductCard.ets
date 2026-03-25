import { Product } from '../model/ProductModel'

@Component
export struct ProductCard {
  @Prop item: Product; // 接受父组件传入的数据
  build() {
    Column() {
      // 商品主图
      Image(this.item.image)
        .width('100%')
        .aspectRatio(1)
        .borderRadius(14)

      // 商品名称
      Text(this.item.name)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#111111')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis }) // 当商品名称长度过长时自动省略并显示省略号
        .margin({ top: 10, bottom: 4 })

      // 价格与占位按钮行
      Row({ space: 4 }) {
        Text(`￥${this.item.price}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#0071E3') // 接近 Apple 蓝

        Blank()

        Text('购买')
          .fontSize(13)
          .fontColor('#0071E3')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .borderRadius(14)
          .backgroundColor('rgba(0,113,227,0.08)')
      }
      .width('100%')
    }
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
    .shadow({
      radius: 16,
      color: 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 8
    })
  }
}