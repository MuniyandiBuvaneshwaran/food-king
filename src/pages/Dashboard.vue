<script setup>
import { onMounted, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Badge from '@/components/ui/badge.vue'
import Button from '@/components/ui/button.vue'
import { ShoppingCart, TrendingUp, Clock, Truck, ArrowRight, BarChart2, PieChart } from 'lucide-vue-next'

const store = useStore()

const stats = computed(() => store.getters['dashboard/dashboardStats'])
const recentOrders = computed(() => store.getters['dashboard/recentOrders'])

onMounted(() => {
  store.dispatch('dashboard/fetchDashboardData')
})

const statCards = [
  {
    label: 'Total Orders',
    value: 'totalOrders',
    icon: ShoppingCart,
    color: 'from-sky-400 to-sky-600',
    bgColor: 'bg-sky-50',
    textColor: 'text-sky-600',
    description: 'All time orders',
  },
  {
    label: 'Total Revenue',
    value: 'totalRevenue',
    icon: TrendingUp,
    color: 'from-green-400 to-green-600',
    bgColor: 'bg-green-50',
    textColor: 'text-green-600',
    description: 'Total sales amount',
  },
  {
    label: 'Pending Orders',
    value: 'pendingOrders',
    icon: Clock,
    color: 'from-blue-400 to-blue-600',
    bgColor: 'bg-blue-50',
    textColor: 'text-blue-600',
    description: 'Awaiting delivery',
  },
  {
    label: 'Active Deliveries',
    value: 'activeDeliveryBoys',
    icon: Truck,
    color: 'from-purple-400 to-purple-600',
    bgColor: 'bg-purple-50',
    textColor: 'text-purple-600',
    description: 'Currently delivering',
  },
]

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    minimumFractionDigits: 0,
  }).format(value)
}

const getStatusVariant = (status) => {
  const variants = {
    pending: 'secondary',
    confirmed: 'default',
    delivered: 'outline',
    cancelled: 'destructive',
  }
  return variants[status?.toLowerCase()] || 'secondary'
}
</script>

<template>
  <div class="space-y-8">

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
      <div
        v-for="(card, index) in statCards"
        :key="index"
        class="group relative overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm hover:shadow-lg transition-all duration-300"
      >
        <!-- Gradient Background -->
        <div
          :class="[
            'absolute inset-0 opacity-0 group-hover:opacity-5 transition-opacity duration-300',
            `bg-gradient-to-br ${card.color}`,
          ]"
        ></div>

        <div class="relative p-6">
          <!-- Icon -->
          <div
            :class="[
              'w-12 h-12 rounded-lg mb-4 flex items-center justify-center',
              card.bgColor,
            ]"
          >
            <component :is="card.icon" :class="['w-6 h-6', card.textColor]" />
          </div>

          <!-- Content -->
          <div>
            <p class="text-sm font-medium text-slate-600 mb-1">{{ card.label }}</p>
            <p class="text-3xl font-bold text-slate-900 mb-2">
              {{ card.value === 'totalRevenue' ? formatCurrency(stats[card.value] || 0) : stats[card.value] || 0 }}
            </p>
            <p :class="['text-xs font-medium', card.textColor]">
              {{ card.description }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts Section -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <Card class="border-slate-200">
        <CardHeader>
          <div class="flex items-center gap-2">
            <BarChart2 class="w-5 h-5 text-sky-600" />
            <div>
              <CardTitle class="text-start">Sales Trend</CardTitle>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div class="h-80 bg-gradient-to-br from-slate-50 to-slate-100 rounded-lg flex items-center justify-center border border-slate-200">
            <div class="text-center">
              <BarChart2 class="w-16 h-16 text-slate-300 mx-auto mb-3" />
              <p class="text-slate-500 font-medium">Sales Chart</p>
              <p class="text-sm text-slate-400">Visualization coming soon</p>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card class="border-slate-200">
        <CardHeader>
          <div class="flex items-center gap-2">
            <PieChart class="w-5 h-5 text-sky-600" />
            <div>
              <CardTitle class="text-start">Order Distribution</CardTitle>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div class="h-80 bg-gradient-to-br from-slate-50 to-slate-100 rounded-lg flex items-center justify-center border border-slate-200">
            <div class="text-center">
              <PieChart class="w-16 h-16 text-slate-300 mx-auto mb-3" />
              <p class="text-slate-500 font-medium">Distribution Chart</p>
              <p class="text-sm text-slate-400">Visualization coming soon</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- Recent Orders -->
    <Card class="border-slate-200">
      <CardHeader class="flex flex-row items-center justify-between pb-4">
        <div>
          <CardTitle class="flex items-start gap-2 text-start my-3">
            <ShoppingCart class="w-5 h-5 text-sky-600" />
            Recent Orders
          </CardTitle>
        </div>
        <Button variant="outline" size="sm" class="gap-2">
          View All
          <ArrowRight class="h-4 w-4" />
        </Button>
      </CardHeader>
      <CardContent>
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead>
              <tr class="border-b bg-slate-50">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">Order ID</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">Customer</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">Amount</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">Status</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">Date</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="recentOrders.length === 0" class="border-b">
                <td colspan="5" class="text-center py-8 text-slate-500">
                  No recent orders
                </td>
              </tr>
              <tr v-for="order in recentOrders" :key="order.id" class="border-b hover:bg-slate-50 transition-colors">
                <td class="py-3 px-4 font-medium text-slate-900">#{{ order.id }}</td>
                <td class="py-3 px-4 text-slate-600">{{ order.customerName }}</td>
                <td class="py-3 px-4 font-medium text-slate-900">{{ formatCurrency(order.amount) }}</td>
                <td class="py-3 px-4">
                  <Badge :variant="getStatusVariant(order.status)">
                    {{ order.status }}
                  </Badge>
                </td>
                <td class="py-3 px-4 text-slate-600">{{ new Date(order.date).toLocaleDateString() }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  </div>
</template>
