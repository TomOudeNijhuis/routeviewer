<template>
    <div ref="mapContainer" style="width: 100%; height: 100%;"></div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useNuxtApp } from '#app';

const mapContainer = ref(null);
const { $leaflet: L } = useNuxtApp();

var taIcon = L.icon({
    iconUrl: 'ta.png',
    shadowUrl: null,

    iconSize: [46, 40],
    shadowSize: null,
    iconAnchor: [23, 20],
    shadowAnchor: null,
    popupAnchor: [0, -25]
});

var cpIcon = L.icon({
    iconUrl: 'cp.png',
    shadowUrl: null,

    iconSize: [40, 40],
    shadowSize: null,
    iconAnchor: [20, 20],
    shadowAnchor: null,
    popupAnchor: [0, -25]
});

const gpxUrlList = ['1.gpx','2.gpx','3.gpx','4.gpx','5.gpx','6.gpx','7.gpx','8.gpx'];
const colors = ['#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#FFA500', '#800080', '#008000', '#000000'];

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
            markers: {
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

    const taMarkers = [
        L.marker([52.219627, 7.809509], { icon: taIcon }).bindPopup("Start/TA1"),
        L.marker([52.246669, 7.695376], { icon: taIcon }).bindPopup("TA2"),
        L.marker([52.272563, 7.451520], { icon: taIcon }).bindPopup("TA3"),
        L.marker([52.302476, 7.178782], { icon: taIcon }).bindPopup("TA4"),
        L.marker([52.310017, 7.024850], { icon: taIcon }).bindPopup("TA5"),
        L.marker([52.258945, 7.015103], { icon: taIcon }).bindPopup("TA6"),
        L.marker([52.259490, 7.003328], { icon: taIcon }).bindPopup("Finish"),
    ];

    taMarkers.forEach(marker => marker.addTo(map));
    
    const cpMarkers = [
        L.marker([52.222233, 7.805282], { icon: cpIcon }).bindPopup("CP01"),
        L.marker([52.224454, 7.813146], { icon: cpIcon }).bindPopup("CP02"),
        L.marker([52.219186, 7.821847], { icon: cpIcon }).bindPopup("CP03"),
        L.marker([52.220005, 7.812918], { icon: cpIcon }).bindPopup("CP04"),
        L.marker([52.217614, 7.803174], { icon: cpIcon }).bindPopup("CP10"),
        L.marker([52.224592, 7.773718], { icon: cpIcon }).bindPopup("CP11"),
        L.marker([52.235783, 7.751091], { icon: cpIcon }).bindPopup("CP12"),
        L.marker([52.234883, 7.734413], { icon: cpIcon }).bindPopup("CP13"),
        L.marker([52.244281, 7.702210], { icon: cpIcon }).bindPopup("CP14"),
        L.marker([52.255773, 7.679797], { icon: cpIcon }).bindPopup("CP20"),
        L.marker([52.287084, 7.624772], { icon: cpIcon }).bindPopup("CP21"),
        L.marker([52.256725, 7.600458], { icon: cpIcon }).bindPopup("CP22"),
        L.marker([52.229232, 7.535001], { icon: cpIcon }).bindPopup("CP23"),
        L.marker([52.24348, 7.49757], { icon: cpIcon }).bindPopup("CP24"),
        L.marker([52.230461, 7.463783], { icon: cpIcon }).bindPopup("CP25"),
        L.marker([52.256134, 7.441456], { icon: cpIcon }).bindPopup("CP26"),
    ];

    const updateMarkerVisibility = () => {
        const zoomLevel = map.getZoom();
        cpMarkers.forEach(marker => {
            if (zoomLevel >= 14) {
                marker.addTo(map);
            } else {
                map.removeLayer(marker);
            }
        });
    };

    map.on('zoomend', updateMarkerVisibility);
    updateMarkerVisibility();
};

onMounted(() => {
    loadMap();
});
</script>