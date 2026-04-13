<template>
  <div class="space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Sales Report</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Revenue, orders, and performance analytics</p>
      </div>
      <div class="flex items-center gap-3">
        <button class="flex items-center gap-2 px-4 py-2.5 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
          <Download class="w-4 h-4" /> Export CSV
        </button>
        <button class="flex items-center gap-2 px-4 py-2.5 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
          <Printer class="w-4 h-4" /> Print
        </button>
      </div>
    </div>

    <!-- Date Filter -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm flex flex-col sm:flex-row gap-4 items-end">
      <div class="flex-1">
        <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">From Date</label>
        <input v-model="dateFrom" type="date" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
      </div>
      <div class="flex-1">
        <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">To Date</label>
        <input v-model="dateTo" type="date" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
      </div>
      <div>
        <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">Branch</label>
        <select v-model="branch" class="px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
          <option value="">All Branches</option>
          <option>Main Branch</option>
          <option>Downtown Branch</option>
          <option>Mall Branch</option>
        </select>
      </div>
      <!-- Quick filters -->
      <div class="flex gap-2 flex-wrap">
        <button v-for="quick in quickFilters" :key="quick.label" @click="setQuickFilter(quick)"
          :class="['px-3 py-2 rounded-xl text-xs font-medium border transition-all', activeQuick === quick.label ? 'bg-sky-500 text-white border-sky-500' : 'border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:border-sky-300']">
          {{ quick.label }}
        </button>
      </div>
    </div>

    <!-- KPI Cards -->
    <div class="grid grid-cols-2 xl:grid-cols-4 gap-4">
      <div v-for="kpi in kpis" :key="kpi.label" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-5 shadow-sm">
        <div class="flex items-start justify-between mb-3">
          <div :class="['w-10 h-10 rounded-xl flex items-center justify-center', kpi.iconBg]">
            <component :is="kpi.icon" :class="['w-5 h-5', kpi.iconColor]" />
          </div>
          <span :class="['text-xs font-bold px-2 py-1 rounded-full', kpi.trend > 0 ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400']">
            {{ kpi.trend > 0 ? '+' : '' }}{{ kpi.trend }}%
          </span>
        </div>
        <p class="text-2xl font-extrabold text-slate-900 dark:text-white">{{ kpi.value }}</p>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">{{ kpi.label }}</p>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-5">
      <!-- Revenue Trend -->
      <div class="xl:col-span-2 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white">Revenue Trend</h2>
          <div class="flex gap-2">
            <button v-for="p in ['Day','Week','Month']" :key="p" @click="period = p"
              :class="['px-3 py-1 rounded-lg text-xs font-medium transition-all', period === p ? 'bg-sky-500 text-white shadow-sm' : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700']">{{ p }}</button>
          </div>
        </div>
        <!-- Bar chart -->
        <div class="h-52 flex items-end gap-1.5 px-2">
          <div v-for="(bar, i) in chartBars" :key="i" class="flex-1 flex flex-col items-center gap-1 group">
            <span class="text-[10px] text-slate-400 opacity-0 group-hover:opacity-100 transition-opacity">{{ bar.label }}</span>
            <div class="w-full rounded-t-lg bg-sky-500/20 hover:bg-sky-500/40 transition-colors relative cursor-pointer"
              :style="{ height: bar.h + 'px' }">
              <div class="absolute inset-x-0 bottom-0 rounded-t-lg bg-sky-500" :style="{ height: bar.filled + 'px' }"></div>
            </div>
            <span class="text-[10px] text-slate-400">{{ bar.day }}</span>
          </div>
        </div>
      </div>

      <!-- Order type breakdown -->
      <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
        <h2 class="text-base font-semibold text-slate-900 dark:text-white mb-5">By Order Type</h2>
        <div class="space-y-4">
          <div v-for="ot in orderTypes" :key="ot.type">
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-sm text-slate-600 dark:text-slate-300">{{ ot.type }}</span>
              <span class="text-sm font-bold text-slate-800 dark:text-white">${{ ot.revenue }}</span>
            </div>
            <div class="h-2.5 bg-slate-100 dark:bg-slate-700 rounded-full overflow-hidden">
              <div :class="['h-full rounded-full transition-all duration-700', ot.color]" :style="{ width: ot.pct + '%' }"></div>
            </div>
            <p class="text-xs text-slate-400 mt-1">{{ ot.pct }}% · {{ ot.orders }} orders</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Sales Table -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
      <div class="px-6 py-4 border-b border-slate-100 dark:border-slate-700 flex items-center justify-between">
        <h2 class="text-base font-semibold text-slate-900 dark:text-white">Daily Breakdown</h2>
        <span class="text-sm text-slate-500 dark:text-slate-400">Last 7 days</span>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-slate-50 dark:bg-slate-700/50">
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Date</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Orders</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Revenue</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Avg Order</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Tax</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Delivery Fees</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Net</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in salesTable" :key="row.date" class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors">
              <td class="px-5 py-3.5 font-medium text-slate-800 dark:text-white">{{ row.date }}</td>
              <td class="px-5 py-3.5 text-slate-700 dark:text-slate-300">{{ row.orders }}</td>
              <td class="px-5 py-3.5 font-semibold text-slate-800 dark:text-white">${{ row.revenue }}</td>
              <td class="px-5 py-3.5 text-slate-700 dark:text-slate-300">${{ row.avg }}</td>
              <td class="px-5 py-3.5 text-slate-500 dark:text-slate-400">${{ row.tax }}</td>
              <td class="px-5 py-3.5 text-slate-500 dark:text-slate-400">${{ row.delivery }}</td>
              <td class="px-5 py-3.5 font-bold text-emerald-600 dark:text-emerald-400">${{ row.net }}</td>
            </tr>
          </tbody>
          <tfoot>
            <tr class="bg-slate-50 dark:bg-slate-700/50 border-t-2 border-slate-300 dark:border-slate-600">
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">Total</td>
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">791</td>
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">$29,742</td>
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">$37.60</td>
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">$2,379</td>
              <td class="px-5 py-3.5 font-bold text-slate-800 dark:text-white">$1,242</td>
              <td class="px-5 py-3.5 font-bold text-emerald-600 dark:text-emerald-400">$26,121</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Download, Printer, ShoppingBag, DollarSign, Users, TrendingUp } from 'lucide-vue-next'

const dateFrom = ref('2026-04-07')
const dateTo = ref('2026-04-13')
const branch = ref('')
const period = ref('Week')
const activeQuick = ref('Last 7 Days')

const quickFilters = [
  { label: 'Today' }, { label: 'Last 7 Days' }, { label: 'This Month' }, { label: 'Last Month' }
]
const setQuickFilter = (q) => { activeQuick.value = q.label }

const kpis = [
  { label: 'Total Revenue', value: '$29,742', trend: 12.5, icon: DollarSign, iconBg: 'bg-emerald-100 dark:bg-emerald-900/30', iconColor: 'text-emerald-600 dark:text-emerald-400' },
  { label: 'Total Orders', value: '791', trend: 8.2, icon: ShoppingBag, iconBg: 'bg-sky-100 dark:bg-sky-900/30', iconColor: 'text-sky-600 dark:text-sky-400' },
  { label: 'New Customers', value: '184', trend: -2.1, icon: Users, iconBg: 'bg-indigo-100 dark:bg-indigo-900/30', iconColor: 'text-indigo-600 dark:text-indigo-400' },
  { label: 'Avg Order Value', value: '$37.60', trend: 4.8, icon: TrendingUp, iconBg: 'bg-amber-100 dark:bg-amber-900/30', iconColor: 'text-amber-600 dark:text-amber-400' },
]

const chartBars = [
  { day: 'Mon', h: 160, filled: 90, label: '$3.2k' },
  { day: 'Tue', h: 160, filled: 125, label: '$4.8k' },
  { day: 'Wed', h: 160, filled: 105, label: '$3.9k' },
  { day: 'Thu', h: 160, filled: 160, label: '$6.1k' },
  { day: 'Fri', h: 160, filled: 140, label: '$5.4k' },
  { day: 'Sat', h: 160, filled: 160, label: '$7.8k' },
  { day: 'Sun', h: 160, filled: 135, label: '$5.2k' },
]

const orderTypes = [
  { type: 'Online Delivery', revenue: '14,250', orders: 324, pct: 85, color: 'bg-sky-500' },
  { type: 'Takeaway', revenue: '8,120', orders: 247, pct: 62, color: 'bg-indigo-500' },
  { type: 'POS', revenue: '5,340', orders: 142, pct: 40, color: 'bg-amber-500' },
  { type: 'Table QR', revenue: '2,032', orders: 78, pct: 22, color: 'bg-emerald-500' },
]

const salesTable = [
  { date: 'Apr 13, 2026', orders: 148, revenue: '5,420', avg: '36.62', tax: '434', delivery: '198', net: '4,788' },
  { date: 'Apr 12, 2026', orders: 132, revenue: '4,890', avg: '37.05', tax: '391', delivery: '172', net: '4,327' },
  { date: 'Apr 11, 2026', orders: 118, revenue: '4,120', avg: '34.92', tax: '330', delivery: '156', net: '3,634' },
  { date: 'Apr 10, 2026', orders: 104, revenue: '3,890', avg: '37.40', tax: '311', delivery: '148', net: '3,431' },
  { date: 'Apr 09, 2026', orders: 98, revenue: '3,560', avg: '36.33', tax: '285', delivery: '132', net: '3,143' },
  { date: 'Apr 08, 2026', orders: 88, revenue: '3,240', avg: '36.82', tax: '259', delivery: '218', net: '2,763' },
  { date: 'Apr 07, 2026', orders: 103, revenue: '4,622', avg: '44.87', tax: '370', delivery: '218', net: '4,034' },
]
</script>
