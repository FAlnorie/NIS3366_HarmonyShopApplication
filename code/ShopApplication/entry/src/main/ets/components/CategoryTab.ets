@Component
export struct CategoryTab {
  @Link currentCategory: string; // 与父组件双向绑定状态变量
  @State categories: string[] = ['精选', '手机', '服饰', '电脑', '配件', '家电', '食品']
  build() {
    Column() {
      // 顶部标题区域，简洁大号标题
      Row() {
        Text('商店')
          .fontSize(28)
          .fontWeight(FontWeight.Medium)
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
