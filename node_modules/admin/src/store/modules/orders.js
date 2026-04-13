const state = () => ({
  orders: [],
  selectedOrder: null,
  filters: {
    status: null,
    dateRange: null,
    branch: null,
  },
  loading: false,
})

const mutations = {
  SET_ORDERS(state, orders) {
    state.orders = orders
  },
  SET_SELECTED_ORDER(state, order) {
    state.selectedOrder = order
  },
  SET_FILTERS(state, filters) {
    state.filters = { ...state.filters, ...filters }
  },
  SET_LOADING(state, value) {
    state.loading = value
  },
  ADD_ORDER(state, order) {
    state.orders.unshift(order)
  },
  UPDATE_ORDER(state, updatedOrder) {
    const index = state.orders.findIndex(o => o.id === updatedOrder.id)
    if (index !== -1) {
      state.orders[index] = updatedOrder
    }
  },
}

const actions = {
  async fetchOrders({ commit }) {
    commit('SET_LOADING', true)
    // Mock API call
    return new Promise((resolve) => {
      setTimeout(() => {
        const mockOrders = [
          { id: 1, customerId: 1, status: 'pending', total: 250, createdAt: new Date() },
          { id: 2, customerId: 2, status: 'preparing', total: 350, createdAt: new Date() },
        ]
        commit('SET_ORDERS', mockOrders)
        commit('SET_LOADING', false)
        resolve(mockOrders)
      }, 500)
    })
  },

  selectOrder({ commit }, order) {
    commit('SET_SELECTED_ORDER', order)
  },

  updateFilters({ commit }, filters) {
    commit('SET_FILTERS', filters)
  },
}

const getters = {
  allOrders: (state) => state.orders,
  filteredOrders: (state) => {
    // Apply filters logic here
    return state.orders
  },
  orderCount: (state) => state.orders.length,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
