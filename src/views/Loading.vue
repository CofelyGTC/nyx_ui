<template>
    <div class="loader"></div>
</template>

<style>
body{
    text-align: center;
    background-color: #002439;
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
  display: block;
  margin: auto;
  margin-top: 45vh;
  transform: translate(100%);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>