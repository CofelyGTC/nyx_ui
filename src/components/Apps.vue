<template>
  <el-popover v-if="apps.length>0" placement="bottom" width="350" trigger="click" id="app-popover">
    <el-form>
      <el-row v-for="(line,index) in moduloapps" :key="index">
        <el-col
          :span="24/modulo"
          v-for="(field,index2) in line"
          :key="index2"
          style="text-align:center;height:90px;"
        >
          <el-button plain @click="appClicked(field.value)">
            <img v-if="field.value.icon && field.value.icon.includes('http')" :src="field.value.icon" scale="2" style="height:32px;filter: brightness(0) saturate(100%) invert(39%) sepia(1%) saturate(2250%) hue-rotate(183deg) brightness(93%) contrast(86%)">
            <v-icon v-else :name="field.value.icon" scale="2" />
          </el-button>
          <br />
          {{field.value.title}}
        </el-col>
      </el-row>
    </el-form>

    <el-button circle type="default" slot="reference">
      <i class="el-icon-menu"></i>
    </el-button>
  </el-popover>
</template>
  
<script>
export default {
  name: "Apps",
  data: () => ({
    modulo: 3,
    moduloapps: [],
    apps: []
  }),
  props: {},
  computed: {},
  methods: {
    appClicked(e) {
      console.log('e: ', e);
      this.$emit("appclicked", e);
    },
    handleCommand(e) {
      if (e == "info") this.info();
      else this.logout();
    },
    info() {
      this.$alert("This is a message", "Title", {
        confirmButtonText: "OK"
      });
    },
    logout() {
      this.$store.commit({
        type: "logout",
        data: {}
      });
      this.$notify({
        title: "Success",
        message: "Bye Bye",
        type: "success",
        position: "bottom-right"
      });
      this.$router.push("/");
    }
  },
  created: function() {
    this.apps = this.$store.getters.apps;
    var lines = [];
    var curline = [];
    var allapps = this.apps;
    for (var i in allapps) {
      var rec = allapps[i];
      curline.push({ key: i, value: rec });
      if (curline.length >= this.modulo) {
        lines.push(curline);
        curline = [];
      }
    }
    if (curline.length > 0) {
      lines.push(curline);
      curline = [];
    }
    this.moduloapps = lines;
  }
};
</script>

<style>
.menuicon {
  margin-bottom: -3px;
}

</style>