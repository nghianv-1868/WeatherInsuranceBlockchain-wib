<template>
  <div id="page-container">
    <div :class="preloadPage ? 'preloader' : ''">
      <svg class="circular" viewBox="25 25 50 50">
        <circle
          class="path"
          cx="50"
          cy="50"
          r="20"
          fill="none"
          stroke-width="2"
          stroke-miterlimit="10"
        />
      </svg>
    </div>
    <div id="et-main-area">
      <div id="main-content">
        <article
          id="post-210302"
          class="post-210302 page type-page status-publish hentry"
        >
          <div class="entry-content">
            <div id="et-boc" class="et-boc">
              <div class="et_builder_inner_content et_pb_gutters3">
                <router-link
                  v-if="manager === account"
                  to="/admin"
                  class="btn-admin"
                  v-b-tooltip.hover
                  title="Page Admin"
                >
                  <i class="fas fa-user-shield"></i>
                </router-link>
                <div class="et_pb_section et_pb_section_0 et_section_regular">
                  <div class="et_pb_row et_pb_row_0" id="introduction">
                    <div
                      class="et_pb_column et_pb_column_4_4 et_pb_column_0 et_pb_css_mix_blend_mode_passthrough et-last-child"
                    >
                      <div
                        class="et_pb_module et_pb_text et_pb_text_0 et_pb_bg_layout_dark et_pb_text_align_center"
                      >
                        <div class="et_pb_text_inner">
                          <h1>
                            <img
                              src="@/assets/images/logo.png"
                              alt="logo"
                              title="logo"
                            />
                          </h1>
                          <h1>Weather Insurance Blockchain</h1>
                          <p>
                            Let choose a suitable insurance package and fill out
                            the information, leaving the rest to us!
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                  <transition name="list">
                    <div
                      class="style-et_pb_row_1-home et_pb_row et_pb_row_1"
                      v-show="show"
                    >
                      <div
                        class="et_pb_column et_pb_column_4_4 et_pb_column_1 et_pb_css_mix_blend_mode_passthrough et-last-child"
                      >
                        <div
                          class="et_pb_with_border et_pb_module et_pb_pricing_tables_0 et_pb_pricing clearfix et_pb_pricing_3 et_pb_no_featured_in_first_row et_pb_pricing_no_bullet"
                        >
                          <div class="et_pb_pricing_table_wrap">
                            <InsurancePack
                              v-for="(pack, index) in packList"
                              :key="index"
                              :price="pack.price"
                              :rate="pack.rate"
                              :compensation="pack.compensation"
                              :description="pack.description"
                              :descDetail="pack.descDetail"
                              :type="pack.type"
                              :index="index"
                              :logo="pack.logo"
                              :colorTitle="pack.colorTitle"
                            ></InsurancePack>
                          </div>
                        </div>
                      </div>
                    </div>
                  </transition>
                </div>
                <div
                  class="et_pb_section et_pb_section_3 et_pb_fullwidth_section et_section_regular"
                >
                  <div
                    class="et_pb_module et_pb_fullwidth_image et_pb_fullwidth_image_0"
                  >
                    <img
                      data-cfsrc="@/assets/images/divider2.jpg"
                      srcset="
                        @/assets/images/divider2.jpg         3000w,
                        @/assets/images/divider2-254x15.jpg   254w,
                        @/assets/images/divider2-533x31.jpg   533w,
                        @/assets/images/divider2-1080x62.jpg 1080w
                      "
                      sizes="(max-width: 3000px) 100vw, 3000px"
                      src="@/assets/images/divider2.jpg"
                    />
                  </div>
                </div>
                <div
                  class="et_pb_section et_pb_section_4 et_pb_with_background et_section_regular my-wib"
                >
                  <div class="et_pb_row et_pb_row_3">
                    <div
                      class="et_pb_module et_pb_text et_pb_text_0 et_pb_bg_layout_dark et_pb_text_align_center"
                    >
                      <div class="et_pb_text_inner" v-if="wibs.length > 0">
                        <h1>My Contract</h1>
                        <hr />
                      </div>
                    </div>
                    <div
                      class="et_pb_column et_pb_column_4_4 et_pb_column_1 et_pb_css_mix_blend_mode_passthrough et-last-child box-wib"
                    >
                      <div
                        class="et_pb_with_border et_pb_module et_pb_pricing_tables_0 et_pb_pricing clearfix et_pb_pricing_3 et_pb_no_featured_in_first_row et_pb_pricing_no_bullet"
                      >
                        <div
                          class="et_pb_pricing_table_wrap"
                          ref="signed"
                          id="signed"
                        >
                          <MyWib
                            v-for="(pack, index) in wibs"
                            :key="index"
                            :instance="pack.instance"
                            :onClick="showModalDetail"
                            :loadingPage="loadingPage"
                            :unLoadingPage="unLoadingPage"
                          ></MyWib>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </article>
      </div>
    </div>
    <div class="table-scroll">
      <div class="cntr">
        <div class="radio-box">
          <label for="opt1" class="radio">
            <input type="radio" name="rdo" id="opt1" class="hidden" />
            <span class="label" @click="scrollTo('#introduction')"></span>
          </label>
        </div>
        <div class="radio-box">
          <label for="opt2" class="radio">
            <input type="radio" name="rdo" id="opt2" class="hidden" />
            <span class="label" @click="scrollTo('#signed')"></span>
          </label>
        </div>
      </div>
    </div>
    <modal
      name="detail-insurance"
      transition="pop-out"
      :scrollable="true"
      height="auto"
    >
      <div class="box">
        <div class="box-part-left" id="bp-left">
          <div class="partition" id="partition-register">
            <div class="partition-title">Detail information</div>
            <div class="row">
              <div class="col-6 map-modal">
                <b-embed
                  type="iframe"
                  aspect="16by9"
                  :class="`mapGoogle`"
                  :src="
                    `https://maps.google.com/maps?amp;hl=en&amp;q=${wibChosen.location}+(My%20Business%20Name)&amp;ie=UTF8&amp;t=h&amp;z=14&amp;iwloc=B&amp;output=embed`
                  "
                ></b-embed>
              </div>
              <div class="col-6">
                <div class="partition-form">
                  <form>
                    <div>
                      <label>Location:</label>
                      <p>
                        <b>{{ wibChosen.nameLocation }}</b>
                      </p>
                    </div>
                    <div>
                      <label>Date:</label>
                      <p>
                        <b>{{ wibChosen.date }}</b>
                      </p>
                    </div>
                    <div>
                      <label>Time:</label>
                      <p>
                        <b
                          >From: {{ wibChosen.timeStart }}h ->
                          {{ wibChosen.timeEnd }}h</b
                        >
                      </p>
                    </div>
                    <div>
                      <label>Type</label>
                      <p>
                        <b>{{ wibChosen.type }}</b>
                      </p>
                    </div>
                  </form>
                  <div style="margin-top: 42px"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </modal>
  </div>
</template>

<script>
/* eslint-disable no-console */
import VueScrollTo from 'vue-scrollto';
import InsurancePack from '@/components/InsurancePack';
import PackList from '@/constants/InsurancePacks';
import MyWib from '@/components/MyWib';
import { mapState, mapActions } from 'vuex';
export default {
  name: 'HomePage',
  components: {
    InsurancePack,
    MyWib,
  },
  data() {
    return {
      preloadPage: true,
      show: false,
      packList: PackList,
      wibChosen: {},
    };
  },
  computed: { ...mapState('contract', ['wibs', 'manager', 'account']) },
  methods: {
    ...mapActions('contract', ['setWeb3', 'initContarct', 'getAllWib']),
    scrollTo(index) {
      return VueScrollTo.scrollTo(index, 500);
    },
    async showModalDetail(event) {
      this.wibChosen = event.wib;
      this.$modal.show('detail-insurance');
    },
    hideModalDetail() {
      this.$modal.hide('detail-insurance');
    },
    loadingPage() {
      this.preloadPage = true;
    },
    unLoadingPage() {
      this.preloadPage = false;
    },
  },

  async created() {
    setTimeout(() => {
      this.preloadPage = false;
    }, 500);
    setTimeout(() => {
      this.show = true;
    }, 100);

    if (this.$route.hash === '#signed') {
      setTimeout(() => {
        this.scrollTo('#signed');
      }, 200);
    }
    await this.setWeb3();
    await this.initContarct();
    await this.getAllWib();
  },
};
</script>
<style lang="scss" scope>
.btn-admin {
  position: fixed;
  color: #eee;
  top: 45vh;
  right: 0.5rem;
  font-size: 1.6rem;
  z-index: 1000;
}
.btn-admin:hover {
  color: #12b5ca;
}
.my-insurance {
  margin-top: 2rem;
}
.et_pb_text_inner > h1 {
  font-family: 'Segoe UI' !important;
  font-weight: bold;
}

.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active,
.list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to /* .list-leave-active below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}

.table-scroll {
  position: fixed;
  z-index: 1000;
  margin-right: 5px;
  top: 50vh;
  right: 0;
}
.radio-box {
  margin-top: 10px;
  margin-bottom: 10px;
}

body {
  font-family: 'Roboto', sans-serif;
}
.radio {
  position: relative;
  cursor: pointer;
  line-height: 20px;
  font-size: 14px;
}
.radio .label {
  position: relative;
  display: block;
  float: left;
  width: 20px;
  height: 20px;
  border: 2px solid white;
  border-radius: 100%;
  -webkit-tap-highlight-color: transparent;
  margin-top: 2rem;
}
.radio .label:after {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 14px;
  height: 10px;
  border-radius: 100%;
  background: #225cff;
  transform: scale(0);
  transition: all 0.2s ease;
  opacity: 0.08;
  pointer-events: none;
}
.radio:hover .label:after {
  transform: scale(3.6);
}
input[type='radio']:checked + .label {
  border-color: #225cff;
}
input[type='radio']:checked + .label:after {
  transform: scale(1);
  transition: all 0.2s cubic-bezier(0.35, 0.9, 0.4, 0.9);
  opacity: 1;
}
.cntr {
  position: relative;
  top: calc(50% - 10px);
  left: 0;
  width: 100%;
  text-align: center;
  border-radius: 10px 10px 10px 10px;
  padding: 5px;
  color: #c8ccd4;
  width: 100%;
}
.hidden {
  display: none;
}
.credit {
  position: fixed;
  right: 20px;
  bottom: 20px;
  transition: all 0.2s ease;
  -webkit-user-select: none;
  user-select: none;
  opacity: 0.6;
}
.credit img {
  width: 72px;
}
.credit:hover {
  transform: scale(0.95);
}

$background_color: #404142;
$github_color: #dba226;
$facebook_color: #3880ff;
.box {
  overflow: hidden;
  width: 100%;
  height: 100%;
  border-radius: 2px;
  color: black;
  font-size: 0;
  .box-part-left {
    display: inline-block;
    position: relative;
    vertical-align: top;
    box-sizing: border-box;
    width: 100%;
    height: 100%;
    &#bp-right {
      border-left: 1px solid #eee;
    }
  }

  .partition {
    width: 100%;
    .partition-title {
      box-sizing: border-box;
      padding: 20px;
      width: 100%;
      text-align: center;
      letter-spacing: 1px;
      font-size: 25px;
      font-weight: 300;
    }
    .partition-form {
      padding: 0 20px;
      box-sizing: border-box;
    }
  }
  label,
  p {
    display: block;
    box-sizing: border-box;
    margin-bottom: 4px;
    width: 100%;
    font-size: 12px;
    line-height: 2;
    border: 0;
    border-bottom: 1px solid #dddedf;
    padding: 4px 8px;
    font-family: inherit;
    transition: 0.5s all;
    outline: none;
  }
  b {
    // margin-left: 1.5rem;
  }
}
.pop-out-enter-active,
.pop-out-leave-active {
  transition: all 0.5s;
}
.pop-out-enter,
.pop-out-leave-active {
  opacity: 0;
  transform: translateY(24px);
}

.et_pb_text_inner > h1 > img {
  width: 6rem;
}

.et_pb_button_wrapper {
  margin-top: 0.6rem;
}
.et_pb_pricing_heading {
  margin-bottom: 1.5rem;
}
.et_pb_pricing_content_top {
  margin-top: 2rem;
}

.et_pb_row_1.et_pb_row {
  // padding-top: 30px !important;
  // margin-top: 60px !important;
  // padding-bottom: 25px;
  padding: 0 !important;
  margin-top: 30px !important;
}
.map-modal {
  padding-top: 40px;
  padding-left: 30px;
  .embed-responsive-16by9 {
    height: 100%;
  }
}
.box-wib {
  margin-top: 2.5rem;
}
.my-wib {
  padding-top: 3rem !important;
}

.style-et_pb_row_1-home {
  padding: 0 !important;
  background: none !important;
}
</style>
