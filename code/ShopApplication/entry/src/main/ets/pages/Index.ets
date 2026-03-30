import { productData } from '../data/ProductData';
import { Product } from '../model/ProductModel'
import { CategoryTab } from '../components/CategoryTab';
import { ProductItemList } from '../components/ProductItemList'
import { CartStore } from '../data/CartStore'
import { AuthStore } from '../data/AuthStore'
import { router } from '@kit.ArkUI'
@Entry
@Component
struct Index {
  @State @Watch('onCategoryChange') currentCategory: string = '精选'; // 监视状态变量
  @State dataSource : Product[] = productData[this.currentCategory];
  @State cartCount: number = 0

  aboutToAppear() {
    // 首页作为业务主入口，进入时先做登录态校验。
    if (!this.ensureLogin()) {
      return
    }
    this.refreshCartCount()
  }

  onPageShow() {
    if (!this.ensureLogin()) {
      return
    }
    this.refreshCartCount()
  }

  build() {
    Column() {
      Column() {
        CategoryTab({
          currentCategory: this.currentCategory,
          cartCount: this.cartCount
        })
      }
      .padding({ top: 16, left: 16, right: 16, bottom: 8 })
      ProductItemList({ productData: this.dataSource})
    }
    .backgroundColor('#F5F5F7')
  }

  onCategoryChange() { // 状态变量变化的时候更新传入的数据
    this.dataSource = productData[this.currentCategory];
  }

  private refreshCartCount() {
    this.cartCount = CartStore.getTotalCount()
  }

  private ensureLogin(): boolean {
    if (AuthStore.isLoggedIn()) {
      return true
    }
    // 统一用 replaceUrl 防止返回栈回到未授权页面。
    router.replaceUrl({ url: 'pages/Login' })
    return false
  }
}
