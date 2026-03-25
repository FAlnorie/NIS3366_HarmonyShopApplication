import { Product, ProductDataSource } from '../model/ProductModel'
import { ProductCard } from './ProductCard'
@Component
export struct ProductItemList {
  @Prop @Watch('onProductDataChange') productData: Product[] // 接受父组件传入的数据 并在发生变化时自动刷新
  @State isRefreshing: boolean = false
  private productList: ProductDataSource = new ProductDataSource([]);
  private promptText: string = '正在刷新...'
  aboutToAppear() {
    this.onProductDataChange(); // 应用启动时自动加载数据
  }
  build() {
    Refresh({ refreshing: $$this.isRefreshing, promptText: this.promptText}){
      List() {
        LazyForEach(this.productList, (item: Product) => {
          ListItem() {
            ProductCard({item: item}) // 传入Product数据 复用ProductCard组件
          }
          .margin({ top: 12, left: 8, right: 8 })
        }, (item: Product) => `${item.id}` )

        // 滑到底时在列表末尾显示 footer（作为列表最后一项，随滚动自然出现）
        // 在商品数量为奇数时补充一个空白 ListItem
        if(this.productData.length % 2 == 1){
          ListItem()
        }
        ListItem() {
          Row() {
            Text('— 已经到底 —')
              .fontSize(12)
              .fontColor('#8E8E93')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 24, bottom: 32 })
        }
        .width('200%') // 通过宽度设置成200%实现占据整行的视觉效果
      }
      .lanes(2) // 设置成两列
      .width('100%')
      .height(600)
      .edgeEffect(EdgeEffect.Spring) // 滑动到边界时，会有弹性回弹效果
      .chainAnimation(false) // 关闭列表项联动动画，提升性能
    }.onRefreshing(() => {
      setTimeout(() => {
        this.isRefreshing = false;
        this.productList.reloadData(this.productData); // 重新加载数据
      }, 1000)
    })

  }
  onProductDataChange() {
    if(this.productData == undefined){ // 防止报错
      this.productData = []
    }
    this.productList.reloadData(this.productData)
  }

}