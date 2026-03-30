import { Product } from '../model/ProductModel'

export interface CartItem {
  product: Product
  quantity: number
}

class CartItemModel implements CartItem {
  product: Product
  quantity: number

  constructor(product: Product, quantity: number) {
    this.product = product
    this.quantity = quantity
  }
}

export class CartStore {
  private static cartItems: CartItem[] = []

  static getItems(): CartItem[] {
    // 返回新实例，避免 UI 因引用未变化而不刷新。
    return CartStore.cartItems.map((item: CartItem) => {
      return new CartItemModel(item.product, item.quantity)
    })
  }

  static addItem(product: Product, quantity: number = 1): void {
    const target = CartStore.cartItems.find((item: CartItem) => item.product.id === product.id)
    if (target) {
      target.quantity += quantity
      return
    }
    CartStore.cartItems.push(new CartItemModel(product, quantity))
  }

  static updateQuantity(productId: number, quantity: number): void {
    // 数量降到 0 及以下等价于移除商品。
    if (quantity <= 0) {
      CartStore.removeItem(productId)
      return
    }
    const target = CartStore.cartItems.find((item: CartItem) => item.product.id === productId)
    if (target) {
      target.quantity = quantity
    }
  }

  static removeItem(productId: number): void {
    CartStore.cartItems = CartStore.cartItems.filter((item: CartItem) => item.product.id !== productId)
  }

  static clear(): void {
    CartStore.cartItems = []
  }

  static getTotalCount(): number {
    return CartStore.cartItems.reduce((sum: number, item: CartItem) => sum + item.quantity, 0)
  }

  static getTotalPrice(): number {
    return CartStore.cartItems.reduce((sum: number, item: CartItem) => sum + item.product.price * item.quantity, 0)
  }
}
