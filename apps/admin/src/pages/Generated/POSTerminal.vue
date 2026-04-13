<template>
  <div class="h-screen flex flex-col bg-slate-100 dark:bg-slate-900 overflow-hidden -m-8">
    <!-- POS Header -->
    <div class="flex items-center justify-between bg-white dark:bg-slate-800 border-b border-slate-200 dark:border-slate-700 px-6 py-3 shadow-sm flex-shrink-0">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-sky-400 to-sky-600 flex items-center justify-center">
          <Monitor class="w-4 h-4 text-white" />
        </div>
        <div>
          <h1 class="font-bold text-slate-900 dark:text-white text-sm">POS Terminal</h1>
          <p class="text-xs text-slate-400">Branch: Main Branch</p>
        </div>
      </div>
      <div class="flex items-center gap-4">
        <span class="text-sm text-slate-500 dark:text-slate-400 font-mono">{{ currentTime }}</span>
        <button @click="clearOrder" class="flex items-center gap-1.5 px-3 py-1.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 rounded-lg text-sm font-medium hover:bg-red-200 transition-colors">
          <Trash2 class="w-3.5 h-3.5" /> Clear
        </button>
      </div>
    </div>

    <div class="flex flex-1 overflow-hidden">
      <!-- Left: Menu browsing -->
      <div class="flex-1 flex flex-col overflow-hidden">
        <!-- Category tabs -->
        <div class="flex gap-2 px-4 py-3 overflow-x-auto bg-white dark:bg-slate-800 border-b border-slate-200 dark:border-slate-700 flex-shrink-0">
          <button
            v-for="cat in ['All', ...categories]" :key="cat"
            @click="activeCategory = cat"
            :class="['px-4 py-2 rounded-xl text-sm font-medium whitespace-nowrap transition-all flex-shrink-0',
              activeCategory === cat
                ? 'bg-sky-500 text-white shadow-md shadow-sky-500/20'
                : 'bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-sky-50 dark:hover:bg-sky-900/20']">
            {{ cat }}
          </button>
        </div>

        <!-- Search -->
        <div class="px-4 py-3 bg-slate-100 dark:bg-slate-900 flex-shrink-0">
          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input v-model="menuSearch" type="text" placeholder="Search menu items..."
              class="w-full pl-9 pr-4 py-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
          </div>
        </div>

        <!-- Items grid -->
        <div class="flex-1 overflow-y-auto px-4 pb-4">
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
            <button
              v-for="item in filteredMenuItems" :key="item.id"
              @click="addToCart(item)"
              :disabled="!item.available"
              class="group bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-3 text-left transition-all hover:border-sky-300 hover:shadow-md disabled:opacity-50 disabled:cursor-not-allowed active:scale-95">
              <div class="h-16 flex items-center justify-center text-3xl mb-2 bg-slate-50 dark:bg-slate-700/50 rounded-xl">{{ item.emoji }}</div>
              <p class="text-sm font-semibold text-slate-800 dark:text-white truncate">{{ item.name }}</p>
              <p class="text-xs text-slate-400 mb-1">{{ item.category }}</p>
              <p class="text-base font-bold text-sky-600 dark:text-sky-400">${{ item.price }}</p>
            </button>
          </div>
        </div>
      </div>

      <!-- Right: Order Cart -->
      <div class="w-80 xl:w-96 flex flex-col bg-white dark:bg-slate-800 border-l border-slate-200 dark:border-slate-700 shadow-xl flex-shrink-0">
        <!-- Cart Header -->
        <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700 flex-shrink-0">
          <div class="flex items-center justify-between mb-3">
            <h2 class="font-bold text-slate-900 dark:text-white">Current Order</h2>
            <span class="text-sm text-slate-500 dark:text-slate-400">{{ cartItemCount }} items</span>
          </div>
          <!-- Order type -->
          <div class="flex bg-slate-100 dark:bg-slate-700 rounded-xl p-1 gap-1">
            <button v-for="type in orderTypes" :key="type.key" @click="orderType = type.key"
              :class="['flex-1 py-1.5 rounded-lg text-xs font-semibold transition-all', orderType === type.key ? 'bg-white dark:bg-slate-600 text-sky-600 shadow-sm' : 'text-slate-500 dark:text-slate-400']">
              {{ type.label }}
            </button>
          </div>
        </div>

        <!-- Cart items -->
        <div class="flex-1 overflow-y-auto px-5 py-3 space-y-3">
          <div v-if="cart.length === 0" class="flex flex-col items-center justify-center h-full text-center py-12">
            <ShoppingCart class="w-12 h-12 text-slate-300 dark:text-slate-600 mb-3" />
            <p class="text-slate-400 text-sm font-medium">No items added</p>
            <p class="text-slate-400 text-xs mt-1">Tap a menu item to add it</p>
          </div>
          <div v-for="(ci, idx) in cart" :key="ci.id + idx"
            class="flex items-center gap-3 bg-slate-50 dark:bg-slate-700/50 rounded-xl p-3">
            <span class="text-xl flex-shrink-0">{{ ci.emoji }}</span>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-semibold text-slate-800 dark:text-white truncate">{{ ci.name }}</p>
              <p class="text-sm text-sky-600 dark:text-sky-400 font-bold">${{ (ci.price * ci.qty).toFixed(2) }}</p>
            </div>
            <div class="flex items-center gap-1.5">
              <button @click="decreaseQty(ci)" class="w-7 h-7 rounded-lg bg-slate-200 dark:bg-slate-600 text-slate-700 dark:text-white font-bold text-sm hover:bg-red-100 dark:hover:bg-red-900/30 hover:text-red-600 transition-colors flex items-center justify-center">−</button>
              <span class="text-sm font-bold text-slate-800 dark:text-white w-5 text-center">{{ ci.qty }}</span>
              <button @click="ci.qty++" class="w-7 h-7 rounded-lg bg-slate-200 dark:bg-slate-600 text-slate-700 dark:text-white font-bold text-sm hover:bg-sky-100 dark:hover:bg-sky-900/30 hover:text-sky-600 transition-colors flex items-center justify-center">+</button>
            </div>
          </div>
        </div>

        <!-- Totals & Checkout -->
        <div class="px-5 py-4 border-t border-slate-200 dark:border-slate-700 space-y-3 flex-shrink-0">
          <!-- Coupon -->
          <div class="flex gap-2">
            <input v-model="coupon" type="text" placeholder="Coupon code..."
              class="flex-1 px-3 py-2 text-sm bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
            <button class="px-3 py-2 bg-sky-100 dark:bg-sky-900/30 text-sky-600 dark:text-sky-400 rounded-xl text-sm font-medium hover:bg-sky-200 transition-colors">Apply</button>
          </div>

          <!-- Totals -->
          <div class="space-y-1.5">
            <div class="flex justify-between text-sm">
              <span class="text-slate-500 dark:text-slate-400">Subtotal</span>
              <span class="text-slate-800 dark:text-white font-medium">${{ subtotal.toFixed(2) }}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-slate-500 dark:text-slate-400">Tax (8%)</span>
              <span class="text-slate-800 dark:text-white font-medium">${{ tax.toFixed(2) }}</span>
            </div>
            <div class="flex justify-between text-sm font-bold border-t border-slate-200 dark:border-slate-700 pt-2 mt-2">
              <span class="text-slate-900 dark:text-white">Total</span>
              <span class="text-xl text-sky-600 dark:text-sky-400">${{ total.toFixed(2) }}</span>
            </div>
          </div>

          <!-- Payment buttons -->
          <div class="grid grid-cols-2 gap-2">
            <button @click="processPayment('Cash')"
              :disabled="cart.length === 0"
              class="flex items-center justify-center gap-2 py-3 bg-emerald-500 hover:bg-emerald-400 disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-bold rounded-xl transition-all shadow-lg shadow-emerald-500/20 active:scale-95">
              <Banknote class="w-4 h-4" /> Cash
            </button>
            <button @click="processPayment('Card')"
              :disabled="cart.length === 0"
              class="flex items-center justify-center gap-2 py-3 bg-sky-500 hover:bg-sky-400 disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-bold rounded-xl transition-all shadow-lg shadow-sky-500/20 active:scale-95">
              <CreditCard class="w-4 h-4" /> Card
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Toast -->
    <Teleport to="body">
      <div v-if="toastMsg" class="fixed top-6 right-6 z-50 bg-emerald-500 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-semibold flex items-center gap-2 animate-bounce">
        <CheckCircle class="w-5 h-5" /> {{ toastMsg }}
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Search, ShoppingCart, Trash2, Monitor, CreditCard, Banknote, CheckCircle } from 'lucide-vue-next'

const activeCategory = ref('All')
const menuSearch = ref('')
const orderType = ref('POS')
const cart = ref([])
const coupon = ref('')
const toastMsg = ref('')
const currentTime = ref('')

const orderTypes = [
  { key: 'POS', label: 'POS' },
  { key: 'Table', label: 'Dine-In' },
  { key: 'Takeaway', label: 'Takeaway' },
]

const categories = ['Burgers', 'Pizza', 'Sushi', 'Pasta', 'Salads', 'Desserts', 'Drinks']

const menuItems = ref([
  { id: 1, name: 'Chicken Burger', category: 'Burgers', price: '12.99', emoji: '🍔', available: true },
  { id: 2, name: 'BBQ Bacon Burger', category: 'Burgers', price: '15.99', emoji: '🍔', available: true },
  { id: 3, name: 'Margherita Pizza', category: 'Pizza', price: '14.99', emoji: '🍕', available: true },
  { id: 4, name: 'Pepperoni Pizza', category: 'Pizza', price: '16.99', emoji: '🍕', available: true },
  { id: 5, name: 'Salmon Sushi Roll', category: 'Sushi', price: '18.50', emoji: '🍱', available: true },
  { id: 6, name: 'Caesar Salad', category: 'Salads', price: '9.50', emoji: '🥗', available: false },
  { id: 7, name: 'Pasta Carbonara', category: 'Pasta', price: '13.50', emoji: '🍝', available: true },
  { id: 8, name: 'Choc Lava Cake', category: 'Desserts', price: '7.99', emoji: '🍰', available: true },
  { id: 9, name: 'Mango Smoothie', category: 'Drinks', price: '5.50', emoji: '🥤', available: true },
  { id: 10, name: 'Sparkling Water', category: 'Drinks', price: '2.99', emoji: '💧', available: true },
  { id: 11, name: 'Greek Salad', category: 'Salads', price: '8.99', emoji: '🥗', available: true },
  { id: 12, name: 'Tiramisu', category: 'Desserts', price: '6.99', emoji: '🍮', available: true },
])

const filteredMenuItems = computed(() => menuItems.value.filter(i => {
  const matchCat = activeCategory.value === 'All' || i.category === activeCategory.value
  const matchSearch = !menuSearch.value || i.name.toLowerCase().includes(menuSearch.value.toLowerCase())
  return matchCat && matchSearch
}))

const cartItemCount = computed(() => cart.value.reduce((a, b) => a + b.qty, 0))
const subtotal = computed(() => cart.value.reduce((a, b) => a + parseFloat(b.price) * b.qty, 0))
const tax = computed(() => subtotal.value * 0.08)
const total = computed(() => subtotal.value + tax.value)

const addToCart = (item) => {
  const existing = cart.value.find(c => c.id === item.id)
  if (existing) { existing.qty++ } else { cart.value.push({ ...item, qty: 1 }) }
}

const decreaseQty = (ci) => {
  if (ci.qty <= 1) { cart.value = cart.value.filter(c => c.id !== ci.id) } else { ci.qty-- }
}

const clearOrder = () => { cart.value = [] }

const processPayment = (method) => {
  if (cart.value.length === 0) return
  toastMsg.value = `Order placed! Paid via ${method}. Total: $${total.value.toFixed(2)}`
  cart.value = []
  setTimeout(() => { toastMsg.value = '' }, 3000)
}

let timer = null
const updateTime = () => { currentTime.value = new Date().toLocaleTimeString() }
onMounted(() => { updateTime(); timer = setInterval(updateTime, 1000) })
onUnmounted(() => clearInterval(timer))
</script>
