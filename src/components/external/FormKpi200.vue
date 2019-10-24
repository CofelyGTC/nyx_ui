<template>
  <div>
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px">
      <el-form
        style="text-align:left"
        :model="dialogObj"
        :orgmodel="orgModel"
        :kpis="kpis"
        :disable="disable"
        v-if="dialogVisible"
        ref="formCall"
      >
        <el-form-item label="KPI" :label-width="formLabelWidth">
          <el-select size="mini" v-model="dialogObj.kpi" :disabled="disable" placeholder="Select" style="width:460px;">
            <el-option
              v-for="item in kpis"
              :key="item.kpi"
              :label="item.kpi +'-'+ item.desc"
              :value="item.kpi"
            ></el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="Uitleg " :label-width="formLabelWidth">
          <el-input style="max-width:620px;" v-model="dialogObj.desc" :controls="false" size="mini" type="textarea"></el-input>
        </el-form-item>

        <el-form-item label="Datum van het incident " :label-width="formLabelWidth">
          <el-date-picker
            :disabled="disable"
            v-model="dialogObj.datetimestart"
            :picker-options="{firstDayOfWeek:1}"
            type="datetime"
            size="mini"
            placeholder="Select date and time"
          ></el-date-picker>
        </el-form-item>

        <el-form-item label="Opgelost " :label-width="formLabelWidth">
          <el-switch v-model="dialogObj.finished"></el-switch>
        </el-form-item>

        <el-form-item
          v-if="dialogObj.finished"
          label="Datum van oplossing"
          :label-width="formLabelWidth"
        >
          <el-date-picker
            v-model="dialogObj.datetimeend"
            :picker-options="{firstDayOfWeek:1,disabledDate:disableDate}"
            type="datetime"
            size="mini"
            placeholder="Select date and time"
          ></el-date-picker>
        </el-form-item>
      </el-form>

      <span slot="footer" class="dialog-footer">
        <el-button type="default" plain size="small" @click="dialogVisible = false">Cancel</el-button>
        <el-button
          v-if="dialogType=='update'"
          type="primary"
          :disabled="!hasBeenModified"
          plain
          size="small"
          :loading="loading"
          @click="clickDialogModify"
        >Modify</el-button>

        <el-button
          v-else
          type="primary"
          plain
          size="small"
          :disabled="dialogObj==null"
          :loading="loading"
          @click="clickDialogCreate"
        >Create</el-button>
      </span>
    </el-dialog>

    <el-row class="kpi200-container" :span="24" type="flex" justify="center">
      <el-card class="box-card2">
        <div slot="header" class="clearfix">
          <span style="font-weight:bold">KPI200 - Correctief Onderhoud</span>
        </div>
        <div class="card-body">
          <el-row class="first-row" :span="24">
            <el-col :span="12" style="text-align:left;">
              <el-row>
                <el-date-picker
                  v-model="monthSelected"
                  type="month"
                  size="mini"
                  placeholder="Pick a month"
                  :clearable="false"
                  @change="dateSelected()"
                ></el-date-picker>
              </el-row>
              <el-row style="margin-left:5px; font-weight:bold;"></el-row>
            </el-col>
          </el-row>

          <span v-if="monthSelected">
            <el-row :span="24" class="parameters-selection" v-if="writeAccess">
              <el-col :span="12" style="text-align:left;">
                <el-button
                  :disabled="!monthSelected || disable"
                  type="primary"
                  icon="el-icon-plus"
                  @click="addRecord"
                  round
                >Nieuw Incident</el-button>
              </el-col>
            </el-row>
          </span>
        </div>

        <div>
          <el-table
            :data="tableData"
            :default-sort="{prop: '_source.kpi', order: 'descending'}"
            style="width: 100%"
          >
            <el-table-column prop="_source.kpi" label="KPI" sortable width="80"></el-table-column>
            <el-table-column
              prop="_source.datetimestart"
              label="Datum van het incident"
              sortable
              width="210"
              :formatter="formaterstart"
            ></el-table-column>

            <el-table-column
              prop="_source.datetimeend"
              label="Datum van oplossing"
              sortable
              width="210"
              size="small"
              :formatter="formaterend"
            >
              <template slot-scope="scope" v-if="scope.row._source.finished">
                <el-popover placement="right" title="Tijd Interval" trigger="hover">
                  <el-form>
                    <el-form-item :label="hintduration(scope.row)"></el-form-item>
                    <el-form-item :label="hintlimit(scope.row)"></el-form-item>
                  </el-form>

                  <el-button
                    v-bind:class="{orangeduration:formatend(scope.row)==1,redduration:formatend(scope.row)==0,greenduration:formatend(scope.row)==2}"
                    type="text"
                    slot="reference"
                  >{{formaterend(scope.row)}}</el-button>
                </el-popover>
              </template>
            </el-table-column>

            <el-table-column
              prop="_source.finished"
              label="Opgelost"
              sortable
              width="120"
              align="center"
            >
              <template slot-scope="scope">
                <v-icon name="times" scale="1.0" v-if="!scope.row._source.finished" />
                <v-icon name="check" scale="1.0" v-if="scope.row._source.finished" />
                <!-- <div style="text-align:center;" >
                    <v-icon name="bug" scale="1.5"/>
                </div>-->
              </template>
            </el-table-column>

            <el-table-column prop="_source.desc" label="Uitleg" sortable></el-table-column>

            <el-table-column label width="130">
              <template slot-scope="scope">
                <el-button
                  v-if="writeAccess"
                  size="mini"
                  icon="el-icon-setting"
                  plain
                  @click="handleEdit(scope.$index, scope.row)"
                ></el-button>
                <el-button
                  v-if="writeAccess"
                  size="mini"
                  type="danger"
                  :disabled="!monthSelected || disable"
                  icon="el-icon-delete"
                  @click="handleDelete(scope.$index, scope.row)"
                ></el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-card>
    </el-row>
  </div>
</template>
<script>
import Vue from "vue";
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import formkpi200 from "@/components/external/FormKpi200";
import { setTimeout } from "timers";
Vue.component("FormKpi200", formkpi200);

export default {
  name: "FormKpi200",
  data() {
    return {
      query: "",
      monthSelected: null,
      monthStart: null,
      monthEnd: null,
      disable: true,
      formLabelWidth: "200px",
      writeAccess: false,
      dialogType: "creation",
      dialogVisible: false,
      dialogTitle: "",
      loading: false,
      dialogObj: null,
      orgModel: null,
      tableData: [],
      kpi: null,
      kpisht: {},
      kpis: []
    };
  },
  computed: {
    hasBeenModified: function() {
      return (
        JSON.stringify(this.orgModel._source) != JSON.stringify(this.dialogObj)
      );
    }
  },
  created: function() {
    for (var i in this.$store.getters.creds.user.privileges) {
      var priv = this.$store.getters.creds.user.privileges[i];
      if (priv == "admin" || priv == "kpi200-write" || priv == "KPI200_WRITE") {
        this.writeAccess = true;
      }
    }
    this.prepareData();
  },
  methods: {
    disableDate(in_date) {
      return (
        moment(this.dialogObj.datetimestart).diff(moment(in_date), "hours") >=
        24
      );
    },
    formaterend(row, column) {
      return moment(row._source.datetimeend).format("DD MMM YYYY - HH:mm");
      //return JSON.stringify(column);
    },
    formatend(row, column) {
      var config = this.kpisht["" + row._source.kpi];
      if (row._source.datetimeend != null) {
        var diff =
          (moment(row._source.datetimeend).unix() -
            moment(row._source.datetimestart).unix()) /
          3600;

        if (diff <= config.limit) return 2;
        else if (row._source.kpi != "211/212") return 0;
        else {
          if (diff <= config.limit2) return 1;
          else return 0;
        }
      } else return 0;
      //return JSON.stringify(column);
    },
    formaterstart(row, column) {
      return moment(row._source.datetimestart).format("DD MMM YYYY - HH:mm");
      //return JSON.stringify(column);
    },
    hintduration(row, column) {
      var diffTime = moment(row._source.datetimeend).set({millisecond:0})
        .diff(moment(row._source.datetimestart).set({millisecond:0}));
      var duration = moment.duration(diffTime);
      var years = duration.years(),
        months = duration.months(),
        days = duration.days(),
        hrs = duration.hours(),
        mins = duration.minutes(),
        secs = duration.seconds();

      var formatDiff = ''
      if(years!=0)
        formatDiff += years + ' jaar '
        
      if(months!=0) {
        if(months==1)
          formatDiff += months + ' maand '
        else
          formatDiff += months + ' maanden '
      }
      
      if(days!=0) {
        if(days==1)
          formatDiff += days + ' dag '
        else
          formatDiff += days + ' dagen '
      }

      if(hrs!=0) {
        if(hrs==1)
          formatDiff += hrs + ' uur '
        else
          formatDiff += hrs + ' uren '
      }

      if(mins!=0) {
        if(mins==1)
          formatDiff += mins + ' minuute '
        else
          formatDiff += mins + ' minuten '
      }

      if(secs!=0) {
        if(secs==1)
          formatDiff += secs + ' seconde '
        else
          formatDiff += secs + ' seconden '
      }
        
      if(formatDiff == '')
        formatDiff = '0 seconden'
        
      return formatDiff
    },
    hintlimit(row, column) {
      var limit = "Limit " + this.kpisht["" + row._source.kpi].limit + " uren";

      if (row._source.kpi == "211/212") {
        limit =
          "Limit " +
          this.kpisht["" + row._source.kpi].limit +
          " / " +
          this.kpisht["" + row._source.kpi].limit2 +
          " uren";
      }
      return limit;

      //return JSON.stringify(column);
    },
    clickDialogCreate() {
      var rec = {
        _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
        _index: "biac_kpi200_monthly",
        _type: "doc",

        _source: this.dialogObj
      };

      rec._source["@timestamp"] = moment();

      this.$store.commit({
        type: "updateRecord",
        data: rec
      });
      setTimeout(() => this.prepareData(), 1000);
      this.dialogVisible = false;
    },
    clickDialogModify() {
      var rec = this.orgModel;

      this.orgModel._source = this.dialogObj;

      this.$store.commit({
        type: "updateRecord",
        data: rec
      });
      setTimeout(() => this.prepareData(), 1000);
      this.dialogVisible = false;
    },

    prepareData() {
      console.log("prepare data");
      var url =
        this.$store.getters.apiurl +
        "generic/biac_kpi/lot4_200s?token=" +
        this.$store.getters.creds.token;

      axios
        .get(url)
        .then(response => {
          if (response.data.error != "") console.log("KPI200 list error...");
          else {
            this.kpis = response.data.data._source.kpis;
            for (var i = 0; i < this.kpis.length; i++) {
              this.kpisht[this.kpis[i].kpi] = this.kpis[i];
            }

            this.monthSelected = moment();
            this.dateSelected();
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    addRecord() {
      this.dialogObj = {
        datetimestart: moment(),
        datetimeend: moment(),
        finished: false,
        kpi: "203"
      };
      this.dialogType = "creation";
      this.dialogTitle = "Nieuw incident";
      this.dialogVisible = true;
    },
    handleEdit(index, row) {
      var newconfig = JSON.parse(JSON.stringify(row));
      this.dialogObj = newconfig._source;
      this.dialogType = "update";
      this.dialogTitle = "Bijwerken incident";
      this.dialogVisible = true;
      this.orgModel = row;
    },
    handleDelete(index, row) {
      this.$confirm(
        "Dit zal de record voor altijd verwijderen, verder gaan?",
        "Warning",
        {
          confirmButtonText: "OK",
          cancelButtonText: "Verwijderen",
          type: "warning"
        }
      ).then(() => {
        this.$store.commit({
          type: "deleteRecord",
          data: row
        });
        setTimeout(() => this.prepareData(), 1000);
      });
    },
    dateSelected() {
      if (this.monthSelected == null) this.monthSelected = moment();

      if (moment().format("D") >= 16) {
        //console.log('report already done')
        this.disable = moment() > moment(this.monthSelected).endOf("Month");
      } else {
        this.disable =
          moment().subtract(1, "months") >
          moment(this.monthSelected).endOf("Month");
      }
      //@this.disable=false;
      this.monthStart = moment(this.monthSelected).startOf("Month");
      this.monthEnd = moment(this.monthSelected).endOf("Month");

      this.query =
        "datetimestart: [" +
        this.monthStart.toISOString() +
        " TO " +
        this.monthEnd.toISOString() +
        "]";

      var url =
        this.$store.getters.apiurl +
        "generic_search/biac_kpi200_monthly*?token=" +
        this.$store.getters.creds.token;

      var fullq = {
        size: 1000,
        query: {
          bool: {
            must: [
              {
                query_string: {
                  query: this.query
                }
              }
            ]
          }
        }
      };

      axios
        .post(url, fullq)
        .then(response => {
          if (response.data.error != "") console.log("KPI200 list error...");
          else {
            console.log(response.data.records);
            console.log(this);
            this.tableData = response.data.records;
          }
        })
        .catch(error => {
          console.log(error);
        });
    }
  }
};
</script>
<style>
.kpi200-container {
  width: 100%;
  margin: 30px 0px;
}
.box-card2 {
  width: 950px !important;
}

.kpi200-container .parameters-selection {
  margin: 10px;
}

.first-row {
  /*margin: 10px;*/
}
.second-row {
  /*margin: 20px 10px;*/
}
.third-row {
  /*margin: 20px 10px;*/
}

.row-day {
  padding-top: 10px;
  padding-bottom: 10px;
  border-top: solid 1px lightgrey;
}

.kpi200-switches-text {
  margin-left: 20px;
  font-size: 11px;
}

.kpi200-container .row-subtitle {
  border-top: solid 1px #eee;
  margin-top: 15px;
  padding-top: 10px;
  padding-bottom: 10px;
  margin-bottom: 15px;
  border-bottom: solid 1px #eee;
}

.redduration {
  color: red !important;
}

.orangeduration {
  color: orange !important;
}

.greenduration {
  color: green !important;
}
</style>