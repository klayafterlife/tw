<template>
  <nav class="navbar">
    <div :class="['navbar__logo', { 'active': navOpen }]" @click="goToPage('/')">
      <img src="/img/whale.png" alt="logo">
    </div>

    <ul :class="['navbar__menu', { 'active': navOpen }]">
      <li><a @click="goToPage('/mint')">포획</a></li>
      <li><a @click="goToPage('/camouflage')">보호색</a></li>
      <li><a @click="goToPage('/adventure')">탐험</a></li>
    </ul>

    <ul :class="['navbar__sns', { 'active': navOpen }]">
      <li>
        <a href="https://klu.bs/pfp/0x2089CFC532195E9568608fD0E8aD7Ab5e4cfDc91" target="_blank">
          <img src="/img/klubs.png" alt="klubs">
        </a>
      </li>
      <li>
        <a href="https://opensea.io/collection/tinywhales" target="_blank">
          <img src="/img/opensea.png" alt="opensea">
        </a>
      </li>
      <li>
        <a href="https://pala.world/square/project/2089CFC532195E9568608fD0E8aD7Ab5e4cfDc91" target="_blank">
          <img id="pala" src="/img/pala.png" alt="pala">
        </a>
      </li>
      <li>
        <a href="https://discord.gg/RtXGG5jxuu" target="_blank">
          <img src="/img/discord.png" alt="discord">
        </a>
      </li>
      <li>
        <a href="https://twitter.com/blanky_nftdev" target="_blank">
          <img src="/img/twitter.png" alt="twitter">
        </a>
      </li>
    </ul>

    <a class="navbar__toggleBtn" @click="navTogle">
      <img src="/img/menu.svg" alt="menu">
    </a>
  </nav>
</template>

<script>
export default {
  data() {
    return {
      navOpen: false
    }
  },

  methods: {
    navTogle() {
      this.navOpen = !this.navOpen;
    },

    goToPage(page) {
      this.$router.push(page);
      this.navOpen = false;
    }
  }
}
</script>

<style scoped>
:root {
  --text-color: #f0f4f5;
  --background-color: #000a12;
  --accent-color: #ffa726;
}
body {
  margin: 0;
}
a {
  text-decoration: none;
  color: var(--text-color);
}
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: var(--background-color);
  padding: 12px 24px;
  background-color: rgba(0, 0, 0, 0.4);

}
.navbar__logo {
  display: flex;
  flex: 1;
}
.navbar__logo img {
  width: 48px;
}
.navbar__menu {
  display: flex;
  list-style: none;
  padding-left: 0;
  margin-top: 1rem;
  justify-content: center;
  flex: 3;
}
.navbar__menu li {
  padding: 0 24px;
}
.navbar__menu li:hover {
  background-color: var(--accent-color);
  border-radius: 4px;
}
.navbar__sns {
  list-style: none;
  display: flex;
  padding-left: 0;
  margin-top: 1rem;
  flex: 1;
  justify-content: flex-end;
}
.navbar__sns li {
  padding: 0px 12px;
}
.navbar__sns img {
  width: 32px;
  height: 32px;
}
.navbar__toggleBtn {
  display: none;
  position: absolute;
  right: 32px;
  font-size: 24px;
  padding: 6px 0;
  color: var(--accent-color);
}
@media screen and (max-width: 768px) {
  .navbar {
    flex-direction: column;
    align-items: flex-start;
    padding: 8px 24px;
  }
  .navbar__menu {
    display: none;
    flex-direction: column;
    align-items: center;
    width: 100%;
  }
  .navbar__menu li {
    width: 100%;
    text-align: center;
    padding: 0.5rem 0;
  }
  .navbar__sns {
    display: none;
    justify-content: center;
    width: 100%;
    }
  .navbar__toggleBtn {
    display: block;
  }
  .navbar__menu.active,
  .navbar__sns.active {
    display: flex;
  }
}

#pala {
  border-radius: 70%;
}
</style>