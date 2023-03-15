<template>
  <div style="width: 100%">
    <el-row class="manualactions-container" style="width: 100%">
      <el-row>ACTIONS :</el-row>
      <el-row>
        <el-button type="primary" @click="onConfirm"
          >Confirmer Commandes</el-button
        >
        <el-button type="primary" @click="onClose"
          >Cloturer commandes</el-button
        >
        <el-button type="primary" @click="onReopen"
          >Réouvir Commandes</el-button
        >
        <el-button type="primary" @click="onCompile"
          >Compiler Production</el-button
        >
      </el-row>
      <el-row>
        <el-button type="primary" @click="onGenerateStocks"
          >Générer Bons de Stocks</el-button
        >
        <el-button type="primary" @click="onGenerateLivraison"
          >Générer Bons de livraison</el-button
        >
        <el-button type="primary" @click="onGenerateLivraisonDetails"
          >Générer détails préparation</el-button
        >
        <el-button type="primary" @click="onGenerateComission"
          >Générer notes de livraisons</el-button
        >
      </el-row>
      <el-row>
        <el-button type="primary" @click="onGeneratePredictive"
          >Générer Production Provisoire</el-button
        >
        <el-button type="primary" @click="onGenerateFinale"
          >Générer Production Finale</el-button
        >
      </el-row>

      <el-row>
        <el-date-picker
          v-model="dateToConfirm"
          type="date"
          placeholder="Choississez un jour"
        >
        </el-date-picker>
        <el-button type="primary" @click="onDateConfirmOrders"
          >Confirmer Orders à la Date</el-button
        >
      </el-row>
      <el-row>
        <el-date-picker
          v-model="dateToFacturation"
          type="date"
          placeholder="Choississez un jour"
        >
        </el-date-picker>
        <el-button type="primary" @click="onDateFacturation"
          >Recalculer la Facturation à la date</el-button
        >
      </el-row>
      <el-row>
        <el-date-picker
          v-model="periodDisable"
          type="daterange"
          range-separator="à"
          start-placeholder="Date de début"
          end-placeholder="Date de fin"
        >
        </el-date-picker>

        <el-select v-model="productToDisable" placeholder="Sélectionner">
          <el-option
            v-for="(prod, idProd) in othersProducts"
            :key="idProd"
            :label="prod.CODE + ' (' + prod.label + ')'"
            :value="prod['_id']"
          >
          </el-option>
        </el-select>
        <el-button type="primary" @click="disableProduct"
          >Désactiver le Produit</el-button
        >
      </el-row>
      <el-row>
        <el-date-picker
          v-model="periodEnable"
          type="daterange"
          range-separator="à"
          start-placeholder="Date de début"
          end-placeholder="Date de fin"
        >
        </el-date-picker>

        <el-select v-model="productToEnable" placeholder="Sélectionner">
          <el-option
            v-for="(prod, idProd) in othersProducts"
            :key="idProd"
            :label="prod.CODE + ' (' + prod.label + ')'"
            :value="prod['_id']"
          >
          </el-option>
        </el-select>
        <el-button type="primary" @click="enableProduct"
          >Réactiver le Produit</el-button
        >
      </el-row>
      <el-row>
        <el-date-picker
          v-model="periodProductAdd"
          type="daterange"
          range-separator="à"
          start-placeholder="Date de début"
          end-placeholder="Date de fin"
        >
        </el-date-picker>

        <el-select v-model="productToAdd" placeholder="Sélectionner">
          <el-option
            v-for="(prod, idProd) in othersProducts"
            :key="idProd"
            :label="prod.CODE + ' (' + prod.label + ')'"
            :value="prod['_id']"
          >
          </el-option>
        </el-select>
        <el-button type="primary" @click="addProduct"
          >Ajouter le Produit</el-button
        >
      </el-row>
      <el-row>
        <el-button type="primary" @click="logoutAll"
          >Déconnecter tout le monde</el-button
        >
      </el-row>
    </el-row>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'

export default {
  name: 'ManualActions',
  data: () => ({
    dateToConfirm: null,
    dateToFacturation: null,
    othersProducts: [],
    productToDisable: '',
    productToEnable: '',
    periodDisable: [],
    periodEnable: [],
    periodProductAdd: [],
    productToAdd: '',
  }),
  props: {
    config: {
      type: Object,
    },
  },
  created: function () {
    this.getOthersProducts()
  },
  methods: {
    onConfirm() {
      var body = {
        destination: '/topic/CONFIRM_ORDERS',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec de la confirmation des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes envoyées à la confirmation',
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

      console.log('Confirming Commands')
    },
    logoutAll() {
      setTimeout(() => {
        axios
          .get(
            this.$store.getters.apiurl +
              'logoutall?token=' +
              this.$store.getters.creds.token
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec Déconnexion Globale',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Autres Users Déconnectés',
                type: 'success',
                position: 'bottom-right',
                duration: 2000,
              })
            }
          })
      }, 1000)
    },
    onReorder() {
      var body = {
        destination: '/topic/REORDER',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes repassées',
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

      console.log('Confirming Reorder')
    },
    test() {
      var body = {
        destination: '/queue/TEST1',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'TEST SEND',
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

      console.log('TEST')
    },
    onClose() {
      var body = {
        destination: '/topic/CLOSE_ORDERS',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec de la fermeture des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes clôturées',
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

      console.log('Confirming Commands')
    },
    onReopen() {
      var body = {
        destination: '/topic/REOPEN_ORDERS',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec de la réouverture des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes réouvertes',
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

      console.log('Confirming Commands')
    },
    onCompile() {
      var body = {
        destination: '/topic/COMPILE_ORDERS',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec de la compilation des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes envoyées à la confirmation',
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

      console.log('Confirming Commands')
    },
    onGenerateComission() {
      var body = {
        destination: '/topic/GENERATE_COMISSION_DAY',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Bons de livraison finaux OK',
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

      console.log('Confirming Reorder')
    },
    onGenerateStocks() {
      var body = {
        destination: '/topic/GENERATE_STOCKS_REPORT',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du calcul des bons de stocks',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Rapports de Stocks Générés',
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

      console.log('Confirming Reorder')
    },
    onGeneratePredictive() {
      var body = {
        destination: '/queue/COMPILE_PREDICTIVE_PRODUCTION',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec génération production provisoire',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Production Provisoire Générée',
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

      console.log('Confirming Reorder')
    },
    onGenerateFinale() {
      var body = {
        destination: '/topic/GENERATE_FINALE_PRODUCTION',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec génération production finale',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Production Finale Générée',
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

      console.log('Confirming Reorder')
    },
    onGenerateLivraison() {
      var body = {
        destination: '/topic/GENERATE_BON_LIVRAISON',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes repassées',
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

      console.log('Confirming Reorder')
    },
    onGenerateLivraisonDetails() {
      var body = {
        destination: '/topic/GENERATE_LIVRAISON_DETAILS',
        body: "{'message':'stop'}",
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes repassées',
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

      console.log('Confirming Reorder')
    },
    onDateConfirmOrders: function () {
      var body = {
        destination: '/topic/ONDATE_CONFIRM_ORDERS',
        body:
          '{"message":"stop", "date": "' +
          this.dateToConfirm.getTime().toString() +
          '"}',
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec du repassage des commandes',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Commandes repassées',
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
    },
    onDateFacturation: function () {
      var body = {
        destination: '/queue/ONDATE_FACTURATION',
        body:
          '{"message":"stop", "date": "' +
          this.dateToFacturation.getTime().toString() +
          '"}',
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec Recalcul Facturation',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Facturation Recalculée',
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
    },
    getOthersProducts: function () {
      console.log('GET PRODUCTS')
      var query = { codes: [] }
      var url =
        this.$store.getters.apiurl +
        'lambdas/2/getOthersProducts?apikey=' +
        this.$store.getters.creds.token
      axios.post(url, query).then((response) => {
        //var status = false

        console.log(response.data)
        this.othersProducts = response.data
      })
    },

    addProduct: function () {
      var body = {
        destination: '/queue/ADD_PRODUCT_ON_DATE',
        body:
          '{"start": "' +
          this.periodProductAdd[0].getTime().toString() +
          '", "stop": "' +
          this.periodProductAdd[1].getTime().toString() +
          '", "CODE": "' +
          this.productToAdd +
          '"}',
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec Ajout Produit',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Ajout du produit démarré',
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
    },

    enableProduct: function () {
      var body = {
        destination: '/topic/CHANGE_PRODUCT_PERIOD',
        body:
          '{"message":"enable", "start": "' +
          this.periodEnable[0].getTime().toString() +
          '", "stop": "' +
          this.periodEnable[1].getTime().toString() +
          '", "CODE": "' +
          this.productToEnable +
          '"}',
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec Réactivation Produit',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Réactivation du produit démarrée',
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
    },
    disableProduct: function () {
      var body = {
        destination: '/topic/CHANGE_PRODUCT_PERIOD',
        body:
          '{"message":"disable", "start": "' +
          this.periodDisable[0].getTime().toString() +
          '", "stop": "' +
          this.periodDisable[1].getTime().toString() +
          '", "CODE": "' +
          this.productToDisable +
          '"}',
      }

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Echec Désactivation Produit',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Désactivation du produit démarrée',
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
