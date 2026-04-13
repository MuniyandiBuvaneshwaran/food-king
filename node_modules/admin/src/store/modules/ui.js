const state = () => ({
  sidebarCollapsed: false,
  theme: 'light',
})

const mutations = {
  TOGGLE_SIDEBAR(state) {
    state.sidebarCollapsed = !state.sidebarCollapsed
  },
  SET_SIDEBAR_COLLAPSED(state, value) {
    state.sidebarCollapsed = value
  },
  SET_THEME(state, theme) {
    state.theme = theme
  },
}

const actions = {
  toggleSidebar({ commit }) {
    commit('TOGGLE_SIDEBAR')
  },

  setSidebarCollapsed({ commit }, value) {
    commit('SET_SIDEBAR_COLLAPSED', value)
  },

  setTheme({ commit }, theme) {
    commit('SET_THEME', theme)
  },
}

const getters = {
  isSidebarCollapsed: (state) => state.sidebarCollapsed,
  currentTheme: (state) => state.theme,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
