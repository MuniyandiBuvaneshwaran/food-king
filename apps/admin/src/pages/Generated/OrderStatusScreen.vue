<template>
  <!-- Full-screen public display -->
  <div class="h-screen bg-slate-900 text-white flex flex-col font-sans">
    <!-- Header bar -->
    <div class="flex items-center justify-between bg-gradient-to-r from-sky-600 to-indigo-600 px-8 py-4 shadow-xl">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-white/20 flex items-center justify-center">
          <Monitor class="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 class="font-extrabold text-xl tracking-tight">FoodKing</h1>
          <p class="text-sky-200 text-xs">Order Status Board</p>
        </div>
      </div>
      <div class="text-right">
        <p class="text-2xl font-mono font-bold text-white">{{ currentTime }}</p>
        <p class="text-sky-200 text-xs">{{ currentDate }}</p>
      </div>
    </div>

    <!-- Status legend -->
    <div class="flex items-center justify-center gap-6 py-4 bg-slate-800/50 border-b border-white/5 flex-wrap">
      <div v-for="s in legend" :key="s.label" class="flex items-center gap-2">
        <span class="w-3 h-3 rounded-full" :style="{ backgroundColor: s.color }"></span>
        <span class="text-sm text-slate-300">{{ s.label }}</span>
      </div>
    </div>

    <!-- Order columns -->
    <div class="flex-1 grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-0 divide-x divide-white/10">
      <div v-for="col in columns" :key="col.label" class="flex flex-col">
        <!-- Column Header -->
        <div :class="['px-6 py-4 text-center border-b border-white/10 flex items-center justify-center gap-3', col.headerBg]">
          <component :is="col.icon" class="w-5 h-5" />
          <span class="font-bold text-lg tracking-wide">{{ col.label }}</span>
          <span class="bg-white/20 text-white text-sm font-bold w-7 h-7 rounded-full flex items-center justify-center">
            {{ ossOrdersFor(col.status).length }}
          </span>
        </div>
        <!-- Orders -->
        <div class="flex-1 p-4 space-y-3 overflow-y-auto">
          <TransitionGroup name="slide" tag="div" class="space-y-3">
            <div v-for="order in ossOrdersFor(col.status)" :key="order.id"
              :class="['rounded-2xl border p-4 transition-all', col.cardClass]">
              <div class="flex items-center justify-between mb-2">
                <span class="font-mono text-xl font-extrabold tracking-widest">{{ order.id }}</span>
                <span :class="['text-xs font-semibold px-2.5 py-1 rounded-full', col.badgeClass]">{{ col.label }}</span>
              </div>
              <p class="text-sm opacity-75">{{ order.type }}</p>
              <div v-if="col.status === 'Prepared'" class="mt-2">
                <span class="text-xs bg-emerald-400/20 text-emerald-300 px-2 py-1 rounded-full animate-pulse">Ready for pickup!</span>
              </div>
            </div>
          </TransitionGroup>
          <div v-if="ossOrdersFor(col.status).length === 0" class="flex flex-col items-center justify-center py-12 opacity-30">
            <component :is="col.icon" class="w-10 h-10 mb-2" />
            <p class="text-sm">No orders here</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Ticker strip -->
    <div class="bg-sky-600/80 py-2 overflow-hidden border-t border-white/10">
      <div class="ticker-track flex gap-16 items-center">
        <span v-for="t in tickerItems" :key="t" class="text-sm text-white/90 font-medium whitespace-nowrap">
          🍔 {{ t }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Monitor, Clock, ChefHat, CheckCircle, Truck } from 'lucide-vue-next'

const currentTime = ref('')
const currentDate = ref('')
let timer = null

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
  currentDate.value = now.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })
}
onMounted(() => { updateTime(); timer = setInterval(updateTime, 1000) })
onUnmounted(() => clearInterval(timer))

const legend = [
  { label: 'Preparing', color: '#f59e0b' },
  { label: 'Prepared / Ready', color: '#10b981' },
  { label: 'Delivery', color: '#6366f1' },
  { label: 'Delivered', color: '#3b82f6' },
]

const columns = [
  { label: 'Preparing', status: 'Preparing', icon: ChefHat, headerBg: 'bg-amber-600/30 text-amber-300', cardClass: 'bg-amber-900/20 border-amber-700/30', badgeClass: 'bg-amber-500/20 text-amber-300' },
  { label: 'Ready', status: 'Prepared', icon: CheckCircle, headerBg: 'bg-emerald-600/30 text-emerald-300', cardClass: 'bg-emerald-900/20 border-emerald-700/30', badgeClass: 'bg-emerald-500/20 text-emerald-300' },
  { label: 'Out for Delivery', status: 'Out for Delivery', icon: Truck, headerBg: 'bg-indigo-600/30 text-indigo-300', cardClass: 'bg-indigo-900/20 border-indigo-700/30', badgeClass: 'bg-indigo-500/20 text-indigo-300' },
  { label: 'Delivered', status: 'Delivered', icon: Clock, headerBg: 'bg-blue-600/30 text-blue-300', cardClass: 'bg-blue-900/20 border-blue-700/30', badgeClass: 'bg-blue-500/20 text-blue-300' },
]

const orders = ref([
  { id: '#5302', type: 'Table 7', status: 'Preparing' },
  { id: '#5303', type: 'Takeaway', status: 'Preparing' },
  { id: '#5304', type: 'Delivery', status: 'Preparing' },
  { id: '#5290', type: 'Table 3', status: 'Prepared' },
  { id: '#5288', type: 'Delivery', status: 'Prepared' },
  { id: '#5280', type: 'Delivery', status: 'Out for Delivery' },
  { id: '#5275', type: 'Delivery', status: 'Out for Delivery' },
  { id: '#5260', type: 'Takeaway', status: 'Delivered' },
  { id: '#5258', type: 'Delivery', status: 'Delivered' },
  { id: '#5255', type: 'Table 5', status: 'Delivered' },
])

const ossOrdersFor = (status) => orders.value.filter(o => o.status === status)

const tickerItems = [
  'Chicken Burger', 'Margherita Pizza', 'Salmon Sushi Roll', 'Caesar Salad', 'Pasta Carbonara',
  'BBQ Bacon Burger', 'Mango Smoothie', 'Choc Lava Cake', 'Grilled Salmon', 'Greek Salad',
]
</script>

<style scoped>
.ticker-track {
  animation: ticker 20s linear infinite;
  width: max-content;
}
@keyframes ticker {
  from { transform: translateX(0); }
  to { transform: translateX(-50%); }
}
.slide-enter-active, .slide-leave-active { transition: all 0.4s ease; }
.slide-enter-from { opacity: 0; transform: translateY(-10px); }
.slide-leave-to { opacity: 0; transform: translateY(10px); }
</style>
