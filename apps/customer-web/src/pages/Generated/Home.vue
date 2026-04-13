<template>
  <div class="min-h-screen bg-white dark:bg-slate-950 font-sans">
    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-white/80 dark:bg-slate-950/80 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <!-- Logo -->
        <RouterLink to="/" class="flex items-center gap-2.5">
          <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center shadow-md">
            <span class="text-white text-lg">🍔</span>
          </div>
          <span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span>
        </RouterLink>

        <!-- Search bar (desktop) -->
        <div class="hidden md:flex flex-1 max-w-md mx-8">
          <div class="relative w-full">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input type="text" placeholder="Search burgers, pizza, sushi..." 
              class="w-full pl-9 pr-4 py-2.5 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50" />
          </div>
        </div>

        <!-- Nav items -->
        <div class="flex items-center gap-3">
          <RouterLink to="/menu" class="hidden md:flex text-sm font-medium text-slate-600 dark:text-slate-300 hover:text-orange-500 transition-colors">Menu</RouterLink>
          <RouterLink to="/orders" class="hidden md:flex text-sm font-medium text-slate-600 dark:text-slate-300 hover:text-orange-500 transition-colors">Orders</RouterLink>
          <RouterLink to="/cart" class="relative p-2 rounded-xl bg-orange-50 dark:bg-orange-900/20 text-orange-500 hover:bg-orange-100 transition-colors">
            <ShoppingCart class="w-5 h-5" />
            <span v-if="cartCount > 0" class="absolute -top-1 -right-1 w-4 h-4 bg-orange-500 text-white text-xs font-bold rounded-full flex items-center justify-center">{{ cartCount }}</span>
          </RouterLink>
          <RouterLink to="/login" class="hidden md:flex items-center gap-1.5 px-4 py-2 bg-orange-500 hover:bg-orange-400 text-white text-sm font-semibold rounded-xl transition-all shadow-md shadow-orange-500/20">
            <User class="w-4 h-4" /> Sign In
          </RouterLink>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-orange-500 via-rose-500 to-pink-600 overflow-hidden">
      <div class="absolute inset-0 opacity-10">
        <div class="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] rounded-full bg-white blur-3xl"></div>
        <div class="absolute bottom-[-20%] right-[-10%] w-[50%] h-[60%] rounded-full bg-white blur-3xl"></div>
      </div>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <div class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-sm border border-white/30 rounded-full px-4 py-2 text-white text-sm font-medium mb-6">
              <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              Free delivery on orders over $25
            </div>
            <h1 class="text-5xl lg:text-6xl font-extrabold text-white leading-tight mb-6">
              Delicious food<br/>
              <span class="text-yellow-300">delivered fast</span> 🚀
            </h1>
            <p class="text-white/80 text-lg leading-relaxed mb-8">
              Order from your favorite restaurants and get fresh, hot meals delivered right to your door in under 30 minutes.
            </p>
            <div class="flex gap-4 flex-wrap">
              <RouterLink to="/menu" class="flex items-center gap-2 px-6 py-3.5 bg-white text-orange-600 font-bold rounded-2xl shadow-xl hover:shadow-2xl transition-all hover:-translate-y-0.5 active:scale-95">
                <UtensilsCrossed class="w-5 h-5" /> Browse Menu
              </RouterLink>
              <RouterLink to="/orders" class="flex items-center gap-2 px-6 py-3.5 bg-white/20 backdrop-blur-sm border border-white/30 text-white font-semibold rounded-2xl hover:bg-white/30 transition-all">
                <Clock class="w-5 h-5" /> Track Order
              </RouterLink>
            </div>

            <!-- Quick stats -->
            <div class="flex gap-8 mt-10">
              <div v-for="s in heroStats" :key="s.label">
                <p class="text-2xl font-extrabold text-white">{{ s.value }}</p>
                <p class="text-white/70 text-sm">{{ s.label }}</p>
              </div>
            </div>
          </div>
          <div class="hidden lg:flex justify-center">
            <div class="text-[10rem] drop-shadow-2xl animate-bounce" style="animation-duration: 3s;">🍔</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Category Pills -->
    <section class="py-10 bg-slate-50 dark:bg-slate-900/50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="text-xl font-bold text-slate-900 dark:text-white mb-6">Browse Categories</h2>
        <div class="flex gap-4 overflow-x-auto pb-2">
          <RouterLink v-for="cat in categories" :key="cat.name" :to="`/menu?category=${cat.name}`"
            class="flex flex-col items-center gap-2 flex-shrink-0 group">
            <div class="w-16 h-16 rounded-2xl bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 flex items-center justify-center text-3xl shadow-sm group-hover:border-orange-300 group-hover:shadow-md group-hover:scale-105 transition-all duration-200">
              {{ cat.emoji }}
            </div>
            <span class="text-xs font-medium text-slate-600 dark:text-slate-400 group-hover:text-orange-500 transition-colors">{{ cat.name }}</span>
          </RouterLink>
        </div>
      </div>
    </section>

    <!-- Featured Items -->
    <section class="py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between mb-8">
          <div>
            <h2 class="text-2xl font-bold text-slate-900 dark:text-white">🔥 Popular Right Now</h2>
            <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Most ordered this week</p>
          </div>
          <RouterLink to="/menu" class="text-orange-500 hover:text-orange-400 text-sm font-semibold transition-colors">See all →</RouterLink>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          <RouterLink v-for="item in featuredItems" :key="item.id" :to="`/menu/${item.id}`"
            class="group bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 overflow-hidden shadow-sm hover:shadow-xl hover:border-orange-200 dark:hover:border-orange-800 transition-all duration-300 hover:-translate-y-1">
            <div class="relative h-44 bg-gradient-to-br from-orange-50 to-rose-50 dark:from-slate-800 dark:to-slate-700 flex items-center justify-center overflow-hidden">
              <span class="text-7xl group-hover:scale-110 transition-transform duration-300">{{ item.emoji }}</span>
              <div v-if="item.tag" :class="['absolute top-3 left-3 text-xs font-bold px-2.5 py-1 rounded-full', item.tagClass]">{{ item.tag }}</div>
              <button @click.prevent="addToCart(item)" class="absolute bottom-3 right-3 w-9 h-9 bg-orange-500 hover:bg-orange-400 text-white rounded-xl flex items-center justify-center shadow-lg transition-all opacity-0 group-hover:opacity-100 scale-90 group-hover:scale-100 duration-200">
                <Plus class="w-5 h-5" />
              </button>
            </div>
            <div class="p-4">
              <div class="flex items-start justify-between mb-1">
                <h3 class="font-bold text-slate-900 dark:text-white flex-1 truncate">{{ item.name }}</h3>
              </div>
              <p class="text-xs text-slate-400 mb-3">{{ item.category }}</p>
              <div class="flex items-center justify-between">
                <div>
                  <span v-if="item.originalPrice" class="text-slate-400 line-through text-xs mr-1">${{ item.originalPrice }}</span>
                  <span class="text-lg font-extrabold text-orange-500">${{ item.price }}</span>
                </div>
                <div class="flex items-center gap-1 text-amber-400">
                  <Star class="w-3.5 h-3.5 fill-current" />
                  <span class="text-xs text-slate-500 dark:text-slate-400 font-medium">{{ item.rating }}</span>
                </div>
              </div>
            </div>
          </RouterLink>
        </div>
      </div>
    </section>

    <!-- Active Offers Banner -->
    <section class="py-10 bg-gradient-to-r from-indigo-600 to-violet-600">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
          <div v-for="offer in offers" :key="offer.title"
            class="bg-white/10 backdrop-blur-sm border border-white/20 rounded-3xl p-6 hover:bg-white/20 transition-all cursor-pointer group">
            <div class="text-4xl mb-3">{{ offer.emoji }}</div>
            <h3 class="font-bold text-white text-lg mb-1">{{ offer.title }}</h3>
            <p class="text-white/70 text-sm mb-3">{{ offer.desc }}</p>
            <div class="flex items-center justify-between">
              <span class="bg-white/20 text-white text-sm font-bold px-3 py-1 rounded-full font-mono">{{ offer.code }}</span>
              <ArrowRight class="w-5 h-5 text-white/70 group-hover:translate-x-1 transition-transform" />
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-slate-900 text-slate-400 py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10 mb-10">
          <div>
            <div class="flex items-center gap-2 mb-4">
              <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-sm">🍔</span></div>
              <span class="font-extrabold text-white">Food<span class="text-orange-400">King</span></span>
            </div>
            <p class="text-sm leading-relaxed">The best food delivery service in town. Fresh, fast, and delicious.</p>
          </div>
          <div v-for="col in footerLinks" :key="col.title">
            <h4 class="font-semibold text-white mb-4">{{ col.title }}</h4>
            <ul class="space-y-2">
              <li v-for="link in col.links" :key="link">
                <RouterLink to="/" class="text-sm hover:text-orange-400 transition-colors">{{ link }}</RouterLink>
              </li>
            </ul>
          </div>
        </div>
        <div class="border-t border-slate-800 pt-8 flex flex-col sm:flex-row justify-between items-center gap-4">
          <p class="text-sm">© {{ new Date().getFullYear() }} FoodKing. All rights reserved.</p>
          <div class="flex gap-3">
            <a v-for="s in socials" :key="s" href="#" class="w-9 h-9 rounded-xl bg-slate-800 hover:bg-slate-700 flex items-center justify-center text-sm transition-colors">{{ s }}</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Search, ShoppingCart, User, UtensilsCrossed, Clock, Plus, Star, ArrowRight } from 'lucide-vue-next'

const cartCount = ref(2)
const heroStats = [
  { value: '500+', label: 'Restaurants' },
  { value: '30 min', label: 'Avg Delivery' },
  { value: '4.8★', label: 'Rating' },
]

const categories = [
  { name: 'Burgers', emoji: '🍔' }, { name: 'Pizza', emoji: '🍕' }, { name: 'Sushi', emoji: '🍱' },
  { name: 'Pasta', emoji: '🍝' }, { name: 'Salads', emoji: '🥗' }, { name: 'Desserts', emoji: '🍰' },
  { name: 'Drinks', emoji: '🥤' }, { name: 'Tacos', emoji: '🌮' }, { name: 'Ramen', emoji: '🍜' },
]

const featuredItems = [
  { id: 1, name: 'Chicken Burger', category: 'Burgers', price: '12.99', originalPrice: null, emoji: '🍔', rating: '4.9', tag: '🔥 Hot', tagClass: 'bg-red-500 text-white' },
  { id: 2, name: 'Margherita Pizza', category: 'Pizza', price: '11.99', originalPrice: '14.99', emoji: '🍕', rating: '4.7', tag: '20% OFF', tagClass: 'bg-emerald-500 text-white' },
  { id: 3, name: 'Salmon Sushi Roll', category: 'Sushi', price: '18.50', originalPrice: null, emoji: '🍱', rating: '4.8', tag: null, tagClass: '' },
  { id: 4, name: 'Choc Lava Cake', category: 'Desserts', price: '7.99', originalPrice: null, emoji: '🍰', rating: '4.6', tag: '⭐ Featured', tagClass: 'bg-amber-400 text-amber-900' },
]

const offers = [
  { emoji: '🎉', title: 'Weekend Special', desc: 'Get 15% off all orders this weekend', code: 'WEEKEND15' },
  { emoji: '🍔', title: 'Burger Bonanza', desc: '$5 off any burger combo order', code: 'BURGER5' },
  { emoji: '🚀', title: 'Free Delivery', desc: 'Free delivery on orders over $25', code: 'FREEDEL' },
]

const footerLinks = [
  { title: 'Company', links: ['About Us', 'Careers', 'Press', 'Blog'] },
  { title: 'Support', links: ['Help Center', 'Contact Us', 'Privacy Policy', 'Terms'] },
  { title: 'Explore', links: ['Restaurants', 'Cuisines', 'Offers', 'Gift Cards'] },
]
const socials = ['𝕏', '📘', '📷', '▶️']

const addToCart = (item) => { cartCount.value++ }
</script>
