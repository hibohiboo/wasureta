import moment from '~/plugins/moment'

export const state = () => ({
  posts: []
})

export const getters = {
  posts: state => state.posts.map(post => Object.assign({ likes: [] }, post))
}

export const mutations = {
  addPost(state, { post }) {
    state.posts.push(post)
  },
  updatePost(state, { post }) {
    state.posts = state.posts.map(p => (p.id === post.id ? post : p))
  },
  clearPosts(state) {
    state.posts = []
  }
}

export const actions = {
  async publishPost({ commit }, { payload }) {
    const user = await this.$axios.$get(
      `/mypages/users/${payload.user.id}.json`
    )
    // firebaseが割り宛てたランダムな英字の投稿データIDを取得する
    const post_id = (await this.$axios.$post('/mypages/posts.json', payload))
      .name
    const created_at = moment().format()
    const post = { id: post_id, ...payload, created_at }
    const putData = { id: post_id, ...payload, created_at }
    delete putData.user
    await this.$axios.$put(`/mypages/users/${user.id}/posts.json`, [
      ...(user.posts || []),
      putData
    ])
    commit('addPost', { post })
  },

}
