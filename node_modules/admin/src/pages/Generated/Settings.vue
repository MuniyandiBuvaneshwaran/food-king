<template>
  <div class="space-y-6">
    <div>
      <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Settings</h1>
      <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Configure your FoodKing platform</p>
    </div>

    <div class="flex gap-6 flex-col lg:flex-row">
      <!-- Sidebar nav -->
      <div class="lg:w-60 flex-shrink-0">
        <nav class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-2 shadow-sm space-y-1">
          <button v-for="tab in tabs" :key="tab.key" @click="activeTab = tab.key"
            :class="['w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium text-left transition-all',
              activeTab === tab.key
                ? 'bg-sky-50 dark:bg-sky-900/20 text-sky-700 dark:text-sky-400 border border-sky-200 dark:border-sky-800'
                : 'text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700']">
            <component :is="tab.icon" class="w-4 h-4 flex-shrink-0" />
            {{ tab.label }}
          </button>
        </nav>
      </div>

      <!-- Content -->
      <div class="flex-1">
        <!-- Company Settings -->
        <div v-if="activeTab === 'company'" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm space-y-5">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4">Company Information</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div v-for="f in companyFields" :key="f.key">
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">{{ f.label }}</label>
              <input v-model="companyForm[f.key]" :type="f.type || 'text'" :placeholder="f.placeholder"
                class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
            </div>
          </div>
          <div class="pt-2">
            <button @click="save" class="px-5 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">Save Changes</button>
          </div>
        </div>

        <!-- Site Settings -->
        <div v-if="activeTab === 'site'" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm space-y-5">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4">Site Configuration</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Date Format</label>
              <select v-model="siteForm.dateFormat" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                <option>d-m-Y</option><option>m/d/Y</option><option>Y-m-d</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Timezone</label>
              <select v-model="siteForm.timezone" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                <option>Asia/Kolkata</option><option>Asia/Dhaka</option><option>America/New_York</option><option>Europe/London</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Currency Symbol</label>
              <input v-model="siteForm.currencySymbol" type="text" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Currency Position</label>
              <select v-model="siteForm.currencyPos" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                <option>Left</option><option>Right</option>
              </select>
            </div>
          </div>
          <!-- Toggles -->
          <div class="space-y-4">
            <div v-for="toggle in siteToggles" :key="toggle.key" class="flex items-center justify-between py-3 border-b border-slate-100 dark:border-slate-700 last:border-0">
              <div>
                <p class="text-sm font-medium text-slate-700 dark:text-slate-300">{{ toggle.label }}</p>
                <p class="text-xs text-slate-400 mt-0.5">{{ toggle.desc }}</p>
              </div>
              <button @click="siteForm[toggle.key] = !siteForm[toggle.key]"
                :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors flex-shrink-0', siteForm[toggle.key] ? 'bg-sky-500' : 'bg-slate-300 dark:bg-slate-600']">
                <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', siteForm[toggle.key] ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
              </button>
            </div>
          </div>
          <button @click="save" class="px-5 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">Save Changes</button>
        </div>

        <!-- Order Setup -->
        <div v-if="activeTab === 'order'" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm space-y-5">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4">Order Configuration</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div v-for="f in orderFields" :key="f.key">
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">{{ f.label }}</label>
              <div class="relative">
                <input v-model="orderForm[f.key]" type="number" :placeholder="f.placeholder"
                  class="w-full px-4 py-2.5 pr-16 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
                <span class="absolute right-4 top-1/2 -translate-y-1/2 text-xs text-slate-400 font-medium">{{ f.unit }}</span>
              </div>
            </div>
          </div>
          <!-- Toggles -->
          <div class="space-y-4">
            <div v-for="toggle in orderToggles" :key="toggle.key" class="flex items-center justify-between py-3 border-b border-slate-100 dark:border-slate-700 last:border-0">
              <p class="text-sm font-medium text-slate-700 dark:text-slate-300">{{ toggle.label }}</p>
              <button @click="orderForm[toggle.key] = !orderForm[toggle.key]"
                :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors flex-shrink-0', orderForm[toggle.key] ? 'bg-sky-500' : 'bg-slate-300 dark:bg-slate-600']">
                <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', orderForm[toggle.key] ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
              </button>
            </div>
          </div>
          <button @click="save" class="px-5 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">Save Changes</button>
        </div>

        <!-- Mail Settings -->
        <div v-if="activeTab === 'mail'" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm space-y-5">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4">Mail / SMTP Configuration</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div v-for="f in mailFields" :key="f.key">
              <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">{{ f.label }}</label>
              <input v-model="mailForm[f.key]" :type="f.type || 'text'" :placeholder="f.placeholder"
                class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30" />
            </div>
          </div>
          <div class="flex gap-3">
            <button class="px-5 py-2.5 border border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300 text-sm font-medium rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Test Connection</button>
            <button @click="save" class="px-5 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">Save Changes</button>
          </div>
        </div>

        <!-- Theme settings -->
        <div v-if="activeTab === 'theme'" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm space-y-5">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4">Theme & Branding</h2>
          <div class="grid grid-cols-3 gap-4">
            <div v-for="logoField in ['Logo', 'Favicon', 'Footer Logo']" :key="logoField" class="border-2 border-dashed border-slate-200 dark:border-slate-600 rounded-2xl p-5 text-center hover:border-sky-400 transition-colors cursor-pointer">
              <div class="text-3xl mb-2">🖼️</div>
              <p class="text-sm text-slate-600 dark:text-slate-300 font-medium">{{ logoField }}</p>
              <p class="text-xs text-slate-400 mt-1">Click to upload</p>
            </div>
          </div>
          <button @click="save" class="px-5 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">Save Changes</button>
        </div>

        <!-- Fallback for other tabs -->
        <div v-if="!['company','site','order','mail','theme'].includes(activeTab)" class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
          <h2 class="text-base font-semibold text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-700 pb-4 mb-5">{{ tabs.find(t => t.key === activeTab)?.label }}</h2>
          <div class="py-10 text-center text-slate-500 dark:text-slate-400">
            <Settings class="w-10 h-10 mx-auto mb-3 opacity-30" />
            <p class="font-medium">Configuration panel</p>
            <p class="text-sm mt-1">Settings for this section will appear here.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <Teleport to="body">
      <div v-if="showToast" class="fixed bottom-6 right-6 z-50 bg-emerald-500 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-semibold flex items-center gap-2">
        <CheckCircle class="w-5 h-5" /> Settings saved successfully!
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Building2, Globe, ShoppingBag, Mail, Bell, Shield, Palette, Share2, Settings, CheckCircle } from 'lucide-vue-next'

const activeTab = ref('company')
const showToast = ref(false)

const tabs = [
  { key: 'company', label: 'Company', icon: Building2 },
  { key: 'site', label: 'Site', icon: Globe },
  { key: 'order', label: 'Order Setup', icon: ShoppingBag },
  { key: 'mail', label: 'Mail / SMTP', icon: Mail },
  { key: 'otp', label: 'OTP', icon: Shield },
  { key: 'fcm', label: 'FCM / Push', icon: Bell },
  { key: 'theme', label: 'Theme', icon: Palette },
  { key: 'social', label: 'Social Media', icon: Share2 },
]

const companyFields = [
  { key: 'name', label: 'Company Name', placeholder: 'FoodKing Restaurant' },
  { key: 'email', label: 'Company Email', placeholder: 'info@foodking.com', type: 'email' },
  { key: 'phone', label: 'Phone Number', placeholder: '+1 555-0100' },
  { key: 'website', label: 'Website', placeholder: 'https://foodking.com' },
  { key: 'city', label: 'City', placeholder: 'New York' },
  { key: 'state', label: 'State', placeholder: 'NY' },
  { key: 'country', label: 'Country Code', placeholder: 'US' },
  { key: 'zip', label: 'Zip Code', placeholder: '10001' },
]

const companyForm = reactive({
  name: 'FoodKing Restaurant', email: 'info@foodking.com', phone: '+1 555-0100', website: 'https://foodking.com',
  city: 'New York', state: 'NY', country: 'US', zip: '10001',
})

const siteForm = reactive({
  dateFormat: 'd-m-Y', timezone: 'Asia/Kolkata', currencySymbol: '$', currencyPos: 'Left',
  emailVerification: true, phoneVerification: false, guestLogin: true, languageSwitch: true,
})

const siteToggles = [
  { key: 'emailVerification', label: 'Email Verification', desc: 'Require email verification for new accounts' },
  { key: 'phoneVerification', label: 'Phone Verification', desc: 'Require phone OTP for new accounts' },
  { key: 'guestLogin', label: 'Guest Login', desc: 'Allow customers to check out without an account' },
  { key: 'languageSwitch', label: 'Language Switcher', desc: 'Show language selector on customer website' },
]

const orderForm = reactive({ prepTime: 30, slotDuration: 30, freeDeliveryKm: 2, basicCharge: 1, perKm: 1, takeaway: true, delivery: true })
const orderFields = [
  { key: 'prepTime', label: 'Food Preparation Time', placeholder: '30', unit: 'min' },
  { key: 'slotDuration', label: 'Schedule Slot Duration', placeholder: '30', unit: 'min' },
  { key: 'freeDeliveryKm', label: 'Free Delivery Distance', placeholder: '2', unit: 'km' },
  { key: 'basicCharge', label: 'Basic Delivery Charge', placeholder: '1', unit: '$' },
  { key: 'perKm', label: 'Charge Per Km', placeholder: '1', unit: '$' },
]
const orderToggles = [
  { key: 'takeaway', label: 'Enable Takeaway Orders' },
  { key: 'delivery', label: 'Enable Delivery Orders' },
]

const mailForm = reactive({ mailer: 'smtp', host: 'smtp.gmail.com', port: '587', username: '', password: '', encryption: 'tls', fromName: 'FoodKing', fromEmail: 'no-reply@foodking.com' })
const mailFields = [
  { key: 'host', label: 'SMTP Host', placeholder: 'smtp.gmail.com' },
  { key: 'port', label: 'SMTP Port', placeholder: '587' },
  { key: 'username', label: 'Username', placeholder: 'your@email.com', type: 'email' },
  { key: 'password', label: 'Password', placeholder: '••••••••', type: 'password' },
  { key: 'encryption', label: 'Encryption', placeholder: 'tls' },
  { key: 'fromName', label: 'From Name', placeholder: 'FoodKing' },
  { key: 'fromEmail', label: 'From Email', placeholder: 'no-reply@foodking.com', type: 'email' },
]

const save = () => {
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 2500)
}
</script>
