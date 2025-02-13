<template>
    <div ref="mapContainer" style="width: 100%; height: 100%;"></div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useNuxtApp } from '#app';

const mapContainer = ref(null);
const { $leaflet: L } = useNuxtApp();

const gpxUrlList = ['1.gpx','2.gpx','3.gpx','4.gpx','5.gpx','6.gpx','7.gpx'];
const colors = ['#FF0000', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#FFA500', '#800080', '#008000', '#000000'];

const loadMap = () => {
    if (!mapContainer.value || !L) return;

    const map = L.map(mapContainer.value).setView([52.3676, 4.9041], 12);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'TAR',
    }).addTo(map);

    let loadedCount = 0;
    const bounds = L.latLngBounds();

    gpxUrlList.forEach((gpxUrl, index) => {
        new L.GPX(gpxUrl, {
            async: true,
            polyline_options: {
                color: colors[index % colors.length],
            },
            marker_options: {
                startIcon: null,
                endIcon: null,
            },
        })
        .on('loaded', function (e) {
            bounds.extend(e.target.getBounds());
            loadedCount++;
            if (loadedCount === gpxUrlList.length) {
                map.fitBounds(bounds);
            }
        })
        .addTo(map);
    });
};

onMounted(() => {
    loadMap();
});
</script>