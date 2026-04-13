const state = () => ({
  user: null,
  token: localStorage.getItem('token') || null,
  isLoggedIn: !!localStorage.getItem('token'),
  role: null,
  error: null,
})

const mutations = {
  SET_USER(state, user) {
    state.user = user
  },
  SET_TOKEN(state, token) {
    state.token = token
    if (token) {
      localStorage.setItem('token', token)
    } else {
      localStorage.removeItem('token')
    }
  },
  SET_LOGGED_IN(state, value) {
    state.isLoggedIn = value
  },
  SET_ROLE(state, role) {
    state.role = role
  },
  SET_ERROR(state, error) {
    state.error = error
  },
  CLEAR_AUTH(state) {
    state.user = null
    state.token = null
    state.isLoggedIn = false
    state.role = null
    state.error = null
    localStorage.removeItem('token')
  },
}

const actions = {
  login({ commit }, credentials) {
    commit('SET_ERROR', null)
    // Mock login - will be replaced with actual API call
    return new Promise((resolve) => {
      setTimeout(() => {
        const token = 'mock-token-' + Date.now()
        commit('SET_TOKEN', token)
        commit('SET_USER', { id: 1, email: credentials.email, name: 'Admin User' })
        commit('SET_ROLE', 'admin')
        commit('SET_LOGGED_IN', true)
        resolve()
      }, 500)
    })
  },

  logout({ commit }) {
    commit('CLEAR_AUTH')
    return Promise.resolve()
  },

  resetPassword({ commit }, email) {
    commit('SET_ERROR', null)
    return Promise.resolve()
  },
}

const getters = {
  isAuthenticated: (state) => state.isLoggedIn,
  currentUser: (state) => state.user,
  userRole: (state) => state.role,
  authToken: (state) => state.token,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
