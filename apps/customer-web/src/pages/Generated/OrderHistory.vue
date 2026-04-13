<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <h1 class="font-bold text-slate-900 dark:text-white">My Orders</h1>
        <RouterLink to="/menu" class="text-sm text-orange-500 hover:text-orange-400 font-semibold">+ New Order</RouterLink>
      </div>
    </nav>

    <div class="max-w-3xl mx-auto px-4 sm:px-6 py-8 space-y-5">
      <!-- Filter tabs -->
      <div class="flex gap-2 overflow-x-auto pb-1">
        <button v-for="tab in tabs" :key="tab.key" @click="activeTab = tab.key"
          :class="['px-4 py-2 rounded-xl text-sm font-medium flex-shrink-0 transition-all', activeTab === tab.key ? 'bg-orange-500 text-white shadow-md shadow-orange-500/20' : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700 hover:border-orange-300']">
          {{ tab.label }}
        </button>
      </div>

      <!-- Orders list -->
      <div class="space-y-4">
        <div v-for="order in filteredOrders" :key="order.id"
          class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm hover:shadow-md transition-shadow">
          <!-- Header -->
          <div class="flex items-start justify-between mb-4">
            <div>
              <p class="font-mono font-bold text-sky-600 dark:text-sky-400 text-sm">{{ order.id }}</p>
              <p class="text-xs text-slate-400 mt-0.5">{{ order.date }}</p>
            </div>
            <span :class="['px-2.5 py-1 rounded-full text-xs font-bold', statusClass(order.status)]">{{ order.status }}</span>
          </div>

          <!-- Items preview -->
          <div class="flex items-center gap-3 mb-4">
            <div class="flex flex-shrink-0">
              <span v-for="(emoji, i) in order.emojis" :key="i" :style="{ marginLeft: i > 0 ? '-8px' : '0' }" class="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-xl border-2 border-white dark:border-slate-900">{{ emoji }}</span>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-slate-800 dark:text-white truncate">{{ order.summary }}</p>
              <p class="text-xs text-slate-400">{{ order.itemCount }} items · {{ order.type }}</p>
            </div>
            <p class="font-extrabold text-orange-500 text-lg flex-shrink-0">${{ order.total }}</p>
          </div>

          <!-- Actions -->
          <div class="flex gap-2 flex-wrap">
            <RouterLink v-if="['Pending','Confirmed','Preparing','Out for Delivery'].includes(order.status)" :to="`/orders/${order.id}/track`"
              class="flex items-center gap-1.5 px-4 py-2 bg-orange-500 hover:bg-orange-400 text-white text-sm font-semibold rounded-xl transition-all shadow-md shadow-orange-500/20 active:scale-95">
              <Truck class="w-4 h-4" /> Track Order
            </RouterLink>
            <button @click="reorder(order)"
              class="flex items-center gap-1.5 px-4 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 text-sm font-semibold rounded-xl transition-colors">
              <RefreshCw class="w-4 h-4" /> Reorder
            </button>
            <button v-if="order.status === 'Delivered'" @click="openReview(order)"
              class="flex items-center gap-1.5 px-4 py-2 bg-amber-50 dark:bg-amber-900/20 hover:bg-amber-100 text-amber-600 dark:text-amber-400 text-sm font-semibold rounded-xl transition-colors border border-amber-200 dark:border-amber-800">
              <Star class="w-4 h-4" /> Review
            </button>
          </div>
        </div>

        <div v-if="filteredOrders.length === 0" class="text-center py-24">
          <div class="text-7xl mb-4">📦</div>
          <h3 class="text-xl font-bold text-slate-700 dark:text-slate-300 mb-2">No orders yet</h3>
          <p class="text-slate-400 mb-6">{{ activeTab === 'all' ? "You haven't placed any orders." : `No ${activeTab} orders.` }}</p>
          <RouterLink to="/menu" class="px-6 py-3 bg-orange-500 text-white font-bold rounded-2xl hover:bg-orange-400 transition-all shadow-lg">Browse Menu</RouterLink>
        </div>
      </div>
    </div>

    <!-- Review Modal -->
    <Teleport to="body">
      <div v-if="reviewOrder" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="reviewOrder = null">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-md p-6">
          <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-1">Rate Your Order</h3>
          <p class="text-sm text-slate-400 mb-4">{{ reviewOrder.id }}</p>
          <div class="flex gap-2 mb-5 justify-center">
            <button v-for="n in 5" :key="n" @click="rating = n" :class="['text-3xl transition-transform hover:scale-110', n <= rating ? 'text-amber-400' : 'text-slate-300 dark:text-slate-600']">★</button>
          </div>
          <textarea v-model="reviewText" rows="3" placeholder="Share your experience..."
            class="w-full px-4 py-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 resize-none mb-4"></textarea>
          <div class="flex gap-3">
            <button @click="reviewOrder = null" class="flex-1 py-2.5 border border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300 text-sm font-semibold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Cancel</button>
            <button @click="submitReview" class="flex-1 py-2.5 bg-orange-500 hover:bg-orange-400 text-white text-sm font-bold rounded-xl transition-all shadow-lg active:scale-95">Submit Review</button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Truck, RefreshCw, Star } from 'lucide-vue-next'

const activeTab = ref('all')
const reviewOrder = ref(null)
const rating = ref(0)
const reviewText = ref('')

const tabs = [
  { key: 'all', label: '📦 All Orders' },
  { key: 'active', label: '🔄 Active' },
  { key: 'Delivered', label: '✅ Delivered' },
  { key: 'Cancelled', label: '❌ Cancelled' },
]

const orders = ref([
  { id: '#13042599', date: 'Apr 13, 2026 · 2:00 PM', status: 'Out for Delivery', type: 'Delivery', summary: 'Chicken Burger, Margherita Pizza, Smoothie', emojis: ['🍔', '🍕', '🥤'], itemCount: 5, total: '52.46' },
  { id: '#13042450', date: 'Apr 11, 2026 · 7:30 PM', status: 'Delivered', type: 'Delivery', summary: 'Salmon Sushi Roll, Miso Soup', emojis: ['🍱', '🍲'], itemCount: 2, total: '22.00' },
  { id: '#13042301', date: 'Apr 9, 2026 · 1:15 PM', status: 'Delivered', type: 'Takeaway', summary: 'Pasta Carbonara, Caesar Salad', emojis: ['🍝', '🥗'], itemCount: 2, total: '23.00' },
  { id: '#13042100', date: 'Apr 7, 2026 · 6:45 PM', status: 'Cancelled', type: 'Delivery', summary: 'BBQ Bacon Burger', emojis: ['🍔'], itemCount: 1, total: '13.99' },
  { id: '#13041950', date: 'Apr 5, 2026 · 12:00 PM', status: 'Delivered', type: 'Delivery', summary: 'Family Pizza, Lava Cake, Drinks', emojis: ['🍕', '🍰', '🥤'], itemCount: 6, total: '48.75' },
])

const filteredOrders = computed(() => {
  if (activeTab.value === 'all') return orders.value
  if (activeTab.value === 'active') return orders.value.filter(o => ['Pending','Confirmed','Preparing','Out for Delivery'].includes(o.status))
  return orders.value.filter(o => o.status === activeTab.value)
})

const statusClass = (status) => ({
  'Delivered': 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400',
  'Out for Delivery': 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400',
  'Preparing': 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  'Pending': 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
  'Cancelled': 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
}[status] || 'bg-slate-100 text-slate-700')

const reorder = (order) => { alert(`Reordering: ${order.id}`) }
const openReview = (order) => { reviewOrder.value = order; rating.value = 0; reviewText.value = '' }
const submitReview = () => { reviewOrder.value = null }
</script>
