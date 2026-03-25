import { productData } from '../data/ProductData';
import { Product } from '../model/ProductModel'
import { CategoryTab } from '../components/CategoryTab';
import { ProductItemList } from '../components/ProductItemList'
@Entry
@Component
struct Index {
  @State @Watch('onCategoryChange') currentCategory: string = '精选'; // 监视状态变量
  @State dataSource : Product[] = productData[this.currentCategory];
  build() {
    Column() {
      Column() {
        CategoryTab({ currentCategory: this.currentCategory })
      }
      .padding({ top: 16, left: 16, right: 16, bottom: 8 })
      ProductItemList({ productData: this.dataSource})
    }
    .backgroundColor('#F5F5F7')
  }
  onCategoryChange() { // 状态变量变化的时候更新传入的数据
    this.dataSource = productData[this.currentCategory];
  }

}