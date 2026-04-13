<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <span class="text-sm font-semibold text-slate-600 dark:text-slate-300">Track Order</span>
        <a href="tel:+15550100" class="flex items-center gap-1.5 text-sm text-orange-500 hover:text-orange-400 font-semibold"><Phone class="w-4 h-4" /> Call</a>
      </div>
    </nav>

    <div class="max-w-2xl mx-auto px-4 sm:px-6 py-8 space-y-6">
      <!-- Order Header -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 shadow-sm">
        <div class="flex items-start justify-between mb-4">
          <div>
            <p class="text-sm text-slate-400 mb-0.5">Order ID</p>
            <h2 class="text-xl font-extrabold text-slate-900 dark:text-white font-mono">#13042599</h2>
          </div>
          <span :class="['px-3 py-1.5 rounded-full text-sm font-bold', currentStatusClass]">{{ currentStatus }}</span>
        </div>
        <div class="grid grid-cols-3 gap-4 text-center">
          <div class="bg-slate-50 dark:bg-slate-800 rounded-xl p-3">
            <p class="text-xs text-slate-400 mb-1">Type</p>
            <p class="font-semibold text-slate-800 dark:text-white text-sm">Delivery</p>
          </div>
          <div class="bg-slate-50 dark:bg-slate-800 rounded-xl p-3">
            <p class="text-xs text-slate-400 mb-1">Items</p>
            <p class="font-semibold text-slate-800 dark:text-white text-sm">5 items</p>
          </div>
          <div class="bg-slate-50 dark:bg-slate-800 rounded-xl p-3">
            <p class="text-xs text-slate-400 mb-1">Total</p>
            <p class="font-semibold text-orange-500 text-sm">$52.46</p>
          </div>
        </div>
      </div>

      <!-- Live ETA Banner -->
      <div class="bg-gradient-to-r from-orange-500 to-rose-500 rounded-2xl p-5 text-white shadow-lg">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-white/80 text-sm mb-1">Estimated Arrival</p>
            <p class="text-3xl font-extrabold">{{ eta }} min</p>
          </div>
          <div class="text-5xl animate-bounce" style="animation-duration: 2s">{{ etaEmoji }}</div>
        </div>
        <div class="mt-3 h-2 bg-white/20 rounded-full overflow-hidden">
          <div class="h-full bg-white rounded-full transition-all duration-1000" :style="{ width: progress + '%' }"></div>
        </div>
        <p class="text-white/70 text-xs mt-2">{{ progress }}% complete</p>
      </div>

      <!-- Status Timeline -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 shadow-sm">
        <h3 class="font-bold text-slate-900 dark:text-white mb-6">Order Timeline</h3>
        <div class="space-y-0">
          <div v-for="(event, i) in timeline" :key="event.status" class="flex gap-4">
            <!-- Dot + Line -->
            <div class="flex flex-col items-center">
              <div :class="['w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 z-10 transition-all duration-500', event.done ? 'bg-emerald-500 shadow-lg shadow-emerald-500/30' : event.active ? 'bg-orange-500 shadow-lg shadow-orange-500/30 animate-pulse' : 'bg-slate-200 dark:bg-slate-700']">
                <component :is="event.icon" :class="['w-5 h-5', event.done || event.active ? 'text-white' : 'text-slate-400']" />
              </div>
              <div v-if="i < timeline.length - 1" :class="['w-0.5 flex-1 my-1 transition-all duration-700 min-h-8', event.done ? 'bg-emerald-400' : 'bg-slate-200 dark:bg-slate-700']"></div>
            </div>
            <!-- Content -->
            <div class="flex-1 pb-6">
              <div class="flex items-center justify-between">
                <p :class="['font-semibold', event.done || event.active ? 'text-slate-900 dark:text-white' : 'text-slate-400 dark:text-slate-500']">{{ event.status }}</p>
                <span v-if="event.time" class="text-xs text-slate-400">{{ event.time }}</span>
              </div>
              <p class="text-sm text-slate-400 mt-0.5">{{ event.desc }}</p>
              <!-- Delivery boy info when out for delivery -->
              <div v-if="event.status === 'Out for Delivery' && event.active" class="mt-3 flex items-center gap-3 bg-slate-50 dark:bg-slate-800 rounded-xl p-3">
                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-sky-400 to-blue-500 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">AM</div>
                <div class="flex-1">
                  <p class="text-sm font-semibold text-slate-800 dark:text-white">Alex Martinez</p>
                  <p class="text-xs text-slate-400">Your delivery partner</p>
                </div>
                <div class="flex gap-2">
                  <a href="tel:+15551001" class="w-8 h-8 rounded-xl bg-emerald-100 dark:bg-emerald-900/30 flex items-center justify-center hover:bg-emerald-200 transition-colors">
                    <Phone class="w-4 h-4 text-emerald-600" />
                  </a>
                  <button class="w-8 h-8 rounded-xl bg-sky-100 dark:bg-sky-900/30 flex items-center justify-center hover:bg-sky-200 transition-colors">
                    <MessageSquare class="w-4 h-4 text-sky-600" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Delivery Address -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
        <h3 class="font-bold text-slate-900 dark:text-white mb-3">Delivery Address</h3>
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 rounded-xl bg-orange-100 dark:bg-orange-900/30 flex items-center justify-center flex-shrink-0">
            <MapPin class="w-5 h-5 text-orange-500" />
          </div>
          <div>
            <p class="font-semibold text-slate-800 dark:text-white">Home</p>
            <p class="text-sm text-slate-400">123 Main Street, Apt 4B, New York, NY 10001</p>
          </div>
        </div>
      </div>

      <!-- Order Items -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
        <h3 class="font-bold text-slate-900 dark:text-white mb-4">Order Items</h3>
        <div class="space-y-3">
          <div v-for="item in orderItems" :key="item.name" class="flex items-center gap-3">
            <span class="text-xl">{{ item.emoji }}</span>
            <div class="flex-1">
              <p class="text-sm font-medium text-slate-800 dark:text-white">{{ item.name }}</p>
              <p class="text-xs text-slate-400">x{{ item.qty }}</p>
            </div>
            <span class="text-sm font-semibold text-slate-800 dark:text-white">${{ item.total }}</span>
          </div>
        </div>
        <div class="border-t border-slate-200 dark:border-slate-700 mt-4 pt-4 flex justify-between">
          <span class="font-bold text-slate-900 dark:text-white">Total</span>
          <span class="text-lg font-extrabold text-orange-500">$52.46</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Phone, MapPin, MessageSquare, CheckCircle, Clock, ChefHat, Truck, Package } from 'lucide-vue-next'

const currentStatus = ref('Out for Delivery')

const timeline = ref([
  { status: 'Order Placed', desc: 'Your order has been received', time: '2:00 PM', done: true, active: false, icon: CheckCircle },
  { status: 'Confirmed', desc: 'Restaurant accepted your order', time: '2:03 PM', done: true, active: false, icon: CheckCircle },
  { status: 'Preparing', desc: 'Kitchen is preparing your meal', time: '2:07 PM', done: true, active: false, icon: ChefHat },
  { status: 'Prepared', desc: 'Your order is ready for pickup', time: '2:28 PM', done: true, active: false, icon: Package },
  { status: 'Out for Delivery', desc: 'Alex is on the way to your location', time: '2:31 PM', done: false, active: true, icon: Truck },
  { status: 'Delivered', desc: 'Enjoy your meal!', time: '', done: false, active: false, icon: CheckCircle },
])

const currentStatusClass = computed(() => ({
  'Out for Delivery': 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400',
  'Preparing': 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  'Delivered': 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400',
}[currentStatus.value] || 'bg-slate-100 text-slate-700'))

const eta = ref(12)
const progress = ref(80)
const etaEmoji = computed(() => progress.value >= 100 ? '🎉' : progress.value >= 60 ? '🚴' : '👨‍🍳')

let timer = null
onMounted(() => {
  timer = setInterval(() => {
    if (eta.value > 0) eta.value--
    if (progress.value < 100) progress.value += 0.5
  }, 2000)
})
onUnmounted(() => clearInterval(timer))

const orderItems = [
  { name: 'Chicken Burger', emoji: '🍔', qty: 2, total: '25.98' },
  { name: 'Margherita Pizza', emoji: '🍕', qty: 1, total: '11.99' },
  { name: 'Mango Smoothie', emoji: '🥤', qty: 2, total: '11.00' },
]
</script>
