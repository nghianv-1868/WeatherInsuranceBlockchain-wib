<template>
  <div :class="classType">
    <div class="et_pb_pricing_heading">
      <h2 class="et_pb_pricing_title">
        <b v-if="displayStatus === 0">Unexpired</b>
        <b v-if="displayStatus === 1" class="color-expired-yet-check">Expired - Yet Check</b>
        <b
          v-if="displayStatus === 2"
          class="color-expired-insurance-unpaid"
        >Expired - Insurance unpaid</b>
        <b v-if="displayStatus === 3" class="color-expired-insurance-paid">Expired - Insurance paid</b>
        <b
          v-if="displayStatus === 4"
          class="color-expired-insurance-failed"
        >Expired - Insurance failed</b>
      </h2>
    </div>
    <span class="et_pb_image_wrap">
      <img
        v-if="displayStatus === 0"
        data-cfsrc="@/assets/images/cheque.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        src="@/assets/images/cheque.png"
      />
      <img
        v-if="displayStatus === 1"
        data-cfsrc="@/assets/images/wait.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        src="@/assets/images/wait.png"
      />
      <img
        v-if="displayStatus === 2"
        data-cfsrc="@/assets/images/payment.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        src="@/assets/images/payment.png"
      />
      <img
        v-if="displayStatus === 3"
        data-cfsrc="@/assets/images/survey.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        src="@/assets/images/survey.png"
      />
      <img
        v-if="displayStatus === 4"
        data-cfsrc="@/assets/images/fail.png"
        sizes="(max-width: 64px) 100vw, 64px"
        class="et-waypoint et_pb_animation_off"
        src="@/assets/images/fail.png"
      />
    </span>
    <div class="et_pb_pricing_content">
      <ul class="et_pb_pricing">
        <li>
          <span class="text-dot">Location: {{ wib.nameLocation }}</span>
        </li>
        <li>
          <span>Date: {{ wib.date }}</span>
        </li>
        <li>
          <span>Type: {{ wib.type }}</span>
        </li>
        <li>
          <span>Total Rainy Hours: {{ wib.totalRainyHours }}</span>
        </li>
      </ul>
    </div>
    <div class="et_pb_button_wrapper">
      <a
        class="et_pb_button et_pb_pricing_table_button margin-right-10px"
        href="javascript:void(0)"
        @click="clicked"
      >Detail</a>
      <a
        @click="checkInsuranceConditions"
        v-if="checkExpired"
        class="et_pb_button et_pb_pricing_table_button bottom-color-red"
        href="javascript:void(0)"
      >Check</a>
      <a
        @click="paymentInsurance"
        v-if="checkPayment"
        class="et_pb_button et_pb_pricing_table_button bottom-color-payment"
        href="javascript:void(0)"
      >Payment</a>
    </div>
  </div>
</template>
<script>
/* eslint-disable no-console */
import { mapState } from "vuex";
import PackList from "@/constants/InsurancePacks";
export default {
  name: "myWib",
  props: {
    index: Number,
    onClick: Function,
    instance: Object,
    loadingPage: Function,
    unLoadingPage: Function
  },
  data() {
    return {
      wib: {}
    };
  },
  computed: {
    ...mapState("contract", ["account"]),
    classType: function() {
      return (
        "et_pb_pricing_table et_pb_pricing_table_" +
        (this.index % 2 == 0 ? 2 : 1).toString() +
        " insurance-package"
      );
    },
    checkExpired: function() {
      return Date.now() + this.wib.gmtOffset > this.wib.expired &&
        !this.wib.isQueryWeather
        ? true
        : false;
    },
    checkPayment: function() {
      return Date.now() + this.wib.gmtOffset > this.wib.expired &&
        this.wib.isQueryWeather &&
        !this.wib.paid &&
        this.wib.totalRainyHours > 0
        ? true
        : false;
    },
    displayStatus: function() {
      if (
        Date.now() + this.wib.gmtOffset > this.wib.expired &&
        this.wib.isQueryWeather &&
        this.wib.totalRainyHours <= 0
      ) {
        return 4;
      } else if (
        Date.now() + this.wib.gmtOffset > this.wib.expired &&
        this.wib.isQueryWeather &&
        this.wib.paid &&
        this.wib.totalRainyHours > 0
      ) {
        return 3;
      } else if (
        Date.now() + this.wib.gmtOffset > this.wib.expired &&
        this.wib.isQueryWeather &&
        !this.wib.paid &&
        this.wib.totalRainyHours > 0
      ) {
        return 2;
      } else if (
        Date.now() + this.wib.gmtOffset > this.wib.expired &&
        !this.wib.isQueryWeather
      ) {
        return 1;
      } else {
        return 0;
      }
    }
  },
  methods: {
    async clicked() {
      this.onClick({
        wib: this.wib
      });
    },
    async checkInsuranceConditions() {
      this.loadingPage();
      await this.instance.methods
        .queryWeather()
        .send({ from: this.account })
        .then(e => {
          this.fetchWib();
          setTimeout(() => {
            this.unLoadingPage();
            this.fetchWib();
          }, 15000);
          console.log("checkInsuranceConditions success", e);
        })
        .catch(() => {
          this.unLoadingPage();
        });
    },
    async paymentInsurance() {
      this.loadingPage();
      await this.instance.methods
        .payInsurance()
        .send({ from: this.account })
        .then(e => {
          this.fetchWib();
          setTimeout(() => {
            this.unLoadingPage();
          }, 1000);
          console.log("payInsurance success", e);
        })
        .catch(() => {
          this.unLoadingPage();
        });
    },
    async fetchWib() {
      let wib = {};
      wib.nameLocation = await this.instance.methods.nameLocation().call();
      wib.expired = await this.instance.methods.expired().call();
      wib.isQueryWeather = await this.instance.methods.isQueryWeather().call();
      wib.paid = await this.instance.methods.paid().call();
      wib.totalRainyHours = await this.instance.methods
        .totalRainyHours()
        .call();
      wib.gmtOffset = await this.instance.methods.gmtOffset().call();
      wib.location = await this.instance.methods.location().call();
      wib.price = await this.instance.methods.price().call();
      wib.date = await this.instance.methods.date().call();
      let timeString = await this.instance.methods.getTimes().call();
      wib.timeStart = Math.min(...timeString);
      wib.timeEnd = Math.max(...timeString);
      let rate = await this.instance.methods.rate().call();
      PackList.forEach(e => {
        if (e.rate == rate) {
          wib.type = e.type;
        }
      });
      this.wib = wib;
    }
  },
  async created() {
    await this.fetchWib();
  }
};
</script>

<style lang="scss">
.margin-right-10px {
  margin-right: 10px;
}

.bottom-color-red {
  border-color: #e6a23c !important;
  background-color: #e6a23c !important;
}

.bottom-color-payment {
  border-color: #469fff !important;
  background-color: #469fff !important;
}

.color-expired-insurance-unpaid {
  color: #00b4ff !important;
}
.color-expired-yet-check {
  color: #ffc107 !important;
}

.color-expired-insurance-paid {
  color: #2dff5d !important ;
}

.color-expired-insurance-failed {
  color: #ff5252 !important;
}

.text-dot {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 50px;
}
</style>
