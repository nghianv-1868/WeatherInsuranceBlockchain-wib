<template>
  <div v-bind:class="classType" class="package-insurance">
    <div class="et_pb_pricing_heading">
      <h2 class="et_pb_pricing_title" :style="{ color: `${colorTitle} !important` }">{{ type }}</h2>
    </div>
    <span class="et_pb_image_wrap">
      <img
        data-cfsrc="@/assets/images/finiance-icon-03.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        :src="linkLogo"
      />
    </span>
    <div class="et_pb_pricing_content_top">
      <span class="et_pb_et_price">
        <span class="et_pb_dollar_sign" :style="{ color: `${colorTitle} !important` }">$</span>
        <span
          class="et_pb_sum"
          :style="{ color: `${colorTitle} !important` }"
        >{{ formatNumber(price) }}</span>
        <span class="et_pb_frequency"></span>
      </span>
    </div>
    <div class="et_pb_pricing_content">
      <ul class="et_pb_pricing">
        <li>
          <span>{{ description }}</span>
        </li>
      </ul>
    </div>
    <div class="et_pb_button_wrapper">
      <a
        class="et_pb_button et_pb_pricing_table_button"
        href="javascript:void(0)"
        @click="choosePackge"
      >Choose Package</a>
    </div>
  </div>
</template>

<script>
/* eslint-disable no-console */
export default {
  name: "InsPack",
  props: {
    index: Number,
    type: String,
    price: Number,
    description: String,
    logo: String,
    descDetail: String,
    compensation: Number,
    rate: Number,
    colorTitle: String
  },
  methods: {
    choosePackge() {
      let contractInsurance = null;
      if (JSON.parse(localStorage.getItem("contractInsurance"))) {
        contractInsurance = JSON.parse(
          localStorage.getItem("contractInsurance")
        );
        contractInsurance.price = this.price;
        contractInsurance.rate = this.rate;
        contractInsurance.compensation = this.compensation;
      } else {
        contractInsurance = {
          address: null,
          date: null,
          timeStart: null,
          timeEnd: null,
          type: this.type,
          price: this.price,
          rate: this.rate,
          compensation: this.compensation
        };
      }
      localStorage.setItem(
        "contractInsurance",
        JSON.stringify(contractInsurance)
      );
      this.$router.push("/create");
    },
    formatNumber(number) {
      return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }
  },
  computed: {
    classType: function() {
      return (
        "et_pb_pricing_table et_pb_pricing_table_" +
        (this.index % 2 == 0 ? 2 : 1).toString()
      );
    },
    linkLogo: function() {
      return require("@/assets/images/" + this.logo);
    }
  }
};
</script>

<style lang="scss">
.package-insurance {
  margin: 0 7px;
  border-radius: 5px;
  padding: 30px 25px;
}
.package-insurance:first-child {
  margin-left: 0;
}

.package-insurance:last-child {
  margin-right: 0;
}

.et_pb_pricing_content {
  margin-bottom: 20px;
}
</style>
