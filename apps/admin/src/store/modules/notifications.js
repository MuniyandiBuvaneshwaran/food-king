const state = () => ({
  notifications: [],
})

const mutations = {
  SET_NOTIFICATIONS(state, notifications) {
    state.notifications = notifications
  },
  ADD_NOTIFICATION(state, notification) {
    state.notifications.push(notification)
  },
  REMOVE_NOTIFICATION(state, id) {
    state.notifications = state.notifications.filter(n => n.id !== id)
  },
}

const actions = {
  addNotification({ commit }, notification) {
    const id = Date.now()
    commit('ADD_NOTIFICATION', { ...notification, id })
    return id
  },

  removeNotification({ commit }, id) {
    commit('REMOVE_NOTIFICATION', id)
  },
}

const getters = {
  allNotifications: (state) => state.notifications,
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters,
}
