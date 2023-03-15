<template>
  <el-popover v-if="apps.length>0" placement="bottom" width="350" trigger="click" id="app-popover">
    <el-form>
      <el-row v-for="(line,index) in moduloapps" :key="index">
        <el-col
          :span="24/modulo"
          v-for="(field,index2) in line"
          :key="index2"
          style="text-align:center;height:90px"
        >
          <el-button plain @click="appClicked(field.value)" style="height:68.5px">
            <v-icon :icon="field.value.icon" size="2x"/>
          </el-button>
          <br />
          {{field.value.title}}
        </el-col>
      </el-row>
    </el-form>
    <template #reference>
    <el-button circle size="large" type="primary" style="margin-top:-10px;">
      <el-icon :size="15"><Menu /></el-icon>
    </el-button>
    </template>
  </el-popover>
</template>
  
<script>
import {Menu} from '@element-plus/icons-vue';
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