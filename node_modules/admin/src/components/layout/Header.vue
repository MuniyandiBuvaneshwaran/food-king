<template>
  <header class="sticky top-0 z-40 w-full shadow-sm bg-white/60 backdrop-blur-md border-b border-gray-200 dark:bg-slate-900/60 dark:border-slate-800 transition-colors duration-300">
    <div class="flex items-center justify-between h-16 px-8">
      <!-- Search focus -->
      <div class="flex-1 max-w-md">
        <Input
          type="text"
          placeholder="Search..."
          class="bg-slate-50 dark:bg-slate-800 dark:text-slate-100 border-none w-full"
        />
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-4">
        <!-- RTL Toggle -->
        <Button variant="ghost" size="sm" @click="toggleRTL" title="Toggle RTL">
          <Languages class="w-5 h-5 text-slate-600 dark:text-slate-300" />
          <span class="ml-2 font-medium {{ isRTL ? 'text-sky-600' : '' }} text-slate-600 dark:text-slate-300">AR</span>
        </Button>
        
        <!-- Dark Mode Toggle -->
        <Button variant="ghost" size="icon" @click="toggleTheme" title="Toggle Theme">
          <Sun v-if="!isDark" class="w-5 h-5 text-amber-500" />
          <Moon v-else class="w-5 h-5 text-indigo-400" />
        </Button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ref, onMounted } from 'vue'
import { Sun, Moon, Languages } from 'lucide-vue-next'
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'

const store = useStore()
const router = useRouter()

const isDark = ref(false)
const isRTL = ref(false)

const toggleTheme = () => {
  isDark.value = !isDark.value
  if (isDark.value) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

const toggleRTL = () => {
  isRTL.value = !isRTL.value
  if (isRTL.value) {
    document.documentElement.setAttribute('dir', 'rtl')
  } else {
    document.documentElement.setAttribute('dir', 'ltr')
  }
}

onMounted(() => {
  if (document.documentElement.classList.contains('dark')) isDark.value = true
  if (document.documentElement.getAttribute('dir') === 'rtl') isRTL.value = true
})
</script>
