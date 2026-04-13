<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const step = ref(1) // 1: Email, 2: OTP, 3: Reset Password
const email = ref('')
const otp = ref('')
const newPassword = ref('')
const confirmPassword = ref('')
const error = ref('')
const loading = ref(false)

const handleSendOtp = async () => {
  if (!email.value) {
    error.value = 'Please enter your email'
    return
  }

  loading.value = true
  error.value = ''

  // Mock API call
  setTimeout(() => {
    step.value = 2
    loading.value = false
  }, 500)
}

const handleVerifyOtp = () => {
  if (!otp.value) {
    error.value = 'Please enter the OTP'
    return
  }

  if (otp.value.length !== 6) {
    error.value = 'OTP must be 6 digits'
    return
  }

  step.value = 3
}

const handleResetPassword = async () => {
  if (!newPassword.value || !confirmPassword.value) {
    error.value = 'Please fill in all fields'
    return
  }

  if (newPassword.value !== confirmPassword.value) {
    error.value = 'Passwords do not match'
    return
  }

  if (newPassword.value.length < 8) {
    error.value = 'Password must be at least 8 characters'
    return
  }

  loading.value = true
  // Mock API call
  setTimeout(() => {
    router.push('/login')
    loading.value = false
  }, 500)
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-light">
    <div class="w-full max-w-md">
      <!-- Logo -->
      <div class="text-center mb-8">
        <h1
          class="text-4xl font-bold mb-2"
          :style="{ color: 'var(--primary)' }"
        >
          FoodKing
        </h1>
        <p class="text-gray-mid">Reset Password</p>
      </div>

      <!-- Form -->
      <div class="bg-white rounded-lg shadow-md p-8">
        <!-- Error Message -->
        <div
          v-if="error"
          class="mb-4 p-3 bg-danger rounded text-white text-sm"
        >
          {{ error }}
        </div>

        <!-- Step 1: Email -->
        <div v-if="step === 1" class="space-y-4">
          <h2 class="text-xl font-bold mb-4">Enter your email</h2>
          <input
            v-model="email"
            type="email"
            placeholder="admin@foodking.com"
            class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-primary"
            :style="{ '--primary': 'var(--primary)' }"
          />
          <button
            @click="handleSendOtp"
            :disabled="loading"
            class="w-full py-2 bg-primary text-white font-medium rounded hover:opacity-90 transition disabled:opacity-50"
            :style="{ backgroundColor: 'var(--primary)' }"
          >
            {{ loading ? 'Sending...' : 'Send OTP' }}
          </button>
        </div>

        <!-- Step 2: OTP -->
        <div v-if="step === 2" class="space-y-4">
          <h2 class="text-xl font-bold mb-4">Enter OTP</h2>
          <p class="text-gray-mid text-sm mb-4">
            We've sent a 6-digit code to {{ email }}
          </p>
          <input
            v-model="otp"
            type="text"
            placeholder="000000"
            maxlength="6"
            class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-primary text-center text-2xl tracking-widest"
            :style="{ '--primary': 'var(--primary)' }"
          />
          <button
            @click="handleVerifyOtp"
            class="w-full py-2 bg-primary text-white font-medium rounded hover:opacity-90 transition"
            :style="{ backgroundColor: 'var(--primary)' }"
          >
            Verify OTP
          </button>
          <button
            @click="step = 1"
            class="w-full py-2 border border-gray-300 text-gray-mid font-medium rounded hover:bg-gray-50"
          >
            Back
          </button>
        </div>

        <!-- Step 3: New Password -->
        <div v-if="step === 3" class="space-y-4">
          <h2 class="text-xl font-bold mb-4">Set New Password</h2>
          <input
            v-model="newPassword"
            type="password"
            placeholder="New Password"
            class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-primary"
            :style="{ '--primary': 'var(--primary)' }"
          />
          <input
            v-model="confirmPassword"
            type="password"
            placeholder="Confirm Password"
            class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-primary"
            :style="{ '--primary': 'var(--primary)' }"
          />
          <button
            @click="handleResetPassword"
            :disabled="loading"
            class="w-full py-2 bg-primary text-white font-medium rounded hover:opacity-90 transition disabled:opacity-50"
            :style="{ backgroundColor: 'var(--primary)' }"
          >
            {{ loading ? 'Resetting...' : 'Reset Password' }}
          </button>
          <button
            @click="step = 2"
            class="w-full py-2 border border-gray-300 text-gray-mid font-medium rounded hover:bg-gray-50"
          >
            Back
          </button>
        </div>

        <!-- Back to Login Link -->
        <div class="text-center mt-4">
          <RouterLink
            to="/login"
            class="text-sm hover:underline"
            :style="{ color: 'var(--primary)' }"
          >
            Back to Login
          </RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
:root {
  --primary: var(--primary);
}
</style>
