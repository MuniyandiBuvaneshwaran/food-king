<template>
  <div class="min-h-screen bg-slate-50 dark:bg-slate-950">
    <nav class="sticky top-0 z-50 bg-white/90 dark:bg-slate-950/90 backdrop-blur-xl border-b border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <RouterLink to="/profile" class="flex items-center gap-2 text-slate-600 dark:text-slate-300 hover:text-orange-500 transition-colors"><ChevronLeft class="w-5 h-5" /> Back</RouterLink>
        <h1 class="font-bold text-slate-900 dark:text-white">Saved Addresses</h1>
        <button @click="showForm = true; editing = null; initForm()" class="text-sm text-orange-500 hover:text-orange-400 font-semibold flex items-center gap-1"><Plus class="w-4 h-4" /> Add</button>
      </div>
    </nav>

    <div class="max-w-2xl mx-auto px-4 sm:px-6 py-8 space-y-4">
      <!-- Address cards -->
      <div v-for="addr in addresses" :key="addr.id"
        :class="['bg-white dark:bg-slate-900 rounded-2xl border-2 shadow-sm p-5 transition-all', addr.default ? 'border-orange-400' : 'border-slate-200 dark:border-slate-800']">
        <div class="flex items-start gap-4">
          <div :class="['w-11 h-11 rounded-2xl flex items-center justify-center flex-shrink-0', addr.default ? 'bg-orange-100 dark:bg-orange-900/30' : 'bg-slate-100 dark:bg-slate-800']">
            <span class="text-xl">{{ addr.emoji }}</span>
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1">
              <h3 class="font-bold text-slate-900 dark:text-white">{{ addr.label }}</h3>
              <span v-if="addr.default" class="bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 text-xs font-bold px-2 py-0.5 rounded-full">Default</span>
            </div>
            <p class="text-sm text-slate-500 dark:text-slate-400 leading-relaxed">{{ addr.full }}</p>
            <p class="text-xs text-slate-400 mt-1">{{ addr.landmark }}</p>
          </div>
        </div>
        <div class="flex items-center gap-2 mt-4 pt-4 border-t border-slate-100 dark:border-slate-800">
          <button v-if="!addr.default" @click="setDefault(addr.id)" class="text-xs font-semibold text-slate-500 dark:text-slate-400 hover:text-orange-500 transition-colors px-3 py-1.5 rounded-lg hover:bg-orange-50 dark:hover:bg-orange-900/20">Set as Default</button>
          <div class="flex-1"></div>
          <button @click="editing = addr; showForm = true; initForm(addr)" class="flex items-center gap-1.5 text-xs font-semibold text-sky-600 dark:text-sky-400 px-3 py-1.5 rounded-lg bg-sky-50 dark:bg-sky-900/20 hover:bg-sky-100 transition-colors">
            <Pencil class="w-3.5 h-3.5" /> Edit
          </button>
          <button @click="deleteAddr(addr.id)" class="flex items-center gap-1.5 text-xs font-semibold text-red-500 px-3 py-1.5 rounded-lg bg-red-50 dark:bg-red-900/20 hover:bg-red-100 transition-colors">
            <Trash2 class="w-3.5 h-3.5" /> Delete
          </button>
        </div>
      </div>

      <!-- Empty state -->
      <div v-if="addresses.length === 0" class="text-center py-20">
        <div class="text-7xl mb-4">📍</div>
        <h3 class="text-xl font-bold text-slate-700 dark:text-slate-300 mb-2">No addresses saved</h3>
        <p class="text-slate-400 mb-6">Add a delivery address to speed up checkout.</p>
        <button @click="showForm = true; editing = null; initForm()" class="px-6 py-3 bg-orange-500 text-white font-bold rounded-2xl hover:bg-orange-400 transition-all shadow-lg">Add New Address</button>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <Teleport to="body">
      <div v-if="showForm" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-end sm:items-center justify-center p-4" @click.self="showForm = false">
        <div class="bg-white dark:bg-slate-800 rounded-3xl shadow-2xl w-full max-w-md max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between p-5 border-b border-slate-200 dark:border-slate-700">
            <h3 class="font-bold text-slate-900 dark:text-white text-lg">{{ editing ? 'Edit Address' : 'New Address' }}</h3>
            <button @click="showForm = false" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"><X class="w-5 h-5 text-slate-500" /></button>
          </div>
          <div class="p-5 space-y-4">
            <!-- Type selector -->
            <div>
              <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-2 uppercase tracking-wide">Address Type</label>
              <div class="flex gap-2">
                <button v-for="t in addrTypes" :key="t.key" @click="addrForm.type = t.key"
                  :class="['flex items-center gap-2 px-3 py-2 rounded-xl border-2 text-sm font-semibold transition-all', addrForm.type === t.key ? 'border-orange-400 bg-orange-50 dark:bg-orange-900/20 text-orange-600' : 'border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300']">
                  <span>{{ t.emoji }}</span> {{ t.label }}
                </button>
              </div>
            </div>
            <div v-for="f in formFields" :key="f.key">
              <label class="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 uppercase tracking-wide">{{ f.label }}</label>
              <input v-model="addrForm[f.key]" :type="f.type || 'text'" :placeholder="f.placeholder"
                class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-orange-400/50 transition" />
            </div>
            <!-- Default toggle -->
            <div class="flex items-center justify-between pt-1">
              <div>
                <p class="text-sm font-medium text-slate-700 dark:text-slate-300">Set as default</p>
                <p class="text-xs text-slate-400">Use this address by default at checkout</p>
              </div>
              <button type="button" @click="addrForm.isDefault = !addrForm.isDefault"
                :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', addrForm.isDefault ? 'bg-orange-500' : 'bg-slate-300 dark:bg-slate-600']">
                <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', addrForm.isDefault ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
              </button>
            </div>
            <div class="flex gap-3 pt-2">
              <button @click="showForm = false" class="flex-1 py-2.5 border border-slate-200 dark:border-slate-600 text-slate-600 dark:text-slate-300 text-sm font-semibold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Cancel</button>
              <button @click="saveAddr" class="flex-1 py-2.5 bg-orange-500 hover:bg-orange-400 text-white text-sm font-bold rounded-xl transition-all shadow-lg active:scale-95">{{ editing ? 'Save Changes' : 'Add Address' }}</button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ChevronLeft, Plus, Pencil, Trash2, X } from 'lucide-vue-next'

const showForm = ref(false)
const editing = ref(null)

const addrTypes = [
  { key: 'home', emoji: '🏠', label: 'Home' },
  { key: 'office', emoji: '🏢', label: 'Office' },
  { key: 'other', emoji: '📍', label: 'Other' },
]

const formFields = [
  { key: 'addressLine1', label: 'Address Line 1', placeholder: '123 Main Street, Apt 4B' },
  { key: 'addressLine2', label: 'Address Line 2 (optional)', placeholder: 'Building, Floor, Landmark' },
  { key: 'city', label: 'City', placeholder: 'New York' },
  { key: 'state', label: 'State', placeholder: 'NY' },
  { key: 'zip', label: 'Zip Code', placeholder: '10001' },
]

const addrForm = reactive({ type: 'home', addressLine1: '', addressLine2: '', city: '', state: '', zip: '', isDefault: false })

const addresses = ref([
  { id: 1, emoji: '🏠', label: 'Home', full: '123 Main Street, Apt 4B, New York, NY 10001', landmark: 'Near Central Park', default: true },
  { id: 2, emoji: '🏢', label: 'Office', full: '456 Park Avenue, Floor 12, New York, NY 10022', landmark: 'Midtown Manhattan', default: false },
])

const initForm = (addr) => {
  if (addr) {
    Object.assign(addrForm, { type: addr.emoji === '🏠' ? 'home' : 'office', addressLine1: addr.full, addressLine2: addr.landmark, city: '', state: '', zip: '', isDefault: addr.default })
  } else {
    Object.assign(addrForm, { type: 'home', addressLine1: '', addressLine2: '', city: '', state: '', zip: '', isDefault: false })
  }
}

const setDefault = (id) => { addresses.value.forEach(a => { a.default = a.id === id }) }
const deleteAddr = (id) => { if (confirm('Delete this address?')) addresses.value = addresses.value.filter(a => a.id !== id) }
const saveAddr = () => {
  if (editing.value) {
    const a = addresses.value.find(a => a.id === editing.value.id)
    if (a) { a.full = addrForm.addressLine1; a.landmark = addrForm.addressLine2 }
  } else {
    const typeMap = { home: '🏠', office: '🏢', other: '📍' }
    const labelMap = { home: 'Home', office: 'Office', other: 'Other' }
    addresses.value.push({ id: Date.now(), emoji: typeMap[addrForm.type], label: labelMap[addrForm.type], full: `${addrForm.addressLine1}, ${addrForm.city}, ${addrForm.state} ${addrForm.zip}`, landmark: addrForm.addressLine2, default: addrForm.isDefault })
    if (addrForm.isDefault) setDefault(addresses.value[addresses.value.length - 1].id)
  }
  showForm.value = false
}
</script>
