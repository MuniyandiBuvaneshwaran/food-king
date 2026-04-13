const fs = require('fs')
const path = require('path')

// Bulk generate remaining admin screens that need real implementations
const screens = [
  {
    file: 'Branches.vue',
    title: 'Branches',
    desc: 'Manage restaurant branches',
    fields: ['Name', 'Email', 'Phone', 'Address', 'City', 'State', 'Country Code', 'Zip', 'Latitude', 'Longitude'],
    rows: [
      { id: 1, name: 'Main Branch', email: 'main@foodking.com', phone: '+1 555-0100', city: 'New York', status: true, orders: 1284, emoji: '🏪' },
      { id: 2, name: 'Downtown Branch', email: 'downtown@foodking.com', phone: '+1 555-0200', city: 'Brooklyn', status: true, orders: 842, emoji: '🏬' },
      { id: 3, name: 'Mall Branch', email: 'mall@foodking.com', phone: '+1 555-0300', city: 'Queens', status: false, orders: 421, emoji: '🏢' },
    ]
  },
  {
    file: 'DeliveryBoys.vue',
    title: 'Delivery Boys',
    desc: 'Manage delivery personnel',
    fields: ['Name', 'Email', 'Phone', 'Branch', 'Password'],
    rows: [
      { id: 1, name: 'Alex Martinez', email: 'alex@delivery.com', phone: '+1 555-1001', branch: 'Main Branch', status: true, orders: 84, rating: 4.8, emoji: '🚴' },
      { id: 2, name: 'Ryan Thompson', email: 'ryan@delivery.com', phone: '+1 555-1002', branch: 'Downtown Branch', status: true, orders: 71, rating: 4.6, emoji: '🛵' },
      { id: 3, name: 'James Wilson', email: 'james@delivery.com', phone: '+1 555-1003', branch: 'Main Branch', status: false, orders: 52, rating: 4.2, emoji: '🚲' },
    ]
  },
  {
    file: 'Coupons.vue',
    title: 'Coupons',
    desc: 'Manage discount coupons',
    fields: ['Code', 'Discount Type', 'Discount Amount', 'Min Order Amount', 'Max Discount', 'Start Date', 'End Date', 'Usage Limit'],
    rows: [
      { id: 1, code: 'FOODKING20', type: 'Percentage', amount: '20%', minOrder: '$30', maxDiscount: '$15', used: 142, limit: 500, expires: 'Apr 30, 2026', status: true },
      { id: 2, code: 'FLAT10', type: 'Fixed', amount: '$10', minOrder: '$25', maxDiscount: '-', used: 88, limit: 200, expires: 'May 15, 2026', status: true },
      { id: 3, code: 'NEWUSER50', type: 'Percentage', amount: '50%', minOrder: '$20', maxDiscount: '$25', used: 24, limit: 1000, expires: 'Dec 31, 2026', status: false },
    ]
  },
  {
    file: 'Offers.vue',
    title: 'Special Offers',
    desc: 'Manage promotional offers',
    fields: ['Name', 'Description', 'Discount Type', 'Discount Amount', 'Applicable To', 'Start Date', 'End Date'],
    rows: [
      { id: 1, name: 'Weekend Special', type: 'Percentage', amount: '15%', applicableTo: 'All Items', start: 'Apr 12', end: 'Apr 13', status: true, emoji: '🎉' },
      { id: 2, name: 'Burger Bonanza', type: 'Fixed', amount: '$5', applicableTo: 'Burgers', start: 'Apr 10', end: 'Apr 20', status: true, emoji: '🍔' },
      { id: 3, name: 'Pizza Party', type: 'Percentage', amount: '25%', applicableTo: 'Pizza', start: 'Apr 15', end: 'Apr 22', status: false, emoji: '🍕' },
    ]
  },
  {
    file: 'DiningTables.vue',
    title: 'Dining Tables',
    desc: 'Manage dine-in tables and QR codes',
    fields: ['Table Name', 'Slug', 'Branch', 'Capacity'],
    rows: [
      { id: 1, name: 'Table 1', slug: 'T001', branch: 'Main Branch', capacity: 4, status: true },
      { id: 2, name: 'Table 2', slug: 'T002', branch: 'Main Branch', capacity: 2, status: true },
      { id: 3, name: 'Table 7', slug: 'T007', branch: 'Downtown Branch', capacity: 6, status: true },
      { id: 4, name: 'Table 12', slug: 'T012', branch: 'Mall Branch', capacity: 8, status: false },
    ]
  },
  {
    file: 'ItemCategories.vue',
    title: 'Item Categories',
    desc: 'Organize your menu into categories',
    fields: ['Category Name', 'Description', 'Sort Position'],
    rows: [
      { id: 1, name: 'Burgers', items: 8, status: true, emoji: '🍔' },
      { id: 2, name: 'Pizza', items: 6, status: true, emoji: '🍕' },
      { id: 3, name: 'Sushi', items: 12, status: true, emoji: '🍱' },
      { id: 4, name: 'Pasta', items: 5, status: true, emoji: '🍝' },
      { id: 5, name: 'Salads', items: 4, status: false, emoji: '🥗' },
      { id: 6, name: 'Desserts', items: 7, status: true, emoji: '🍰' },
      { id: 7, name: 'Drinks', items: 10, status: true, emoji: '🥤' },
    ]
  },
]

const generateCRUDScreen = (s) => {
  const rowsJSON = JSON.stringify(s.rows, null, 6)
  const fieldsHTML = s.fields.map(f => `
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">${f}</label>
                <input type="text" placeholder="${f}..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>`).join('')

  return `<template>
  <div class="space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">${s.title}</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">${s.desc}</p>
      </div>
      <button @click="showForm = true; editItem = null"
        class="flex items-center gap-2 px-4 py-2.5 bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold rounded-xl transition-all shadow-lg shadow-sky-500/20">
        <Plus class="w-4 h-4" /> Add New
      </button>
    </div>

    <!-- Search -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-4 shadow-sm flex gap-3">
      <div class="relative flex-1">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
        <input v-model="search" type="text" placeholder="Search ${s.title.toLowerCase()}..."
          class="w-full pl-9 pr-4 py-2 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
      </div>
    </div>

    <!-- Table -->
    <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden">
      <table class="w-full text-sm">
        <thead>
          <tr class="bg-slate-50 dark:bg-slate-700/50 border-b border-slate-200 dark:border-slate-700">
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Name</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Details</th>
            <th class="text-left px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Status</th>
            <th class="text-center px-5 py-3.5 text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in filteredRows" :key="row.id"
            class="border-t border-slate-100 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors">
            <td class="px-5 py-3.5">
              <div class="flex items-center gap-3">
                <span v-if="row.emoji" class="text-2xl">{{ row.emoji }}</span>
                <div>
                  <p class="font-semibold text-slate-800 dark:text-white">{{ row.name }}</p>
                  <p v-if="row.email" class="text-xs text-slate-400">{{ row.email }}</p>
                  <p v-if="row.phone" class="text-xs text-slate-400">{{ row.phone }}</p>
                </div>
              </div>
            </td>
            <td class="px-5 py-3.5">
              <div class="text-sm text-slate-600 dark:text-slate-300 space-y-0.5">
                <p v-if="row.city">{{ row.city }}</p>
                <p v-if="row.branch">{{ row.branch }}</p>
                <p v-if="row.type">Type: {{ row.type }}</p>
                <p v-if="row.amount">{{ row.amount }}</p>
                <p v-if="row.slug" class="font-mono text-xs">{{ row.slug }}</p>
                <p v-if="row.capacity">Cap: {{ row.capacity }} seats</p>
                <p v-if="row.items !== undefined">{{ row.items }} items</p>
                <p v-if="row.orders !== undefined">{{ row.orders }} {{ row.rating ? 'orders · ⭐' + row.rating : 'orders' }}</p>
              </div>
            </td>
            <td class="px-5 py-3.5">
              <button @click="row.status = !row.status" :class="['relative inline-flex h-5 w-9 items-center rounded-full transition-colors', row.status ? 'bg-emerald-500' : 'bg-slate-300 dark:bg-slate-600']">
                <span :class="['inline-block h-3.5 w-3.5 rounded-full bg-white shadow-md transform transition-transform', row.status ? 'translate-x-4.5' : 'translate-x-0.5']"></span>
              </button>
            </td>
            <td class="px-5 py-3.5">
              <div class="flex items-center justify-center gap-1.5">
                <button @click="editItem = row; showForm = true" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-sky-100 dark:hover:bg-sky-900/30 hover:text-sky-600 transition-colors"><Pencil class="w-4 h-4" /></button>
                <button @click="rows = rows.filter(r => r.id !== row.id)" class="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-red-100 dark:hover:bg-red-900/30 hover:text-red-600 transition-colors"><Trash2 class="w-4 h-4" /></button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <div v-if="filteredRows.length === 0" class="py-16 text-center text-slate-500 dark:text-slate-400">
        <p class="font-medium">No ${s.title.toLowerCase()} found</p>
      </div>
    </div>

    <!-- Modal -->
    <Teleport to="body">
      <div v-if="showForm" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="showForm = false">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">{{ editItem ? 'Edit' : 'Add New' }} {{ '${s.title}'.replace(/s$/, '') }}</h3>
            <button @click="showForm = false" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700"><X class="w-5 h-5 text-slate-500" /></button>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              ${fieldsHTML}
            </div>
            <div class="flex gap-3 mt-6">
              <button @click="showForm = false" class="flex-1 py-2.5 rounded-xl border border-slate-200 dark:border-slate-600 text-sm font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">Cancel</button>
              <button @click="showForm = false" class="flex-1 py-2.5 rounded-xl bg-sky-500 hover:bg-sky-400 text-white text-sm font-semibold transition-colors shadow-lg shadow-sky-500/20">{{ editItem ? 'Save Changes' : 'Add' }}</button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Plus, Pencil, Trash2, X } from 'lucide-vue-next'

const search = ref('')
const showForm = ref(false)
const editItem = ref(null)
const rows = ref(${rowsJSON})
const filteredRows = computed(() => rows.value.filter(r => !search.value || r.name.toLowerCase().includes(search.value.toLowerCase())))
</script>
`
}

screens.forEach(s => {
  const outPath = path.join(__dirname, 'apps', 'admin', 'src', 'pages', 'Generated', s.file)
  fs.writeFileSync(outPath, generateCRUDScreen(s))
  console.log(`Generated: ${s.file}`)
})

console.log('Bulk CRUD screens done!')
