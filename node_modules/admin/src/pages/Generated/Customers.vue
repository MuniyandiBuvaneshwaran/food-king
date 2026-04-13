<template>
  <div class="space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Customers</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Manage all registered customers</p>
      </div>
      <div class="flex items-center gap-3">
        <button class="flex items-center gap-2 px-4 py-2.5 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
          <Download class="w-4 h-4" /> Export
        </button>
      </div>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 xl:grid-cols-4 gap-4">
      <div v-for="s in custStats" :key="s.label" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm">
        <p class="text-sm text-slate-500 dark:text-slate-400">{{ s.label }}</p>
        <p class="text-2xl font-extrabold text-slate-900 dark:text-white mt-1">{{ s.value }}</p>
        <p :class="['text-xs mt-1 font-semibold', s.up ? 'text-emerald-600' : 'text-red-500']">{{ s.change }}</p>
      </div>
    </div>

    <!-- Filters -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm flex flex-col sm:flex-row gap-3">
      <div class="relative flex-1">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
        <input v-model="search" type="text" placeholder="Search customers..." class="w-full pl-9 pr-4 py-2 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
      </div>
      <select v-model="statusFilter" class="py-2 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
        <option value="">All Status</option>
        <option value="active">Active</option>
        <option value="inactive">Inactive</option>
      </select>
    </div>

    <!-- Table -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
      <table class="w-full text-sm">
        <thead>
          <tr class="bg-slate-50 dark:bg-slate-700/50 border-b border-slate-200 dark:border-slate-700">
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Customer</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Contact</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Orders</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Total Spent</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Credit Balance</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Status</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Joined</th>
            <th class="text-center px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="c in filteredCustomers" :key="c.id" class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors">
            <td class="px-5 py-3.5">
              <div class="flex items-center gap-3">
                <div :class="`w-9 h-9 rounded-full flex items-center justify-center text-white text-sm font-bold bg-gradient-to-br ${c.grad}`">{{ c.name[0] }}</div>
                <div>
                  <p class="font-semibold text-slate-800 dark:text-white">{{ c.name }}</p>
                  <p class="text-xs text-slate-400">#CUST{{ String(c.id).padStart(4, '0') }}</p>
                </div>
              </div>
            </td>
            <td class="px-5 py-3.5">
              <p class="text-slate-700 dark:text-slate-300">{{ c.email }}</p>
              <p class="text-xs text-slate-400">{{ c.phone }}</p>
            </td>
            <td class="px-5 py-3.5 font-semibold text-slate-800 dark:text-white">{{ c.orders }}</td>
            <td class="px-5 py-3.5 font-semibold text-slate-800 dark:text-white">${{ c.spent }}</td>
            <td class="px-5 py-3.5">
              <span class="bg-indigo-100 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 text-xs font-semibold px-2.5 py-1 rounded-full">${{ c.credit }}</span>
            </td>
            <td class="px-5 py-3.5">
              <span :class="['inline-flex px-2.5 py-1 rounded-full text-xs font-semibold', c.active ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400']">
                {{ c.active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td class="px-5 py-3.5 text-slate-500 dark:text-slate-400 text-xs">{{ c.joined }}</td>
            <td class="px-5 py-3.5">
              <div class="flex items-center justify-center gap-1.5">
                <button @click="viewCustomer(c)" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-sky-100 dark:hover:bg-sky-900/30 hover:text-sky-600 transition-colors" title="View">
                  <Eye class="w-4 h-4" />
                </button>
                <button class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-red-100 dark:hover:bg-red-900/30 hover:text-red-600 transition-colors" title="Delete">
                  <Trash2 class="w-4 h-4" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <!-- Pagination -->
      <div class="flex items-center justify-between px-5 py-4 border-t border-slate-100 dark:border-slate-700">
        <p class="text-sm text-slate-500 dark:text-slate-400">Showing <span class="font-semibold text-slate-700 dark:text-slate-200">{{ filteredCustomers.length }}</span> customers</p>
        <div class="flex items-center gap-1">
          <button class="px-3 py-1.5 rounded-lg text-sm bg-sky-500 text-white font-medium shadow-sm">1</button>
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">2</button>
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">3</button>
        </div>
      </div>
    </div>

    <!-- Customer Detail Modal -->
    <Teleport to="body">
      <div v-if="selected" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="selected = null">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-lg">
          <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">Customer Profile</h3>
            <button @click="selected = null" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"><X class="w-5 h-5 text-slate-500" /></button>
          </div>
          <div class="p-6 space-y-5">
            <div class="flex items-center gap-4">
              <div :class="`w-16 h-16 rounded-2xl flex items-center justify-center text-white text-2xl font-bold bg-gradient-to-br ${selected.grad}`">{{ selected.name[0] }}</div>
              <div>
                <h4 class="text-xl font-bold text-slate-900 dark:text-white">{{ selected.name }}</h4>
                <p class="text-slate-500 text-sm">{{ selected.email }}</p>
                <p class="text-slate-400 text-sm">{{ selected.phone }}</p>
              </div>
            </div>
            <div class="grid grid-cols-3 gap-4">
              <div class="bg-sky-50 dark:bg-sky-900/20 rounded-xl p-4 text-center">
                <p class="text-2xl font-extrabold text-sky-600 dark:text-sky-400">{{ selected.orders }}</p>
                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Total Orders</p>
              </div>
              <div class="bg-emerald-50 dark:bg-emerald-900/20 rounded-xl p-4 text-center">
                <p class="text-2xl font-extrabold text-emerald-600 dark:text-emerald-400">${{ selected.spent }}</p>
                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Total Spent</p>
              </div>
              <div class="bg-indigo-50 dark:bg-indigo-900/20 rounded-xl p-4 text-center">
                <p class="text-2xl font-extrabold text-indigo-600 dark:text-indigo-400">${{ selected.credit }}</p>
                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Credit Balance</p>
              </div>
            </div>
            <div class="flex items-center justify-between bg-slate-50 dark:bg-slate-700/50 rounded-xl p-4">
              <div>
                <p class="text-sm text-slate-500 dark:text-slate-400">Joined</p>
                <p class="font-semibold text-slate-800 dark:text-white">{{ selected.joined }}</p>
              </div>
              <span :class="['px-3 py-1.5 rounded-full text-sm font-semibold', selected.active ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400']">
                {{ selected.active ? '● Active' : '● Inactive' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Eye, Trash2, Download, X } from 'lucide-vue-next'

const search = ref('')
const statusFilter = ref('')
const selected = ref(null)

const custStats = [
  { label: 'Total Customers', value: '8,421', change: '+12.5% this month', up: true },
  { label: 'Active Today', value: '1,284', change: '+8.2% vs yesterday', up: true },
  { label: 'New This Month', value: '326', change: '-2.1% vs last month', up: false },
  { label: 'Avg Order Value', value: '$37.60', change: '+4.8% this month', up: true },
]

const customers = ref([
  { id: 1, name: 'Sarah Johnson', email: 'sarah@example.com', phone: '+1 555-1234', orders: 24, spent: '842.50', credit: '15.00', active: true, joined: 'Jan 12, 2024', grad: 'from-pink-400 to-rose-500' },
  { id: 2, name: 'Mike Williams', email: 'mike@example.com', phone: '+1 555-2345', orders: 8, spent: '312.00', credit: '0.00', active: true, joined: 'Mar 5, 2024', grad: 'from-sky-400 to-blue-500' },
  { id: 3, name: 'Emily Chen', email: 'emily@example.com', phone: '+1 555-3456', orders: 41, spent: '1,520.75', credit: '50.00', active: true, joined: 'Nov 20, 2023', grad: 'from-violet-400 to-purple-500' },
  { id: 4, name: 'James Brown', email: 'james@example.com', phone: '+1 555-4567', orders: 3, spent: '98.20', credit: '0.00', active: false, joined: 'Apr 1, 2024', grad: 'from-amber-400 to-orange-500' },
  { id: 5, name: 'Lisa Davis', email: 'lisa@example.com', phone: '+1 555-5678', orders: 17, spent: '624.00', credit: '10.00', active: true, joined: 'Feb 8, 2024', grad: 'from-emerald-400 to-teal-500' },
  { id: 6, name: 'Tom Wilson', email: 'tom@example.com', phone: '+1 555-6789', orders: 2, spent: '45.00', credit: '0.00', active: false, joined: 'Apr 10, 2024', grad: 'from-red-400 to-rose-600' },
  { id: 7, name: 'Anna Garcia', email: 'anna@example.com', phone: '+1 555-7890', orders: 31, spent: '1,102.50', credit: '25.00', active: true, joined: 'Dec 15, 2023', grad: 'from-indigo-400 to-violet-500' },
])

const filteredCustomers = computed(() => customers.value.filter(c => {
  const matchSearch = !search.value || c.name.toLowerCase().includes(search.value.toLowerCase()) || c.email.toLowerCase().includes(search.value.toLowerCase())
  const matchStatus = !statusFilter.value || (statusFilter.value === 'active' ? c.active : !c.active)
  return matchSearch && matchStatus
}))

const viewCustomer = (c) => { selected.value = c }
</script>
