const state = () => ({
  items: [],
  categories: [],
  loading: false,
})

const mutations = {
  SET_ITEMS(state, items) {
    state.items = items
  },
  SET_CATEGORIES(state, categories) {
    state.categories = categories
  },
  SET_LOADING(state, value) {
    state.loading = value
  },
  ADD_ITEM(state, item) {
    state.items.push(item)
  },
  UPDATE_ITEM(state, updatedItem) {
    const index = state.items.findIndex(i => i.id === updatedItem.id)
    if (index !== -1) {
      state.items[index] = updatedItem
    }
  },
  DELETE_ITEM(state, itemId) {
    state.items = state.items.filter(i => i.id !== itemId)
  },
}

const actions = {
  async fetchItems({ commit }) {
    commit('SET_LOADING', true)
    return new Promise((resolve) => {
      setTimeout(() => {
        commit('SET_ITEMS', [])
        commit('SET_LOADING', false)
        resolve()
      }, 500)
    })
  },

  async fetchCategories({ commit }) {
    commit('SET_LOADING', true)
    return new Promise((resolve) => {
      setTimeout(() => {
        commit('SET_CATEGORIES', [])
        commit('SET_LOADING', false)
        resolve()
      }, 500)
    })
  },
}

const getters = {
  allItems: (state) => state.items,
  allCategories: (state) => state.categories,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
