<template>
  <div>
    <nav-header />

    <div id="container">
      <Nuxt />
    </div>
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
  font-family: 'neo';
  color: white;
  text-align: center;
  font-size: 1.2rem;
  text-shadow: 2px 2px 2px black;
  overflow-x: hidden;
  background-image: url('/img/water.png');
  width: 100vw;
  min-height: 100vh;
}

#container {
  display: flex;
  justify-content: center;
}

.container {
  margin-top: 10vh;
  margin-bottom: 10vh;
  margin-left: 1rem;
  margin-right: 1rem;
  border: 0.3rem solid white;
  border-radius: 1.5rem;
  padding: 2.5rem;
  min-height: 30vh;
  max-width: 650px;
  background-color: rgba(0, 0, 0, 0.4);
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