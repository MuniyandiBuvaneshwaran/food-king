<template>
  <div class="space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Dining Tables</h1>
        <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">Manage dine-in tables and QR codes</p>
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
        <input v-model="search" type="text" placeholder="Search dining tables..."
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
        <p class="font-medium">No dining tables found</p>
      </div>
    </div>

    <!-- Modal -->
    <Teleport to="body">
      <div v-if="showForm" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4" @click.self="showForm = false">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">{{ editItem ? 'Edit' : 'Add New' }} {{ 'Dining Tables'.replace(/s$/, '') }}</h3>
            <button @click="showForm = false" class="p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700"><X class="w-5 h-5 text-slate-500" /></button>
          </div>
          <div class="p-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Table Name</label>
                <input type="text" placeholder="Table Name..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Slug</label>
                <input type="text" placeholder="Slug..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Branch</label>
                <input type="text" placeholder="Branch..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1.5">Capacity</label>
                <input type="text" placeholder="Capacity..."
                  class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl text-sm text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-sky-500/30 transition" />
              </div>
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
const rows = ref([
      {
            "id": 1,
            "name": "Table 1",
            "slug": "T001",
            "branch": "Main Branch",
            "capacity": 4,
            "status": true
      },
      {
            "id": 2,
            "name": "Table 2",
            "slug": "T002",
            "branch": "Main Branch",
            "capacity": 2,
            "status": true
      },
      {
            "id": 3,
            "name": "Table 7",
            "slug": "T007",
            "branch": "Downtown Branch",
            "capacity": 6,
            "status": true
      },
      {
            "id": 4,
            "name": "Table 12",
            "slug": "T012",
            "branch": "Mall Branch",
            "capacity": 8,
            "status": false
      }
])
const filteredRows = computed(() => rows.value.filter(r => !search.value || r.name.toLowerCase().includes(search.value.toLowerCase())))
</script>
