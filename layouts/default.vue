<template>
  <div id="container">
    <nav-header />

    <Nuxt />
  </div>
</template>

<script>
import NavHeader from '@/components/NavHeader.vue';

export default {
  components: {
    NavHeader
  },

  mounted() {
    const { klaytn } = window;
    if(klaytn) {
      klaytn.on('networkChanged', () => {
        alert('네트워크가 변경되었습니다')
        location.reload();
      });
    }
  }
}
</script>

<style>
@font-face {
    font-family: 'neo';
    src: url('/neodgm.ttf') format('truetype');
}

body {
  overflow-x: hidden;
}

#container {
  font-family: 'neo';
  width: 100vw;
  min-height: 100vh;
  background-image: url('/img/water.png');
  color: white;
  display: flex;
  justify-content: center;
  text-align: center;
  font-size: 1.2rem;
  text-shadow: 2px 2px 2px black;
}

.container {
  margin-top: 20vh;
  margin-bottom: 20vh;
  margin-left: 1rem;
  margin-right: 1rem;
  border: 0.3rem solid white;
  border-radius: 1.5rem;
  padding: 2.5rem;
  min-height: 30vh;
  max-width: 650px;
}

.link {
  color: white;
  text-decoration: underline;
  cursor: pointer;
}

#header {
  position: absolute;
  top: 2rem;
}

a:hover {
  color: white;
}
</style>