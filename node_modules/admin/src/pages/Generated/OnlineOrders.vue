<template>
  <div class="space-y-5">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Online Orders</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Manage delivery and takeaway orders</p>
      </div>
      <div class="flex items-center gap-3">
        <span class="text-sm text-slate-400">{{ orders.length }} orders found</span>
      </div>
    </div>

    <!-- Filters Bar -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm flex flex-col sm:flex-row gap-3">
      <!-- Search -->
      <div class="relative flex-1">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
        <input v-model="search" type="text" placeholder="Search by order ID, customer..."
          class="w-full pl-9 pr-4 py-2 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
      </div>
      <!-- Status filter -->
      <select v-model="statusFilter" class="py-2 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
        <option value="">All Statuses</option>
        <option v-for="s in statuses" :key="s" :value="s">{{ s }}</option>
      </select>
      <!-- Type filter -->
      <select v-model="typeFilter" class="py-2 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
        <option value="">All Types</option>
        <option value="Delivery">Delivery</option>
        <option value="Takeaway">Takeaway</option>
      </select>
    </div>

    <!-- Status Tabs -->
    <div class="flex gap-2 flex-wrap">
      <button v-for="tab in statusTabs" :key="tab.key"
        @click="statusFilter = tab.key"
        :class="['px-4 py-1.5 rounded-full text-sm font-medium transition-all', statusFilter === tab.key ? 'bg-sky-500 text-white shadow-md shadow-sky-500/20' : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700 hover:border-sky-300']">
        {{ tab.label }}
        <span :class="['ml-1.5 text-xs px-1.5 py-0.5 rounded-full', statusFilter === tab.key ? 'bg-white/20 text-white' : 'bg-slate-100 dark:bg-slate-700 text-slate-500']">{{ tab.count }}</span>
      </button>
    </div>

    <!-- Orders Table -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-slate-50 dark:bg-slate-700/50 border-b border-slate-200 dark:border-slate-700">
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Order ID</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Customer</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Type</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Items</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Total</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Payment</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Status</th>
              <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Date</th>
              <th class="text-center px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in filteredOrders" :key="order.id"
              class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors">
              <td class="px-5 py-3.5 font-mono text-sky-600 dark:text-sky-400 font-semibold text-sm">{{ order.id }}</td>
              <td class="px-5 py-3.5">
                <div class="flex items-center gap-2.5">
                  <div :class="`w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-bold bg-gradient-to-br ${order.avatarGrad}`">{{ order.customer[0] }}</div>
                  <div>
                    <p class="font-medium text-slate-800 dark:text-white text-sm">{{ order.customer }}</p>
                    <p class="text-slate-400 text-xs">{{ order.phone }}</p>
                  </div>
                </div>
              </td>
              <td class="px-5 py-3.5">
                <span :class="['inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-medium', order.type === 'Delivery' ? 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400' : 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400']">
                  <Truck v-if="order.type === 'Delivery'" class="w-3 h-3" />
                  <ShoppingBag v-else class="w-3 h-3" />
                  {{ order.type }}
                </span>
              </td>
              <td class="px-5 py-3.5 text-slate-600 dark:text-slate-300">{{ order.items }} items</td>
              <td class="px-5 py-3.5 font-semibold text-slate-800 dark:text-white">${{ order.total }}</td>
              <td class="px-5 py-3.5">
                <span :class="['inline-flex px-2.5 py-1 rounded-full text-xs font-medium', order.paid ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400' : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400']">
                  {{ order.paid ? 'Paid' : 'Unpaid' }}
                </span>
              </td>
              <td class="px-5 py-3.5">
                <span :class="['inline-flex px-2.5 py-1 rounded-full text-xs font-semibold', statusClass(order.status)]">{{ order.status }}</span>
              </td>
              <td class="px-5 py-3.5 text-slate-500 dark:text-slate-400 text-xs">{{ order.date }}</td>
              <td class="px-5 py-3.5">
                <div class="flex items-center justify-center gap-1.5">
                  <button @click="openDetail(order)" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-sky-100 dark:hover:bg-sky-900/30 hover:text-sky-600 transition-colors" title="View">
                    <Eye class="w-4 h-4" />
                  </button>
                  <button class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-amber-100 dark:hover:bg-amber-900/30 hover:text-amber-600 transition-colors" title="Change Status">
                    <RefreshCw class="w-4 h-4" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-if="filteredOrders.length === 0" class="text-center py-16 text-slate-500 dark:text-slate-400">
          <ShoppingBag class="w-10 h-10 mx-auto mb-3 opacity-30" />
          <p class="font-medium">No orders found</p>
          <p class="text-sm mt-1">Try adjusting your search or filters</p>
        </div>
      </div>

      <!-- Pagination -->
      <div class="flex items-center justify-between px-5 py-4 border-t border-slate-100 dark:border-slate-700">
        <p class="text-sm text-slate-500 dark:text-slate-400">Showing <span class="font-semibold text-slate-700 dark:text-slate-200">{{ filteredOrders.length }}</span> of <span class="font-semibold text-slate-700 dark:text-slate-200">{{ orders.length }}</span> orders</p>
        <div class="flex items-center gap-1">
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors" disabled>&laquo;</button>
          <button class="px-3 py-1.5 rounded-lg text-sm bg-sky-500 text-white font-medium shadow-sm">1</button>
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">2</button>
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">3</button>
          <button class="px-3 py-1.5 rounded-lg text-sm text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">&raquo;</button>
        </div>
      </div>
    </div>

    <!-- Order Detail Modal -->
    <Teleport to="body">
      <div v-if="selectedOrder" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="selectedOrder = null">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
          <!-- Modal Header -->
          <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
            <div>
              <h3 class="text-lg font-bold text-slate-900 dark:text-white">Order {{ selectedOrder.id }}</h3>
              <p class="text-sm text-slate-500 dark:text-slate-400">{{ selectedOrder.date }}</p>
            </div>
            <button @click="selectedOrder = null" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
              <X class="w-5 h-5 text-slate-500" />
            </button>
          </div>

          <div class="p-6 space-y-5">
            <!-- Customer Info -->
            <div class="grid grid-cols-2 gap-4">
              <div class="bg-slate-50 dark:bg-slate-700/50 rounded-xl p-4">
                <p class="text-xs text-slate-500 dark:text-slate-400 uppercase font-medium mb-1">Customer</p>
                <p class="font-semibold text-slate-800 dark:text-white">{{ selectedOrder.customer }}</p>
                <p class="text-sm text-slate-500">{{ selectedOrder.phone }}</p>
              </div>
              <div class="bg-slate-50 dark:bg-slate-700/50 rounded-xl p-4">
                <p class="text-xs text-slate-500 dark:text-slate-400 uppercase font-medium mb-1">Order Info</p>
                <p class="font-semibold text-slate-800 dark:text-white">{{ selectedOrder.type }}</p>
                <p class="text-sm text-slate-500">{{ selectedOrder.items }} items</p>
              </div>
            </div>

            <!-- Status + Total -->
            <div class="flex items-center justify-between p-4 bg-slate-50 dark:bg-slate-700/50 rounded-xl">
              <div>
                <p class="text-xs text-slate-500 uppercase font-medium mb-1">Status</p>
                <span :class="['inline-flex px-3 py-1 rounded-full text-sm font-semibold', statusClass(selectedOrder.status)]">{{ selectedOrder.status }}</span>
              </div>
              <div class="text-right">
                <p class="text-xs text-slate-500 uppercase font-medium mb-1">Total</p>
                <p class="text-2xl font-extrabold text-slate-900 dark:text-white">${{ selectedOrder.total }}</p>
              </div>
            </div>

            <!-- Change Status -->
            <div>
              <p class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Change Status</p>
              <div class="flex flex-wrap gap-2">
                <button v-for="s in statuses" :key="s"
                  @click="selectedOrder.status = s"
                  :class="['px-3 py-1.5 rounded-full text-xs font-medium border transition-all', selectedOrder.status === s ? 'bg-sky-500 text-white border-sky-500' : 'border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:border-sky-300']">
                  {{ s }}
                </button>
              </div>
            </div>

            <!-- Assign Delivery Boy -->
            <div v-if="selectedOrder.type === 'Delivery'">
              <p class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Assign Delivery Boy</p>
              <select class="w-full py-2.5 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                <option value="">Select delivery boy...</option>
                <option v-for="boy in deliveryBoys" :key="boy">{{ boy }}</option>
              </select>
            </div>

            <!-- Action buttons -->
            <div class="flex gap-3">
              <button @click="selectedOrder = null" class="flex-1 py-2.5 rounded-xl border border-slate-200 dark:border-slate-600 text-sm font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Cancel</button>
              <button class="flex-1 py-2.5 rounded-xl bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold transition-colors shadow-lg shadow-sky-500/20">Save Changes</button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Eye, RefreshCw, Truck, ShoppingBag, X } from 'lucide-vue-next'

const search = ref('')
const statusFilter = ref('')
const typeFilter = ref('')
const selectedOrder = ref(null)

const statuses = ['Pending', 'Confirmed', 'Preparing', 'Prepared', 'Out for Delivery', 'Delivered', 'Cancelled']
const deliveryBoys = ['Alex Martinez', 'Ryan Thompson', 'James Wilson', 'Carlos Rodriguez', 'David Kim']

const statusTabs = [
  { key: '', label: 'All', count: 15 },
  { key: 'Pending', label: 'Pending', count: 4 },
  { key: 'Preparing', label: 'Preparing', count: 3 },
  { key: 'Out for Delivery', label: 'Out for Delivery', count: 2 },
  { key: 'Delivered', label: 'Delivered', count: 5 },
  { key: 'Cancelled', label: 'Cancelled', count: 1 },
]

const orders = ref([
  { id: '#13042501', customer: 'Sarah Johnson', phone: '+1 555-1234', type: 'Delivery', items: 3, total: '42.50', paid: true, status: 'Delivered', date: 'Apr 13, 2:15 PM', avatarGrad: 'from-pink-400 to-rose-500' },
  { id: '#13042502', customer: 'Mike Williams', phone: '+1 555-2345', type: 'Takeaway', items: 5, total: '87.00', paid: true, status: 'Preparing', date: 'Apr 13, 2:05 PM', avatarGrad: 'from-sky-400 to-blue-500' },
  { id: '#13042503', customer: 'Emily Chen', phone: '+1 555-3456', type: 'Delivery', items: 2, total: '28.75', paid: false, status: 'Pending', date: 'Apr 13, 1:58 PM', avatarGrad: 'from-violet-400 to-purple-500' },
  { id: '#13042504', customer: 'James Brown', phone: '+1 555-4567', type: 'Delivery', items: 4, total: '61.20', paid: true, status: 'Out for Delivery', date: 'Apr 13, 1:45 PM', avatarGrad: 'from-amber-400 to-orange-500' },
  { id: '#13042505', customer: 'Lisa Davis', phone: '+1 555-5678', type: 'Takeaway', items: 7, total: '112.00', paid: true, status: 'Delivered', date: 'Apr 13, 1:30 PM', avatarGrad: 'from-emerald-400 to-teal-500' },
  { id: '#13042506', customer: 'Tom Wilson', phone: '+1 555-6789', type: 'Delivery', items: 1, total: '18.50', paid: false, status: 'Cancelled', date: 'Apr 13, 1:20 PM', avatarGrad: 'from-red-400 to-rose-600' },
  { id: '#13042507', customer: 'Anna Garcia', phone: '+1 555-7890', type: 'Delivery', items: 3, total: '55.00', paid: true, status: 'Confirmed', date: 'Apr 13, 1:10 PM', avatarGrad: 'from-indigo-400 to-violet-500' },
  { id: '#13042508', customer: 'Chris Lee', phone: '+1 555-8901', type: 'Takeaway', items: 2, total: '33.25', paid: true, status: 'Pending', date: 'Apr 13, 1:00 PM', avatarGrad: 'from-teal-400 to-cyan-500' },
])

const filteredOrders = computed(() => {
  return orders.value.filter(o => {
    const matchSearch = !search.value || o.id.toLowerCase().includes(search.value.toLowerCase()) || o.customer.toLowerCase().includes(search.value.toLowerCase())
    const matchStatus = !statusFilter.value || o.status === statusFilter.value
    const matchType = !typeFilter.value || o.type === typeFilter.value
    return matchSearch && matchStatus && matchType
  })
})

const statusClass = (status) => ({
  'Delivered': 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400',
  'Preparing': 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  'Pending': 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
  'Out for Delivery': 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400',
  'Confirmed': 'bg-cyan-100 text-cyan-700 dark:bg-cyan-900/30 dark:text-cyan-400',
  'Cancelled': 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
}[status] || 'bg-slate-100 text-slate-700')

const openDetail = (order) => { selectedOrder.value = { ...order } }
</script>
