<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/profile" class="flex items-center gap-2 text-slate-600 dark:text-slate-300 hover:text-orange-500 transition-colors"><ChevronLeft class="w-5 h-5" /> Back</RouterLink>
        <h1 class="font-bold text-slate-900 dark:text-white">Notifications</h1>
        <button @click="markAllRead" class="text-sm text-orange-500 hover:text-orange-400 font-semibold">Mark all read</button>
      </div>
    </nav>

    <div class="max-w-2xl mx-auto px-4 sm:px-6 py-6 space-y-3">
      <!-- Filter tabs -->
      <div class="flex gap-2 overflow-x-auto pb-1">
        <button v-for="tab in tabs" :key="tab.key" @click="activeTab = tab.key"
          :class="['px-4 py-2 rounded-xl text-sm font-medium flex-shrink-0 transition-all', activeTab === tab.key ? 'bg-orange-500 text-white shadow-md shadow-orange-500/20' : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700 hover:border-orange-300']">
          {{ tab.label }}
        </button>
      </div>

      <!-- Notifications -->
      <div v-for="notif in filteredNotifs" :key="notif.id"
        :class="['bg-white dark:bg-slate-900 rounded-2xl border shadow-sm p-4 flex gap-4 transition-all cursor-pointer hover:shadow-md', notif.read ? 'border-slate-200 dark:border-slate-800' : 'border-orange-200 dark:border-orange-800 bg-orange-50/50 dark:bg-orange-950/20']"
        @click="notif.read = true">
        <!-- Icon -->
        <div :class="['w-12 h-12 rounded-2xl flex items-center justify-center flex-shrink-0 text-xl', notif.iconBg]">
          {{ notif.emoji }}
        </div>
        <!-- Content -->
        <div class="flex-1 min-w-0">
          <div class="flex items-start justify-between gap-2">
            <p :class="['text-sm font-semibold', notif.read ? 'text-slate-700 dark:text-slate-300' : 'text-slate-900 dark:text-white']">{{ notif.title }}</p>
            <div class="flex items-center gap-2 flex-shrink-0">
              <span v-if="!notif.read" class="w-2 h-2 rounded-full bg-orange-500 flex-shrink-0 mt-1"></span>
              <span class="text-xs text-slate-400 whitespace-nowrap">{{ notif.time }}</span>
            </div>
          </div>
          <p class="text-sm text-slate-500 dark:text-slate-400 mt-0.5 leading-relaxed">{{ notif.body }}</p>
          <!-- CTA -->
          <button v-if="notif.cta" class="mt-2 text-xs font-bold text-orange-500 hover:text-orange-400 transition-colors">{{ notif.cta }} →</button>
        </div>
      </div>

      <div v-if="filteredNotifs.length === 0" class="text-center py-20">
        <div class="text-6xl mb-4">🔔</div>
        <h3 class="text-lg font-bold text-slate-700 dark:text-slate-300 mb-2">No notifications</h3>
        <p class="text-slate-400 text-sm">You're all caught up!</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ChevronLeft } from 'lucide-vue-next'

const activeTab = ref('all')
const tabs = [
  { key: 'all', label: '🔔 All' },
  { key: 'order', label: '📦 Orders' },
  { key: 'promo', label: '🎁 Offers' },
  { key: 'system', label: '⚙️ System' },
]

const notifs = ref([
  { id: 1, type: 'order', emoji: '🚴', iconBg: 'bg-indigo-100 dark:bg-indigo-900/30', title: 'Order Out for Delivery', body: 'Your order #13042599 is on the way! Alex Martinez is delivering your order.', time: '2 min ago', read: false, cta: 'Track Order' },
  { id: 2, type: 'order', emoji: '✅', iconBg: 'bg-emerald-100 dark:bg-emerald-900/30', title: 'Order Confirmed', body: 'Your order #13042599 has been accepted by the restaurant.', time: '18 min ago', read: false, cta: null },
  { id: 3, type: 'promo', emoji: '🎉', iconBg: 'bg-amber-100 dark:bg-amber-900/30', title: 'Weekend Special!', body: 'Get 15% off all orders this weekend with code WEEKEND15.', time: '1 hour ago', read: true, cta: 'Claim Offer' },
  { id: 4, type: 'order', emoji: '📦', iconBg: 'bg-sky-100 dark:bg-sky-900/30', title: 'Order Delivered', body: 'Your order #13042450 was delivered successfully. Rate your experience!', time: '2 days ago', read: true, cta: 'Leave Review' },
  { id: 5, type: 'promo', emoji: '💰', iconBg: 'bg-violet-100 dark:bg-violet-900/30', title: '$5 Credit Added!', body: 'You earned $5 FoodKing credit from referral. Use it on your next order.', time: '3 days ago', read: true, cta: null },
  { id: 6, type: 'system', emoji: '🔒', iconBg: 'bg-slate-100 dark:bg-slate-800', title: 'Password Changed', body: 'Your account password was changed successfully. If this wasn\'t you, contact support.', time: '1 week ago', read: true, cta: null },
  { id: 7, type: 'promo', emoji: '🍔', iconBg: 'bg-orange-100 dark:bg-orange-900/30', title: 'Burger Bonanza!', body: 'Get $5 off any burger combo this week. Limited time offer!', time: '1 week ago', read: true, cta: 'Order Now' },
])

const filteredNotifs = computed(() => {
  if (activeTab.value === 'all') return notifs.value
  return notifs.value.filter(n => n.type === activeTab.value)
})

const markAllRead = () => { notifs.value.forEach(n => { n.read = true }) }
</script>
