<script setup>
import { useRoute, useRouter } from 'vue-router'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Button from '@/components/ui/button.vue'
import Badge from '@/components/ui/badge.vue'
import { ChevronLeft, Printer, Download } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const orderId = route.params.id
</script>

<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <button
        @click="router.back()"
        class="flex items-center gap-2 text-sky-600 hover:text-sky-700 font-medium mb-4"
      >
        <ChevronLeft class="h-4 w-4" />
        Back to Orders
      </button>
      <h1 class="text-3xl font-bold tracking-tight">Order #{{ orderId }}</h1>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Order Details -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Customer Info -->
        <Card>
          <CardHeader>
            <CardTitle class="text-start">Customer Information</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="grid grid-cols-2 gap-6">
              <div>
                <p class="text-sm text-slate-600 mb-1">Name</p>
                <p class="font-semibold">John Doe</p>
              </div>
              <div>
                <p class="text-sm text-slate-600 mb-1">Phone</p>
                <p class="font-semibold">+91 98765 43210</p>
              </div>
              <div>
                <p class="text-sm text-slate-600 mb-1">Email</p>
                <p class="font-semibold">john@example.com</p>
              </div>
              <div>
                <p class="text-sm text-slate-600 mb-1">Address</p>
                <p class="font-semibold">123 Main St, City</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <!-- Items -->
        <Card>
          <CardHeader>
            <CardTitle class="text-start">Order Items</CardTitle>
            <CardDescription class="text-start">Items included in this order</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div
                v-for="i in 3"
                :key="i"
                class="flex justify-between items-center py-3 border-b last:border-b-0"
              >
                <div>
                  <p class="font-medium">Item {{ i }}</p>
                  <p class="text-sm text-slate-600">Quantity: {{ i }}</p>
                </div>
                <p class="font-semibold text-red-600">₹{{ i * 100 }}</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <!-- Summary -->
      <div class="space-y-6">
        <Card class="sticky top-6">
          <CardHeader>
            <CardTitle class="text-start">Order Items</CardTitle>
          </CardHeader>
          <CardContent class="space-y-6">
            <!-- Breakdown -->
            <div class="space-y-3 border-b pb-4">
              <div class="flex justify-between">
                <p class="text-slate-600">Subtotal</p>
                <p class="font-medium">₹600</p>
              </div>
              <div class="flex justify-between">
                <p class="text-slate-600">Taxes (5%)</p>
                <p class="font-medium">₹30</p>
              </div>
              <div class="flex justify-between">
                <p class="text-slate-600">Delivery</p>
                <p class="font-medium">₹50</p>
              </div>
              <div class="flex justify-between pt-3 border-t text-lg font-bold">
                <p>Total</p>
                <p class="text-red-600">₹680</p>
              </div>
            </div>

            <!-- Status -->
            <div>
              <p class="text-sm text-slate-600 mb-2">Status</p>
              <Badge class="bg-yellow-100 text-yellow-800">Pending</Badge>
            </div>

            <!-- Actions -->
            <div class="space-y-2 pt-4 border-t">
              <Button class="w-full">Accept Order</Button>
              <Button variant="outline" class="w-full">Reject Order</Button>
              <div class="flex gap-2 pt-2">
                <Button variant="ghost" size="icon" class="flex-1 gap-2">
                  <Printer class="h-4 w-4" />
                </Button>
                <Button variant="ghost" size="icon" class="flex-1 gap-2">
                  <Download class="h-4 w-4" />
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  </div>
</template>
