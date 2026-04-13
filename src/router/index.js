import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login',
  },
  {
    path: '/login',
    component: () => import('../pages/auth/Login.vue'),
    meta: { requiresAuth: false },
  },
  {
    path: '/forgot-password',
    component: () => import('../pages/auth/ForgotPassword.vue'),
    meta: { requiresAuth: false },
  },
  {
    path: '/dashboard',
    component: () => import('../pages/Dashboard.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/orders',
    component: () => import('../pages/Orders/Index.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/orders/:id',
    component: () => import('../pages/Orders/Detail.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/catalog/items',
    component: () => import('../pages/Catalog/Items.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/catalog/categories',
    component: () => import('../pages/Catalog/Categories.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/settings',
    component: () => import('../pages/Settings.vue'),
    meta: { requiresAuth: true },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('token')

  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  } else if (to.path === '/login' && isAuthenticated) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
