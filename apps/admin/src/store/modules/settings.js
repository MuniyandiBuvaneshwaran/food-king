const state = () => ({
  settings: {},
})

const mutations = {
  SET_SETTINGS(state, settings) {
    state.settings = settings
  },
}

const actions = {
  async fetchSettings({ commit }) {
    return new Promise((resolve) => {
      setTimeout(() => {
        commit('SET_SETTINGS', {})
        resolve()
      }, 500)
    })
  },
}

const getters = {
  allSettings: (state) => state.settings,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
