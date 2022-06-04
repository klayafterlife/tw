<template>
  <div id="header">
    <a class="col-4 link" @click="goToPage('/')">메인</a>
    <a class="col-4 link" @click="goToPage('/mint')">포획</a>
    <a class="col-4 link" @click="goToPage('/camouflage')">보호색</a>
    <a class="col-4 link" @click="goToPage('/adventure')">탐험</a>

    <div class="mt-4">
      <a class="col-4 link" href="https://discord.gg/RtXGG5jxuu" target="_blank">디스코드</a>
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