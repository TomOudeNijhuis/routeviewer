<template>
    <div  :class="['container', { authenticated }]">
        <img src="@/assets/logo4.svg" alt="Logo" class="logo" />
        <h1 v-if="authenticated" class="title">TAR Route viewer</h1>
        <div v-if="authenticated" class="map-container">
            <MapWithGpx />
        </div>
        <div v-else class="login-form">
            <form @submit.prevent="checkPassword">
                <label for="password">Enter Password:</label>
                <input type="password" v-model="password" id="password" />
                <button type="submit">Submit</button>
            </form>
        </div>
    </div>
  </template>
  
<script setup>
import MapWithGpx from '~/components/MapWithGpx.vue';

const password = ref('');
const authenticated = ref(false);

const checkPassword = () => {
    if (password.value === 'rat0803') {
        authenticated.value = true;
    } else {
        alert('Incorrect password');
    }
};

</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background-color: #f0f0f0;
  text-align: center;
}

.logo {
  width: 300px;
  height: auto;
  margin-bottom: 20px;
}

.map-container {
  position: absolute;
  top: 100px;
  width: 100%;
  height: 90vh;
}

h1 {
  margin-bottom: 20px;
}

.login-form {
  width: 300px;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.login-form form {
  display: flex;
  flex-direction: column;
}

.login-form label {
  margin-bottom: 10px;
  font-weight: bold;
}

.login-form input {
  padding: 10px;
  margin-bottom: 20px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.login-form button {
  padding: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.login-form button:hover {
  background-color: #0056b3;
}

.authenticated .logo {
  position: absolute;
  top: 10px;
  left: 20px;
  width: 180px;
  margin-bottom: 0;
}

.authenticated .title {
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
}

</style>

<style>
body {
  margin: 0;
}
</style>