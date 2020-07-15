<template>
  <div id="page-container">
    <div id="et-main-area">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
/* eslint-disable no-console */
export default {
  name: 'CommonLayout'
};
</script>
<style lang="scss" scope>
@import '../assets/css/style.css';
@import '../assets/css/et-core-unified-15749750804049.min.css';
@import '../assets/fontawesome-free-5.11.2-web/css/all.min.css';
body {
  font-family: 'Poppins', sans-serif !important;
}
</style>
