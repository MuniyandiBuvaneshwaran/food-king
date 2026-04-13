<template>
  <div class="min-h-screen bg-white dark:bg-slate-950">
    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center shadow-md"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <div class="flex items-center gap-3">
          <RouterLink to="/cart" class="relative p-2 rounded-xl bg-orange-50 dark:bg-orange-900/20 text-orange-500"><ShoppingCart class="w-5 h-5" /><span v-if="cartCount" class="absolute -top-1 -right-1 w-4 h-4 bg-orange-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center">{{ cartCount }}</span></RouterLink>
          <RouterLink to="/login" class="px-4 py-2 bg-orange-500 hover:bg-orange-400 text-white text-sm font-semibold rounded-xl transition-all shadow-md">Sign In</RouterLink>
        </div>
      </div>
    </nav>

    <div class="max-w-4xl mx-auto px-4 py-8" v-if="item">
      <!-- Breadcrumb -->
      <div class="flex items-center gap-2 text-sm text-slate-400 mb-6">
        <RouterLink to="/" class="hover:text-orange-500 transition-colors">Home</RouterLink>
        <ChevronRight class="w-4 h-4" />
        <RouterLink to="/menu" class="hover:text-orange-500 transition-colors">Menu</RouterLink>
        <ChevronRight class="w-4 h-4" />
        <span class="text-slate-700 dark:text-slate-300">{{ item.name }}</span>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 items-start">
        <!-- Item image -->
        <div class="relative">
          <div class="h-80 lg:h-96 bg-gradient-to-br from-orange-50 to-rose-100 dark:from-slate-800 dark:to-slate-700 rounded-3xl flex items-center justify-center overflow-hidden shadow-xl">
            <span class="text-[9rem]">{{ item.emoji }}</span>
          </div>
          <div v-if="item.tag" :class="['absolute top-4 left-4 text-xs font-bold px-3 py-1.5 rounded-full shadow-md', item.tagClass]">{{ item.tag }}</div>
        </div>

        <!-- Info panel -->
        <div class="space-y-5">
          <div>
            <div class="flex items-center gap-2 mb-2">
              <span class="text-xs font-semibold bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 px-3 py-1 rounded-full">{{ item.category }}</span>
            </div>
            <h1 class="text-3xl font-extrabold text-slate-900 dark:text-white mb-2">{{ item.name }}</h1>
            <p class="text-slate-500 dark:text-slate-400 leading-relaxed">{{ item.description }}</p>
          </div>

          <!-- Stats -->
          <div class="flex gap-5">
            <div class="flex items-center gap-1.5 text-amber-500">
              <Star class="w-5 h-5 fill-current" />
              <span class="font-bold text-slate-800 dark:text-white">{{ item.rating }}</span>
              <span class="text-slate-400 text-sm">({{ item.reviews }} reviews)</span>
            </div>
            <div class="flex items-center gap-1.5 text-slate-500">
              <Clock class="w-5 h-5" />
              <span class="text-sm">{{ item.prepTime }}</span>
            </div>
          </div>

          <!-- Price -->
          <div class="flex items-baseline gap-3">
            <span v-if="item.discountPrice" class="text-slate-400 line-through text-lg">${{ item.price }}</span>
            <span class="text-4xl font-extrabold text-orange-500">${{ item.discountPrice || item.price }}</span>
          </div>

          <!-- Addons Section -->
          <div v-if="item.addons && item.addons.length > 0" class="space-y-4">
            <div v-for="group in item.addons" :key="group.title" class="bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-4">
              <div class="flex items-center justify-between mb-3">
                <h3 class="font-semibold text-slate-800 dark:text-white">{{ group.title }}</h3>
                <span :class="['text-xs font-medium px-2 py-0.5 rounded-full', group.required ? 'bg-red-100 text-red-600 dark:bg-red-900/30 dark:text-red-400' : 'bg-slate-200 dark:bg-slate-700 text-slate-500 dark:text-slate-400']">
                  {{ group.required ? 'Required' : 'Optional' }}
                </span>
              </div>
              <div class="space-y-2">
                <label v-for="opt in group.options" :key="opt.name"
                  class="flex items-center justify-between p-3 rounded-xl border border-slate-200 dark:border-slate-700 hover:border-orange-300 dark:hover:border-orange-700 cursor-pointer transition-all"
                  :class="{ 'border-orange-400 bg-orange-50 dark:bg-orange-900/20': selectedAddons[group.title] === opt.name }">
                  <div class="flex items-center gap-3">
                    <input :type="group.required ? 'radio' : 'checkbox'" :name="group.title" :value="opt.name" v-model="selectedAddons[group.title]"
                      class="w-4 h-4 accent-orange-500" />
                    <span class="text-sm font-medium text-slate-700 dark:text-slate-300">{{ opt.name }}</span>
                  </div>
                  <span class="text-sm font-semibold text-orange-500" v-if="opt.extra">+${{ opt.extra }}</span>
                </label>
              </div>
            </div>
          </div>

          <!-- Quantity controller -->
          <div class="flex items-center gap-4">
            <div class="flex items-center gap-3 bg-slate-100 dark:bg-slate-800 rounded-2xl p-1">
              <button @click="qty = Math.max(1, qty - 1)" class="w-10 h-10 rounded-xl bg-white dark:bg-slate-700 shadow-sm font-bold text-slate-700 dark:text-white text-xl hover:bg-orange-50 dark:hover:bg-orange-900/20 hover:text-orange-500 transition-all flex items-center justify-center">−</button>
              <span class="w-8 text-center font-extrabold text-slate-900 dark:text-white text-lg">{{ qty }}</span>
              <button @click="qty++" class="w-10 h-10 rounded-xl bg-white dark:bg-slate-700 shadow-sm font-bold text-slate-700 dark:text-white text-xl hover:bg-orange-50 dark:hover:bg-orange-900/20 hover:text-orange-500 transition-all flex items-center justify-center">+</button>
            </div>
            <div class="flex-1">
              <button @click="addToCart" class="w-full flex items-center justify-center gap-2 py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-2xl transition-all shadow-xl shadow-orange-500/20 hover:shadow-orange-500/40 active:scale-95">
                <ShoppingCart class="w-5 h-5" /> Add {{ qty }} to Cart — ${{ totalPrice }}
              </button>
            </div>
          </div>

          <!-- Note input -->
          <div>
            <label class="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">Special Instructions (optional)</label>
            <textarea v-model="note" rows="2" placeholder="e.g., no onions, extra sauce..."
              class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 resize-none"></textarea>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <Teleport to="body">
      <transition name="slide-up">
        <div v-if="showToast" class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-slate-900 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-semibold flex items-center gap-3 min-w-64">
          <CheckCircle class="w-5 h-5 text-emerald-400" /> Added to cart!
          <RouterLink to="/cart" class="text-orange-400 font-bold hover:underline ml-2">View Cart →</RouterLink>
        </div>
      </transition>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { ShoppingCart, Star, Clock, ChevronRight, CheckCircle } from 'lucide-vue-next'

const route = useRoute()
const qty = ref(1)
const note = ref('')
const cartCount = ref(2)
const showToast = ref(false)
const selectedAddons = ref({})

// Mock item data (in real app, fetched by route.params.id)
const item = ref({
  id: 1,
  name: 'Chicken Burger',
  category: 'Burgers',
  price: '12.99',
  discountPrice: null,
  description: 'Juicy grilled chicken breast patty seasoned with herbs, served on a toasted brioche bun with crisp lettuce, ripe tomato, pickles, and our house secret sauce. A crowd favorite!',
  emoji: '🍔',
  rating: '4.9',
  reviews: 284,
  prepTime: '15–20 min',
  tag: '🔥 Bestseller',
  tagClass: 'bg-red-500 text-white',
  addons: [
    { title: 'Size', required: true, options: [{ name: 'Regular' }, { name: 'Large', extra: '2.00' }, { name: 'XL', extra: '4.00' }] },
    { title: 'Extras', required: false, options: [{ name: 'Extra Cheese', extra: '1.50' }, { name: 'Bacon', extra: '2.00' }, { name: 'Avocado', extra: '1.50' }] },
  ]
})

const addonTotal = computed(() => {
  return Object.values(selectedAddons.value).reduce((total, addonName) => {
    for (const group of item.value.addons || []) {
      const opt = group.options.find(o => o.name === addonName)
      if (opt?.extra) return total + parseFloat(opt.extra)
    }
    return total
  }, 0)
})

const totalPrice = computed(() => {
  const base = parseFloat(item.value.discountPrice || item.value.price)
  return ((base + addonTotal.value) * qty.value).toFixed(2)
})

const addToCart = () => {
  cartCount.value += qty.value
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 2500)
}
</script>

<style scoped>
.slide-up-enter-active, .slide-up-leave-active { transition: all 0.3s ease; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateX(-50%) translateY(20px); }
</style>
