<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useStore } from 'vuex'
import MainLayout from './components/layout/MainLayout.vue'

const route = useRoute()
const store = useStore()

// Routes that don't use the admin layout
const noLayoutRoutes = ['/login', '/forgot-password', '/admin/kds', '/admin/oss']

const isAuthRoute = computed(() => {
  return route.path === '/login' || route.path === '/forgot-password'
})

const isFullScreenRoute = computed(() => {
  return ['/admin/kds', '/admin/oss'].includes(route.path)
})

const isAuthenticated = computed(() => {
  // During mock/development: always show layout
  return true
})

const showLayout = computed(() => !isAuthRoute.value)
</script>

<template>
  <RouterView v-if="isAuthRoute" />
  <RouterView v-else-if="isFullScreenRoute" />
  <MainLayout v-else />
</template>

<style scoped></style>
