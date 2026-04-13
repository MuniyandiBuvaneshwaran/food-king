const state = () => ({
  customers: [],
  loading: false,
})

const mutations = {
  SET_CUSTOMERS(state, customers) {
    state.customers = customers
  },
  SET_LOADING(state, value) {
    state.loading = value
  },
}

const actions = {
  async fetchCustomers({ commit }) {
    commit('SET_LOADING', true)
    return new Promise((resolve) => {
      setTimeout(() => {
        commit('SET_CUSTOMERS', [])
        commit('SET_LOADING', false)
        resolve()
      }, 500)
    })
  },
}

const getters = {
  allCustomers: (state) => state.customers,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
