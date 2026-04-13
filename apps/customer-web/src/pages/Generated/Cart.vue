<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <h1 class="font-bold text-slate-900 dark:text-white">My Cart</h1>
        <RouterLink to="/menu" class="text-sm text-orange-500 hover:text-orange-400 font-semibold">+ Add More</RouterLink>
      </div>
    </nav>

    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div v-if="cartItems.length > 0" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Cart items -->
        <div class="lg:col-span-2 space-y-4">
          <h2 class="text-lg font-bold text-slate-900 dark:text-white mb-2">{{ cartItems.length }} items in your cart</h2>
          <div v-for="item in cartItems" :key="item.id"
            class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-4 flex gap-4 shadow-sm hover:shadow-md transition-shadow">
            <!-- Item image -->
            <div class="w-20 h-20 flex-shrink-0 bg-gradient-to-br from-orange-50 to-rose-50 dark:from-slate-800 dark:to-slate-700 rounded-2xl flex items-center justify-center text-3xl">
              {{ item.emoji }}
            </div>
            <!-- Info -->
            <div class="flex-1 min-w-0">
              <h3 class="font-bold text-slate-900 dark:text-white truncate">{{ item.name }}</h3>
              <p class="text-sm text-slate-400 mt-0.5">{{ item.addons }}</p>
              <div class="flex items-center justify-between mt-3">
                <!-- Quantity -->
                <div class="flex items-center gap-2 bg-slate-100 dark:bg-slate-800 rounded-xl p-1">
                  <button @click="dec(item)" class="w-7 h-7 rounded-lg bg-white dark:bg-slate-700 shadow-sm text-slate-700 dark:text-white font-bold hover:text-orange-500 transition-colors flex items-center justify-center text-sm">−</button>
                  <span class="w-6 text-center text-sm font-bold text-slate-900 dark:text-white">{{ item.qty }}</span>
                  <button @click="item.qty++" class="w-7 h-7 rounded-lg bg-white dark:bg-slate-700 shadow-sm text-slate-700 dark:text-white font-bold hover:text-orange-500 transition-colors flex items-center justify-center text-sm">+</button>
                </div>
                <!-- Price + Delete -->
                <div class="flex items-center gap-3">
                  <span class="font-extrabold text-orange-500 text-lg">${{ (parseFloat(item.price) * item.qty).toFixed(2) }}</span>
                  <button @click="removeItem(item.id)" class="p-1.5 rounded-lg text-slate-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                    <Trash2 class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Order Summary -->
        <div class="lg:col-span-1">
          <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 shadow-sm sticky top-24 space-y-5">
            <h2 class="text-base font-bold text-slate-900 dark:text-white">Order Summary</h2>

            <!-- Coupon -->
            <div>
              <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">Promo Code</label>
              <div class="flex gap-2">
                <input v-model="coupon" type="text" placeholder="e.g. FOODKING20"
                  class="flex-1 px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
                <button @click="applyCoupon" class="px-3 py-2 bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 rounded-xl text-sm font-semibold hover:bg-orange-200 transition-colors">Apply</button>
              </div>
              <p v-if="couponMsg" :class="['text-xs mt-1.5 font-medium', couponApplied ? 'text-emerald-600' : 'text-red-500']">{{ couponMsg }}</p>
            </div>

            <!-- Totals -->
            <div class="space-y-2.5">
              <div class="flex justify-between text-sm">
                <span class="text-slate-500 dark:text-slate-400">Subtotal</span>
                <span class="font-medium text-slate-800 dark:text-white">${{ subtotal.toFixed(2) }}</span>
              </div>
              <div v-if="couponApplied" class="flex justify-between text-sm">
                <span class="text-emerald-600 dark:text-emerald-400">Discount (20%)</span>
                <span class="font-medium text-emerald-600 dark:text-emerald-400">−${{ discount.toFixed(2) }}</span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="text-slate-500 dark:text-slate-400">Delivery Fee</span>
                <span :class="['font-medium', deliveryFee === 0 ? 'text-emerald-600 dark:text-emerald-400' : 'text-slate-800 dark:text-white']">
                  {{ deliveryFee === 0 ? 'FREE' : `$${deliveryFee.toFixed(2)}` }}
                </span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="text-slate-500 dark:text-slate-400">Tax (8%)</span>
                <span class="font-medium text-slate-800 dark:text-white">${{ tax.toFixed(2) }}</span>
              </div>
              <div class="border-t border-slate-200 dark:border-slate-700 pt-2.5 flex justify-between">
                <span class="font-bold text-slate-900 dark:text-white">Total</span>
                <span class="text-xl font-extrabold text-orange-500">${{ total.toFixed(2) }}</span>
              </div>
            </div>

            <p v-if="subtotal < 25" class="text-xs text-slate-400 bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-xl px-3 py-2.5 text-amber-700 dark:text-amber-400">
              Add ${{ (25 - subtotal).toFixed(2) }} more for free delivery!
            </p>

            <RouterLink to="/checkout"
              class="block w-full text-center py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-xl shadow-orange-500/20 hover:shadow-orange-500/40 active:scale-95">
              Proceed to Checkout →
            </RouterLink>

            <RouterLink to="/menu" class="block text-center text-sm text-slate-500 dark:text-slate-400 hover:text-orange-400 transition-colors">← Continue Shopping</RouterLink>
          </div>
        </div>
      </div>

      <!-- Empty Cart -->
      <div v-else class="flex flex-col items-center justify-center py-28 text-center">
        <div class="text-8xl mb-6 animate-bounce" style="animation-duration: 2s">🛒</div>
        <h2 class="text-2xl font-bold text-slate-800 dark:text-white mb-2">Your cart is empty</h2>
        <p class="text-slate-400 mb-8">Looks like you haven't added anything yet.</p>
        <RouterLink to="/menu" class="px-8 py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-xl shadow-orange-500/20 active:scale-95">
          Browse Menu
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Trash2 } from 'lucide-vue-next'

const coupon = ref('')
const couponMsg = ref('')
const couponApplied = ref(false)

const cartItems = ref([
  { id: 1, name: 'Chicken Burger', emoji: '🍔', price: '12.99', qty: 2, addons: 'Large, Extra Cheese' },
  { id: 2, name: 'Margherita Pizza', emoji: '🍕', price: '11.99', qty: 1, addons: 'Regular' },
  { id: 3, name: 'Mango Smoothie', emoji: '🥤', price: '5.50', qty: 2, addons: '' },
])

const subtotal = computed(() => cartItems.value.reduce((a, b) => a + parseFloat(b.price) * b.qty, 0))
const discount = computed(() => couponApplied.value ? subtotal.value * 0.20 : 0)
const deliveryFee = computed(() => subtotal.value >= 25 ? 0 : 3.99)
const tax = computed(() => (subtotal.value - discount.value) * 0.08)
const total = computed(() => subtotal.value - discount.value + deliveryFee.value + tax.value)

const dec = (item) => { if (item.qty <= 1) removeItem(item.id); else item.qty-- }
const removeItem = (id) => { cartItems.value = cartItems.value.filter(i => i.id !== id) }

const applyCoupon = () => {
  if (coupon.value.toUpperCase() === 'FOODKING20') {
    couponApplied.value = true
    couponMsg.value = '✓ 20% discount applied!'
  } else {
    couponApplied.value = false
    couponMsg.value = 'Invalid coupon code.'
  }
}
</script>
