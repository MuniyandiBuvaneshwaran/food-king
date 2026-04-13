<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <div class="flex items-center gap-2 text-sm">
          <span v-for="(step, i) in steps" :key="step" class="flex items-center gap-1">
            <span :class="['w-6 h-6 rounded-full text-xs font-bold flex items-center justify-center flex-shrink-0', currentStep > i ? 'bg-emerald-500 text-white' : currentStep === i ? 'bg-orange-500 text-white' : 'bg-slate-200 dark:bg-slate-700 text-slate-400']">
              <CheckCircle v-if="currentStep > i" class="w-4 h-4" />
              <span v-else>{{ i + 1 }}</span>
            </span>
            <span :class="['hidden sm:block', currentStep === i ? 'text-orange-500 font-semibold' : 'text-slate-400']">{{ step }}</span>
            <ChevronRight v-if="i < steps.length - 1" class="w-4 h-4 text-slate-300 dark:text-slate-600 hidden sm:block" />
          </span>
        </div>
      </div>
    </nav>

    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left: Steps -->
        <div class="lg:col-span-2 space-y-5">

          <!-- Step 1: Delivery Details -->
          <div v-if="currentStep === 0" class="space-y-5">
            <h2 class="text-xl font-bold text-slate-900 dark:text-white">Delivery Details</h2>

            <!-- Order Type -->
            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
              <h3 class="font-semibold text-slate-800 dark:text-white mb-4">Order Type</h3>
              <div class="grid grid-cols-2 gap-3">
                <button v-for="type in orderTypes" :key="type.key" @click="orderType = type.key"
                  :class="['flex items-center gap-3 p-4 rounded-2xl border-2 transition-all text-left', orderType === type.key ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20' : 'border-slate-200 dark:border-slate-700 hover:border-orange-300']">
                  <span class="text-2xl">{{ type.emoji }}</span>
                  <div>
                    <p class="font-semibold text-slate-900 dark:text-white text-sm">{{ type.label }}</p>
                    <p class="text-xs text-slate-400">{{ type.desc }}</p>
                  </div>
                </button>
              </div>
            </div>

            <!-- Delivery Address (only for Delivery) -->
            <div v-if="orderType === 'delivery'" class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
              <div class="flex items-center justify-between mb-4">
                <h3 class="font-semibold text-slate-800 dark:text-white">Delivery Address</h3>
                <button class="text-sm text-orange-500 hover:text-orange-400 font-semibold">+ New Address</button>
              </div>
              <div class="space-y-3">
                <label v-for="addr in addresses" :key="addr.id"
                  :class="['flex items-start gap-3 p-4 rounded-2xl border-2 cursor-pointer transition-all', selectedAddress === addr.id ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20' : 'border-slate-200 dark:border-slate-700 hover:border-orange-300']">
                  <input type="radio" :value="addr.id" v-model="selectedAddress" class="mt-1 accent-orange-500" />
                  <div class="flex-1">
                    <div class="flex items-center gap-2 mb-1">
                      <p class="font-semibold text-slate-900 dark:text-white text-sm">{{ addr.label }}</p>
                      <span v-if="addr.default" class="text-xs bg-emerald-100 dark:bg-emerald-900/30 text-emerald-600 dark:text-emerald-400 px-2 py-0.5 rounded-full">Default</span>
                    </div>
                    <p class="text-sm text-slate-500 dark:text-slate-400">{{ addr.full }}</p>
                  </div>
                  <MapPin class="w-4 h-4 text-slate-400 flex-shrink-0 mt-1" />
                </label>
              </div>
            </div>

            <!-- Schedule -->
            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
              <h3 class="font-semibold text-slate-800 dark:text-white mb-4">Delivery Time</h3>
              <div class="grid grid-cols-2 gap-3 mb-4">
                <button @click="deliveryTime = 'now'" :class="['p-3 rounded-2xl border-2 text-sm font-semibold transition-all', deliveryTime === 'now' ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20 text-orange-600' : 'border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300']">
                  ⚡ ASAP (30 min)
                </button>
                <button @click="deliveryTime = 'schedule'" :class="['p-3 rounded-2xl border-2 text-sm font-semibold transition-all', deliveryTime === 'schedule' ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20 text-orange-600' : 'border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300']">
                  📅 Schedule
                </button>
              </div>
              <div v-if="deliveryTime === 'schedule'" class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-xs font-medium text-slate-500 mb-1.5">Date</label>
                  <input type="date" v-model="scheduleDate" class="w-full px-3 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
                </div>
                <div>
                  <label class="block text-xs font-medium text-slate-500 mb-1.5">Time Slot</label>
                  <select v-model="scheduleSlot" class="w-full px-3 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-orange-400/50">
                    <option>2:00 PM – 2:30 PM</option><option>2:30 PM – 3:00 PM</option><option>3:00 PM – 3:30 PM</option><option>3:30 PM – 4:00 PM</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
              <h3 class="font-semibold text-slate-800 dark:text-white mb-3">Order Notes</h3>
              <textarea v-model="note" rows="2" placeholder="Any special instructions for the restaurant or delivery..."
                class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 resize-none"></textarea>
            </div>

            <button @click="currentStep = 1" class="w-full py-4 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-xl shadow-orange-500/20 active:scale-95">
              Continue to Payment →
            </button>
          </div>

          <!-- Step 2: Payment -->
          <div v-if="currentStep === 1" class="space-y-5">
            <h2 class="text-xl font-bold text-slate-900 dark:text-white">Payment Method</h2>

            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm">
              <div class="space-y-3">
                <label v-for="method in paymentMethods" :key="method.key"
                  :class="['flex items-center gap-4 p-4 rounded-2xl border-2 cursor-pointer transition-all', paymentMethod === method.key ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20' : 'border-slate-200 dark:border-slate-700 hover:border-orange-300']">
                  <input type="radio" :value="method.key" v-model="paymentMethod" class="accent-orange-500" />
                  <span class="text-2xl">{{ method.emoji }}</span>
                  <div class="flex-1">
                    <p class="font-semibold text-slate-900 dark:text-white text-sm">{{ method.label }}</p>
                    <p class="text-xs text-slate-400">{{ method.desc }}</p>
                  </div>
                </label>
              </div>

              <!-- Card fields shown when Card is selected -->
              <div v-if="paymentMethod === 'card'" class="mt-4 space-y-3">
                <div class="grid grid-cols-1 gap-3">
                  <input type="text" placeholder="Card Number" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
                  <div class="grid grid-cols-2 gap-3">
                    <input type="text" placeholder="MM / YY" class="px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
                    <input type="text" placeholder="CVV" class="px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
                  </div>
                </div>
              </div>
            </div>

            <div class="flex gap-3">
              <button @click="currentStep = 0" class="px-6 py-3.5 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-semibold rounded-2xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">← Back</button>
              <button @click="placeOrder" class="flex-1 py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-xl shadow-orange-500/20 active:scale-95 flex items-center justify-center gap-2">
                <Lock class="w-4 h-4" /> Place Order — ${{ total.toFixed(2) }}
              </button>
            </div>
          </div>

          <!-- Step 3: Confirmation -->
          <div v-if="currentStep === 2" class="text-center py-12">
            <div class="w-24 h-24 bg-emerald-100 dark:bg-emerald-900/30 rounded-full flex items-center justify-center mx-auto mb-6">
              <CheckCircle class="w-12 h-12 text-emerald-500" />
            </div>
            <h2 class="text-3xl font-extrabold text-slate-900 dark:text-white mb-2">Order Placed! 🎉</h2>
            <p class="text-slate-500 dark:text-slate-400 mb-1">Your order #13042599 has been confirmed.</p>
            <p class="text-slate-400 text-sm mb-8">Estimated delivery: <span class="font-semibold text-orange-500">30–40 minutes</span></p>
            <div class="flex gap-3 justify-center">
              <RouterLink to="/orders/13042599/track" class="px-6 py-3 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-lg">Track Order →</RouterLink>
              <RouterLink to="/menu" class="px-6 py-3 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-semibold rounded-2xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">Order More</RouterLink>
            </div>
          </div>
        </div>

        <!-- Right: Summary -->
        <div class="lg:col-span-1" v-if="currentStep < 2">
          <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm sticky top-24 space-y-4">
            <h3 class="font-bold text-slate-900 dark:text-white">Order Summary</h3>
            <div v-for="item in cartItems" :key="item.id" class="flex items-center gap-3">
              <span class="text-xl">{{ item.emoji }}</span>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-slate-800 dark:text-white truncate">{{ item.name }}</p>
                <p class="text-xs text-slate-400">x{{ item.qty }}</p>
              </div>
              <span class="text-sm font-bold text-slate-800 dark:text-white">${{ (parseFloat(item.price) * item.qty).toFixed(2) }}</span>
            </div>
            <div class="border-t border-slate-200 dark:border-slate-700 pt-3 space-y-2">
              <div class="flex justify-between text-sm"><span class="text-slate-500 dark:text-slate-400">Subtotal</span><span class="font-medium text-slate-800 dark:text-white">${{ subtotal.toFixed(2) }}</span></div>
              <div class="flex justify-between text-sm"><span class="text-slate-500 dark:text-slate-400">Delivery</span><span class="font-medium text-emerald-600">FREE</span></div>
              <div class="flex justify-between text-sm"><span class="text-slate-500 dark:text-slate-400">Tax (8%)</span><span class="font-medium text-slate-800 dark:text-white">${{ tax.toFixed(2) }}</span></div>
              <div class="flex justify-between pt-1 border-t border-slate-200 dark:border-slate-700">
                <span class="font-bold text-slate-900 dark:text-white">Total</span>
                <span class="text-xl font-extrabold text-orange-500">${{ total.toFixed(2) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { CheckCircle, ChevronRight, MapPin, Lock } from 'lucide-vue-next'

const currentStep = ref(0)
const steps = ['Delivery', 'Payment', 'Confirmation']
const orderType = ref('delivery')
const selectedAddress = ref(1)
const deliveryTime = ref('now')
const scheduleDate = ref('')
const scheduleSlot = ref('2:00 PM – 2:30 PM')
const note = ref('')
const paymentMethod = ref('cash')

const orderTypes = [
  { key: 'delivery', emoji: '🚴', label: 'Home Delivery', desc: 'Delivered to your door' },
  { key: 'takeaway', emoji: '🏃', label: 'Takeaway', desc: 'Pick up at restaurant' },
]

const addresses = [
  { id: 1, label: '🏠 Home', full: '123 Main Street, Apt 4B, New York, NY 10001', default: true },
  { id: 2, label: '🏢 Office', full: '456 Park Avenue, Floor 12, New York, NY 10022', default: false },
]

const paymentMethods = [
  { key: 'cash', emoji: '💵', label: 'Cash on Delivery', desc: 'Pay when you receive your order' },
  { key: 'card', emoji: '💳', label: 'Credit / Debit Card', desc: 'Visa, Mastercard, Amex' },
  { key: 'wallet', emoji: '👛', label: 'FoodKing Wallet', desc: 'Balance: $15.00' },
  { key: 'paypal', emoji: '🅿️', label: 'PayPal', desc: 'Pay securely via PayPal' },
]

const cartItems = ref([
  { id: 1, name: 'Chicken Burger', emoji: '🍔', price: '12.99', qty: 2 },
  { id: 2, name: 'Margherita Pizza', emoji: '🍕', price: '11.99', qty: 1 },
  { id: 3, name: 'Mango Smoothie', emoji: '🥤', price: '5.50', qty: 2 },
])

const subtotal = computed(() => cartItems.value.reduce((a, b) => a + parseFloat(b.price) * b.qty, 0))
const tax = computed(() => subtotal.value * 0.08)
const total = computed(() => subtotal.value + tax.value)

const placeOrder = () => { currentStep.value = 2 }
</script>
