<template>
  <section class="container">
    <div>
      <h3>Nuxt.js のタグが付けられた投稿の一覧</h3>
      <ul>
        <li v-for="item in items" :key="item.id">
          <h4>
            <span>{{item.title}} </span>
            <small>
              <span>by </span>
              <nuxt-link :to="`/users/${item.user.id}`">
                {{item.user.id}}
              </nuxt-link>
            </small>
          </h4>
          <div>{{item.body.slice(0, 130)}}……</div>
          <p><a target="_blank" :href="item.url">{{item.url}}</a></p>
        </li>
      </ul>
    </div>
  </section>
</template>

<script>
export default {
  // サーバサイドレンダリングをdata関数を拡張したasyncDataで行う。nuxt.jsの独自実装。
  async asyncData({ app }) {
    // コンポーネントの初期化前に行われる = thisへのアクセスができない
    const items= await app.$axios.$get('https://qiita.com/api/v2/items?query=tag:nuxt.js&page=1&per_page=1')
    return {
      items
    }
  },
}
</script>

<style>
.container {
  min-height: 100vh;
  padding: 16px;
}
h3 {
  margin: 16px 0;
  padding: 8px 0;
  border-bottom: solid 1px #e5e5e5;
}
li + li {
  margin: 16px 0;
}
p {
  margin: 8px 0;
}
</style>

