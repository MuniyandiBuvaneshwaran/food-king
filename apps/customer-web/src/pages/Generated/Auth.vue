<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950 flex">
    <!-- Left: Branding (desktop) -->
    <div class="hidden lg:flex flex-col justify-between w-1/2 bg-gradient-to-br from-orange-500 via-rose-500 to-pink-600 p-16 relative overflow-hidden">
      <div class="absolute inset-0 opacity-10">
        <div class="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] rounded-full bg-white blur-3xl"></div>
        <div class="absolute bottom-[-20%] right-[-10%] w-[50%] h-[60%] rounded-full bg-white blur-3xl"></div>
      </div>

      <RouterLink to="/" class="flex items-center gap-3 relative z-10">
        <div class="w-12 h-12 rounded-2xl bg-white/20 backdrop-blur-sm border border-white/30 flex items-center justify-center"><span class="text-3xl">🍔</span></div>
        <span class="font-extrabold text-2xl text-white">FoodKing</span>
      </RouterLink>

      <div class="relative z-10">
        <div class="text-7xl mb-8">{{ isLogin ? '👋' : '🎉' }}</div>
        <h1 class="text-4xl font-extrabold text-white mb-4">{{ isLogin ? 'Welcome back!' : 'Join FoodKing!' }}</h1>
        <p class="text-white/80 text-lg mb-8">{{ isLogin ? 'Sign in to track your orders, save addresses, and enjoy exclusive deals.' : 'Create an account and get your first order 10% off.' }}</p>
        <div class="flex flex-wrap gap-3">
          <span v-for="f in features" :key="f" class="bg-white/20 backdrop-blur-sm border border-white/30 text-white text-sm px-4 py-1.5 rounded-full">{{ f }}</span>
        </div>
      </div>

      <div class="grid grid-cols-3 gap-5 relative z-10">
        <div v-for="s in stats" :key="s.label" class="bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl p-4 text-center">
          <p class="text-2xl font-extrabold text-white">{{ s.value }}</p>
          <p class="text-white/70 text-sm mt-1">{{ s.label }}</p>
        </div>
      </div>
    </div>

    <!-- Right: Auth form -->
    <div class="flex flex-1 items-center justify-center p-8">
      <div class="w-full max-w-md">
        <!-- Mobile logo -->
        <RouterLink to="/" class="flex lg:hidden items-center gap-2 mb-8">
          <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-400 to-rose-500 flex items-center justify-center"><span class="text-xl">🍔</span></div>
          <span class="font-extrabold text-xl text-slate-900 dark:text-white">Food<span class="text-orange-500">King</span></span>
        </RouterLink>

        <!-- Tab toggle -->
        <div class="flex bg-slate-100 dark:bg-slate-800 rounded-2xl p-1 mb-8">
          <button @click="isLogin = true" :class="['flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all', isLogin ? 'bg-white dark:bg-slate-700 text-orange-600 shadow-sm' : 'text-slate-500 dark:text-slate-400']">Sign In</button>
          <button @click="isLogin = false" :class="['flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all', !isLogin ? 'bg-white dark:bg-slate-700 text-orange-600 shadow-sm' : 'text-slate-500 dark:text-slate-400']">Register</button>
        </div>

        <!-- Login form -->
        <form v-if="isLogin" @submit.prevent="handleLogin" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Email</label>
            <div class="relative"><Mail class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="loginForm.email" type="email" placeholder="your@email.com" required class="w-full pl-9 pr-4 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Password</label>
            <div class="relative"><Lock class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="loginForm.password" :type="showPwd ? 'text' : 'password'" placeholder="••••••••" required class="w-full pl-9 pr-10 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
              <button type="button" @click="showPwd = !showPwd" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"><EyeOff v-if="showPwd" class="w-4 h-4" /><Eye v-else class="w-4 h-4" /></button>
            </div>
          </div>
          <div class="flex items-center justify-between">
            <label class="flex items-center gap-2 cursor-pointer"><input type="checkbox" class="w-4 h-4 accent-orange-500" /><span class="text-sm text-slate-500 dark:text-slate-400">Remember me</span></label>
            <a href="#" class="text-sm text-orange-500 hover:text-orange-400 font-semibold">Forgot password?</a>
          </div>
          <button type="submit" :disabled="loading" class="w-full py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-xl transition-all shadow-xl shadow-orange-500/20 active:scale-95 disabled:opacity-60 flex items-center justify-center gap-2">
            <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />{{ loading ? 'Signing in...' : 'Sign In' }}
          </button>
          <!-- Divider + Google -->
          <div class="relative flex items-center gap-3 my-1"><div class="flex-1 h-px bg-slate-200 dark:bg-slate-700"></div><span class="text-xs text-slate-400">or</span><div class="flex-1 h-px bg-slate-200 dark:bg-slate-700"></div></div>
          <button type="button" class="w-full py-3 border-2 border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 font-semibold rounded-xl hover:border-orange-300 hover:bg-orange-50 dark:hover:bg-orange-900/10 transition-all flex items-center justify-center gap-3">
            <span class="text-xl">G</span> Continue with Google
          </button>
        </form>

        <!-- Register form -->
        <form v-else @submit.prevent="handleRegister" class="space-y-4">
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">First Name</label>
              <input v-model="regForm.firstName" type="text" placeholder="John" required class="w-full px-4 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Last Name</label>
              <input v-model="regForm.lastName" type="text" placeholder="Doe" required class="w-full px-4 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Email</label>
            <div class="relative"><Mail class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="regForm.email" type="email" placeholder="your@email.com" required class="w-full pl-9 pr-4 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Phone</label>
            <div class="relative"><Phone class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="regForm.phone" type="tel" placeholder="+1 555-0100" class="w-full pl-9 pr-4 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Password</label>
            <div class="relative"><Lock class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="regForm.password" :type="showPwd ? 'text' : 'password'" placeholder="Min. 6 characters" required class="w-full pl-9 pr-10 py-3 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
              <button type="button" @click="showPwd = !showPwd" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400"><EyeOff v-if="showPwd" class="w-4 h-4" /><Eye v-else class="w-4 h-4" /></button>
            </div>
          </div>
          <!-- OTP step indicator -->
          <div class="bg-sky-50 dark:bg-sky-900/20 border border-sky-200 dark:border-sky-800 rounded-xl px-4 py-3 flex items-center gap-2 text-sm text-sky-700 dark:text-sky-400">
            <Info class="w-4 h-4 flex-shrink-0" /> An OTP will be sent to verify your email/phone.
          </div>
          <button type="submit" :disabled="loading" class="w-full py-3.5 bg-orange-500 hover:bg-orange-400 text-white font-bold rounded-xl transition-all shadow-xl shadow-orange-500/20 active:scale-95 disabled:opacity-60 flex items-center justify-center gap-2">
            <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />{{ loading ? 'Creating Account...' : 'Create Account' }}
          </button>
          <div class="relative flex items-center gap-3"><div class="flex-1 h-px bg-slate-200 dark:bg-slate-700"></div><span class="text-xs text-slate-400">or</span><div class="flex-1 h-px bg-slate-200 dark:bg-slate-700"></div></div>
          <button type="button" class="w-full py-3 border-2 border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 font-semibold rounded-xl hover:border-orange-300 hover:bg-orange-50 dark:hover:bg-orange-900/10 transition-all flex items-center justify-center gap-3">
            <span class="text-xl">G</span> Sign up with Google
          </button>
        </form>
        <p class="text-center text-slate-400 text-xs mt-6">© {{ new Date().getFullYear() }} FoodKing. All rights reserved.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { Mail, Lock, Eye, EyeOff, Loader2, Phone, Info } from 'lucide-vue-next'

const router = useRouter()
const isLogin = ref(true)
const showPwd = ref(false)
const loading = ref(false)

const loginForm = reactive({ email: '', password: '' })
const regForm = reactive({ firstName: '', lastName: '', email: '', phone: '', password: '' })

const features = ['Free Delivery', 'Track Orders Live', 'Exclusive Deals', 'Save Addresses']
const stats = [{ value: '500+', label: 'Restaurants' }, { value: '50k+', label: 'Happy Customers' }, { value: '4.8★', label: 'App Rating' }]

const handleLogin = async () => {
  loading.value = true
  await new Promise(r => setTimeout(r, 1000))
  loading.value = false
  router.push('/')
}

const handleRegister = async () => {
  loading.value = true
  await new Promise(r => setTimeout(r, 1200))
  loading.value = false
  isLogin.value = true
}
</script>
