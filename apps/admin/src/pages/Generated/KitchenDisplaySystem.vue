  <div class="h-screen bg-slate-50 dark:bg-slate-900 p-8 overflow-y-auto">
    <div class="space-y-5">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Kitchen Display System</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Real-time order queue for kitchen staff</p>
      </div>
      <div class="flex items-center gap-3">
        <div class="flex items-center gap-2 bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-400 px-4 py-2 rounded-xl text-sm font-medium">
          <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          Live — {{ liveTime }}
        </div>
        <button @click="autoRefresh = !autoRefresh" :class="['px-4 py-2 rounded-xl text-sm font-medium border transition-all', autoRefresh ? 'bg-sky-500 text-white border-sky-500 shadow-lg shadow-sky-500/20' : 'border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300']">
          <RefreshCw :class="['w-4 h-4 inline mr-1.5', autoRefresh ? 'animate-spin' : '']" />
          Auto Refresh
        </button>
      </div>
    </div>

    <!-- Columns: 4 statuses side by side -->
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
      <div v-for="col in columns" :key="col.status" class="space-y-3">
        <!-- Column Header -->
        <div :class="['flex items-center justify-between px-4 py-3 rounded-2xl border', col.headerClass]">
          <div class="flex items-center gap-2">
            <component :is="col.icon" class="w-4 h-4" />
            <span class="font-semibold text-sm">{{ col.status }}</span>
          </div>
          <span class="w-6 h-6 rounded-full bg-current/20 flex items-center justify-center text-xs font-bold">
            {{ ordersFor(col.status).length }}
          </span>
        </div>

        <!-- Order Cards -->
        <div v-for="order in ordersFor(col.status)" :key="order.id"
          :class="['bg-white dark:bg-slate-800 rounded-2xl border shadow-sm p-4 space-y-3 hover:shadow-md transition-shadow', order.urgent ? 'border-red-300 dark:border-red-700' : 'border-slate-200 dark:border-slate-700']">
          <!-- Card Header -->
          <div class="flex items-start justify-between">
            <div>
              <div class="flex items-center gap-2">
                <span class="font-mono text-sm font-bold text-sky-600 dark:text-sky-400">{{ order.id }}</span>
                <span v-if="order.urgent" class="bg-red-100 text-red-600 text-xs font-bold px-2 py-0.5 rounded-full animate-pulse">URGENT</span>
              </div>
              <p class="text-xs text-slate-400 mt-0.5">{{ order.type }}</p>
            </div>
            <!-- Timer -->
            <div :class="['text-right']">
              <p :class="['text-sm font-bold font-mono', order.elapsed > 15 ? 'text-red-500' : order.elapsed > 8 ? 'text-amber-500' : 'text-emerald-600']">
                {{ order.elapsed }}m
              </p>
              <p class="text-xs text-slate-400">elapsed</p>
            </div>
          </div>

          <!-- Items list -->
          <div class="space-y-1.5">
            <div v-for="item in order.items" :key="item.name" class="flex items-center gap-2">
              <span class="w-6 h-6 bg-sky-100 dark:bg-sky-900/30 text-sky-700 dark:text-sky-400 rounded-lg text-xs font-bold flex items-center justify-center">{{ item.qty }}</span>
              <span class="text-sm text-slate-700 dark:text-slate-300 flex-1">{{ item.name }}</span>
              <span v-if="item.note" class="text-xs text-amber-600 bg-amber-50 dark:bg-amber-900/20 px-1.5 py-0.5 rounded">{{ item.note }}</span>
            </div>
          </div>

          <!-- Customer Note -->
          <div v-if="order.note" class="bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-xl px-3 py-2">
            <p class="text-xs text-amber-700 dark:text-amber-400"><span class="font-bold">Note:</span> {{ order.note }}</p>
          </div>

          <!-- Table/Type info -->
          <div class="flex items-center justify-between pt-1 border-t border-slate-100 dark:border-slate-700">
            <span class="text-xs text-slate-400">{{ order.time }}</span>
            <div class="flex gap-2">
              <!-- Advance to next status -->
              <button @click="advanceOrder(order)" :class="['text-xs font-semibold px-3 py-1.5 rounded-lg transition-all shadow-sm', col.btnClass]">
                {{ col.btnLabel }}
              </button>
            </div>
          </div>
        </div>

        <!-- Empty state -->
        <div v-if="ordersFor(col.status).length === 0" class="text-center py-10 border-2 border-dashed border-slate-200 dark:border-slate-700 rounded-2xl">
          <p class="text-slate-400 text-sm">No orders</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { Clock, ChefHat, CheckCircle, RefreshCw, Flame } from 'lucide-vue-next'

const autoRefresh = ref(true)
const liveTime = ref('')
let interval = null

const updateTime = () => {
  liveTime.value = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
}
onMounted(() => { updateTime(); interval = setInterval(updateTime, 1000) })
onUnmounted(() => clearInterval(interval))

const statusOrder = ['Pending', 'Confirmed', 'Preparing', 'Prepared']
const columns = [
  { status: 'Pending', icon: Clock, headerClass: 'bg-blue-50 dark:bg-blue-900/20 border-blue-200 dark:border-blue-800 text-blue-700 dark:text-blue-400', btnClass: 'bg-blue-500 text-white hover:bg-blue-400', btnLabel: 'Confirm' },
  { status: 'Confirmed', icon: CheckCircle, headerClass: 'bg-cyan-50 dark:bg-cyan-900/20 border-cyan-200 dark:border-cyan-800 text-cyan-700 dark:text-cyan-400', btnClass: 'bg-cyan-500 text-white hover:bg-cyan-400', btnLabel: 'Start Prep' },
  { status: 'Preparing', icon: Flame, headerClass: 'bg-amber-50 dark:bg-amber-900/20 border-amber-200 dark:border-amber-800 text-amber-700 dark:text-amber-400', btnClass: 'bg-amber-500 text-white hover:bg-amber-400', btnLabel: 'Mark Ready' },
  { status: 'Prepared', icon: ChefHat, headerClass: 'bg-emerald-50 dark:bg-emerald-900/20 border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-400', btnClass: 'bg-emerald-500 text-white hover:bg-emerald-400', btnLabel: 'Deliver' },
]

const orders = ref([
  { id: '#5301', type: 'Delivery', status: 'Pending', elapsed: 2, urgent: false, time: '2:43 PM', note: '', items: [{ name: 'Chicken Burger', qty: 2 }, { name: 'Fries (L)', qty: 2 }] },
  { id: '#5302', type: 'Table 7', status: 'Pending', elapsed: 5, urgent: false, time: '2:40 PM', note: 'No onions please', items: [{ name: 'Margherita Pizza', qty: 1 }, { name: 'Caesar Salad', qty: 1, note: '!no dressing' }] },
  { id: '#5303', type: 'Takeaway', status: 'Confirmed', elapsed: 8, urgent: false, time: '2:37 PM', note: '', items: [{ name: 'Salmon Sushi Roll', qty: 3 }, { name: 'Miso Soup', qty: 1 }] },
  { id: '#5298', type: 'Delivery', status: 'Preparing', elapsed: 14, urgent: false, time: '2:31 PM', note: 'Extra spicy!', items: [{ name: 'BBQ Bacon Burger', qty: 1 }, { name: 'Milkshake', qty: 1 }] },
  { id: '#5295', type: 'POS', status: 'Preparing', elapsed: 19, urgent: true, time: '2:26 PM', note: '', items: [{ name: 'Pasta Carbonara', qty: 2 }, { name: 'Garlic Bread', qty: 2 }, { name: 'Tiramisu', qty: 1 }] },
  { id: '#5290', type: 'Table 3', status: 'Prepared', elapsed: 22, urgent: false, time: '2:23 PM', note: '', items: [{ name: 'Grilled Salmon', qty: 1 }, { name: 'Pilaf Rice', qty: 1 }] },
  { id: '#5288', type: 'Delivery', status: 'Prepared', elapsed: 25, urgent: true, time: '2:20 PM', note: '', items: [{ name: 'Family Pizza', qty: 1 }, { name: 'Soft Drinks', qty: 4 }] },
])

const ordersFor = (status) => orders.value.filter(o => o.status === status)
const advanceOrder = (order) => {
  const idx = statusOrder.indexOf(order.status)
  if (idx < statusOrder.length - 1) order.status = statusOrder[idx + 1]
}
</script>
