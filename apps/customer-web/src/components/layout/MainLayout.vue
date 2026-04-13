<script setup>
import { useStore } from 'vuex'
import Header from './Header.vue'
import Sidebar from './Sidebar.vue'

const store = useStore()
</script>

<template>
  <div class="flex min-h-screen bg-gradient-to-br from-indigo-50/50 via-sky-50/50 to-emerald-50/50 relative overflow-hidden text-slate-900">
    <!-- Decorative background blobs -->
    <div class="absolute top-[-20%] left-[-10%] w-[60%] h-[60%] rounded-full bg-sky-200/40 blur-[120px] pointer-events-none mix-blend-multiply"></div>
    <div class="absolute bottom-[-10%] right-[-10%] w-[50%] h-[70%] rounded-full bg-purple-200/40 blur-[120px] pointer-events-none mix-blend-multiply"></div>
    <div class="absolute top-[20%] right-[20%] w-[30%] h-[30%] rounded-full bg-emerald-200/30 blur-[100px] pointer-events-none mix-blend-multiply"></div>

    <!-- Sidebar (z-10 ensures it is above background) -->
    <div class="relative z-10 flex">
      <Sidebar />
    </div>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col relative z-10 h-screen overflow-hidden">
      <!-- Header -->
      <Header />

      <!-- Main Content Area -->
      <main class="flex-1 overflow-auto">
        <div class="p-8">
          <RouterView />
        </div>
      </main>
    </div>
  </div>
</template>

<style scoped>
.bg-gray-light {
  background-color: var(--gray-light);
}

.p-page-padding {
  padding: var(--page-padding);
}
</style>
