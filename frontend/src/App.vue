<template>
  <div id="app">
    <router-view></router-view>
    <!-- {{ this.setWeb3() }} -->
  </div>
</template>

<script>
/* eslint-disable no-console */
import { mapState, mapActions } from 'vuex';
export default {
  name: 'app',
  components: {},
  computed: { ...mapState('contract', ['web3']) },
  methods: {
    ...mapActions('contract', [
      'setWeb3',
      'initContarct',
      'getAllWib',
      'getAllWibsByAdmin',
    ]),
  },
  async mounted() {
    await this.setWeb3();
    await this.initContarct();
    await this.getAllWib();
    await this.getAllWibsByAdmin();
  },
};
</script>

<style>
a {
  text-decoration: none !important;
}

/*Preloader*/
.preloader {
  width: 100%;
  height: 100%;
  top: 0px;
  position: fixed;
  z-index: 99999;
  background: #00051b;
  opacity: 0.9;
}

.preloader .cssload-speeding-wheel {
  position: absolute;
  top: calc(50% - 3.5px);
  left: calc(50% - 3.5px);
}

.circular {
  animation: rotate 2s linear infinite;
  height: 50px;
  transform-origin: center center;
  width: 50px;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
}

svg:not(:root) {
  overflow: hidden;
}

.path {
  stroke-dasharray: 1, 200;
  stroke-dashoffset: 0;
  animation: dash 1.5s ease-in-out infinite, color 6s ease-in-out infinite;
  stroke-linecap: round;
}

@keyframes rotate {
  100% {
    transform: rotate(360deg);
  }
}

@keyframes dash {
  0% {
    stroke-dasharray: 1, 200;
    stroke-dashoffset: 0;
  }

  50% {
    stroke-dasharray: 89, 200;
    stroke-dashoffset: -35px;
  }

  100% {
    stroke-dasharray: 89, 200;
    stroke-dashoffset: -124px;
  }
}

@keyframes color {
  100%,
  0% {
    stroke: #d62d20;
  }

  40% {
    stroke: #0057e7;
  }

  66% {
    stroke: #008744;
  }

  80%,
  90% {
    stroke: #ffa700;
  }
}
</style>
