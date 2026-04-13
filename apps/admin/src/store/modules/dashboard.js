const state = () => ({
  stats: {
    totalOrders: 0,
    totalRevenue: 0,
    pendingOrders: 0,
    activeDeliveryBoys: 0,
  },
  recentOrders: [],
  loading: false,
})

const mutations = {
  SET_STATS(state, stats) {
    state.stats = stats
  },
  SET_RECENT_ORDERS(state, orders) {
    state.recentOrders = orders
  },
  SET_LOADING(state, value) {
    state.loading = value
  },
}

const actions = {
  async fetchDashboardData({ commit }) {
    commit('SET_LOADING', true)
    return new Promise((resolve) => {
      setTimeout(() => {
        commit('SET_STATS', {
          totalOrders: 1256,
          totalRevenue: 125600,
          pendingOrders: 24,
          activeDeliveryBoys: 8,
        })
        commit('SET_RECENT_ORDERS', [])
        commit('SET_LOADING', false)
        resolve()
      }, 500)
    })
  },
}

const getters = {
  dashboardStats: (state) => state.stats,
  recentOrders: (state) => state.recentOrders,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
