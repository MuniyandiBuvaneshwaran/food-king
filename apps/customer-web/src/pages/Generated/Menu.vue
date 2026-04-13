<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <!-- Sticky Navbar -->
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-900/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <RouterLink to="/" class="flex items-center gap-2">
          <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center shadow-md">
            <span class="text-white text-lg">🍔</span>
          </div>
          <span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span>
        </RouterLink>

        <!-- Search bar -->
        <div class="flex-1 max-w-xl mx-8 hidden sm:flex">
          <div class="relative w-full">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input v-model="searchQuery" type="text" placeholder="Search for food..."
              class="w-full pl-9 pr-4 py-2.5 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
          </div>
        </div>

        <div class="flex items-center gap-2">
          <RouterLink to="/cart" class="relative p-2 rounded-xl bg-orange-50 dark:bg-orange-900/20 text-orange-500 hover:bg-orange-100 transition-colors">
            <ShoppingCart class="w-5 h-5" />
            <span v-if="cartCount" class="absolute -top-1 -right-1 w-4 h-4 bg-orange-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center">{{ cartCount }}</span>
          </RouterLink>
        </div>
      </div>
    </nav>

    <!-- Filters Bar -->
    <div class="bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex flex-col sm:flex-row gap-4 items-start sm:items-center">
        <!-- Category pills -->
        <div class="flex gap-2 overflow-x-auto pb-1 flex-1">
          <button v-for="cat in ['All', ...categories]" :key="cat"
            @click="activeCategory = cat"
            :class="['px-4 py-2 rounded-xl text-sm font-medium whitespace-nowrap flex-shrink-0 transition-all',
              activeCategory === cat
                ? 'bg-orange-500 text-white shadow-md shadow-orange-500/20'
                : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-orange-50 dark:hover:bg-orange-900/20 hover:text-orange-600']">
            {{ cat === 'All' ? '🍽️ All' : cat }}
          </button>
        </div>
        <!-- Sort -->
        <select v-model="sortBy" class="py-2 px-3 bg-slate-100 dark:bg-slate-800 border-0 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-orange-400/50 flex-shrink-0">
          <option value="popular">Most Popular</option>
          <option value="price_asc">Price: Low to High</option>
          <option value="price_desc">Price: High to Low</option>
          <option value="rating">Top Rated</option>
        </select>
      </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Results count -->
      <div class="flex items-center justify-between mb-6">
        <p class="text-sm text-slate-500 dark:text-slate-400">
          <span class="font-semibold text-slate-800 dark:text-white">{{ filteredItems.length }}</span> items found
          <span v-if="activeCategory !== 'All'"> in <span class="text-orange-500 font-semibold">{{ activeCategory }}</span></span>
        </p>
      </div>

      <!-- Items Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
        <div v-for="item in filteredItems" :key="item.id"
          class="group bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 overflow-hidden shadow-sm hover:shadow-xl hover:border-orange-200 dark:hover:border-orange-800 transition-all duration-300 hover:-translate-y-1 flex flex-col">
          <!-- Image -->
          <RouterLink :to="`/menu/${item.id}`" class="block">
            <div class="relative h-48 bg-gradient-to-br from-orange-50 to-rose-50 dark:from-slate-800 dark:to-slate-700 flex items-center justify-center overflow-hidden">
              <span class="text-7xl group-hover:scale-110 transition-transform duration-300">{{ item.emoji }}</span>
              <!-- Tags -->
              <div class="absolute top-3 left-3 flex flex-col gap-1.5">
                <span v-if="item.tag" :class="['text-xs font-bold px-2.5 py-1 rounded-full', item.tagClass]">{{ item.tag }}</span>
              </div>
              <div v-if="item.discountPrice" class="absolute top-3 right-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-full">
                {{ Math.round((1 - item.discountPrice / item.price) * 100) }}% OFF
              </div>
            </div>
          </RouterLink>

          <!-- Info -->
          <div class="p-4 flex flex-col flex-1">
            <RouterLink :to="`/menu/${item.id}`">
              <h3 class="font-bold text-slate-900 dark:text-white truncate mb-0.5 hover:text-orange-500 transition-colors">{{ item.name }}</h3>
            </RouterLink>
            <p class="text-xs text-slate-400 mb-2">{{ item.category }}</p>
            <p class="text-sm text-slate-500 dark:text-slate-400 leading-relaxed line-clamp-2 flex-1 mb-3">{{ item.description }}</p>

            <!-- Rating + prep time -->
            <div class="flex items-center gap-3 mb-4">
              <div class="flex items-center gap-1 text-amber-400">
                <Star class="w-3.5 h-3.5 fill-current" />
                <span class="text-xs font-semibold text-slate-700 dark:text-slate-300">{{ item.rating }}</span>
              </div>
              <div class="flex items-center gap-1 text-slate-400">
                <Clock class="w-3.5 h-3.5" />
                <span class="text-xs">{{ item.prepTime }}</span>
              </div>
            </div>

            <div class="flex items-center justify-between">
              <div>
                <span v-if="item.discountPrice" class="text-slate-400 line-through text-xs mr-1">${{ item.price }}</span>
                <span class="text-xl font-extrabold text-orange-500">${{ item.discountPrice || item.price }}</span>
              </div>
              <button @click="addToCart(item)"
                class="flex items-center gap-1.5 px-4 py-2 bg-orange-500 hover:bg-orange-400 text-white text-sm font-semibold rounded-xl transition-all shadow-md shadow-orange-500/20 active:scale-95">
                <Plus class="w-4 h-4" /> Add
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-if="filteredItems.length === 0" class="text-center py-24">
        <div class="text-6xl mb-4">🔍</div>
        <h3 class="text-xl font-bold text-slate-700 dark:text-slate-300 mb-2">No items found</h3>
        <p class="text-slate-400 mb-6">Try a different category or search term</p>
        <button @click="activeCategory = 'All'; searchQuery = ''" class="px-6 py-2.5 bg-orange-500 text-white font-semibold rounded-xl hover:bg-orange-400 transition-colors">Clear Filters</button>
      </div>
    </div>

    <!-- Cart Toast -->
    <Teleport to="body">
      <transition name="slide-up">
        <div v-if="toastItem" class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-slate-900 dark:bg-white text-white dark:text-slate-900 px-5 py-3 rounded-2xl shadow-2xl text-sm font-semibold flex items-center gap-3 min-w-64">
          <span class="text-2xl">{{ toastItem.emoji }}</span>
          <span>{{ toastItem.name }} added to cart!</span>
          <RouterLink to="/cart" class="text-orange-400 dark:text-orange-600 font-bold hover:underline">View</RouterLink>
        </div>
      </transition>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, ShoppingCart, Star, Clock, Plus } from 'lucide-vue-next'

const searchQuery = ref('')
const activeCategory = ref('All')
const sortBy = ref('popular')
const cartCount = ref(0)
const toastItem = ref(null)

const categories = ['Burgers', 'Pizza', 'Sushi', 'Pasta', 'Salads', 'Desserts', 'Drinks']

const allItems = ref([
  { id: 1, name: 'Chicken Burger', category: 'Burgers', price: '12.99', discountPrice: null, description: 'Juicy grilled chicken patty with fresh lettuce, tomato, and our secret sauce', emoji: '🍔', rating: '4.9', prepTime: '15 min', tag: '🔥 Hot', tagClass: 'bg-red-500 text-white', sales: 284 },
  { id: 2, name: 'BBQ Bacon Burger', category: 'Burgers', price: '15.99', discountPrice: '13.99', description: 'Double beef patty with crispy bacon, cheddar, and smoky BBQ sauce', emoji: '🍔', rating: '4.7', prepTime: '18 min', tag: '20% OFF', tagClass: 'bg-emerald-500 text-white', sales: 198 },
  { id: 3, name: 'Margherita Pizza', category: 'Pizza', price: '14.99', discountPrice: '11.99', description: 'Classic Neapolitan-style with San Marzano tomato, fresh mozzarella, and basil', emoji: '🍕', rating: '4.8', prepTime: '20 min', tag: null, tagClass: '', sales: 241 },
  { id: 4, name: 'Pepperoni Pizza', category: 'Pizza', price: '16.99', discountPrice: null, description: 'Loaded with premium pepperoni, mozzarella on a crispy thin crust', emoji: '🍕', rating: '4.6', prepTime: '22 min', tag: '⭐ Popular', tagClass: 'bg-amber-400 text-amber-900', sales: 210 },
  { id: 5, name: 'Salmon Sushi Roll', category: 'Sushi', price: '18.50', discountPrice: null, description: 'Premium fresh Atlantic salmon with cucumber, avocado, and tobiko', emoji: '🍱', rating: '4.9', prepTime: '10 min', tag: '🔥 Hot', tagClass: 'bg-red-500 text-white', sales: 198 },
  { id: 6, name: 'Tuna Nigiri Set', category: 'Sushi', price: '22.00', discountPrice: null, description: 'Hand-pressed sushi rice topped with fresh bluefin tuna (8 pieces)', emoji: '🐟', rating: '4.8', prepTime: '12 min', tag: null, tagClass: '', sales: 154 },
  { id: 7, name: 'Caesar Salad', category: 'Salads', price: '9.50', discountPrice: null, description: 'Crispy romaine, parmesan shavings, croutons with classic caesar dressing', emoji: '🥗', rating: '4.5', prepTime: '8 min', tag: null, tagClass: '', sales: 176 },
  { id: 8, name: 'Pasta Carbonara', category: 'Pasta', price: '13.50', discountPrice: null, description: 'Al dente spaghetti with rich egg sauce, guanciale, black pepper, and pecorino', emoji: '🍝', rating: '4.7', prepTime: '20 min', tag: null, tagClass: '', sales: 167 },
  { id: 9, name: 'Choc Lava Cake', category: 'Desserts', price: '7.99', discountPrice: null, description: 'Warm chocolate fondant with a gooey molten center, served with vanilla ice cream', emoji: '🍰', rating: '4.9', prepTime: '15 min', tag: '⭐ Featured', tagClass: 'bg-amber-400 text-amber-900', sales: 143 },
  { id: 10, name: 'Tiramisu', category: 'Desserts', price: '6.99', discountPrice: null, description: 'Classic Italian dessert with espresso-soaked ladyfingers and mascarpone cream', emoji: '🍮', rating: '4.6', prepTime: '5 min', tag: null, tagClass: '', sales: 128 },
  { id: 11, name: 'Mango Smoothie', category: 'Drinks', price: '5.50', discountPrice: null, description: 'Fresh Alphonso mango blended with yogurt and a touch of honey', emoji: '🥤', rating: '4.7', prepTime: '5 min', tag: null, tagClass: '', sales: 189 },
  { id: 12, name: 'Sparkling Water', category: 'Drinks', price: '2.99', discountPrice: null, description: 'Premium sparkling mineral water, chilled', emoji: '💧', rating: '4.3', prepTime: '2 min', tag: null, tagClass: '', sales: 204 },
])

const filteredItems = computed(() => {
  let items = allItems.value
  if (activeCategory.value !== 'All') items = items.filter(i => i.category === activeCategory.value)
  if (searchQuery.value) items = items.filter(i => i.name.toLowerCase().includes(searchQuery.value.toLowerCase()) || i.description.toLowerCase().includes(searchQuery.value.toLowerCase()))
  if (sortBy.value === 'price_asc') items = [...items].sort((a, b) => parseFloat(a.discountPrice || a.price) - parseFloat(b.discountPrice || b.price))
  if (sortBy.value === 'price_desc') items = [...items].sort((a, b) => parseFloat(b.discountPrice || b.price) - parseFloat(a.discountPrice || a.price))
  if (sortBy.value === 'rating') items = [...items].sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating))
  if (sortBy.value === 'popular') items = [...items].sort((a, b) => b.sales - a.sales)
  return items
})

const addToCart = (item) => {
  cartCount.value++
  toastItem.value = item
  setTimeout(() => { toastItem.value = null }, 2500)
}
</script>

<style scoped>
.slide-up-enter-active, .slide-up-leave-active { transition: all 0.3s ease; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateX(-50%) translateY(20px); }
</style>
