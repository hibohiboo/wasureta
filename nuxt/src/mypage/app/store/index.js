export const state = () => ({
  isLoggedIn: false,
  user: null
})

export const getters = {
  isLoggedIn: state => state.isLoggedIn,
  user: state => (state.user ? Object.assign({ likes: [] }, state.user) : null)
}

export const mutations = {
  setUser(state, { user }) {
    state.user = user
    state.isLoggedIn = true
  }
}

export const actions = {
  async login({ commit }, { id }) {
    const user = await this.$axios.$get(`/mypages/users/${id}.json`)
    console.log(user)
    if (!user.id) throw new Error('Invalid user')
    commit('setUser', { user })
  },
  async register({ commit }, { id }) {
    const payload = {}
    payload[id] = { id }
    await this.$axios.$patch(`/mypages/users.json`, payload)
    const user = await this.$axios.$get(`/mypages/users/${id}.json`)
    if (!user.id) throw new Error('Invalid user')
    commit('setUser', { user })
  },
  async addLikeLogToUser({ commit }, { user, post }) {
    user.likes.push({
      created_at: moment().format(),
      user_id: user.id,
      post_id: post.id
    })
    const newUser = await this.$axios.$put(
      `/mypages/users/${user.id}.json`,
      user
    )
    commit('updateUser', { user: newUser })
  },
  async removeLikeLogToUser({ commit }, { user, post }) {
    user.likes = post.likes.filter(like => like.user_id !== user.id) || []
    const newUser = await this.$axios.$put(
      `/mypages/users/${user.id}.json`,
      user
    )
    commit('updateUser', { user: newUser })
  }
}
