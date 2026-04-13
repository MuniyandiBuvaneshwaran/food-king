<template>
  <header class="sticky top-0 z-40 w-full  shadow-sm">
    <div class="flex items-center justify-center h-16 px-8">

      <!-- Center: Search -->
      <div class="flex-1 max-w-md mx-8 justify-center">
        <Input
          type="text"
          placeholder="Search..."
          class="bg-slate-50"
        />
      </div>
    </div>
  </header>
</template>

<script setup>
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ref } from 'vue'
import { Menu, Eye, LogOut } from 'lucide-vue-next'
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'

const store = useStore()
const router = useRouter()

const currentUser = ref({
  name: 'Admin User',
  email: 'admin@foodking.com',
})

const handleLogout = async () => {
  await store.dispatch('auth/logout')
  router.push('/login')
}
</script>

<style scoped>
header {
  background-color: white;
}

h1 {
  margin: 0;
}
</style>
