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
const transitionAreas = [
    { lat: 52.219515, lon: 7.808803, name: 'Start/TA1' },
    { lat: 52.247072, lon: 7.690348, name: 'TA2' },
    { lat: 52.272357, lon: 7.451155, name: 'TA3' },
    { lat: 52.302506, lon: 7.178918, name: 'TA4' },
    { lat: 52.310105, lon: 7.024913, name: 'TA6' },
    { lat: 52.259106, lon: 7.015267, name: 'TA7' },
    { lat: 52.259490, lon: 7.003328, name: 'Finish' },
];

const checkPoints = [
    { lat: 52.224670, lon: 7.804779, name: 'CP01' },
    { lat: 52.224664, lon: 7.816335, name: 'CP02' },
    { lat: 52.218137, lon: 7.823503, name: 'CP03' },
    { lat: 52.213733, lon: 7.813764, name: 'CP04' }, 
    { lat: 52.217394, lon: 7.803385, name: 'CP11' },
    { lat: 52.225135, lon: 7.773691, name: 'CP12' },
    { lat: 52.234379, lon: 7.753893, name: 'CP13' },
    { lat: 52.234161, lon: 7.739185, name: 'CP14' },
    { lat: 52.258669, lon: 7.675968, name: 'CP21' },
    { lat: 52.286685, lon: 7.622578, name: 'CP22' },
    { lat: 52.256825, lon: 7.601122, name: 'CP23' },
    { lat: 52.251603, lon: 7.562869, name: 'CP25' },
    { lat: 52.229840, lon: 7.522544, name: 'CP26' },
    { lat: 52.233927, lon: 7.469315, name: 'CP27' },
    { lat: 52.254742, lon: 7.441090, name: 'CP28' },
    { lat: 52.279060, lon: 7.415344, name: 'CP37' },
    { lat: 52.317076, lon: 7.422668, name: 'CP31' },
    { lat: 52.364130, lon: 7.369549, name: 'CP38' },
    { lat: 52.381555, lon: 7.336252, name: 'CP32' },
    { lat: 52.327944, lon: 7.355728, name: 'CP33' },
    { lat: 52.280267, lon: 7.317371, name: 'CP34' },
    { lat: 52.269407, lon: 7.213912, name: 'CP35' },
    { lat: 52.309379, lon: 7.232497, name: 'CP36' },
    { lat: 52.302858, lon: 7.188177, name: 'ST41' },
    { lat: 52.305364, lon: 7.212966, name: 'CP42' },
    { lat: 52.288988, lon: 7.161085, name: 'CP47' },
    { lat: 52.289398, lon: 7.137594, name: 'CP46' },
    { lat: 52.295168, lon: 7.093752, name: 'CP45' },
    { lat: 52.303395, lon: 7.101776, name: 'CP44' },
    { lat: 52.301305, lon: 7.145126, name: 'CP43' },
    { lat: 52.302896, lon: 7.155383, name: 'CP48' },
    { lat: 52.319004, lon: 7.166261, name: 'CP51' },
    { lat: 52.357007, lon: 7.150695, name: 'CP52' },
    { lat: 52.405047, lon: 7.137582, name: 'CP53' },
    { lat: 52.433936, lon: 7.076605, name: 'CP54' },
    { lat: 52.418552, lon: 7.037528, name: 'CP55' },
    { lat: 52.387538, lon: 6.968703, name: 'CP56' },
    { lat: 52.365528, lon: 6.987410, name: 'CP57' },
    { lat: 52.351946, lon: 7.018171, name: 'CP58' },
    { lat: 52.307003, lon: 6.988659, name: 'CP61' },
    { lat: 52.291543, lon: 6.972217, name: 'CP62' },
    { lat: 52.279456, lon: 6.964643, name: 'CP63' },
    { lat: 52.270779, lon: 6.947268, name: 'CP64' },
    { lat: 52.265635, lon: 6.976677, name: 'CP65' },
    { lat: 52.283252, lon: 7.026038, name: 'CP71' },
    { lat: 52.301499, lon: 7.030023, name: 'CP72' },
    { lat: 52.284813, lon: 7.053492, name: 'CP81' },
    { lat: 52.280298, lon: 7.034171, name: 'CP82' }
]

const loadMap = () => {
    if (!mapContainer.value || !L) return;

    const map = L.map(mapContainer.value).setView([52.3676, 4.9041], 12);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'TAR',
    }).addTo(map);

    L.control.scale({ position: 'topright' }).addTo(map);

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
    const taMarkers = [];
    transitionAreas.forEach(cp => {
        const popupContent = `
            <strong>${cp.name}</strong><br>
            ${cp.hint ? 'hint: ' + cp.hint + '<br>' : ''}
            <br>
            <a href="https://www.google.com/maps?q=${cp.lat},${cp.lon}" target="_blank">Bekijk in Google Maps</a>
        `;
        taMarkers.push(
            L.marker([cp.lat, cp.lon], { icon: taIcon }).bindPopup(popupContent)
        );
    });

    taMarkers.forEach(marker => marker.addTo(map));
    
    const cpMarkers = [];
    checkPoints.forEach(cp => {
        const popupContent = `
            <strong>${cp.name}</strong><br>
            ${cp.hint ? 'hint: ' + cp.hint + '<br>' : ''}
            <br>
            <a href="https://www.google.com/maps?q=${cp.lat},${cp.lon}" target="_blank">Bekijk in Google Maps</a>
        `;
        cpMarkers.push(
            L.marker([cp.lat, cp.lon], { icon: cpIcon }).bindPopup(popupContent)
        );
    });

    const updateMarkerVisibility = () => {
        const zoomLevel = map.getZoom();
        cpMarkers.forEach(marker => {
            if (zoomLevel >= 13) {
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