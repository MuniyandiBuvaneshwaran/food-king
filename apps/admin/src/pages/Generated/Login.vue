<template>
  <div class="min-h-screen flex bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 relative overflow-hidden">
    <!-- Animated background blobs -->
    <div class="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] rounded-full bg-sky-600/20 blur-[120px] animate-pulse pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[50%] h-[70%] rounded-full bg-indigo-600/20 blur-[120px] animate-pulse pointer-events-none"></div>

    <!-- Left panel: Branding -->
    <div class="hidden lg:flex flex-col justify-between w-1/2 p-16 relative z-10">
      <!-- Logo -->
      <div class="flex items-center gap-3">
        <div class="relative flex items-center justify-center w-12 h-12 rounded-2xl shadow-lg overflow-hidden bg-gradient-to-br from-sky-400 to-sky-600">
          <svg class="w-7 h-7 text-white" viewBox="0 0 24 24" fill="currentColor">
            <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="1.5" opacity="0.8"/>
            <path d="M 9 5 L 9 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            <path d="M 12 5 L 12 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            <path d="M 15 5 L 15 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            <path d="M 9 14 Q 12 15 15 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
          </svg>
        </div>
        <span class="text-2xl font-bold text-white tracking-tight">FoodKing</span>
      </div>

      <!-- Tagline -->
      <div>
        <div class="inline-flex items-center gap-2 bg-sky-500/10 border border-sky-500/20 rounded-full px-4 py-2 mb-6">
          <span class="w-2 h-2 rounded-full bg-sky-400 animate-pulse"></span>
          <span class="text-sky-400 text-sm font-medium">Admin Dashboard</span>
        </div>
        <h1 class="text-5xl font-extrabold text-white leading-tight mb-4">
          Manage your<br/>
          <span class="bg-gradient-to-r from-sky-400 to-indigo-400 bg-clip-text text-transparent">restaurant empire</span>
        </h1>
        <p class="text-slate-400 text-lg leading-relaxed">
          Complete oversight of orders, kitchen, delivery, and analytics — all in one beautiful interface.
        </p>

        <!-- Feature pills -->
        <div class="flex flex-wrap gap-3 mt-8">
          <span v-for="f in features" :key="f" class="bg-white/5 border border-white/10 text-slate-300 text-sm px-4 py-1.5 rounded-full">{{ f }}</span>
        </div>
      </div>

      <!-- Stats row -->
      <div class="grid grid-cols-3 gap-6">
        <div v-for="stat in stats" :key="stat.label" class="bg-white/5 border border-white/10 rounded-2xl p-4">
          <p class="text-2xl font-bold text-white">{{ stat.value }}</p>
          <p class="text-slate-400 text-sm mt-1">{{ stat.label }}</p>
        </div>
      </div>
    </div>

    <!-- Right panel: Login Form -->
    <div class="flex flex-1 items-center justify-center relative z-10 p-8">
      <div class="w-full max-w-md">
        <div class="bg-white/5 backdrop-blur-2xl border border-white/10 rounded-3xl shadow-2xl p-8">
          <!-- Mobile logo -->
          <div class="flex lg:hidden items-center gap-2 mb-8">
            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-sky-400 to-sky-600 flex items-center justify-center">
              <svg class="w-6 h-6 text-white" viewBox="0 0 24 24" fill="currentColor">
                <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="1.5" opacity="0.8"/>
                <path d="M 9 5 L 9 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
                <path d="M 12 5 L 12 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
                <path d="M 15 5 L 15 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
              </svg>
            </div>
            <span class="text-xl font-bold text-white">FoodKing</span>
          </div>

          <h2 class="text-2xl font-bold text-white mb-1">Welcome back 👋</h2>
          <p class="text-slate-400 text-sm mb-8">Sign in to your admin account</p>

          <form @submit.prevent="handleLogin" class="space-y-5">
            <!-- Email -->
            <div>
              <label class="block text-sm font-medium text-slate-300 mb-2">Email address</label>
              <div class="relative">
                <Mail class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
                <input
                  id="login-email"
                  v-model="form.email"
                  type="email"
                  placeholder="admin@foodking.com"
                  class="w-full bg-white/5 border border-white/10 text-white placeholder-slate-500 rounded-xl py-3 pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-sky-500/50 focus:border-sky-500/50 transition-all"
                  required
                />
              </div>
              <p v-if="errors.email" class="text-red-400 text-xs mt-1">{{ errors.email }}</p>
            </div>

            <!-- Password -->
            <div>
              <label class="block text-sm font-medium text-slate-300 mb-2">Password</label>
              <div class="relative">
                <Lock class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
                <input
                  id="login-password"
                  v-model="form.password"
                  :type="showPassword ? 'text' : 'password'"
                  placeholder="••••••••"
                  class="w-full bg-white/5 border border-white/10 text-white placeholder-slate-500 rounded-xl py-3 pl-10 pr-10 focus:outline-none focus:ring-2 focus:ring-sky-500/50 focus:border-sky-500/50 transition-all"
                  required
                />
                <button type="button" @click="showPassword = !showPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition-colors">
                  <EyeOff v-if="showPassword" class="w-4 h-4" />
                  <Eye v-else class="w-4 h-4" />
                </button>
              </div>
              <p v-if="errors.password" class="text-red-400 text-xs mt-1">{{ errors.password }}</p>
            </div>

            <!-- Remember & Forgot -->
            <div class="flex items-center justify-between">
              <label class="flex items-center gap-2 cursor-pointer">
                <input v-model="form.rememberMe" type="checkbox" class="w-4 h-4 rounded border-white/20 bg-white/5 text-sky-500 focus:ring-sky-500/50" />
                <span class="text-slate-400 text-sm">Remember me</span>
              </label>
              <RouterLink to="/forgot-password" class="text-sm text-sky-400 hover:text-sky-300 transition-colors">Forgot password?</RouterLink>
            </div>

            <!-- Error alert -->
            <div v-if="loginError" class="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm flex items-center gap-2">
              <AlertCircle class="w-4 h-4 flex-shrink-0" />
              {{ loginError }}
            </div>

            <!-- Submit -->
            <button
              id="login-submit"
              type="submit"
              :disabled="isLoading"
              class="w-full bg-gradient-to-r from-sky-500 to-indigo-500 hover:from-sky-400 hover:to-indigo-400 text-white font-semibold py-3 rounded-xl transition-all duration-200 shadow-lg shadow-sky-500/20 hover:shadow-sky-500/40 active:scale-[0.98] disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <Loader2 v-if="isLoading" class="w-4 h-4 animate-spin" />
              <span>{{ isLoading ? 'Signing in...' : 'Sign in' }}</span>
            </button>
          </form>

          <!-- Demo credentials -->
          <div class="mt-6 p-4 bg-sky-500/5 border border-sky-500/20 rounded-xl">
            <p class="text-slate-400 text-xs font-medium mb-2">Demo Credentials</p>
            <div class="flex gap-2 flex-wrap">
              <button v-for="demo in demoCreds" :key="demo.role" @click="fillDemo(demo)"
                class="text-xs bg-white/5 hover:bg-white/10 border border-white/10 text-sky-400 px-3 py-1 rounded-full transition-colors">
                {{ demo.role }}
              </button>
            </div>
          </div>
        </div>

        <p class="text-center text-slate-500 text-sm mt-6">
          © {{ new Date().getFullYear() }} FoodKing. All rights reserved.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { Mail, Lock, Eye, EyeOff, AlertCircle, Loader2 } from 'lucide-vue-next'

const router = useRouter()
const store = useStore()

const form = reactive({
  email: '',
  password: '',
  rememberMe: false,
})
const errors = reactive({ email: '', password: '' })
const showPassword = ref(false)
const isLoading = ref(false)
const loginError = ref('')

const features = ['Multi-Branch', 'KDS & OSS', '22+ Payments', 'Real-time Orders', 'Analytics']
const stats = [
  { value: '12.4k', label: 'Daily Orders' },
  { value: '98.6%', label: 'Uptime' },
  { value: '3.2s', label: 'Avg Delivery' },
]

const demoCreds = [
  { role: 'Admin', email: 'admin@foodking.com', password: 'password' },
  { role: 'Branch Mgr', email: 'manager@foodking.com', password: 'password' },
  { role: 'POS Op.', email: 'pos@foodking.com', password: 'password' },
]

const fillDemo = (demo) => {
  form.email = demo.email
  form.password = demo.password
}

const validate = () => {
  errors.email = ''
  errors.password = ''
  let valid = true
  if (!form.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = 'Please enter a valid email address.'
    valid = false
  }
  if (!form.password || form.password.length < 6) {
    errors.password = 'Password must be at least 6 characters.'
    valid = false
  }
  return valid
}

const handleLogin = async () => {
  loginError.value = ''
  if (!validate()) return

  isLoading.value = true
  // Mock login — accept any @foodking.com email with password "password"
  await new Promise(r => setTimeout(r, 1000))

  if (form.email.includes('@foodking.com') && form.password === 'password') {
    localStorage.setItem('token', 'mock-token-12345')
    localStorage.setItem('user', JSON.stringify({ name: 'Admin User', email: form.email, role: 'Admin' }))
    router.push('/admin/dashboard')
  } else {
    loginError.value = 'Invalid credentials. Use demo credentials above.'
    isLoading.value = false
  }
}
</script>
