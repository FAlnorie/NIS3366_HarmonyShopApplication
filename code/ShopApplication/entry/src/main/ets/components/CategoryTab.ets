import { router } from '@kit.ArkUI'

@Component
export struct CategoryTab {
  @Link currentCategory: string; // 与父组件双向绑定状态变量
  @Prop cartCount: number = 0
  @State categories: string[] = ['精选', '手机', '服饰', '电脑', '配件', '家电', '食品']
  build() {
    Column() {
      // 顶部标题区域，简洁大号标题
      Row() {
        Text('商店')
          .fontSize(28)
          .fontWeight(FontWeight.Medium)

        Blank()

        Stack({ alignContent: Alignment.TopEnd }) {
          Text('购物车')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111111')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor('#FFFFFF')
            .borderRadius(16)

          if (this.cartCount > 0) {
            Text(`${this.cartCount}`)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor('#E53935')
              .borderRadius(10)
              .margin({ right: -6, top: -6 })
          }
        }
        .onClick(() => {
          router.pushUrl({ url: 'pages/Cart' })
        })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 类目 Tab，苹果风 pill 风格
      Scroll() {
        Row({ space: 10 }) {
          ForEach(this.categories, (category: string) => {
            Text(category)
              .padding({ left: 14, right: 14, top: 8, bottom: 8 })
              .fontSize(15)
              .fontWeight(category === this.currentCategory ? FontWeight.Medium : FontWeight.Regular)
              .backgroundColor(category === this.currentCategory ? '#000000' : '#ffeeeef5')
              .fontColor(category === this.currentCategory ? '#FFFFFF' : '#3C3C43')
              .borderRadius(18)
              .onClick(() => {
                this.currentCategory = category
                console.log(`currentCategory changes => ${this.currentCategory}`)
              })
          })
        }
      }
      .width('100%')
      .height(40)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
  }
}
