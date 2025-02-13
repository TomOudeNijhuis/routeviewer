<template>
  <div ref="mapContainer" style="width: 100%; height: 80vh;"></div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useNuxtApp } from '#app';

const mapContainer = ref(null);
const { $leaflet: L } = useNuxtApp(); // Access Leaflet from the plugin

const gpxUrl = '1.gpx'; // Change this to the actual GPX file path

onMounted(() => {
  if (!mapContainer.value || !L) return;

  const map = L.map(mapContainer.value).setView([52.3676, 4.9041], 12);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap contributors',
  }).addTo(map);

  // Load the GPX file and add it to the map
  new L.GPX(gpxUrl, {
    async: true,
    marker_options: {
      startIconUrl: 'https://leafletjs.com/examples/custom-icons/leaf-green.png',
      endIconUrl: 'https://leafletjs.com/examples/custom-icons/leaf-red.png',
      shadowUrl: 'https://leafletjs.com/examples/custom-icons/leaf-shadow.png',
    },
  })
    .on('loaded', function (e) {
      map.fitBounds(e.target.getBounds());
    })
    .addTo(map);
});
</script>