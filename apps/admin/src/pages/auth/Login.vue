<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import Card from '@/components/ui/card.vue'
import CardContent from '@/components/ui/card-content.vue'
import CardDescription from '@/components/ui/card-description.vue'
import CardHeader from '@/components/ui/card-header.vue'
import CardTitle from '@/components/ui/card-title.vue'
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'
import { AlertCircle } from 'lucide-vue-next'

const router = useRouter()
const store = useStore()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

const handleLogin = async () => {
  if (!email.value || !password.value) {
    error.value = 'Please fill in all fields'
    return
  }

  loading.value = true
  error.value = ''

  try {
    await store.dispatch('auth/login', {
      email: email.value,
      password: password.value,
    })
    router.push('/dashboard')
  } catch (err) {
    error.value = 'Login failed. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 via-sky-50 to-blue-50 py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <!-- Animated Background Elements -->
    <div class="absolute top-0 left-0 w-96 h-96 bg-sky-200 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse"></div>
    <div class="absolute -bottom-8 right-0 w-96 h-96 bg-blue-200 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse" style="animation-delay: 2s;"></div>

    <div class="w-full max-w-md space-y-8 relative z-10">
      <!-- Premium Logo Section -->
      <div class="text-center">
        <div class="inline-flex items-center justify-center relative">
          <!-- Animated Ring -->
          <div class="absolute inset-0 w-20 h-20 bg-gradient-to-r from-sky-400 to-sky-600 rounded-2xl blur-lg opacity-30 animate-pulse"></div>
          
          <!-- Logo Container -->
          <div class="relative w-16 h-16 bg-gradient-to-br from-sky-400 via-sky-500 to-sky-600 rounded-2xl shadow-2xl flex items-center justify-center overflow-hidden group">
            <!-- Animated Background -->
            <div class="absolute inset-0 bg-gradient-to-r from-transparent via-white to-transparent opacity-0 group-hover:opacity-20 animate-pulse"></div>
            
            <!-- SVG Fork Icon -->
            <svg class="w-8 h-8 relative z-10 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M 9 5 L 9 14 M 12 5 L 12 14 M 15 5 L 15 14 M 9 14 Q 12 15 15 14 Q 12 16 9 14"/>
              <circle cx="12" cy="12" r="9" fill="none" opacity="0.3"/>
            </svg>
          </div>
        </div>

        <!-- Title -->
        <h1 class="mt-8 text-4xl md:text-5xl font-bold">
          <span class="bg-gradient-to-r from-sky-600 via-sky-500 to-blue-600 bg-clip-text text-transparent">
            FoodKing
          </span>
        </h1>
        
        <!-- Subtitle -->
        <p class="text-slate-600 mt-3 text-lg font-medium">Admin Dashboard</p>
        <p class="text-slate-500 mt-1 text-sm">Welcome back! Sign in to your account</p>
      </div>

      <!-- Login Card with Premium Design -->
      <Card class="shadow-2xl border border-sky-100/50 backdrop-blur-sm">
        <CardHeader class="bg-gradient-to-r from-sky-50/50 to-blue-50/50 border-b border-sky-100/30 rounded-t-lg">
          <CardTitle class="text-2xl text-sky-900 text-start">Sign In</CardTitle>
          <CardDescription class="text-slate-600 text-start">Enter your credentials to access the dashboard</CardDescription>
        </CardHeader>
        
        <CardContent class="space-y-6 pt-8">
          <!-- Error Message with Animation -->
          <div
            v-if="error"
            class="flex items-center gap-3 p-4 bg-gradient-to-r from-red-50 to-rose-50 border border-red-200/50 rounded-xl text-red-700 animate-shake shadow-sm"
          >
            <AlertCircle class="h-5 w-5 flex-shrink-0 animate-bounce" />
            <span class="text-sm font-semibold">{{ error }}</span>
          </div>

          <!-- Email Input with Icon -->
          <div class="space-y-3">
            <label class="block text-sm font-semibold text-slate-700">Email Address</label>
            <div class="relative group">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-sky-400 group-focus-within:text-sky-600 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
              </span>
              <Input
                v-model="email"
                type="email"
                placeholder="admin@foodking.com"
                :disabled="loading"
                class="pl-10 border-sky-200/50 focus:border-sky-500 focus:ring-sky-500"
              />
            </div>
          </div>

          <!-- Password Input with Icon -->
          <div class="space-y-3">
            <div class="flex justify-between items-center">
              <label class="block text-sm font-semibold text-slate-700">Password</label>
              <RouterLink
                to="/forgot-password"
                class="text-xs text-sky-600 hover:text-sky-700 hover:underline font-medium transition-colors"
              >
                Forgot?
              </RouterLink>
            </div>
            <div class="relative group">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-sky-400 group-focus-within:text-sky-600 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </span>
              <Input
                v-model="password"
                type="password"
                placeholder="••••••••"
                :disabled="loading"
                class="pl-10 border-sky-200/50 focus:border-sky-500 focus:ring-sky-500"
              />
            </div>
          </div>

          <!-- Sign In Button -->
          <Button
            @click="handleLogin"
            :disabled="loading"
            class="w-full bg-gradient-to-r from-sky-500 to-sky-600 hover:from-sky-600 hover:to-sky-700 text-white font-semibold py-2 rounded-lg transition-all duration-200 shadow-lg hover:shadow-xl"
            size="lg"
          >
            <span v-if="loading" class="flex items-center gap-2">
              <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Signing in...
            </span>
            <span v-else>Sign In to Dashboard</span>
          </Button>

          <!-- Divider -->
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-slate-200"></div>
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-2 bg-white text-slate-500">Need help?</span>
            </div>
          </div>

          <!-- Contact Support -->
          <p class="text-center text-slate-600 text-sm">
            Contact support at
            <a href="mailto:support@foodking.com" class="text-sky-600 font-semibold hover:text-sky-700 hover:underline">
              support@foodking.com
            </a>
          </p>
        </CardContent>
      </Card>

      <!-- Footer -->
      <p class="text-center text-slate-500 text-xs">© 2024 FoodKing Admin. All rights reserved.</p>
    </div>
  </div>
</template>
