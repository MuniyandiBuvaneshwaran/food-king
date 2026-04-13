<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Dashboard</h1>
        <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Welcome back, {{ user.name }}! Here's what's happening today.</p>
      </div>
      <div class="flex items-center gap-3">
        <span class="text-sm text-slate-500 dark:text-slate-400">{{ today }}</span>
        <button class="flex items-center gap-2 bg-sky-500 hover:bg-sky-400 text-white text-sm font-medium px-4 py-2.5 rounded-xl transition-all shadow-lg shadow-sky-500/20">
          <RefreshCw class="w-4 h-4" /> Refresh
        </button>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5">
      <div v-for="stat in stats" :key="stat.label"
        class="group relative bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-5 shadow-sm hover:shadow-lg transition-all duration-300 overflow-hidden">
        <!-- Color accent bar -->
        <div class="absolute inset-x-0 top-0 h-1 rounded-t-2xl" :class="stat.accent"></div>

        <div class="flex items-start justify-between">
          <div>
            <p class="text-sm text-slate-500 dark:text-slate-400 font-medium">{{ stat.label }}</p>
            <p class="text-3xl font-extrabold text-slate-900 dark:text-white mt-2">{{ stat.value }}</p>
            <div class="flex items-center gap-1.5 mt-2">
              <span :class="['text-xs font-semibold px-2 py-0.5 rounded-full', stat.trend > 0 ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400']">
                {{ stat.trend > 0 ? '+' : '' }}{{ stat.trend }}%
              </span>
              <span class="text-xs text-slate-400">vs last month</span>
            </div>
          </div>
          <div :class="['w-12 h-12 rounded-2xl flex items-center justify-center shadow-sm', stat.iconBg]">
            <component :is="stat.icon" class="w-6 h-6" :class="stat.iconColor" />
          </div>
        </div>
      </div>
    </div>

    <!-- Mid Row: Chart + Today's Orders -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-5">
      <!-- Revenue Chart placeholder -->
      <div class="xl:col-span-2 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
        <div class="flex items-center justify-between mb-6">
          <div>
            <h2 class="text-base font-semibold text-slate-900 dark:text-white">Revenue Overview</h2>
            <p class="text-sm text-slate-500 dark:text-slate-400">Last 7 days performance</p>
          </div>
          <select class="text-sm bg-slate-100 dark:bg-slate-700 border-none text-slate-600 dark:text-slate-300 rounded-lg px-3 py-1.5 focus:ring-2 focus:ring-sky-500/30">
            <option>Last 7 days</option>
            <option>Last 30 days</option>
            <option>Last 90 days</option>
          </select>
        </div>

        <!-- SVG chart: simple bar chart -->
        <div class="h-56 flex items-end gap-2 px-2">
          <div v-for="(bar, i) in chartData" :key="i" class="flex-1 flex flex-col items-center gap-1">
            <span class="text-[11px] text-slate-400">{{ bar.value }}</span>
            <div
              class="w-full rounded-t-lg transition-all duration-500 group relative cursor-pointer"
              :class="i === 5 ? 'bg-sky-500 shadow-lg shadow-sky-500/30' : 'bg-slate-200 dark:bg-slate-700 hover:bg-sky-300 dark:hover:bg-sky-600'"
              :style="{ height: bar.height + 'px' }"
            >
              <div class="absolute -top-7 left-1/2 -translate-x-1/2 bg-slate-800 text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap">
                ${{ bar.value }}
              </div>
            </div>
            <span class="text-[10px] text-slate-400">{{ bar.day }}</span>
          </div>
        </div>
      </div>

      <!-- Order Status Ring -->
      <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
        <h2 class="text-base font-semibold text-slate-900 dark:text-white mb-1">Orders by Status</h2>
        <p class="text-sm text-slate-500 dark:text-slate-400 mb-6">Today's breakdown</p>

        <div class="flex flex-col items-center">
          <!-- Donut ring (SVG) -->
          <svg viewBox="0 0 100 100" class="w-40 h-40 -rotate-90">
            <circle cx="50" cy="50" r="35" fill="none" stroke="#e2e8f0" stroke-width="12"/>
            <circle v-for="(seg, i) in donutSegments" :key="i"
              cx="50" cy="50" r="35" fill="none"
              :stroke="seg.color" stroke-width="12"
              stroke-dasharray="220"
              :stroke-dashoffset="seg.offset"
              class="transition-all duration-700"
            />
          </svg>
          <!-- Legend -->
          <div class="w-full space-y-2.5 mt-4">
            <div v-for="s in orderStatus" :key="s.label" class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <span class="w-3 h-3 rounded-full" :style="{ backgroundColor: s.color }"></span>
                <span class="text-sm text-slate-600 dark:text-slate-400">{{ s.label }}</span>
              </div>
              <span class="text-sm font-semibold text-slate-800 dark:text-white">{{ s.value }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bottom Row: Recent Orders + Top Items -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-5">
      <!-- Recent Orders Table -->
      <div class="xl:col-span-2 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
        <div class="flex items-center justify-between px-6 py-4 border-b border-slate-100 dark:border-slate-700">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white">Recent Orders</h2>
          <RouterLink to="/admin/online-orders" class="text-sm text-sky-500 hover:text-sky-400 font-medium transition-colors">View all →</RouterLink>
        </div>
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead>
              <tr class="bg-slate-50 dark:bg-slate-700/50">
                <th class="text-left px-6 py-3 font-medium text-slate-500 dark:text-slate-400 uppercase text-xs tracking-wider">Order</th>
                <th class="text-left px-6 py-3 font-medium text-slate-500 dark:text-slate-400 uppercase text-xs tracking-wider">Customer</th>
                <th class="text-left px-6 py-3 font-medium text-slate-500 dark:text-slate-400 uppercase text-xs tracking-wider">Items</th>
                <th class="text-left px-6 py-3 font-medium text-slate-500 dark:text-slate-400 uppercase text-xs tracking-wider">Total</th>
                <th class="text-left px-6 py-3 font-medium text-slate-500 dark:text-slate-400 uppercase text-xs tracking-wider">Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in recentOrders" :key="order.id"
                class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors cursor-pointer">
                <td class="px-6 py-3.5 font-mono text-sky-600 dark:text-sky-400 font-semibold">{{ order.id }}</td>
                <td class="px-6 py-3.5">
                  <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-400 to-purple-500 flex items-center justify-center text-white text-xs font-bold">{{ order.customer[0] }}</div>
                    <div>
                      <p class="font-medium text-slate-800 dark:text-white text-sm">{{ order.customer }}</p>
                      <p class="text-slate-400 text-xs">{{ order.type }}</p>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-3.5 text-slate-600 dark:text-slate-300">{{ order.items }} items</td>
                <td class="px-6 py-3.5 font-semibold text-slate-800 dark:text-white">${{ order.total }}</td>
                <td class="px-6 py-3.5">
                  <span :class="['inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold', statusClass(order.status)]">
                    {{ order.status }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Top Items -->
      <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
        <h2 class="text-base font-semibold text-slate-900 dark:text-white mb-1">Top Items</h2>
        <p class="text-sm text-slate-500 dark:text-slate-400 mb-5">Best selling this week</p>
        <div class="space-y-4">
          <div v-for="(item, i) in topItems" :key="item.name" class="flex items-center gap-3">
            <span class="text-sm font-mono font-bold text-slate-400 w-5">{{ i + 1 }}</span>
            <div class="w-10 h-10 rounded-xl flex items-center justify-center text-xl">{{ item.emoji }}</div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-slate-800 dark:text-white truncate">{{ item.name }}</p>
              <div class="flex items-center gap-2 mt-1">
                <div class="flex-1 h-1.5 bg-slate-100 dark:bg-slate-700 rounded-full overflow-hidden">
                  <div class="h-1.5 bg-sky-500 rounded-full" :style="{ width: item.pct + '%' }"></div>
                </div>
                <span class="text-xs text-slate-400">{{ item.sold }}</span>
              </div>
            </div>
            <p class="text-sm font-semibold text-slate-800 dark:text-white">${{ item.revenue }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { ShoppingBag, Users, DollarSign, TrendingUp, RefreshCw } from 'lucide-vue-next'

const today = computed(() => new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }))
const user = ref({ name: 'Admin User' })

const stats = [
  { label: "Today's Orders", value: '1,284', trend: 12.5, icon: ShoppingBag, accent: 'bg-sky-500', iconBg: 'bg-sky-100 dark:bg-sky-900/30', iconColor: 'text-sky-600 dark:text-sky-400' },
  { label: 'Revenue', value: '$48,295', trend: 8.2, icon: DollarSign, accent: 'bg-emerald-500', iconBg: 'bg-emerald-100 dark:bg-emerald-900/30', iconColor: 'text-emerald-600 dark:text-emerald-400' },
  { label: 'New Customers', value: '326', trend: -2.1, icon: Users, accent: 'bg-indigo-500', iconBg: 'bg-indigo-100 dark:bg-indigo-900/30', iconColor: 'text-indigo-600 dark:text-indigo-400' },
  { label: 'Avg Order Value', value: '$37.60', trend: 4.8, icon: TrendingUp, accent: 'bg-amber-500', iconBg: 'bg-amber-100 dark:bg-amber-900/30', iconColor: 'text-amber-600 dark:text-amber-400' },
]

const chartData = [
  { day: 'Mon', value: '3.2k', height: 90 },
  { day: 'Tue', value: '4.8k', height: 125 },
  { day: 'Wed', value: '3.9k', height: 105 },
  { day: 'Thu', value: '6.1k', height: 160 },
  { day: 'Fri', value: '5.4k', height: 140 },
  { day: 'Sat', value: '7.8k', height: 195 },
  { day: 'Sun', value: '5.2k', height: 135 },
]

const orderStatus = [
  { label: 'Delivered', value: 648, color: '#10b981' },
  { label: 'Preparing', value: 201, color: '#f59e0b' },
  { label: 'Pending', value: 145, color: '#3b82f6' },
  { label: 'Cancelled', value: 52, color: '#ef4444' },
]
const totalOrders = orderStatus.reduce((a, b) => a + b.value, 0)
const donutSegments = orderStatus.reduce((acc, s, i) => {
  const circ = 220
  const offset = i === 0 ? 0 : acc[i - 1]._nextOffset
  const dash = (s.value / totalOrders) * circ
  acc.push({ color: s.color, offset: circ - dash + offset, _nextOffset: offset + dash })
  return acc
}, [])

const recentOrders = [
  { id: '#13042501', customer: 'Sarah Johnson', type: 'Delivery', items: 3, total: '42.50', status: 'Delivered' },
  { id: '#13042502', customer: 'Mike Williams', type: 'POS', items: 5, total: '87.00', status: 'Preparing' },
  { id: '#13042503', customer: 'Emily Chen', type: 'Takeaway', items: 2, total: '28.75', status: 'Pending' },
  { id: '#13042504', customer: 'James Brown', type: 'Delivery', items: 4, total: '61.20', status: 'Out for Delivery' },
  { id: '#13042505', customer: 'Lisa Davis', type: 'Table', items: 7, total: '112.00', status: 'Delivered' },
]

const topItems = [
  { name: 'Chicken Burger', emoji: '🍔', sold: 284, revenue: '2,840', pct: 100 },
  { name: 'Margherita Pizza', emoji: '🍕', sold: 241, revenue: '2,169', pct: 85 },
  { name: 'Grilled Salmon', emoji: '🐟', sold: 198, revenue: '3,564', pct: 70 },
  { name: 'Caesar Salad', emoji: '🥗', sold: 176, revenue: '1,408', pct: 62 },
  { name: 'Chocolate Lava Cake', emoji: '🍰', sold: 143, revenue: '860', pct: 50 },
]

const statusClass = (status) => ({
  'Delivered': 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400',
  'Preparing': 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  'Pending': 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
  'Out for Delivery': 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400',
  'Cancelled': 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
}[status] || 'bg-slate-100 text-slate-700')
</script>
