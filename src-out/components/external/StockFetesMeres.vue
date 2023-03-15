<template>
  <div style="width: 100%">
    <el-row class="stockviewer-container" style="width: 100%">
      <el-form style="widht: 100%">
        <el-row><h1>Fêtes des Mères</h1></el-row><br />
        <el-row><h2>Biscuit Litchi Framboise</h2></el-row><br />
        <el-row>
          <el-col :span="12">
            <el-form-item label="1 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C462" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="5 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C463" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col> </el-row
        ><br />
        <el-row><h2>Macaron Fraises</h2></el-row><br />
        <el-row>
          <el-col :span="12">
            <el-form-item label="1 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C467" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="4 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C468" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col> </el-row
        ><br />
        <el-row><h2>Bavarois Framboise</h2></el-row><br />
        <el-row>
          <el-col :span="12">
            <el-form-item label="1 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C469" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="4 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C470" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col> </el-row
        ><br />
        <el-row><h2>Coeur Choc</h2></el-row><br />
        <el-row>
          <el-col :span="12">
            <el-form-item label="1 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C471" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="4 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C472" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col> </el-row
        ><br />
        <el-row><h2>Coeur Crème au Beurre</h2></el-row><br />
        <el-row>
          <el-col :span="24">
            <el-form-item label="1 Pers." :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C464" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col> </el-row
        ><br />
        <el-row><h2>Boite Macarons</h2></el-row><br />
        <el-row>
          <el-col :span="24">
            <el-form-item label="8 Pièces" :label-width="formLabelWidth2">
              <el-input-number v-model="record._source.C449" :step="1" :min="0">
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>

        <br />
        <div>
          <el-row>
            <el-button type="primary" @click="onSubmit">Enregistrer</el-button>
          </el-row>
        </div>
      </el-form>
    </el-row>
  </div>
</template>

<script>
import Vue from 'vue'
import moment, { months } from 'moment'
import axios from 'axios'

export default {
  name: 'StockFetesMeres',
  data: () => ({
    record: null,
    magasin: '',
    shopid: '',
    ts: 0,
    productsLabels: {},
    formLabelWidth2: '120px',
  }),
  props: {
    config: {
      type: Object,
    },
  },
  filters: {
    roundTo2: function (value) {
      return value.toFixed(2)
    },
  },
  created: function () {
    this.ts = Date.now() * 1000
    this.getMagasin()
  },
  methods: {
    onSubmit() {
      this.refillNan()
      this.ts = Date.now()
      this.record._source.lastUpdate = this.ts
      this.record._source.modifiedBy = this.$store.getters.creds.user.id
      var url =
        this.$store.getters.apiurl +
        'lambdas/7/update_stocks_fetes_meres?apikey=' +
        this.$store.getters.creds.token

      setTimeout(() => {
        axios
          .post(url, this.record)
          .then((response) => {
            console.log(response)
            if (response.data.errors) {
              this.$notify({
                title: 'Error',
                message: 'Stocks Non Enregistrés',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Stocks correctement enregistrés',
                type: 'success',
                position: 'bottom-right',
                duration: 2000,
              })
            }
          })
          .catch((error) => {
            console.log(error)
          })
      }, 1000)

      console.log('Sending Command')
    },
    prepareData() {
      this.getProductsLabels()
      this.getData()
    },

    getProductsLabels() {
      var demandor = this.$store.getters.creds.user.id
      var query = { shopid: this.shopid }
      var url =
        this.$store.getters.apiurl +
        'lambdas/7/get_products_labels?apikey=' +
        this.$store.getters.creds.token
      axios.post(url, query).then((response) => {
        //var status = false

        console.log(response.data.orderstatus)
        this.productsLabels = response.data
      })
    },

    getData() {
      var demandor = this.$store.getters.creds.user.id
      var query = { shopid: this.shopid }
      var url =
        this.$store.getters.apiurl +
        'lambdas/7/get_stock_fetes_meres?apikey=' +
        this.$store.getters.creds.token
      axios.post(url, query).then((response) => {
        //var status = false

        console.log(response.data.orderstatus)
        this.record = response.data
      })
    },

    refillNan() {
      for (var index in this.record._source) {
        if (this.record._source[index] == null) {
          this.record._source[index] = 0
          console.log(
            index.toString() + ' ' + this.record._source[index].toString()
          )
        }
      }
    },

    getMagasin() {
      var demandor = this.$store.getters.creds.user.id
      var url =
        this.$store.getters.apiurl +
        'schamps/check_user_shop?demandor=' +
        demandor +
        '&token=' +
        this.$store.getters.creds.token

      console.log('CHECK USER SHOP')

      axios.get(url, demandor).then((response) => {
        if (response.data.error != '')
          console.log('User Shop Calls list error...')
        else {
          var res = JSON.parse(response.data.data)
          console.log('MAGASIN COUCOU: ')
          console.log(res)
          this.magasin = res.reccords[0]._source.magasin
          this.shopid = res.reccords[0]._source.shopid
          console.log(this.shopid)
          this.prepareData()
        }
      })
    },
  },
}
</script>

<style>
.box-card {
  width: 800px !important;
}

.first-row {
  margin: 10px;
}
.second-row {
  margin: 20px 10px;
}
.third-row {
  margin: 20px 10px;
}
.forth-row {
  margin: 20px 10px;
}

.table-disable {
  cursor: not-allowed;
}
.footer {
  position: fixed;
  left: 0;
  bottom: 1%;
  width: 100%;
  text-align: center;
}
</style>
