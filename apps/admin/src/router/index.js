import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('../pages/Generated/Login.vue'), meta: { requiresAuth: false } },
  { 
    path: '/admin', 
    component: () => import('../components/layout/PassThrough.vue'),
    meta: { requiresAuth: true },
    children: [
      { path: 'dashboard', component: () => import('../pages/Generated/Dashboard.vue') },
      
      // Orders
      { path: 'online-orders', component: () => import('../pages/Generated/OnlineOrders.vue') },
      { path: 'online-orders/:id', component: () => import('../pages/Generated/OnlineOrderDetail.vue') },
      { path: 'pos-orders', component: () => import('../pages/Generated/POSOrders.vue') },
      { path: 'pos-orders/:id', component: () => import('../pages/Generated/POSOrderDetail.vue') },
      { path: 'table-orders', component: () => import('../pages/Generated/TableOrders.vue') },
      { path: 'table-orders/:id', component: () => import('../pages/Generated/TableOrderDetail.vue') },
      
      // Terminals/Screens
      { path: 'pos-terminal', component: () => import('../pages/Generated/POSTerminal.vue') },
      { path: 'kds', component: () => import('../pages/Generated/KitchenDisplaySystem.vue') },
      { path: 'oss', component: () => import('../pages/Generated/OrderStatusScreen.vue') },
      
      // Catalog
      { path: 'items', component: () => import('../pages/Generated/Items.vue') },
      { path: 'items/create', component: () => import('../pages/Generated/ItemForm.vue') },
      { path: 'items/:id/edit', component: () => import('../pages/Generated/ItemForm.vue') },
      { path: 'categories', component: () => import('../pages/Generated/ItemCategories.vue') },
      { path: 'categories/create', component: () => import('../pages/Generated/CategoryForm.vue') },
      { path: 'addons', component: () => import('../pages/Generated/Addons.vue') },
      { path: 'addons/create', component: () => import('../pages/Generated/AddonForm.vue') },
      
      // Branch & Table Mgt
      { path: 'branches', component: () => import('../pages/Generated/Branches.vue') },
      { path: 'branches/create', component: () => import('../pages/Generated/BranchForm.vue') },
      { path: 'dining-tables', component: () => import('../pages/Generated/DiningTables.vue') },
      { path: 'dining-tables/create', component: () => import('../pages/Generated/DiningTableForm.vue') },
      { path: 'kiosk-machines', component: () => import('../pages/Generated/KioskMachines.vue') },
      { path: 'kiosk-machines/create', component: () => import('../pages/Generated/KioskMachineForm.vue') },
      
      // Users
      { path: 'customers', component: () => import('../pages/Generated/Customers.vue') },
      { path: 'customers/:id', component: () => import('../pages/Generated/CustomerDetail.vue') },
      { path: 'delivery-boys', component: () => import('../pages/Generated/DeliveryBoys.vue') },
      { path: 'delivery-boys/create', component: () => import('../pages/Generated/DeliveryBoyForm.vue') },
      { path: 'administrators', component: () => import('../pages/Generated/Administrators.vue') },
      { path: 'administrators/create', component: () => import('../pages/Generated/AdministratorForm.vue') },
      { path: 'employees', component: () => import('../pages/Generated/Employees.vue') },
      { path: 'employees/create', component: () => import('../pages/Generated/EmployeeForm.vue') },
      
      // Marketing
      { path: 'coupons', component: () => import('../pages/Generated/Coupons.vue') },
      { path: 'coupons/create', component: () => import('../pages/Generated/CouponForm.vue') },
      { path: 'offers', component: () => import('../pages/Generated/Offers.vue') },
      { path: 'offers/create', component: () => import('../pages/Generated/OfferForm.vue') },
      { path: 'sliders', component: () => import('../pages/Generated/Sliders.vue') },
      { path: 'pages', component: () => import('../pages/Generated/Pages.vue') },
      { path: 'subscribers', component: () => import('../pages/Generated/Subscribers.vue') },
      { path: 'messages', component: () => import('../pages/Generated/Messages.vue') },
      
      // Configuration
      { path: 'payment-gateways', component: () => import('../pages/Generated/PaymentGateways.vue') },
      { path: 'sms-gateways', component: () => import('../pages/Generated/SmsGateways.vue') },
      { path: 'push-notifications', component: () => import('../pages/Generated/PushNotifications.vue') },
      { path: 'time-slots', component: () => import('../pages/Generated/TimeSlots.vue') },
      { path: 'currencies', component: () => import('../pages/Generated/Currencies.vue') },
      { path: 'languages', component: () => import('../pages/Generated/Languages.vue') },
      { path: 'roles', component: () => import('../pages/Generated/RolesPermissions.vue') },
      
      // Reports
      { path: 'reports/sales', component: () => import('../pages/Generated/SalesReport.vue') },
      { path: 'reports/items', component: () => import('../pages/Generated/ItemsReport.vue') },
      { path: 'reports/credits', component: () => import('../pages/Generated/CreditBalanceReport.vue') },
      
      // Settings
      { path: 'settings', component: () => import('../pages/Generated/Settings.vue') },
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('token')

  // TEMPORARILY DISABLED AUTH REQUIREMENT FOR MOCK UI VIEWING
  // if (to.meta.requiresAuth && !isAuthenticated) {
  //   next('/login')
  // } else if (to.path === '/login' && isAuthenticated) {
  //   next('/admin/dashboard')
  // } else {
    next()
  // }
})

export default router
