<template>
  <div class="page-container">
    <div class="loader-container">
      <div class="loader"></div>
    </div>
  </div>
</template>

<style>
.page-container{
    width:100vw;
    height: 100vh;
    text-align: center;
    background-color: #002439;
    position: absolute;
}
.loader-container{
  position: absolute  ;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
}
.loader {
  border: 16px solid #002439; /* Light grey */
  border-top: 16px solid #70BD95; /* Blue */
  border-bottom: 16px solid #70BD95;
  border-radius: 50%;
  width: 120px;
  height: 120px;
  animation: spin 2s linear infinite;
  background-color: #002439;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>