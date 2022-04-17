<template>
  <div id="header">
    <a class="col-4 link disable" @click="goToPage('/')">보호색</a>
    <a class="col-4 link disable" @click="goToPage('/')">낚시</a>

    <div class="mt-4">
      <a class="col-4 link" href="https://twitter.com/blanky_nftdev" target="_blank">트위터</a>
      <a class="col-4 link" href="https://opensea.io/collection/tinywhales" target="_blank">오픈씨</a>
      <a class="col-4 link" href="https://klu.bs/pfp/0x2089CFC532195E9568608fD0E8aD7Ab5e4cfDc91" target="_blank">클럽스</a>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    goToPage(page) {
      this.$router.push(page);
    }
  }
}
</script>

<style scoped>
.disable {
  color: grey;
  text-decoration: none;
  cursor: auto;
}
</style>