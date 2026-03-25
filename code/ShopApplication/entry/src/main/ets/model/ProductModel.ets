// 定义商品数据结构
export interface Product{
  id: number
  name: string
  price: number
  image: Resource
  category: string
}
// LazyForEach 需要实现 IDataSource 接口
export class ProductDataSource implements IDataSource {
  private productList: Product[] = []
  private listeners: DataChangeListener[] = [] // 监听器，监听到数据变化触发对应函数

  constructor(data: Product[]) {
    this.productList = data || [];
  }

  totalCount(): number {
    return this.productList.length
  }
  getData(index: number): Product {
    return this.productList[index]
  }
  registerDataChangeListener(listener: DataChangeListener): void { // 注册监听器
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }
  unregisterDataChangeListener(listener: DataChangeListener): void { // 删除监听器
    let index = this.listeners.indexOf(listener)
    if (index >= 0) {
      this.listeners.splice(index, 1)
    }
  }
  reloadData(newList: Product[]) { // 重新加载数据
    this.productList = newList
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }
}

