<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useStore } from 'vuex'
import MainLayout from './components/layout/MainLayout.vue'

const router = useRouter()
const route = useRoute()
const store = useStore()

const isAuthRoute = computed(() => {
  return route.path === '/login' || route.path === '/forgot-password'
})

const isAuthenticated = computed(() => {
  return store.getters['auth/isAuthenticated']
})
</script>

<template>
  <MainLayout v-if="!isAuthRoute && isAuthenticated" />
  <RouterView v-else />
</template>

<style scoped></style>

