<script setup>
import { onMounted, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'
import Badge from '@/components/ui/badge.vue'
import { Plus, Filter } from 'lucide-vue-next'

const store = useStore()
const orders = computed(() => store.getters['orders/allOrders'])

onMounted(() => {
  store.dispatch('orders/fetchOrders')
})

const getStatusVariant = (status) => {
  const variants = {
    pending: 'secondary',
    preparing: 'default',
    ready: 'outline',
    delivered: 'outline',
  }
  return variants[status?.toLowerCase()] || 'secondary'
}

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    minimumFractionDigits: 0,
  }).format(value)
}
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-start">
      <Button class="gap-2">
        <Plus class="h-4 w-4" />
        New Order
      </Button>
    </div>

    <!-- Filters Card -->
    <Card>
      <CardHeader>
        <CardTitle class="text-base flex items-center gap-2 text-start">
          <Filter class="h-4 w-4" />
          Filter Orders
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label class="block text-sm font-medium mb-2">Status</label>
            <select class="w-full px-3 py-2 border border-slate-200 rounded-md focus:outline-none focus:ring-2 focus:ring-slate-950">
              <option>All Status</option>
              <option>Pending</option>
              <option>Preparing</option>
              <option>Ready</option>
              <option>Delivered</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Date Range</label>
            <Input type="date" />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2">Branch</label>
            <select class="w-full px-3 py-2 border border-slate-200 rounded-md focus:outline-none focus:ring-2 focus:ring-slate-950">
              <option>All Branches</option>
              <option>Main Branch</option>
              <option>Downtown</option>
            </select>
          </div>
        </div>
      </CardContent>
    </Card>

    <!-- Orders Table -->
    <Card>
      <CardHeader>
        <CardTitle>Recent Orders</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="overflow-x-auto my-2">
          <table class="w-full text-sm">
            <thead>
              <tr class="border-b">
                <th class="text-left py-3 px-4 font-semibold">Order ID</th>
                <th class="text-left py-3 px-4 font-semibold">Customer</th>
                <th class="text-left py-3 px-4 font-semibold">Amount</th>
                <th class="text-left py-3 px-4 font-semibold">Status</th>
                <th class="text-left py-3 px-4 font-semibold">Date</th>
                <th class="text-left py-3 px-4 font-semibold">Action</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="orders.length === 0" class="border-b">
                <td colspan="6" class="text-center py-8 text-slate-600">
                  No orders found
                </td>
              </tr>
              <tr v-for="order in orders" :key="order.id" class="border-b hover:bg-slate-50 transition">
                <td class="py-3 px-4 font-medium">#{{ order.id }}</td>
                <td class="py-3 px-4">Customer {{ order.customerId }}</td>
                <td class="py-3 px-4 font-medium">{{ formatCurrency(order.total) }}</td>
                <td class="py-3 px-4">
                  <Badge :variant="getStatusVariant(order.status)">
                    {{ order.status }}
                  </Badge>
                </td>
                <td class="py-3 px-4 text-slate-600">
                  {{ new Date(order.createdAt).toLocaleDateString() }}
                </td>
                <td class="py-3 px-4">
                  <RouterLink
                    :to="`/orders/${order.id}`"
                    class="text-sky-600 hover:underline font-medium"
                  >
                    View
                  </RouterLink>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  </div>
</template>
