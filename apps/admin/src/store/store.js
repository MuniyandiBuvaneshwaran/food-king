import { createStore } from 'vuex'
import * as modules from './index'

export function createStoreInstance() {
  return createStore({
    modules: {
      auth: modules.auth,
      orders: modules.orders,
      items: modules.items,
      customers: modules.customers,
      dashboard: modules.dashboard,
      settings: modules.settings,
      notifications: modules.notifications,
      ui: modules.ui,
    },
  })
}

export default createStoreInstance
