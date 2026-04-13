<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center gap-2"><div class="w-9 h-9 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-white text-lg">🍔</span></div><span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span></RouterLink>
        <h1 class="font-bold text-slate-900 dark:text-white">My Profile</h1>
        <button @click="saveProfile" class="text-sm text-orange-500 hover:text-orange-400 font-semibold">Save</button>
      </div>
    </nav>

    <div class="max-w-2xl mx-auto px-4 sm:px-6 py-8 space-y-5">
      <!-- Avatar section -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm p-6 flex flex-col items-center">
        <div class="relative mb-4">
          <div class="w-24 h-24 rounded-full bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center text-4xl font-bold text-white shadow-xl shadow-orange-500/20">
            {{ form.firstName[0] || 'U' }}{{ form.lastName[0] || '' }}
          </div>
          <button class="absolute bottom-0 right-0 w-8 h-8 bg-orange-500 hover:bg-orange-400 text-white rounded-full flex items-center justify-center shadow-lg transition-colors">
            <Camera class="w-4 h-4" />
          </button>
        </div>
        <h2 class="text-xl font-bold text-slate-900 dark:text-white">{{ form.firstName }} {{ form.lastName }}</h2>
        <p class="text-slate-400 text-sm">{{ form.email }}</p>
        <div class="flex items-center gap-2 mt-2">
          <span class="bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 text-xs font-semibold px-3 py-1 rounded-full">⭐ Gold Member</span>
          <span class="bg-slate-100 dark:bg-slate-800 text-slate-500 text-xs font-semibold px-3 py-1 rounded-full">24 Orders</span>
        </div>
      </div>

      <!-- Personal Info -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm p-6 space-y-4">
        <h3 class="font-bold text-slate-900 dark:text-white">Personal Information</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">First Name</label>
            <input v-model="form.firstName" type="text" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">Last Name</label>
            <input v-model="form.lastName" type="text" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
          </div>
        </div>
        <div>
          <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">Email</label>
          <div class="relative">
            <Mail class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input v-model="form.email" type="email" class="w-full pl-9 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
          </div>
        </div>
        <div>
          <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">Phone</label>
          <div class="relative">
            <Phone class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input v-model="form.phone" type="tel" class="w-full pl-9 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
          </div>
        </div>
      </div>

      <!-- Quick links -->
      <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-hidden">
        <RouterLink v-for="link in quickLinks" :key="link.to" :to="link.to"
          class="flex items-center gap-4 px-5 py-4 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors border-b border-slate-100 dark:border-slate-800 last:border-0">
          <div :class="['w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0', link.iconBg]">
            <component :is="link.icon" :class="['w-5 h-5', link.iconColor]" />
          </div>
          <div class="flex-1">
            <p class="font-semibold text-slate-800 dark:text-white text-sm">{{ link.label }}</p>
            <p class="text-xs text-slate-400">{{ link.desc }}</p>
          </div>
          <ChevronRight class="w-4 h-4 text-slate-400" />
        </RouterLink>
      </div>

      <!-- Wallet / Credits -->
      <div class="bg-gradient-to-r from-indigo-600 to-violet-600 rounded-2xl p-5 shadow-lg">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-white/70 text-sm mb-1">FoodKing Wallet</p>
            <p class="text-3xl font-extrabold text-white">$15.00</p>
            <p class="text-white/70 text-xs mt-1">Redeemable on next order</p>
          </div>
          <div class="text-5xl">👛</div>
        </div>
        <button class="mt-4 px-4 py-2 bg-white/20 hover:bg-white/30 text-white text-sm font-semibold rounded-xl transition-colors">Add Money +</button>
      </div>

      <!-- Logout -->
      <button class="w-full py-3.5 border-2 border-red-200 dark:border-red-900 text-red-500 dark:text-red-400 font-bold rounded-2xl hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors flex items-center justify-center gap-2">
        <LogOut class="w-5 h-5" /> Sign Out
      </button>
    </div>

    <!-- Toast -->
    <Teleport to="body">
      <transition name="slide-up">
        <div v-if="showToast" class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-emerald-500 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-semibold flex items-center gap-2">
          <CheckCircle class="w-5 h-5" /> Profile updated!
        </div>
      </transition>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Mail, Phone, Camera, ChevronRight, LogOut, ShoppingBag, MapPin, Bell, Lock, CheckCircle } from 'lucide-vue-next'

const form = reactive({ firstName: 'Sarah', lastName: 'Johnson', email: 'sarah@example.com', phone: '+1 555-1234' })
const showToast = ref(false)

const quickLinks = [
  { to: '/orders', label: 'My Orders', desc: '24 placed orders', icon: ShoppingBag, iconBg: 'bg-orange-100 dark:bg-orange-900/30', iconColor: 'text-orange-500' },
  { to: '/addresses', label: 'Saved Addresses', desc: '2 saved locations', icon: MapPin, iconBg: 'bg-sky-100 dark:bg-sky-900/30', iconColor: 'text-sky-500' },
  { to: '/notifications', label: 'Notifications', desc: 'Order updates & offers', icon: Bell, iconBg: 'bg-violet-100 dark:bg-violet-900/30', iconColor: 'text-violet-500' },
  { to: '#', label: 'Change Password', desc: 'Update your security', icon: Lock, iconBg: 'bg-emerald-100 dark:bg-emerald-900/30', iconColor: 'text-emerald-500' },
]

const saveProfile = () => {
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 2000)
}
</script>

<style scoped>
.slide-up-enter-active, .slide-up-leave-active { transition: all 0.3s ease; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateX(-50%) translateY(20px); }
</style>
