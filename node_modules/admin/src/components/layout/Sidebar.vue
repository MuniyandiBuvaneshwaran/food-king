<script setup>
import { useStore } from 'vuex'
import { useRoute, useRouter } from 'vue-router'
import { computed } from 'vue'
import {
  LayoutGrid,
  ShoppingCart,
  Package,
  Gift,
  Cog,
  Users,
  BarChart3,
  Settings,
  ChevronRight,
  ChevronLeft,
  ChevronsUpDown,
  Sparkles,
  BadgeCheck,
  CreditCard,
  Bell,
  LogOut,
} from 'lucide-vue-next'
import {
  DropdownMenuRoot,
  DropdownMenuTrigger,
  DropdownMenuPortal,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
} from 'reka-ui'
import Button from '@/components/ui/button.vue'

const store = useStore()
const route = useRoute()
const router = useRouter()

const isCollapsed = computed(() => store.getters['ui/isSidebarCollapsed'])
const fallbackUser = {
  name: 'shadcn',
  email: 'm@example.com',
}
const currentUser = computed(() => {
  const authUser = store.getters['auth/currentUser']
  return {
    name: authUser?.name || fallbackUser.name,
    email: authUser?.email || fallbackUser.email,
  }
})
const userInitials = computed(() => {
  const parts = currentUser.value.name.split(' ').filter(Boolean)
  if (parts.length >= 2) {
    return `${parts[0][0]}${parts[1][0]}`.toUpperCase()
  }
  return currentUser.value.name.slice(0, 2).toUpperCase()
})

const toggleSidebar = () => {
  store.dispatch('ui/toggleSidebar')
}

const navItems = [
  { label: 'Dashboard', path: '/admin/dashboard', icon: LayoutGrid },
  { label: 'Online Orders', path: '/admin/online-orders', icon: ShoppingCart },
  { label: 'POS Terminal', path: '/admin/pos-terminal', icon: Package },
  { label: 'Items', path: '/admin/items', icon: Package },
  { label: 'Branches', path: '/admin/branches', icon: Users },
  { label: 'Customers', path: '/admin/customers', icon: Users },
  { label: 'Offers', path: '/admin/offers', icon: Gift },
  { label: 'Reports', path: '/admin/reports/sales', icon: BarChart3 },
  { label: 'Settings', path: '/admin/settings', icon: Settings },
]

const isActive = (path) => {
  return route.path.startsWith(path)
}

const navigateToSettings = () => {
  router.push('/settings')
}

const handleLogout = async () => {
  await store.dispatch('auth/logout')
  router.push('/login')
}
</script>

<template>
  <aside
    class="sticky top-0 hidden md:flex flex-col bg-white/40 backdrop-blur-xl border-r border-white/40 transition-all duration-300 h-screen z-40 shadow-[4px_0_24px_rgba(0,0,0,0.02)]"
    :style="{
      width: isCollapsed ? 'var(--sidebar-collapsed)' : 'var(--sidebar-width)',
    }"
  >
    <!-- Logo Section with Toggle Button -->
    <div
      class="flex items-center justify-between border-b border-white/40 flex-shrink-0 px-2 transition-all duration-300"
      :style="{ height: 'var(--header-height)' }"
    >
      <!-- Creative Logo -->
      <div class="flex items-center gap-3 flex-1 transition-all duration-300">
        <div
          class="relative flex items-center justify-center w-10 h-10 rounded-xl shadow-lg overflow-hidden transition-all duration-300"
        >
          <!-- Gradient Background -->
          <div class="absolute inset-0 bg-gradient-to-br from-sky-400 via-sky-500 to-sky-600"></div>
          
          <!-- Creative Fork and Plate Design -->
          <svg class="w-6 h-6 relative z-10 text-white" viewBox="0 0 24 24" fill="currentColor">
            <!-- Plate/Circle -->
            <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="1.5" opacity="0.8"/>
            
            <!-- Fork Prongs -->
            <path d="M 9 5 L 9 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            <path d="M 12 5 L 12 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            <path d="M 15 5 L 15 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
            
            <!-- Fork Handle -->
            <path d="M 9 14 Q 12 15 15 14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" fill="none"/>
          </svg>
        </div>

        <!-- Text -->
        <div v-if="!isCollapsed" class="flex transition-all duration-300">
          <span class="font-bold text-base bg-gradient-to-r from-sky-600 to-sky-500 bg-clip-text text-transparent justify-center">
            FoodKing
          </span>
        </div>
      </div>

      <!-- Toggle Button -->
      <Button
        variant="ghost"
        size="icon"
        @click="toggleSidebar"
        class="flex-shrink-0 transition-all duration-300 hover:bg-sky-50"
      >
        <ChevronLeft v-if="!isCollapsed" class="h-5 w-5 text-sky-600 transition-transform duration-300" />
        <ChevronRight v-else class="h-5 w-5 text-sky-600 transition-transform duration-300" />
      </Button>
    </div>

    <!-- Navigation Items -->
    <nav class="flex-1 overflow-y-auto p-2 space-y-1">
      <RouterLink
        v-for="item in navItems"
        :key="item.path"
        :to="item.path"
        :class="[
          'flex items-center gap-3 px-3 py-2 rounded-md transition-all duration-200',
          isActive(item.path)
            ? 'bg-white/60 text-sky-700 shadow-sm border border-white/60 font-semibold backdrop-blur-sm'
            : 'text-slate-600 hover:text-sky-700 hover:bg-white/40 border border-transparent',
        ]"
        :title="item.label"
      >
        <component :is="item.icon" class="w-5 h-5 flex-shrink-0 transition-colors duration-200" />
        <span v-if="!isCollapsed" class="text-sm font-medium truncate transition-all duration-200">
          {{ item.label }}
        </span>
      </RouterLink>
    </nav>

    <div class="border-t border-white/40 p-2">
      <DropdownMenuRoot>
        <DropdownMenuTrigger as-child>
          <button
            type="button"
            :class="[
              'flex w-full items-center gap-3 rounded-xl border border-white/40 bg-white/30 py-2 shadow-sm transition-all hover:bg-white/60 hover:shadow focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-500/50',
              isCollapsed ? 'justify-center px-0' : 'px-2.5',
            ]"
            aria-label="Open account menu"
          >
            <div
              class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-fuchsia-500 via-indigo-500 to-sky-500 text-xs font-semibold text-white shadow-sm"
            >
              {{ userInitials }}
            </div>

            <template v-if="!isCollapsed">
              <div class="flex-1 text-left leading-tight min-w-0">
                <p class="truncate text-sm font-semibold text-slate-900">{{ currentUser.name }}</p>
                <p class="truncate text-xs text-slate-500">{{ currentUser.email }}</p>
              </div>
              <ChevronsUpDown class="h-4 w-4 shrink-0 text-slate-500" />
            </template>
          </button>
        </DropdownMenuTrigger>

        <DropdownMenuPortal>
          <DropdownMenuContent
            side="right"
            align="end"
            :side-offset="10"
            class="z-50 min-w-[15rem] overflow-hidden rounded-xl border border-slate-200 bg-white p-0 text-slate-900 shadow-xl"
          >
            <div class="flex items-center gap-3 border-b border-slate-200 px-3 py-3">
              <div
                class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-fuchsia-500 via-indigo-500 to-sky-500 text-xs font-semibold text-white shadow-sm"
              >
                {{ userInitials }}
              </div>
              <div class="leading-tight flex-1 min-w-0">
                <p class="truncate text-sm font-semibold">{{ currentUser.name }}</p>
                <p class="truncate text-xs text-slate-500">{{ currentUser.email }}</p>
              </div>
            </div>

            <div class="py-1">
              <DropdownMenuItem
                class="flex cursor-pointer items-center gap-2 rounded-none px-3 py-2 text-sm outline-none transition-colors data-[highlighted]:bg-slate-100"
                @select="navigateToSettings"
              >
                <Sparkles class="h-4 w-4 text-slate-600" />
                <span>Upgrade to Pro</span>
              </DropdownMenuItem>
              <DropdownMenuItem
                class="flex cursor-pointer items-center gap-2 rounded-none px-3 py-2 text-sm outline-none transition-colors data-[highlighted]:bg-slate-100"
                @select="navigateToSettings"
              >
                <BadgeCheck class="h-4 w-4 text-slate-600" />
                <span>Account</span>
              </DropdownMenuItem>
              <DropdownMenuItem
                class="flex cursor-pointer items-center gap-2 rounded-none px-3 py-2 text-sm outline-none transition-colors data-[highlighted]:bg-slate-100"
                @select="navigateToSettings"
              >
                <CreditCard class="h-4 w-4 text-slate-600" />
                <span>Billing</span>
              </DropdownMenuItem>
              <DropdownMenuItem
                class="flex cursor-pointer items-center gap-2 rounded-none px-3 py-2 text-sm outline-none transition-colors data-[highlighted]:bg-slate-100"
                @select="navigateToSettings"
              >
                <Bell class="h-4 w-4 text-slate-600" />
                <span>Notifications</span>
              </DropdownMenuItem>
            </div>

            <DropdownMenuSeparator class="h-px bg-slate-200" />

            <div class="py-1">
              <DropdownMenuItem
                class="flex cursor-pointer items-center gap-2 rounded-none px-3 py-2 text-sm outline-none transition-colors data-[highlighted]:bg-red-50 data-[highlighted]:text-red-700"
                @select="handleLogout"
              >
                <LogOut class="h-4 w-4" />
                <span>Log out</span>
              </DropdownMenuItem>
            </div>
          </DropdownMenuContent>
        </DropdownMenuPortal>
      </DropdownMenuRoot>
    </div>
  </aside>
</template>

<style scoped>
aside {
  scrollbar-width: thin;
  scrollbar-color: rgb(203, 213, 225) transparent;
}

aside::-webkit-scrollbar {
  width: 4px;
}

aside::-webkit-scrollbar-track {
  background: transparent;
}

aside::-webkit-scrollbar-thumb {
  background-color: rgb(203, 213, 225);
  border-radius: 2px;
}

a.router-link-active {
  background-color: rgb(224, 242, 254);
  color: rgb(8, 85, 157);
  border-left: 4px solid rgb(14, 165, 233);
}
</style>
