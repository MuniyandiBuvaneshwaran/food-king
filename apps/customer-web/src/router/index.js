import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: () => import('../pages/Generated/Home.vue') },
  { path: '/menu', component: () => import('../pages/Generated/Menu.vue') },
  { path: '/menu/:id', component: () => import('../pages/Generated/ItemDetail.vue') },
  { path: '/cart', component: () => import('../pages/Generated/Cart.vue') },
  { path: '/checkout', component: () => import('../pages/Generated/Checkout.vue') },
  { path: '/orders', component: () => import('../pages/Generated/OrderHistory.vue') },
  { path: '/orders/:id/track', component: () => import('../pages/Generated/OrderTracking.vue') },
  { path: '/profile', component: () => import('../pages/Generated/Profile.vue') },
  { path: '/addresses', component: () => import('../pages/Generated/Addresses.vue') },
  { path: '/notifications', component: () => import('../pages/Generated/Notifications.vue') },
  { path: '/login', component: () => import('../pages/Generated/Auth.vue') },
  { path: '/register', component: () => import('../pages/Generated/Auth.vue') },
  { path: '/page/:slug', component: () => import('../pages/Generated/StaticPage.vue') },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0 } },
})

export default router
