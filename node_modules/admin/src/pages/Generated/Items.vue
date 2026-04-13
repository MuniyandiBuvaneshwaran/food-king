<template>
  <div class="space-y-5">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Food Items</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Manage your menu items, pricing, addons and availability</p>
      </div>
      <div class="flex items-center gap-3">
        <button class="flex items-center gap-2 px-4 py-2.5 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
          <Upload class="w-4 h-4" /> Import
        </button>
        <button class="flex items-center gap-2 px-4 py-2.5 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
          <Download class="w-4 h-4" /> Export
        </button>
        <button @click="showForm = true; editItem = null; initForm()"
          class="flex items-center gap-2 px-4 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">
          <Plus class="w-4 h-4" /> Add Item
        </button>
      </div>
    </div>

    <!-- Search + Filter -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm flex flex-col sm:flex-row gap-3">
      <div class="relative flex-1">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
        <input v-model="search" type="text" placeholder="Search items..."
          class="w-full pl-9 pr-4 py-2 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
      </div>
      <select v-model="catFilter" class="py-2 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
        <option value="">All Categories</option>
        <option v-for="c in categories" :key="c" :value="c">{{ c }}</option>
      </select>
      <select v-model="availFilter" class="py-2 px-3 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
        <option value="">All Status</option>
        <option value="available">Available</option>
        <option value="unavailable">Unavailable</option>
      </select>
      <!-- View toggle -->
      <div class="flex bg-slate-100 dark:bg-slate-700 rounded-xl p-1 gap-1">
        <button @click="view='grid'" :class="['p-1.5 rounded-lg transition-colors', view === 'grid' ? 'bg-white dark:bg-slate-600 shadow-sm text-sky-600' : 'text-slate-400 hover:text-slate-600']">
          <LayoutGrid class="w-4 h-4" />
        </button>
        <button @click="view='list'" :class="['p-1.5 rounded-lg transition-colors', view === 'list' ? 'bg-white dark:bg-slate-600 shadow-sm text-sky-600' : 'text-slate-400 hover:text-slate-600']">
          <List class="w-4 h-4" />
        </button>
      </div>
    </div>

    <!-- Grid View -->
    <div v-if="view === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
      <div v-for="item in filteredItems" :key="item.id"
        class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden group hover:shadow-lg hover:border-sky-200 dark:hover:border-sky-700 transition-all duration-300">
        <!-- Image -->
        <div class="relative h-44 bg-gradient-to-br from-slate-100 to-slate-200 dark:from-slate-700 dark:to-slate-600 overflow-hidden">
          <div class="absolute inset-0 flex items-center justify-center text-5xl">{{ item.emoji }}</div>
          <!-- Featured badge -->
          <div v-if="item.featured" class="absolute top-3 left-3">
            <span class="bg-amber-400 text-amber-900 text-xs font-bold px-2 py-1 rounded-full flex items-center gap-1">
              <Star class="w-3 h-3" /> Featured
            </span>
          </div>
          <!-- Status badge -->
          <div class="absolute top-3 right-3">
            <span :class="['text-xs font-semibold px-2.5 py-1 rounded-full', item.available ? 'bg-emerald-500 text-white' : 'bg-red-500 text-white']">
              {{ item.available ? 'Available' : 'Unavailable' }}
            </span>
          </div>
          <!-- Actions overlay -->
          <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-3">
            <button @click="editItem = item; showForm = true; initForm(item)" class="p-2 bg-white rounded-xl shadow hover:scale-110 transition-transform" title="Edit">
              <Pencil class="w-4 h-4 text-slate-700" />
            </button>
            <button @click="deleteItem(item)" class="p-2 bg-red-500 rounded-xl shadow hover:scale-110 transition-transform" title="Delete">
              <Trash2 class="w-4 h-4 text-white" />
            </button>
          </div>
        </div>

        <!-- Info -->
        <div class="p-4">
          <div class="flex items-start justify-between mb-1">
            <h3 class="font-semibold text-slate-800 dark:text-white truncate flex-1">{{ item.name }}</h3>
          </div>
          <p class="text-xs text-slate-400 mb-3">{{ item.category }}</p>
          <div class="flex items-center justify-between">
            <div>
              <span v-if="item.discountPrice" class="text-slate-400 line-through text-xs mr-1">${{ item.price }}</span>
              <span class="text-lg font-bold text-sky-600 dark:text-sky-400">${{ item.discountPrice || item.price }}</span>
            </div>
            <button @click="toggleAvailability(item)" :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', item.available ? 'bg-emerald-500' : 'bg-slate-300 dark:bg-slate-600']">
              <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', item.available ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- List View -->
    <div v-else class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
      <table class="w-full text-sm">
        <thead>
          <tr class="bg-slate-50 dark:bg-slate-700/50 border-b border-slate-200 dark:border-slate-700">
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Item</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Category</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Price</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Featured</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Availability</th>
            <th class="text-center px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in filteredItems" :key="item.id" class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors">
            <td class="px-5 py-3.5">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-700 flex items-center justify-center text-xl">{{ item.emoji }}</div>
                <div>
                  <p class="font-medium text-slate-800 dark:text-white">{{ item.name }}</p>
                  <p class="text-xs text-slate-400 truncate max-w-xs">{{ item.description }}</p>
                </div>
              </div>
            </td>
            <td class="px-5 py-3.5">
              <span class="bg-sky-100 dark:bg-sky-900/30 text-sky-700 dark:text-sky-400 text-xs font-medium px-2.5 py-1 rounded-full">{{ item.category }}</span>
            </td>
            <td class="px-5 py-3.5">
              <div>
                <span v-if="item.discountPrice" class="text-slate-400 line-through text-xs">${{ item.price }} </span>
                <span class="font-bold text-slate-800 dark:text-white">${{ item.discountPrice || item.price }}</span>
              </div>
            </td>
            <td class="px-5 py-3.5">
              <span v-if="item.featured" class="bg-amber-100 text-amber-700 text-xs font-medium px-2.5 py-1 rounded-full">⭐ Yes</span>
              <span v-else class="text-slate-400 text-xs">No</span>
            </td>
            <td class="px-5 py-3.5">
              <button @click="toggleAvailability(item)" :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', item.available ? 'bg-emerald-500' : 'bg-slate-300 dark:bg-slate-600']">
                <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', item.available ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
              </button>
            </td>
            <td class="px-5 py-3.5">
              <div class="flex items-center justify-center gap-2">
                <button @click="editItem = item; showForm = true; initForm(item)" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-sky-100 dark:hover:bg-sky-900/30 hover:text-sky-600 transition-colors"><Pencil class="w-4 h-4" /></button>
                <button @click="deleteItem(item)" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-red-100 dark:hover:bg-red-900/30 hover:text-red-600 transition-colors"><Trash2 class="w-4 h-4" /></button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Add/Edit Modal -->
    <Teleport to="body">
      <div v-if="showForm" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="showForm = false">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">{{ editItem ? 'Edit Item' : 'Add New Item' }}</h3>
            <button @click="showForm = false" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
              <X class="w-5 h-5 text-slate-500" />
            </button>
          </div>
          <form @submit.prevent="saveItem" class="p-6 space-y-5">
            <!-- Image Upload Placeholder -->
            <div class="border-2 border-dashed border-slate-300 dark:border-slate-600 rounded-2xl p-8 text-center hover:border-sky-400 dark:hover:border-sky-500 transition-colors cursor-pointer">
              <div class="text-5xl mb-3">📷</div>
              <p class="text-sm font-medium text-slate-600 dark:text-slate-300">Click to upload item image</p>
              <p class="text-xs text-slate-400 mt-1">PNG, JPG, WEBP up to 5MB</p>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="col-span-2">
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Item Name <span class="text-red-400">*</span></label>
                <input v-model="form.name" type="text" placeholder="e.g., Chicken Burger" required
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Category <span class="text-red-400">*</span></label>
                <select v-model="form.category" required class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                  <option value="">Select category</option>
                  <option v-for="c in categories" :key="c" :value="c">{{ c }}</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Tax</label>
                <select v-model="form.tax" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-700 dark:text-slate-300 focus:outline-none focus:ring-2 focus:ring-sky-500/30">
                  <option value="">No Tax</option>
                  <option value="5">5% GST</option>
                  <option value="10">10% VAT</option>
                  <option value="18">18% GST</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Price ($) <span class="text-red-400">*</span></label>
                <input v-model="form.price" type="number" step="0.01" min="0" placeholder="0.00" required
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Discount Price ($)</label>
                <input v-model="form.discountPrice" type="number" step="0.01" min="0" placeholder="0.00"
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Description</label>
                <textarea v-model="form.description" rows="3" placeholder="Describe this item..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition resize-none"></textarea>
              </div>
            </div>

            <!-- Toggles -->
            <div class="flex gap-6">
              <label class="flex items-center gap-3 cursor-pointer select-none">
                <button type="button" @click="form.available = !form.available" :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', form.available ? 'bg-emerald-500' : 'bg-slate-300 dark:bg-slate-600']">
                  <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', form.available ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
                </button>
                <span class="text-sm font-medium text-slate-700 dark:text-slate-300">Available</span>
              </label>
              <label class="flex items-center gap-3 cursor-pointer select-none">
                <button type="button" @click="form.featured = !form.featured" :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', form.featured ? 'bg-amber-500' : 'bg-slate-300 dark:bg-slate-600']">
                  <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', form.featured ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
                </button>
                <span class="text-sm font-medium text-slate-700 dark:text-slate-300">Featured</span>
              </label>
            </div>

            <div class="flex gap-3 pt-2">
              <button type="button" @click="showForm = false" class="flex-1 py-2.5 rounded-xl border border-slate-200 dark:border-slate-600 text-sm font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Cancel</button>
              <button type="submit" class="flex-1 py-2.5 rounded-xl bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold transition-colors shadow-lg shadow-sky-500/20">{{ editItem ? 'Save Changes' : 'Add Item' }}</button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { Search, Plus, Pencil, Trash2, X, Upload, Download, LayoutGrid, List, Star } from 'lucide-vue-next'

const search = ref('')
const catFilter = ref('')
const availFilter = ref('')
const view = ref('grid')
const showForm = ref(false)
const editItem = ref(null)

const form = reactive({ name: '', category: '', price: '', discountPrice: '', description: '', tax: '', available: true, featured: false })

const categories = ['Burgers', 'Pizza', 'Sushi', 'Pasta', 'Salads', 'Desserts', 'Drinks']

const items = ref([
  { id: 1, name: 'Chicken Burger', category: 'Burgers', price: '12.99', discountPrice: '', description: 'Juicy grilled chicken with fresh veggies', emoji: '🍔', available: true, featured: true },
  { id: 2, name: 'Margherita Pizza', category: 'Pizza', price: '14.99', discountPrice: '11.99', description: 'Classic tomato, mozzarella, basil', emoji: '🍕', available: true, featured: false },
  { id: 3, name: 'Salmon Sushi Roll', category: 'Sushi', price: '18.50', discountPrice: '', description: 'Premium fresh salmon, cucumber, avocado', emoji: '🍱', available: true, featured: true },
  { id: 4, name: 'Caesar Salad', category: 'Salads', price: '9.50', discountPrice: '', description: 'Romaine, parmesan, croutons, caesar dressing', emoji: '🥗', available: false, featured: false },
  { id: 5, name: 'Pasta Carbonara', category: 'Pasta', price: '13.50', discountPrice: '', description: 'Creamy egg sauce, pancetta, parmesan', emoji: '🍝', available: true, featured: false },
  { id: 6, name: 'Chocolate Lava Cake', category: 'Desserts', price: '7.99', discountPrice: '', description: 'Warm chocolate cake with molten center', emoji: '🍰', available: true, featured: true },
  { id: 7, name: 'Mango Smoothie', category: 'Drinks', price: '5.50', discountPrice: '', description: 'Fresh mango, yogurt, honey blend', emoji: '🥤', available: true, featured: false },
  { id: 8, name: 'BBQ Bacon Burger', category: 'Burgers', price: '15.99', discountPrice: '13.99', description: 'Double beef patty with smoky BBQ sauce', emoji: '🍔', available: true, featured: false },
])

const filteredItems = computed(() => items.value.filter(i => {
  const matchSearch = !search.value || i.name.toLowerCase().includes(search.value.toLowerCase())
  const matchCat = !catFilter.value || i.category === catFilter.value
  const matchAvail = !availFilter.value || (availFilter.value === 'available' ? i.available : !i.available)
  return matchSearch && matchCat && matchAvail
}))

const toggleAvailability = (item) => { item.available = !item.available }
const deleteItem = (item) => { if (confirm('Delete this item?')) items.value = items.value.filter(i => i.id !== item.id) }

const initForm = (item) => {
  if (item) {
    Object.assign(form, { name: item.name, category: item.category, price: item.price, discountPrice: item.discountPrice, description: item.description, tax: item.tax || '', available: item.available, featured: item.featured })
  } else {
    Object.assign(form, { name: '', category: '', price: '', discountPrice: '', description: '', tax: '', available: true, featured: false })
  }
}

const saveItem = () => {
  if (editItem.value) {
    const i = items.value.find(i => i.id === editItem.value.id)
    if (i) Object.assign(i, { ...form })
  } else {
    items.value.unshift({ id: Date.now(), ...form, emoji: '🍽️' })
  }
  showForm.value = false
}
</script>
