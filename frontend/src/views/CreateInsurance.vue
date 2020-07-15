<template>
  <div id="main-content">
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
    <article id="post-210302" class="post-210302 page type-page status-publish hentry">
      <div class="entry-content">
        <div id="et-boc" class="et-boc">
          <div class="et_builder_inner_content et_pb_gutters3">
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
                        <router-link to="/">
                          <img src="@/assets/images/logo.png" alt="logo" title="logo" width="96" />
                        </router-link>
                      </h1>
                    </div>
                  </div>
                </div>
              </div>
              <div class="et_pb_row et_pb_row_1 et_pb_row_1_create">
                <a class="fill-button">
                  <router-link class="fill-button-hover" tag="span" to="/">
                    <span class="fill-button-text">
                      <i class="fas fa-home">Home</i>
                    </span>
                  </router-link>
                </a>
                <form-wizard
                  @on-complete="onComplete"
                  shape="circle"
                  color="#20a0ff"
                  error-color="#ff4949"
                >
                  <h3 slot="title" class="title-form">Insurance Details</h3>
                  <h5 slot="title" class="title-form">{{ this.contractInsurance.descDetail }}</h5>
                  <tab-content
                    title="Address"
                    icon="fas fa-map-marked"
                    :before-change="validateFirstStep"
                  >
                    <b-row>
                      <div class="col-12">
                        <el-form ref="validate1" :model="contractInsurance">
                          <el-form-item
                            label="Address Event:"
                            prop="address"
                            :rules="[
                              {
                                required: true,
                                message: 'Please enter address',
                              },
                            ]"
                          >
                            <el-input
                              v-model="contractInsurance.address"
                              placeholder="Enter Address"
                            ></el-input>
                          </el-form-item>
                        </el-form>
                      </div>
                      <div class="col-12">
                        <b-embed
                          type="iframe"
                          aspect="16by9"
                          :class="`mapGoogle`"
                          :src="
                            `https://maps.google.com/maps?amp;hl=en&amp;q=${contractInsurance.address}+(My%20Business%20Name)&amp;ie=UTF8&amp;t=h&amp;z=14&amp;iwloc=B&amp;output=embed`
                          "
                        ></b-embed>
                      </div>
                    </b-row>
                  </tab-content>
                  <tab-content
                    title="Time"
                    icon="far fa-calendar-alt"
                    :before-change="validateSecondsStep"
                  >
                    <el-form ref="validate2" :model="contractInsurance">
                      <div>
                        <b-row>
                          <div class="col-12 col-md-4 time-choose">
                            <b-form-group
                              label="Enter Date:"
                              label-for="input"
                              class="mx-auto color-white"
                            >
                              <date-picker
                                v-model="contractInsurance.date"
                                tpye="date"
                                placeholder="Select date"
                                :disabled-date="notBeforeTenDay"
                                style="width:100%"
                                :class="!checkFrom2.date ? 'input__inner' : ''"
                                value-type="format"
                              />
                              <div
                                class="el-form-item__error col"
                                style="text-align: left"
                                v-if="!checkFrom2.date"
                              >Please enter date</div>
                            </b-form-group>
                          </div>
                          <div class="col-12 col-md-4 time-choose">
                            <b-form-group
                              label="Enter Time Start:"
                              label-for="input"
                              class="color-white"
                            >
                              <date-picker
                                value-type="format"
                                v-model="contractInsurance.timeStart"
                                type="time"
                                placeholder="Select time start"
                                format="H"
                                style="width:100%"
                                :class="
                                  !checkFrom2.timeStart ? 'input__inner' : ''
                                "
                              />
                              <div
                                class="el-form-item__error col"
                                style="text-align: left"
                                v-if="!checkFrom2.timeStart"
                              >Please enter time start</div>
                            </b-form-group>
                          </div>
                          <div class="col-12 col-md-4 time-choose">
                            <b-form-group
                              label="Enter Time End:"
                              label-for="input"
                              class="color-white"
                            >
                              <date-picker
                                value-type="format"
                                v-model="contractInsurance.timeEnd"
                                type="time"
                                placeholder="Select time end"
                                format="H"
                                style="width:100%"
                                :disabled="!contractInsurance.timeStart"
                                :disabled-time="notBeforeStart"
                                :class="
                                  !checkFrom2.timeEnd ? 'input__inner' : ''
                                "
                              />
                              <div
                                class="el-form-item__error col"
                                style="text-align: left"
                                v-if="!checkFrom2.timeEnd"
                              >Please enter time end</div>
                            </b-form-group>
                          </div>
                        </b-row>
                      </div>
                    </el-form>
                  </tab-content>
                  <tab-content title="Check Information" icon="fas fa-clipboard-check">
                    <div class="source">
                      <b-row>
                        <div class="col-12 col-lg-6 source-left" style="margin-bottom: 2rem">
                          <b-embed
                            type="iframe"
                            aspect="16by9"
                            :class="`mapGoogle`"
                            :src="
                              `https://maps.google.com/maps?amp;hl=en&amp;q=${contractInsurance.address}+(My%20Business%20Name)&amp;ie=UTF8&amp;t=h&amp;z=14&amp;iwloc=B&amp;output=embed`
                            "
                          ></b-embed>
                        </div>
                        <div class="col-12 col-lg-6 source-right">
                          <el-form ref="form" class="form-preview">
                            <div class="row form-group">
                              <div class="col-12 col-md-4">
                                <label>Address :</label>
                              </div>
                              <div class="col-12 col-md-8">
                                <b>{{ this.contractInsurance.address }}</b>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-4">
                                <label>Date :</label>
                              </div>
                              <div class="col-12 col-md-8">
                                <b>{{ this.contractInsurance.date }}</b>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-4">
                                <label>Time :</label>
                              </div>
                              <div class="col-12 col-md-8">
                                <div class="row">
                                  <div class="col-2 text-left">
                                    <b>{{ this.contractInsurance.timeStart }}h</b>
                                  </div>
                                  <el-col
                                    class="line"
                                    :span="2"
                                    style="color:white; text-align: center;"
                                  >-</el-col>
                                  <div class="col-2 text-left">
                                    <b>{{ this.contractInsurance.timeEnd }}h</b>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-4">
                                <label>Price :</label>
                              </div>
                              <div class="col-12 col-md-8">
                                <b>{{ this.contractInsurance.rate }} %</b>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-4">
                                <label>Rate :</label>
                              </div>
                              <div class="col-12 col-md-8">
                                <b>
                                  {{ formatPrice }} $ ~
                                  {{ this.ethConverted.toFixed(2) }} ETH
                                </b>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-5">
                                <label>Compensation:</label>
                              </div>
                              <div class="col-12 col-md-7">
                                <b>
                                  {{ formatCompensation }} $
                                  <label>( Max )</label>
                                </b>
                              </div>
                            </div>
                            <div class="row form-group">
                              <div class="col-12 col-md-5">
                                <label>Rainfall Condition:</label>
                              </div>
                              <div class="col-12 col-md-7">
                                <b>≥ 100 mm/h</b>
                              </div>
                            </div>
                          </el-form>
                        </div>
                        <div class="col-12 source-center style-formula">
                          <h6 class="text-center">
                            Compensation = (Price * Total-Rain-Hours /
                            Total-Times-Insurance) + Price + (Price * Rate/ 100)
                          </h6>
                        </div>
                      </b-row>
                    </div>
                  </tab-content>
                </form-wizard>
              </div>
            </div>
            <div class="et_pb_section et_pb_section_3 et_pb_fullwidth_section et_section_regular">
              <div class="et_pb_module et_pb_fullwidth_image et_pb_fullwidth_image_0">
                <img
                  data-cfsrc="@/assets/images/divider2.jpg"
                  srcset="@/assets/images/divider2.jpg         3000w, @/assets/images/divider2-254x15.jpg   254w, @/assets/images/divider2-533x31.jpg   533w, @/assets/images/divider2-1080x62.jpg 1080w"
                  sizes="(max-width: 3000px) 100vw, 3000px"
                  src="@/assets/images/divider2.jpg"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </article>
  </div>
</template>

<script>
import { FormWizard, TabContent } from "vue-form-wizard";
import "vue-form-wizard/dist/vue-form-wizard.min.css";
import { mapActions } from "vuex";
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";

const today = new Date();
const tenDay = today.setDate(today.getDate() + 9);
/* eslint-disable no-console */
export default {
  name: "create-insurance",
  data() {
    return {
      preloadPage: true,
      contractInsurance: {
        address: null,
        date: null,
        timeStart: null,
        timeEnd: null,
        price: null,
        compensation: null,
        descDetail: ""
      },
      checkFrom2: {
        date: true,
        timeStart: true,
        timeEnd: true
      },
      ethConverted: 0
    };
  },
  components: {
    FormWizard,
    TabContent,
    DatePicker
  },
  watch: {
    "contractInsurance.address": function() {
      this.saveLocalStorage();
    },
    "contractInsurance.date": function() {
      if (this.contractInsurance.date) {
        this.checkFrom2.date = true;
      } else {
        this.checkFrom2.date = false;
      }
      this.saveLocalStorage();
    },
    "contractInsurance.timeStart": function() {
      if (this.contractInsurance.timeStart) {
        this.checkFrom2.timeStart = true;
      } else {
        this.checkFrom2.timeStart = false;
      }
      this.saveLocalStorage();
    },
    "contractInsurance.timeEnd": function() {
      if (this.contractInsurance.timeEnd) {
        this.checkFrom2.timeEnd = true;
      } else {
        this.checkFrom2.timeEnd = false;
      }
      this.saveLocalStorage();
    }
  },
  computed: {
    formatPrice: function() {
      return this.contractInsurance.price
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    },
    formatCompensation: function() {
      return this.contractInsurance.compensation
        .toString()
        .replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }
  },
  methods: {
    ...mapActions("contract", ["createWib"]),
    onComplete: async function() {
      this.preloadPage = true;
      let rawWib = JSON.parse(localStorage.getItem("contractInsurance"));
      let times = "";
      for (let i = 0; i < 24; i++) {
        if (i >= parseInt(rawWib.timeStart) && i <= parseInt(rawWib.timeEnd)) {
          times += "1";
        } else {
          times += "0";
        }
      }
      let response = await fetch(
        "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD"
      );
      let eth2usd;
      if (response.ok) {
        eth2usd = await response.json();
      } else {
        alert("HTTP-Error: " + response.status);
      }
      let priceWei = ((rawWib.price / eth2usd["USD"]) * 10 ** 18).toString();
      let compensation = (
        (rawWib.compensation / eth2usd["USD"]) *
        10 ** 18
      ).toString();
      // let priceWei = (
      //   ((rawWib.price / eth2usd["USD"]) * 10 ** 18) /
      //   100
      // ).toString();

      await this.createWib({
        location: rawWib.address,
        date: rawWib.date,
        times: times,
        priceWei: priceWei,
        packageName: rawWib.type,
        link: "0x0000000000000000000000000000000000000000",
        compensation
      })
        .then(() => {
          this.preloadPage = false;
          localStorage.removeItem("contractInsurance");
          this.$router.push({ name: "homepage", hash: "#signed" });
        })
        .catch(e => {
          this.preloadPage = false;
          console.log(e);
        });
    },
    notBeforeTenDay(date) {
      return date < tenDay;
    },
    notBeforeStart(date) {
      let timeStart = parseInt(this.contractInsurance.timeStart) + 1;
      return date.getHours() < timeStart;
    },
    validateFirstStep() {
      let check = false;
      this.$refs.validate1.validate(valid => {
        check = valid;
      });
      return check;
    },
    validateSecondsStep() {
      let check = true;
      if (!this.contractInsurance.date) {
        this.checkFrom2.date = false;
        check = false;
      }
      if (!this.contractInsurance.timeStart) {
        this.checkFrom2.timeStart = false;
        check = false;
      }
      if (!this.contractInsurance.timeEnd) {
        this.checkFrom2.timeEnd = false;
        check = false;
      }
      return check;
    },
    keyUpDate() {
      if (this.contractInsurance.date) {
        this.checkFrom2.date = true;
      }
      if (this.contractInsurance.timeEnd) {
        this.checkFrom2.timeEnd = true;
      }
      if (this.contractInsurance.timeStart) {
        this.checkFrom2.timeStart = true;
      }
    },
    checkPropertiesNull(obj) {
      for (var key in obj) {
        if (obj[key] !== null && obj[key] != "") return false;
      }
      return true;
    },
    saveLocalStorage() {
      localStorage.setItem(
        "contractInsurance",
        JSON.stringify(this.contractInsurance)
      );
    },
    async convertUsd2Eth() {
      let rawWib = this.contractInsurance;
      let response = await fetch(
        "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD"
      );
      let eth2usd;
      if (response.ok) {
        eth2usd = await response.json();
      } else {
        console.log("HTTP-Error: " + response.status);
      }

      let priceWei = rawWib.price / eth2usd["USD"];
      this.ethConverted = priceWei;
    }
  },
  created() {
    if (this.checkPropertiesNull(this.contractInsurance)) {
      this.contractInsurance = JSON.parse(
        localStorage.getItem("contractInsurance")
      );
      setInterval(async () => {
        await this.convertUsd2Eth();
      }, 5000);
    }
    setTimeout(() => {
      this.preloadPage = false;
    }, 500);
  }
};
</script>

<style lang="scss" scope>
.embed-responsive {
  height: 100%;
}
.source {
  padding: 0.5rem;
  margin: 0.7rem;
}
.source-right {
  padding-left: 2.5rem;
}
.source-left {
  margin-bottom: 2rem;
  padding-left: 3rem;
}
.text-left {
  text-align: left;
}
.el-form-item .el-form-item__label {
  font-size: 1em;
  color: aliceblue;
  text-align: left;
  width: 200px;
}
.form-group b {
  font-size: 1.1em;
  color: #ffffff;
}

.vue-form-wizard .wizard-card-footer {
  padding: 20px;
}
span.stepTitle {
  color: aliceblue;
}
h3.title-form {
  color: aliceblue;
  font-family: "Apple Color Emoji";
}
h5.title-form {
  color: aliceblue;
  font-family: "Apple Color Emoji";
}
.form-preview div.form-group label {
  color: rgba(129, 188, 216, 0.54);
}
.el-form-item__label {
  color: aliceblue;
}

.et_pb_row_1.et_pb_row.et_pb_row_1_create {
  padding-top: 10px !important;
  margin-top: 25px !important;
}
.time-choose {
  text-align: center;
  margin-bottom: 25px;
}
.et_pb_section_0.et_pb_section {
  padding-bottom: 300px;
}
.wizard-footer-left,
.wizard-footer-right {
  width: 50%;
}
.wizard-footer-right {
  text-align: right;
}

.input__inner > .mx-input-wrapper > .mx-input {
  border-color: #f56c6c;
}

/* fill button */
.fill-button {
  position: relative;
  overflow: hidden;
  display: inline-block;
  width: 110px;
  height: 30px;
  border: 1px solid #35495e;
  text-align: center;
  box-sizing: border-box;
  color: #35495e;
  text-decoration: none;
  cursor: pointer;
  line-height: 28px;
  font-family: "arial";
  border-radius: 4px;
  margin-left: 10px;
}
.fill-button > span {
  display: block;
}
.fill-button > .fill-button-hover:after,
.fill-button > .fill-button-hover:before {
  position: absolute;
  top: 0;
  opacity: 0;
  display: block;
  content: "";
  width: 0;
  height: 30px;
}
.fill-button > .fill-button-hover:after {
  background-color: #35495e;
  transform: skewX(45deg);
  transform-origin: center center;
  transition: all 0.35s, opacity 0.4s;
  left: 50%;
}
.fill-button .fill-button-hover:before {
  background-color: #42b883;
  transition: opacity 1s;
}

.fill-button .fill-button-text {
  z-index: 1;
  position: relative;
  color: aliceblue;
  transition: color 0.35s;
}
.fill-button:hover .fill-button-text {
  color: #42b883;
}
.fill-button .fill-button-hover:hover:after {
  opacity: 1;
  left: 2%;
  width: 95%;
  transform: skewX(45deg);
}
.fill-button > .fill-button-hover:hover:before {
  opacity: 1;
  left: 0;
  width: 100%;
}

.el-input input,
.mx-input-wrapper input {
  padding-left: 10px;
}

.source-center {
  margin-bottom: 2rem;
  padding: 0 3rem;
}

.color-white {
  color: #ffffff;
}

.style-formula {
  margin-top: 3em;
  font-family: "Segoe UI Symbol";
  h6 {
    color: #d4d4d4;
  }
}

@media (max-width: 768px) {
  .source {
    padding: 0rem;
    margin: 0rem;
  }
  .source-right {
    padding-left: 1.5rem;
  }
  .source-left {
    padding-left: 15px;
  }

  .source-center {
    padding-left: 1.5rem;
  }
}
</style>
